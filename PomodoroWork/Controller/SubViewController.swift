//
//  SubViewController.swift
//  PomodoroWork
//
//  Created by gemaojing on 2018/7/25.
//  Copyright © 2018年 葛茂菁. All rights reserved.
//

import UIKit
import StoreKit

/// 订阅页面
class SubViewController: UIViewController {
    
    var products = [SKProduct]()
    
    deinit {
        SKPaymentQueue.default().remove(self)
    }


    // subscribe订阅
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blue
        setUI()
        getProducts()
    }
    
   func setUI() {
    
    let backRestoreBtn =  UIButton(frame: CGRect(x: 60, y: 100, width: 100, height: 30))
    backRestoreBtn.setTitle("恢复购买", for: .normal)
    backRestoreBtn.setTitleColor(UIColor.black, for: .normal)
    backRestoreBtn.addTarget(self, action: #selector(restoreClick), for: .touchUpInside)
    backRestoreBtn.backgroundColor = UIColor.white
    view.addSubview(backRestoreBtn)
    
    let storeBtn = UIButton(frame: CGRect(x: 60, y: 200, width: 100, height: 30))
    storeBtn.setTitle("购买", for: .normal)
    storeBtn.setTitleColor(UIColor.black, for: .normal)
    storeBtn.addTarget(self, action: #selector(purchase), for: .touchUpInside)
    storeBtn.backgroundColor = UIColor.white
    view.addSubview(storeBtn)
    
    }
    // 2，加载产品ID
    func getProducts() {
        
        let productIDs = Set(["com.cn.huizhijia.01"])
        let request = SKProductsRequest(productIdentifiers: productIDs)
        request.delegate = self
        request.start()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showRestoreAlert() {
        
    }
    //5: 用户发起购买
    func purchase() {
//        let transactions = SKPaymentQueue.default().transactions
//        if (transactions.count > 0) {
//            //检测是否有未完成的交易
//            let transaction = transactions[0]
//            if transaction.transactionState == .purchased {
//                SKPaymentQueue.default().finishTransaction(transaction)
//                return;
//            }
//        }
       // 判断是否取得产品信息
        if products.count > 0 {
            let product = products[0]
            print(product)
            
            if SKPaymentQueue.canMakePayments() {//判断当前的支付环境, 是否可以支付
                print("允许支付")
                let payment = SKPayment(product: product)
                SKPaymentQueue.default().add(payment)//添加到支付队列
//                SKPaymentQueue.default().add(self)//监听交易状态
            }
        }
    }
    // 回复购买
    func restoreClick() {
        print("恢复购买res")
        SKPaymentQueue.default().restoreCompletedTransactions()
//        SKPaymentQueue.default().add(self)
        
    }
    
    private func loadReceipt() -> Data? {
        guard let url = Bundle.main.appStoreReceiptURL else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            print("Error loading receipt data: \(error.localizedDescription)")
            return nil
        }
    }
    
    
}


extension SubViewController:SKPaymentTransactionObserver{
    // 6: 处理交易（交易结果）
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        // 当交易队列里面添加的每一笔交易状态发生变化的时候调用
        for transaction in transactions {
            switch transaction.transactionState {
            case .deferred:
                print("延迟处理")
            case .failed:
                print("支付失败")
                handleFailedState(for: transaction, in: queue)
                queue.finishTransaction(transaction)
            case .purchased:
                print("支付成功")
                handlePurchasedState(for: transaction, in: queue)
                queue.finishTransaction(transaction)
            case .purchasing:
                print("正在支付")
            case .restored:
                print("恢复购买")
                queue.finishTransaction(transaction)
            }
        }
    }
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("request=\(request),\n error = \(error)")
    }
    func handlePurchasedState(for transaction: SKPaymentTransaction, in queue: SKPaymentQueue) {
        let sub1 = Sub1ViewController()
        self.present(sub1, animated: true, completion: nil)
    }
    func handleFailedState(for transaction: SKPaymentTransaction, in queue: SKPaymentQueue) {
        print("购买失败: \(transaction.payment.productIdentifier)")
    }
}

extension SubViewController:SKProductsRequestDelegate {
    // 3,抓取产品信息（收到appleStore产品反馈信息）
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        // 产品标识符
        print("didReceive-response.products=\(response.products)")
        // 无效产品标识符
        print("didReceive-invalidProductIdentifiers=\(response.invalidProductIdentifiers)")
        products = response.products
        
        print("-----------收到产品反馈信息--------------");
        let myProduct = response.products;
        print("产品Product ID:%@",response.invalidProductIdentifiers);
        print("产品付费数量: \(myProduct.count)");
        // 4，展现产品信息
        for product in myProduct {
            print("product info");
            print("SKProduct 描述信息\(product.description)");
            print("产品标题 \(product.localizedTitle)");
            print("产品描述信息:\(product.localizedDescription)");
            print("价格: \(product.price)");
            print("Product id: \(product.productIdentifier)");
            
        }
    }
}








