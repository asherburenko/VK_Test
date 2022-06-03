//
//  GetAPIDataFriends.swift
//  VK_Test
//
//  Created by Александр Шербуренко on 03.06.2022.
//

import Foundation
import Alamofire
import SwiftyJSON

class GetAPIDataFriends:AsyncOperation {
    
    private var host: String
    private var path: String
    private var parameters: [String: String]
    
    static var data: Friends0?
    
    init(host: String, path: String, parameters: [String: String]) {
        self.host = host
        self.path = path
        self.parameters = parameters
    }
    
    override func main() {
        AF
            .request(host + path,
                        method: .get,
                        parameters: parameters)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    let json = JSON(data)
                    let friends = Friends0(json)
                    GetAPIDataFriends.data = friends
                    self.state = .finished
                case .failure(let error):
                    print(error)
                }
            }
    }
}
