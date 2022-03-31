//
//  Session.swift
//  VK_Test_API
//
//  Created by Александр Шербуренко on 30.03.2022.
//

import Foundation
import UIKit

class Session {
    
    public static let shared = Session()
    
    private init() {}
    
    var token = ""
    var userID = 0
}
