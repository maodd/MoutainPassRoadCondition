//
//  ViewController.swift
//  MoutainPassRoadCondition
//
//  Created by Frank on 2022-12-19.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        guard let url = URL(string: "https://www.costco.com") else { return }

        webView.navigationDelegate = self
        webView.load(URLRequest(url: url))

    }
    
    private func showPassConditionVC() {
        guard let detailsController = storyboard?.instantiateViewController(withIdentifier: "PassConditionVC") else { return }
 
        let navigationController = UINavigationController(rootViewController: detailsController)
        navigationController.modalPresentationStyle = UIModalPresentationStyle.fullScreen

        present(navigationController, animated: true)
    }

}

extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView,
                   decidePolicyFor navigationAction: WKNavigationAction,
                   decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        if navigationAction.navigationType == WKNavigationType.linkActivated,
           let url = navigationAction.request.url,
           url.absoluteString == "https://www.costco.com/warehouse-locations" {
            
            showPassConditionVC()
            
            // Ask the web view to ignore the original navigation request
            decisionHandler(.cancel)
            return
        }

        decisionHandler(.allow)
    }
}
