//
//  NetworkOperation.swift
//  Core
//
//  Created by Sapa Denys on 05.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import Core

public final class NetworkOperation: CoreOperation<RequestConvertible, Data> {

    // MARK: - Properties
    private var session: URLSession
    private var dataTask: URLSessionDataTask!

    // MARK: - Init / Deinit methods
    public init(in queue: OperationQueue,
                session: URLSession,
                request: RequestConvertible? = nil) {
        self.session = session
        super.init(in: queue)
        if let request = request {
            input = .success(request)
        }
    }

    // MARK: - Life Cycle
    public override func main() {
        guard canProceed() else { return }

        _ = input.map(execute)
    }

    public override func cancel() {
        super.cancel()

        dataTask?.cancel()
    }

    private func execute(urlRequest: RequestConvertible) {

        dataTask = session.request(urlRequest) { responseData, response, error in

            defer {
                self.finished()
            }

            if let urlResponse = response as? HTTPURLResponse,
                !Constants.validStatusCodes.contains(urlResponse.statusCode) {
                self.output = .failure(NetworkError.unacceptableStatusCode(code: urlResponse.statusCode))

                return
            }

            guard let data = responseData,
                error == nil else {
                    self.output = .failure(NetworkError.invalidResponse(error: error))

                    return
            }

            self.output = .success(data)
        }
    }
}
