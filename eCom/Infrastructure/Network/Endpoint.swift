//
//  Endpoint.swift
//  eCom
//
//  Created by Sumit Kumar Jangra on 01/02/25.
//

import Foundation

enum HTTPMethodType: String {
    case get = "GET"
    case post = "POST"
}

enum RequestError: Error {
    case component
}

protocol BodyEncoder {
    func encode<T: Encodable>(_ parameter: T) throws -> Data?
}

protocol ResponseDecoder {
    func decode<T: Decodable>(_ data: Data) throws -> T
}

struct JSONBodyEncoder: BodyEncoder {
    private let jsonEncoder: JSONEncoder
    
    init(jsonEncoder: JSONEncoder = JSONEncoder()) {
        self.jsonEncoder = jsonEncoder
    }
    
    func encode<T: Encodable>(_ parameter: T) throws -> Data? {
        try jsonEncoder.encode(parameter)
    }
}

struct JSONResponseDecoder: ResponseDecoder {
    private let decoder: JSONDecoder
    
    init(decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
    }
    
    func decode<T>(_ data: Data) throws -> T where T : Decodable {
        return try decoder.decode(T.self, from: data)
    }
}

protocol Requestable {
    var path: String { get }
    var method: HTTPMethodType { get }
    var headerParameter: [String: String] { get }
    var queryParameter: [String: String] { get }
    var bodyParameter: Encodable? { get }
    var bodyEncoder: JSONBodyEncoder { get }
    var responseDecoder: ResponseDecoder { get }
    func urlRequest(with config: NetworkConfigurable) throws -> URLRequest
}

protocol ResponseRequestable: Requestable {
    associatedtype Response
}

class Endpoint<R>: ResponseRequestable {
    typealias Response = R
    
    let path: String
    let method: HTTPMethodType
    let headerParameter: [String: String]
    let queryParameter: [String: String]
    let bodyParameter: Encodable?
    let bodyEncoder: JSONBodyEncoder
    let responseDecoder: ResponseDecoder
    
    init(
        path: String,
        method: HTTPMethodType,
        headerParameter: [String : String] = [:],
        queryParameter: [String : String] = [:],
        bodyParameter: Encodable? = nil,
        bodyEncoder: JSONBodyEncoder = JSONBodyEncoder(),
        responseDecoder: ResponseDecoder = JSONResponseDecoder()
    ) {
        self.path = path
        self.method = method
        self.headerParameter = headerParameter
        self.queryParameter = queryParameter
        self.bodyParameter = bodyParameter
        self.bodyEncoder = bodyEncoder
        self.responseDecoder = responseDecoder
    }
}

extension Requestable {
    func url(with config: NetworkConfigurable) throws -> URL {
        let baseURL = config.baseURL.absoluteString
        let endpoint = baseURL.appending(path)
        guard var urlComponent = URLComponents(string: endpoint) else { throw RequestError.component }
        var urlQueryItems = [URLQueryItem]()
        
        queryParameter.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: $0.value))
        }
        
        urlComponent.queryItems = !urlQueryItems.isEmpty ? urlQueryItems : nil
        guard let url = urlComponent.url else { throw RequestError.component }
        return url
    }
    
    func urlRequest(with config: NetworkConfigurable) throws -> URLRequest {
        let url = try self.url(with: config)
        var urlRequest = URLRequest(url: url)
        var allHeaders: [String: String] = config.headers
        headerParameter.forEach { allHeaders.updateValue($1, forKey: $0) }
        if let bodyParameter = bodyParameter {
            urlRequest.httpBody = try bodyEncoder.encode(bodyParameter)
        }
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = allHeaders
        return urlRequest
    }
}
