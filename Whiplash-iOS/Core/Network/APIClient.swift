//
//  APIClient.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 7/8/25.
//

import Foundation
import Moya

public final class APIClient {
    private let provider: MoyaProvider<DefaultTargetType>
    
    public init() {
        let insterceptor = AuthInterceptor.shared
        let session = Session(interceptor: insterceptor)
        provider = MoyaProvider<DefaultTargetType>(session: session)
    }
    
    /// response가 있는 api request에 사용
    public func request<T: Respondable>(
        _ T: T.Type,
        target: DefaultTargetType,
        completion: @escaping (Result<T, MoyaError>) -> Void
    ) {
        provider.request(target) { result in
            switch result {
            case .success(let response):
                guard (200..<300) ~= response.statusCode else {
                    completion(.failure(.statusCode(response)))
                    return
                }
                
                do {
                    let data = try JSONDecoder().decode(T.self, from: response.data)
                    completion(.success(data))
                } catch let error {
                    completion(.failure(.objectMapping(error, response)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func request<T: Respondable>(
        _ T: T.Type,
        target: DefaultTargetType
    ) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            request(T.self, target: target) { result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response)
                case .failure(let error):
                    let response = error.response
                    print("에러 statusCode:", response!.statusCode)
                    print("에러 body:", String(data: response!.data, encoding: .utf8) ?? "nil")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
