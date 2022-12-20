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
//    @IBOutlet weak var tableView: UITableView!

    var passConditionModel: PassConditionModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        guard let url = URL(string: "https://www.costco.com") else { return }

        webView.navigationDelegate = self
        webView.load(URLRequest(url: url))

    }
    
    private func showBottomSheet() {
        guard let detailsController = storyboard?.instantiateViewController(withIdentifier: "PassConditionVC") else { return }
 
        let navigationController = UINavigationController(rootViewController: detailsController)
        navigationController.modalPresentationStyle = UIModalPresentationStyle.pageSheet

        if let sheetPresentationController = detailsController.presentationController as? UISheetPresentationController {
            // Let's have the grabber always visible
            sheetPresentationController.prefersGrabberVisible = true
            // Define which heights are allowed for our sheet
            sheetPresentationController.detents = [
                UISheetPresentationController.Detent.medium(),
                UISheetPresentationController.Detent.large()
            ]
        }
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
            
            showBottomSheet()
            
            // Ask the web view to ignore the original navigation request
            decisionHandler(.cancel)
            return
        }

        decisionHandler(.allow)
    }
}
