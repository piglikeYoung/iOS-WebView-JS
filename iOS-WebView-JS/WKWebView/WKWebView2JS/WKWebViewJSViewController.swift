//
//  WKWebViewJSViewController.swift
//  iOS-WebView-JS
//
//  Created by pike young on 2018/3/23.
//  Copyright © 2018年 YJH. All rights reserved.
//

import UIKit
import WebKit

class WKWebViewJSViewController: UIViewController {
    
    var myWebView: WKWebView = {
        let myWebView = WKWebView(frame: CGRect(x: 0, y: 64, width: UIScreen.main.bounds.size.width, height: 221), configuration: WKWebViewConfiguration())
        return myWebView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "WKWebView调用JS"
        
        myWebView.uiDelegate = self
        view.addSubview(myWebView)
        
        refreshHTML("")
    }
    
    deinit {
        log.printLog("WKWebViewJSViewController")
    }
    
    // MARK: - Private
    
    func loadHTML(name: String) {
        let filePath = Bundle.main.path(forResource: name, ofType: "html")
        let url = URL(fileURLWithPath: filePath!, isDirectory: false)
        myWebView.load(URLRequest(url: url))
    }

    // 刷新 HTML
    @IBAction func refreshHTML(_ sender: Any) {
        loadHTML(name: "WKWebViewJS")
    }
    
    // 执行已经存在的js方法+传值
    @IBAction func doFunction(_ sender: Any) {
        myWebView.evaluateJavaScript("showAlert('fsdafasdfsad')") { (item, error) in
            log.printLog("调用完毕")
        }
    }
    
    // getElementsByTagName插入html
    @IBAction func insertHTMLByTagName(_ sender: Any) {
        // 插入整个页面内容
        // document.getElementsByTagName('body')[0];"
        let tempString = "document.getElementsByTagName('p')[0].innerHTML ='放假萨的看法见识到了房间里的哭声挂号费读后感的风华高科水电费';"
        myWebView.evaluateJavaScript(tempString) { (item, error) in
            log.printLog("调用完毕")
        }
    }
    
    // getElementsByName 填input
    @IBAction func inputSomething(_ sender: Any) {
        let tempString = "document.getElementsByName('wd')[0].value='yjh';"
        myWebView.evaluateJavaScript(tempString) { (item, error) in
            log.printLog("调用完毕")
        }
    }
    
    // getElementById插入html
    @IBAction func insertHTMLByID(_ sender: Any) {
        let tempString = "document.getElementById('idTest').innerHTML ='放假考虑到缩放结束打开了放假放假开发就放大镜看规范化个斯卡迪发家史；阿';"
        myWebView.evaluateJavaScript(tempString) { (item, error) in
            log.printLog("调用完毕")
        }
    }
    
    // 插入JS并且执行
    @IBAction func insertJS(_ sender: Any) {
        let insertString = "var script = document.createElement('script');" +
        "script.type = 'text/javascript';" +
        "script.text = \"function jsFunc() { " +
        "var a=document.getElementsByTagName('body')[0];" +
        "alert('你好吗？');" +
        "}\";" +
        "document.getElementsByTagName('head')[0].appendChild(script);"
        
        myWebView.evaluateJavaScript(insertString) { (item, error) in
            log.printLog("插入完毕")
        }
        
        myWebView.evaluateJavaScript("jsFunc();") { (item, error) in
            log.printLog("调用完毕")
        }
    }
    
    // 替换图片地址
    @IBAction func replaceImgSrc(_ sender: Any) {
        let tempString = "document.getElementsByTagName('img')[0].src ='light_advice.png';"
        myWebView.evaluateJavaScript(tempString) { (item, error) in
            log.printLog("调用完毕")
        }
    }
    
    // 修改标签字体
    @IBAction func changeFont(_ sender: Any) {
        let tempString = "document.getElementsByTagName('p')[0].style.fontSize='19px';"
        myWebView.evaluateJavaScript(tempString) { (item, error) in
            log.printLog("调用完毕")
        }
    }
    
    // submit
    @IBAction func submit(_ sender: Any) {
        myWebView.evaluateJavaScript("document.forms[0].submit();") { (item, error) in
            log.printLog("调用完毕")
        }
    }
    
    // 定位
    @IBAction func location(_ sender: Any) {
        loadHTML(name: "WKWebViewJS_location")
    }
    
    // 上传图片
    @IBAction func upload(_ sender: Any) {
        loadHTML(name: "WKWebViewJS_file")
    }
}

extension WKWebViewJSViewController: WKUIDelegate {
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
