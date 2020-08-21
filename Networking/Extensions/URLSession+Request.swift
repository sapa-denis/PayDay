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

    func request(_ urlRequest: RequestConvertible,
                 completion: @escaping URLRequestResponse) -> URLSessionDataTask? {
        do {
            let request = try urlRequest.asURLRequest()
            let task = dataTask(with: request, completionHandler: completion)

            task.resume()

            return task
        } catch {
            completion(nil, nil, error)
            return nil
        }
    }
}
