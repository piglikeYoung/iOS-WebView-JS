//
//  JSWKWebViewViewController.swift
//  iOS-WebView-JS
//
//  Created by pike young on 2018/3/23.
//  Copyright © 2018年 YJH. All rights reserved.
//

import UIKit
import WebKit

class JSWKWebViewViewController: UIViewController {
    
    var myWebView: WKWebView?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "JS调用WKWebView"
        
        let config = WKWebViewConfiguration()
        config.userContentController = WKUserContentController()
        // 注入JS对象Native，
        // 声明WKScriptMessageHandler 协议
        config.userContentController.add(self, name: "Native")
        config.userContentController.add(self, name: "Pay")
        
        myWebView = WKWebView(frame: view.bounds, configuration: config)
        myWebView!.uiDelegate = self
        view.addSubview(myWebView!)
        
        loadHTML(name: "JSWKWebView")
    }
    
    // MARK: - Private
    
    func loadHTML(name: String) {
        let filePath = Bundle.main.path(forResource: name, ofType: "html")
        let url = URL(fileURLWithPath: filePath!, isDirectory: false)
        myWebView!.load(URLRequest(url: url))
    }
    
    func showMessage(title: String?, message: String?) {
        guard message == nil else {
            return
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension JSWKWebViewViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        log.printLog(message.name)
        log.printLog(message.body)
        
        let body = message.body as! Dictionary<String, Any>
        let functionName = body["function"] as! String
        log.printLog(functionName)
        
        if message.name == "Native" {
            if let parameters = body["parameters"] as? Dictionary<String, Any> {
                // 调用本地函数1
                if functionName == "addSubView" {
                    let tempClass = NSClassFromString(parameters["view"] as! String) as! UIWebView.Type
                    let frame = CGRectFromString(parameters["frame"] as! String)
                    
                    let tempObject = tempClass.init(frame: frame)
                    tempObject.tag = Int(parameters["tag"] as! String)!
                    
                    let url = URL(string: parameters["urlstring"] as! String)
                    let request = URLRequest(url: url!)
                    tempObject.loadRequest(request)
                    myWebView?.addSubview(tempObject)
                }
                    // 调用本地函数2
                else if functionName == "alert" {
                    showMessage(title: "来自网页的提示", message: parameters.debugDescription)
                }
                    // 调用本地函数3
                else if functionName == "callFunc" {
                    
                }
                    // 调用本地函数4
                else if functionName == "testFunc" {
                    
                }
            }
            
        } else if message.name == "Pay" {
            //如果是自己定义的协议, 再截取协议中的方法和参数, 判断无误后在这里进行逻辑处理
            
        } else if message.name == "dosomething" {
            //........
            
        }
    }
}

extension JSWKWebViewViewController: WKUIDelegate {
    func webViewDidClose(_ webView: WKWebView) {
        log.printLog("webViewDidClose")
    }
    
    // 拦截alert
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            completionHandler()
        }))
        present(alert, animated: true, completion: nil)
    }
}
