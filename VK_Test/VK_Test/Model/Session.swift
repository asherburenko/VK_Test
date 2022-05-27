//
//  Session.swift
//  VK_Test
//
//  Created by Александр Шербуренко on 29.03.2022.
//

import Foundation
import UIKit

class Session {
    
    public static let shared = Session()
    
    private init() {}
    
    var token = ""
    var userID = 0
    
    func loginInUser(with token: String, userID: Int) {
        self.token = token
        self.userID = userID
        print("Token \(token), UserID \(userID)")
    }
}
