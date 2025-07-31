//
//  NetworkRequestInterceptor.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 7/11/25.
//

import Foundation
import Alamofire

final class NetworkRequestInterceptor: RequestInterceptor {
    
    public init () {}
    
    public func adapt(_ urlRequest: URLRequest,
                      for session: Session,
                      completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        var urlRequest = urlRequest
        
        guard let accessToken = KeychainProvider.shared.read(.accessToken) else {
            completion(.success(urlRequest))
            return
        }
        
        urlRequest.headers.add(.authorization(bearerToken: accessToken))
        completion(.success(urlRequest))
    }
    
    public func retry(_ request: Request,
                      for session: Session,
                      dueTo error: any Error,
                      completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse,
              response.statusCode == 401 else {
            completion(.doNotRetryWithError(error))
            return
        }
        self.reissueTokens(completion: completion)
    }
    
    func reissueTokens(completion: @escaping (RetryResult) -> Void) {}
}
