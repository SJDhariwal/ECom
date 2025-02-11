//
//  NetworkService.swift
//  eCom
//
//  Created by Sumit Kumar Jangra on 01/02/25.
//

import Foundation

enum NetworkError: Error {
    case error(statusCode: Int, data: Data?)
    case notConnected
    case cancelled
    case generic(Error)
}

protocol NetworkSessionManager {
    func request(request: URLRequest) async throws -> (Data?, URLResponse?, Error?)
}

protocol NetworkService {
    func request(endpoint: Requestable) async throws -> Result<Data?, NetworkError>
}

final class DefaultNetworkService: NetworkService {
    
    let sessionManager: NetworkSessionManager
    let config: NetworkConfigurable
    
    init(
        sessionManager: NetworkSessionManager = DefaultNetworkSessionManager(),
        config: NetworkConfigurable
    ) {
        self.sessionManager = sessionManager
        self.config = config
    }
    
    func request(endpoint: Requestable) async throws -> Result<Data?, NetworkError> {
        let urlRequest = try endpoint.urlRequest(with: config)
        let (data, requestError) = try await request(request: urlRequest)
        if let requestError = requestError {
            return .failure(requestError)
        }
        return .success(data)
    }
    
    private func request(request: URLRequest) async throws -> (Data?, NetworkError?) {
        let (data, response, requestError) = try await sessionManager.request(request: request)
        if let requestError = requestError {
            var error: NetworkError
            if let response = response as? HTTPURLResponse {
                error = .error(statusCode: response.statusCode, data: data)
            } else {
                error = self.resolve(error: requestError)
            }
            return (nil, error)
        } else {
            return (data, nil)
        }
    }
    
    private func resolve(error: Error) -> NetworkError {
        let code = URLError.Code(rawValue: (error as NSError).code)
        switch code {
        case .notConnectedToInternet:
            return .notConnected
        case .cancelled:
            return .cancelled
        default:
            return .generic(error)
        }
    }
}

final class DefaultNetworkSessionManager: NetworkSessionManager {
    func request(request: URLRequest) async throws -> (Data?, URLResponse?, Error?) {
        let (data, response) = try await URLSession.shared.data(for: request)
        return (data, response, nil)
    }
}
