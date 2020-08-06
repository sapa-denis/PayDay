//
//  OperationQueue.swift
//  Core
//
//  Created by Sapa Denys on 06.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import Foundation

private let concurentNetworkingQueue = DispatchQueue(label: "concurent.networking.queue", attributes: .concurrent)
private let concurentAdditionalQueue = DispatchQueue(label: "concurent.additional.queue", attributes: .concurrent)

extension OperationQueue {
    
    public static let networking: OperationQueue = {
        let queue = OperationQueue()
        queue.name = String(describing: concurentNetworkingQueue.label)
        queue.underlyingQueue = concurentNetworkingQueue
        
        return queue
    }()
    
    public static let additional: OperationQueue = {
        let queue = OperationQueue()
        queue.name = String(describing: concurentAdditionalQueue.label)
        queue.underlyingQueue = concurentAdditionalQueue
        
        return queue
    }()
}
