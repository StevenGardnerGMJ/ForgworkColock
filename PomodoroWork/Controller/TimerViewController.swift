//
//  TimerViewController.swift
//  PomodoroWork
//
//  Created by gemaojing on 2018/4/12.
//  Copyright © 2018年 葛茂菁. All rights reserved.
//

import UIKit
import Foundation
import StoreKit // 1.首先导入支付包

class TimerViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var buttonContainer: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var ADWord: UILabel!
    //3.创建内购支付按钮
    @IBOutlet weak var subscribeBtn: UIButton!
    
    
    // Scheduler表
    fileprivate let scheduler: Scheduler
    fileprivate let pomodoro = Pomodoro.sharedInstance
    
    // Time计时
    fileprivate var timer: Timer?
    fileprivate var currentTime: Double!
    fileprivate var running = false
    
    // Configuration结构
    fileprivate let animationDuration = 0.3
    fileprivate let settings = SettingsManager.sharedManager
    
    fileprivate struct CollectionViewIdentifiers {
        static let emptyCell = "EmptyCell"
        static let filledCell = "FilledCell"
    }
    
    // Pomodoros view
    fileprivate var pomodorosCompleted: Int!
    fileprivate var targetPomodoros: Int
    
    // MARK: - Initialization
    
    required init?(coder aDecoder: NSCoder) {
        targetPomodoros = settings.targetPomodoros
        pomodorosCompleted = pomodoro.pomodorosCompleted
        scheduler = Scheduler()
        
        super.init(coder: aDecoder)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
NotificationCenter.default.addObserver(self,selector:#selector(willEnterForeground),name:NSNotification.Name.UIApplicationWillEnterForeground,object: nil)
        
        buttonContainer.isHidden = true
        longPress() // 长按弹出记录界面
        // 4.设置支付服务
        SKPaymentQueue.default().add(self)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        willEnterForeground()
        
        
    }
    
    func ADword() {
        let calendar: Calendar = Calendar(identifier: .gregorian)
         var comps: DateComponents = DateComponents()
        comps = calendar.dateComponents([.day, .weekday], from: Date())
        var   weekdayNow = comps.weekday! - 1

        let temp = Int(arc4random()%13)
        weekdayNow = weekdayNow + temp
        
//        print("星期\(weekdayNow)")
        
        if weekdayNow <= 20 {
            ADWord.text = ADwordString[weekdayNow]
        } else {
            ADWord.text = "陛下！正在更新中敬请期待！"
        }
        
        
        
    }
    
    
    func willEnterForeground() {
        //print("willEnterForeground called from controller")
        
        setCurrentTime()
        updateTimerLabel()
        
        if scheduler.pausedTime != nil {
            animateStarted()
            animatePaused()
        }
        
        reloadData()
    }
    func secondPassed() {
        if currentTime > 0 {
            currentTime = currentTime - 1.0
            updateTimerLabel()
            return
        }
       // print("State: \(pomodoro.state), done: \(pomodoro.pomodorosCompleted)")
        
        if pomodoro.state == .default {
            pomodoro.completePomodoro()
            startButton.setTitle("休 息", for: .normal)
            reloadData()
        } else {
            startButton.setTitle("开 始", for: .normal)
            pomodoro.completeBreak()
        }
        
        stop()
        
       // print("State: \(pomodoro.state), done: \(pomodoro.pomodorosCompleted)")
    }
    
    // MARK: ----- 点击 -------
    
   
    
    
    /// - 付费订阅按钮 点击方法
    @IBAction func subscribeClick(_ sender: UIButton) {
        // 5.点击按钮的时候判断app是否允许apple支付
        if SKPaymentQueue.canMakePayments() {
            print("允许Apple支付")
            // 6.请求苹果后台商品
            getRequestAppleProduct()
        } else {
            print("不")
        }
    }
    
    @IBAction func togglePaused(_ sender: EmptyRoundedButton) {
        scheduler.paused ? unpause() :pause()
    }
    
    
    @IBAction func start(_ sender: RoundedButton) {
        start()
    }
    
    @IBAction func stop(_ sender: RoundedButton) {
        stop()
    }
    
    func start() {
        scheduler.start()
        running = true
        animateStarted()
        fireTimer()
        ADword()
    }
    
    func stop() {
        scheduler.stop()
        running = false
        animateStopped()
        timer?.invalidate()
        resetCurrentTime()
        updateTimerLabel()
    }
    
    func pause() {
        guard running else { return }
        
        scheduler.pause(currentTime)
        running = false
        timer?.invalidate()
        animatePaused()
    }
    
    func unpause() {
        scheduler.unpause()
        running = true
        fireTimer()
        animateUnpaused()
    }
    func presentAlertFromNotification(_ notification: UILocalNotification) {
        let alertController = UIAlertController(title: notification.alertTitle,
                                                message: notification.alertBody,
                                                preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { action in print("OK") }
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // 帮助
    fileprivate func reloadData() {
        targetPomodoros = settings.targetPomodoros
        pomodorosCompleted = pomodoro.pomodorosCompleted
        collectionView.reloadData()
    }
    fileprivate func updateTimerLabel() {
        let time = Int(currentTime)
        timerLabel.text = String(format: "%02d:%02d", time / 60, time % 60)
    }
    fileprivate func setCurrentTime() {
        if let pausedTime = scheduler.pausedTime {
            currentTime = pausedTime
            return
        }
        
        if let fireDate = scheduler.fireDate {
            let newTime = fireDate.timeIntervalSinceNow
            currentTime = (newTime > 0 ? newTime : 0)
            return
        }
        
        resetCurrentTime()
    }
    
    fileprivate func resetCurrentTime() {
        switch pomodoro.state {
        case .default: currentTime = Double(settings.pomodoroLength)
        case .shortBreak: currentTime = Double(settings.shortBreakLength)
        case .longBreak: currentTime = Double(settings.longBreakLength)
        }
        resetTimerLabelColor()
    }
    fileprivate func resetTimerLabelColor() {
        switch pomodoro.state {
        case .default: timerLabel.textColor = UIColor.accentColor
        case .shortBreak, .longBreak: timerLabel.textColor = UIColor.breakColor
        }
    }
    fileprivate func fireTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self, selector: #selector(secondPassed), userInfo: nil, repeats: true)
    }
    
    fileprivate func refreshPomodoros() {
        targetPomodoros = settings.targetPomodoros
        collectionView.reloadData()
    }
    fileprivate func animateStarted() {
        let deltaY: CGFloat = 54
        buttonContainer.frame.origin.y += deltaY
        buttonContainer.isHidden = false
        
        UIView.animate(withDuration: animationDuration, animations: {
            self.startButton.alpha = 0.0
            self.buttonContainer.alpha = 1.0
            self.buttonContainer.frame.origin.y += -deltaY
        })
    }
    
    
    //  长按停止计时 双击停止计时
    fileprivate func animateStopped() {
        UIView.animate(withDuration: animationDuration, animations: {
            self.startButton.alpha = 1.0
            self.buttonContainer.alpha = 0.0
        })
        
        pauseButton.setTitle("暂停", for: UIControlState())
    }
    fileprivate func animatePaused() {
        pauseButton.setTitle("继续", for: UIControlState())
    }
    
    fileprivate func animateUnpaused() {
        pauseButton.setTitle("暂停", for: UIControlState())
    }
    
    fileprivate func longPress(){
//        print("longpress")
        timerLabel.isUserInteractionEnabled = true
        let ges = UILongPressGestureRecognizer(target: self, action: #selector(TimerViewController.handleLongpressGesture))
        //长按时间为1秒
        ges.minimumPressDuration = 1.0
        //所需触摸1次
        ges.numberOfTouchesRequired = 1
        timerLabel.addGestureRecognizer(ges)
        
    }
    
    
    @objc fileprivate func handleLongpressGesture(sender : UILongPressGestureRecognizer){
//        print("handleLongpressGesture")
        
        if sender.state == UIGestureRecognizerState.began{
            //
            let storyB = UIStoryboard(name: "Main", bundle: Bundle.main)
            let recordVC = storyB.instantiateViewController(withIdentifier: "recordTableViewController")
//            self.navigationController?.present(recordVC, animated: true, completion: nil)
            self.present(recordVC, animated: true, completion: nil)
            
            
        }
    }
    

}


extension TimerViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        return numberOfRows(inSection: section)
}
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let index = rowsPerSection * indexPath.section + indexPath.row
        let identifier = (index < pomodorosCompleted) ?
            CollectionViewIdentifiers.filledCell : CollectionViewIdentifiers.emptyCell
        
        return collectionView.dequeueReusableCell(withReuseIdentifier: identifier,
                                                  for: indexPath)
}

// MARK：--UICollectionViewDelegate协议

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let bottomInset: CGFloat = 12
        return UIEdgeInsetsMake(0, 0, bottomInset, 0)
}
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
}
// MARK:-- 帮助
    fileprivate var rowsPerSection: Int {
        let cellWidth: CGFloat = 30.0
        let margin: CGFloat = 10.0
        return Int(collectionView.frame.width / (cellWidth + margin))
    }
    
    fileprivate func numberOfRows(inSection section: Int) -> Int {
        if section == lastSectionIndex {
            return numberOfRowsInLastSection
        } else {
            return rowsPerSection
        }
}
    fileprivate var numberOfRowsInLastSection: Int {
        if targetPomodoros % rowsPerSection == 0 {
            return rowsPerSection
        } else {
            return targetPomodoros % rowsPerSection
        }
    }
    
    fileprivate var numberOfSections: Int {
        return Int(ceil(Double(targetPomodoros) / Double(rowsPerSection)))
    }
    
    fileprivate var lastSectionIndex: Int {
        if numberOfSections == 0 {
            return 0
        }
        
        return numberOfSections - 1
    }
    
}

// MARK: - 对内购进行扩展：
// 2.设置代理服务
extension TimerViewController:SKPaymentTransactionObserver,SKProductsRequestDelegate {
    //7,8,9 请求苹果商品
    func getRequestAppleProduct(){
        var product = Array<String>()
        product = ["com.czchat.CZChat01"]
        let nsset = NSSet(array: product)
        // 8.初始化请求
        let request = SKProductsRequest(productIdentifiers: nsset as! Set<String>)
        request.delegate = self
        
        // 9.开始请求
        request.start()
    }
    
//10.接收到产品的返回信息,然后用返回的商品信息进行发起购买请求
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let product = response.products
        //如果服务器没有产品
        if product.count == 0 {
            print("没有购买信息")
            return
        }
        var requestProduct = SKProduct()
        for pro in product {
            print("description=\(pro.description)")
            print("localizedTitle=\(pro.localizedTitle)")
            print("localizedDescription=\(pro.localizedDescription)")
            print("price=\(pro.price)")
            print("productIdentifier=\(pro.productIdentifier)")
            // 11.如果后台消费条目的ID与我这里需要请求的一样（用于确保订单的正确性
            if pro.productIdentifier == "com.czchat.CZChat01" {
                requestProduct = pro
            }
        }
        // 12.发送购买请求
        let payment = SKPayment(product: requestProduct)
        SKPaymentQueue.default().add(payment)
    }
    func request(_ request: SKRequest, didFailWithError error: Error) {
        //请求失败
        debugPrint("购买请求失败\(error)")
    }
    
    func requestDidFinish(_ request: SKRequest) {
        //反馈请求的产品信息结束后
        print("反馈信息调用结束")
    }
// 13.监听购买结果
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for tran in transactions {
            switch tran.transactionState {
            case .purchased: print("交易完成")
            case .purchasing:print("商品添加进列表")
            case .restored:print("已经购买过商品");SKPaymentQueue.default().finishTransaction(tran)
            case .failed:print("交易失败");SKPaymentQueue.default().finishTransaction(tran)
            default:break
            }
        }
    }
    
// 14.交易结束,当交易结束后还要去appstore上验证支付信息是否都正确,只有所有都正确后,我们就可以给用户方法我们的虚拟物品了。
    func completeTransaction(transaction:SKPaymentTransaction) {
//        let str = String.init(data: transaction., encoding: <#T##String.Encoding#>)
        let recvURL = Bundle.main.appStoreReceiptURL//是用来获取交易收据的
        let receiptData = NSData(contentsOf: recvURL!)
//        let encodeStr = receiptData?.base64EncodedString(options: .endLineWithLineFeed)//进行加密
        // 储存 收据数据
    // 已知完成 支付跳转界面到知识
        
    }
    
    
    // 提供restore的功能:使用户可以在其他设备上重新存储购买信息,Apple Store生成新的,用于恢复的交易信息
    // 当之前所有的交易都被恢复时， 就会调用观察者对象的paymentQueueRestoreCompletedTransactionsFinished方法。
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        
    }
    
    
    /// 添加观察者
    func addTransactionObserver(){
        SKPaymentQueue.default().add(self)
    }
    /// 删除观察者
    func removeTransactionObserver(){
        SKPaymentQueue.default().remove(self)
    }
    
    
    
    
    
}












