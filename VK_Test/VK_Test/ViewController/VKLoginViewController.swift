//
//  VKLoginViewController.swift
//  VK_Test
//
//  Created by Александр Шербуренко on 19.04.2022.
//

import UIKit
import WebKit

class VKLoginViewController: UIViewController {

    @IBOutlet weak var webViewVKLogin: WKWebView! {
        didSet {
            webViewVKLogin.navigationDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let request = NetworkingService().getAuthorizeRequest() {
            webViewVKLogin.load(request)
        }
    }
}

extension VKLoginViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url, url.path == "/blank.html",
                let fragment = url.fragment
        else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
            }
        
        if let token = params["access_token"], let userID = params["user_id"], let id = Int(userID) {
            Session.shared.loginInUser(with: token, userID: id)
            performSegue(withIdentifier: "loginID", sender: nil)
        }
        decisionHandler(.cancel)
    }
}
