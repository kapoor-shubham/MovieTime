//
//  ApiRequestManager.swift
//  MovieTime
//
//  Created by Shubham Kapoor on 02/01/19.
//  Copyright © 2019 Shubham Kapoor. All rights reserved.
//

import UIKit
import Alamofire

typealias ServerResponse = (_: Any?, _: Bool, _: Error?) -> Void

enum  RequestType: String {
    case  RequestTypeGet = "GET"
    case  RequestTypePost = "POST"
    case  RequestTypePut = "PUT"
    case  RequestTypeDelete = "DELETE"
}

class ApiRequestManager: NSObject {
    
    static let apiSharedManager = ApiRequestManager()
    
    func getApiCall(url: URL, headers: [String: String]?, responseObj: @escaping (ServerResponse)) -> Void {
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.get.rawValue
        urlRequest.allHTTPHeaderFields = headers
        
        Alamofire.request(urlRequest).responseJSON { response in
            if let error = response.result.error {
                responseObj(["Message": "Something went wrong, Please try again later." as AnyObject], false, error as NSError)
            } else {
                if let apiResponseDict = response.result.value {
                    responseObj(apiResponseDict, true, nil)
                }
            }
        }
    }
    
    func postApiCall(params: [String: AnyObject]?, url: URL, headers: [String: AnyObject]?, responseObj: @escaping (ServerResponse)) -> Void {
        
        Alamofire.request(url, method: HTTPMethod.post, parameters: params).responseJSON { response in
            if let error = response.result.error {
                responseObj(["Message": "Something went wrong, Please try again later." as AnyObject], false, error as NSError)
            } else {
                if let apiResponseDict = response.result.value {
                    responseObj(apiResponseDict, true, nil)
                }
            }
        }
    }
    
    func deleteApiCall(url: URL, responseObj: @escaping (ServerResponse)) -> Void {
        let firstTodoEndpoint: String = "https://jsonplaceholder.typicode.com/todos/1"
        Alamofire.request(firstTodoEndpoint, method: .delete).responseJSON { response in
            if let error = response.result.error {
                responseObj(["Message": "Something went wrong, Please try again later." as AnyObject], false, error as NSError)
            } else {
                if let apiResponseDict = response.result.value {
                    responseObj(apiResponseDict, true, nil)
                }
            }
        }
    }
}
