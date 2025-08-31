//
//  Response.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/1/25.
//

import Foundation

struct Response<T: Decodable>: Respondable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: T?
}

public struct EmptyDTO: Codable {}
