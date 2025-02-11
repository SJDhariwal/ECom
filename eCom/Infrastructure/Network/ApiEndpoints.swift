//
//  ApiEndpoints.swift
//  eCom
//
//  Created by Sumit Kumar Jangra on 02/02/25.
//

import Foundation

struct ApiEndpoints {
    static func getProductList() -> Endpoint<ProductListModel> {
        return Endpoint(path: "/products", method: .get)
    }
}
