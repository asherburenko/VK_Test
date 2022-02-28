//
//  ViewController.swift
//  VK_Test
//
//  Created by Александр Шербуренко on 31.01.2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var scrollViewTitle: UIScrollView!
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    
    let fromLoginToTabBarId = "fromLoginToTabBarId"
    
    func loadAnimate(currentCount: Int, totalCount: Int) {
        view1.alpha = 1
        view2.alpha = 0
        view3.alpha = 0
        
        UIView.animate(withDuration: 1) { [weak self] in
            self?.view1.alpha = 0
            self?.view2.alpha = 1
        } completion: { _ in
            UIView.animate(withDuration: 1) { [weak self] in
                self?.view2.alpha = 0
                self?.view3.alpha = 1
            } completion: { _ in
                UIView.animate(withDuration: 1) { [weak self] in
                    self?.view3.alpha = 0
                    self?.view1.alpha = 1
                } completion: { [weak self] _ in
                    if currentCount + 1 <= totalCount {
                        self?.loadAnimate(currentCount: currentCount + 1, totalCount: totalCount)
                        //self?.loginTextField.text = String(currentCount + 1)
                    } else {
                        return
                    }
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadAnimate(currentCount: 1, totalCount: 20)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapOnGestures()
        notificationKayboard()
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let login = self.loginTextField.text,
              login == "",
              let password = self.passwordTextField.text,
              password == ""
        else {
            print("Error")
            return
        }
        
        performSegue(withIdentifier: fromLoginToTabBarId, sender: nil)
       }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

private extension ViewController {
    func tapOnGestures() {
        let tapRecognaizer = UITapGestureRecognizer(target: self, action: #selector(onTap))
        self.view.addGestureRecognizer(tapRecognaizer)
    }
    
    @objc func onTap() {
        self.view.endEditing(true)
    }
    
    func notificationKayboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc func keyboardDidShow(_ notification: Notification) {
        let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        guard let keyboardHeight = keyboardSize?.height else { return }
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        
        scrollViewTitle.contentInset = contentInset
        scrollViewTitle.scrollIndicatorInsets = contentInset
    }
    
    @objc func keyboardDidHide() {
        scrollViewTitle.contentInset = UIEdgeInsets.zero
        scrollViewTitle.scrollIndicatorInsets = UIEdgeInsets.zero
    }
}
