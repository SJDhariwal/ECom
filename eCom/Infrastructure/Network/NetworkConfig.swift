//
//  NetworkConfig.swift
//  eCom
//
//  Created by Sumit Kumar Jangra on 02/02/25.
//

import Foundation

protocol NetworkConfigurable {
    var baseURL: URL { get }
    var headers: [String: String] { get }
}

struct ApiDataNetworkConfig: NetworkConfigurable {
    let baseURL: URL
    let headers: [String : String]
    
    init(baseURL: URL,
         headers: [String: String] = [:]) {
        self.baseURL = baseURL
        self.headers = headers
    }
}

