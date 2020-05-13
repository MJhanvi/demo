//
//  WebserviceHandler.swift
//  Demo
//
//  Created by Jhanvi M. on 13/05/20.
//  Copyright © 2020 Jhanvi. All rights reserved.
//

import Foundation
import Alamofire
import PKHUD

let listData_url = "http://opentable.herokuapp.com/api/restaurants?city=chicago&per_page=50&page="
let details_url = "https://www.opentable.com/r/rosebud-steakhouse-chicago?rid="

typealias CompletionHandler = (_ success:Bool,_ reponsedata:NSDictionary) -> Void

class WebserviceHandler {
    static let shared = WebserviceHandler()
    
    func getList(pageCount: Int, completionHandler: @escaping CompletionHandler){
        print("urlhere \(listData_url)\(pageCount)")
        AF.request("\(listData_url)\(pageCount)").responseJSON { response in
            switch response.result {
            case .success(let value):
                if let JSONdict = value as? NSDictionary{
                    completionHandler(true, JSONdict)
                } else {
                    completionHandler(false,NSDictionary())
                }
            case .failure(let error):
                print(error)
                completionHandler(false,NSDictionary())
            }
        }
    }
}
