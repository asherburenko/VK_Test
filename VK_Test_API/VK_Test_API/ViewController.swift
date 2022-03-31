//
//  ViewController.swift
//  VK_Test_API
//
//  Created by Александр Шербуренко on 30.03.2022.
//

import UIKit
import Foundation
import WebKit

class ViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView! {
        didSet{
            webView.navigationDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        autorizationVK()
        getFriendsList()
    }

    func autorizationVK() {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "8121440"),
            URLQueryItem(name: "scope", value: "336918"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.131")
        ]
        let request = URLRequest(url: urlComponents.url!)
        webView.load(request)
    }
}

extension ViewController: WKNavigationDelegate {
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
        
        let token = params["access_token"]
        let userID = params["user_id"]

        print("token", token, "user_id", userID)
        
        decisionHandler(.cancel)
    }
}

extension ViewController {
    func getFriendsList() {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/friends.get"
        urlComponents.queryItems = [
            URLQueryItem(name: "user_id", value: "26574729"),
            URLQueryItem(name: "order", value: "random"),
            URLQueryItem(name: "count", value: "10"),
            URLQueryItem(name: "access_token", value: "dba88d6df1a1e2d39134b8d6fafac0ec1e7cf122117d0aece0e95bec478acb87daa32ba4282ad652b085e"),
            URLQueryItem(name: "v", value: "5.131")
        ]
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request) { (data, response, error) in
            let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
            print(json)
            print("222222", Session.shared.token, "3333")
        }
        task.resume()
    }
}

