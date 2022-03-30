//
//  Session.swift
//  VK_Test
//
//  Created by Александр Шербуренко on 29.03.2022.
//

import Foundation

class Account {
    
    private init() {}
    
    public static let shared = Account()
    
    var token: String = ""
    var userID: Int = 0
}
