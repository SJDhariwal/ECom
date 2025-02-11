//
//  DataTransferService.swift
//  eCom
//
//  Created by Sumit Kumar Jangra on 02/02/25.
//

import Foundation

enum DataTransferError: Error {
    case noResponse
    case parsing(Error)
    case networkFailure(NetworkError)
}

protocol DataTransferService {
    
    func request<T: Decodable, E: ResponseRequestable>(
        with endpoint: E
    ) async throws -> Result<T, DataTransferError> where E.Response == T
}

class DefaultDataTransferService: DataTransferService {
    let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func request<T: Decodable, E: ResponseRequestable>(
        with endpoint: E
    ) async throws -> Result<T, DataTransferError> where E.Response == T {
        let result = try await networkService.request(endpoint: endpoint)
        switch result {
        case .success(let data):
            let result: Result<T, DataTransferError> = self.decode(data: data, decoder: endpoint.responseDecoder)
            return result
            
        case .failure(let error):
            return .failure(.networkFailure(error))
        }
    }
    
    private func decode<T: Decodable>(data: Data?, decoder: ResponseDecoder) -> Result<T, DataTransferError> {
        do {
            guard let data = data else { return .failure(.noResponse) }
            let result: T = try decoder.decode(data)
            return .success(result)
        } catch {
            return .failure(.parsing(error))
        }
    }
}

