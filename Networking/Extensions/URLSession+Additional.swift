//
//  URLSession+Additional.swift
//  Networking
//
//  Created by Sapa Denys on 06.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import Foundation

extension URLSession {

    public static let main: URLSession = {
        let sessionConfiguration: URLSessionConfiguration = .default
        sessionConfiguration.httpShouldSetCookies = false
        sessionConfiguration.httpCookieAcceptPolicy = .never
        sessionConfiguration.requestCachePolicy = .reloadIgnoringLocalCacheData

        return URLSession(configuration: sessionConfiguration)
    }()

    public static let background: URLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier: "core.background.session.manager")
        configuration.sharedContainerIdentifier = "core.background.container"

        return URLSession(configuration: configuration)
    }()
}
