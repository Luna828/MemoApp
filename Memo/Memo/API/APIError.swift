//
//  APIError.swift
//  Memo
//
//  Created by t2023-m0050 on 2023/08/29.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case decodingError
    case networkError
}
