//
//  URLSession+Request.swift
//  Core
//
//  Created by Sapa Denys on 05.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import Foundation

typealias URLRequestResponse = (Data?, URLResponse?, Error?) -> Void

extension URLSession {
    
    func request(_ urlRequest: URLRequest, completion: @escaping URLRequestResponse) -> URLSessionDataTask? {
        let task = dataTask(with: urlRequest, completionHandler: completion)
        
        task.resume()
        
        return task
    }
}
