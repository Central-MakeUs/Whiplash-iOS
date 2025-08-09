//
//  NetworkRequestInterceptor.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 7/11/25.
//

import Foundation
import Alamofire

open class NetworkRequestInterceptor: RequestInterceptor {
    
    public init () {}
    
    public func adapt(_ urlRequest: URLRequest,
                      for session: Session,
                      completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        var urlRequest = urlRequest
        
        guard let accessToken = KeychainProvider.shared.read(.accessToken) else {
            completion(.success(urlRequest))
            return
        }
        print(accessToken)
        urlRequest.headers.add(.authorization(bearerToken: accessToken))
        completion(.success(urlRequest))
    }
    
    public func retry(_ request: Request,
                      for session: Session,
                      dueTo error: any Error,
                      completion: @escaping (RetryResult) -> Void) {
        Logger.shared.log(level: .debug, category: .network, "retry 호출됨")
        guard let response = request.task?.response as? HTTPURLResponse,
              response.statusCode == 401 else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        // 무한 재시도 방지
        guard request.retryCount == 0 else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        self.reissueTokens(completion: completion)
        
    }
    
    func reissueTokens(completion: @escaping (RetryResult) -> Void) {}
}
