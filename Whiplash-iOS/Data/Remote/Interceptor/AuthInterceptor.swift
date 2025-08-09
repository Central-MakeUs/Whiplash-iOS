//
//  AuthInterceptor.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 7/11/25.
//

import Foundation
import Alamofire

final class AuthInterceptor: NetworkRequestInterceptor {
    
    static let shared = AuthInterceptor()
    
    override func reissueTokens(completion: @escaping (RetryResult) -> Void) {
        guard let refreshToken = KeychainProvider.shared.read(.refreshToken) else {
            completion(.doNotRetry)
            return
        }
        
        let apiClient = APIClient()
        let request = TokenReissueRequestDTO(deviceId: "")
        
        apiClient.request(Response<TokenReissueResponseDTO>.self, target: .reissueToken(request)) { result in
            switch result {
            case .success(let response):
                let data = response.result!

                TokenStore().save(accessToken: data.accessToken,
                                  refreshToken: data.refreshToken)
                Logger.shared.log(level: .debug, category: .network, "토큰 재발급 성공 : \(data)")
                
                completion(.retry)

            case .failure(let error):
                Logger.shared.log(level: .debug, category: .network, "토큰 재발급 실패 : \(error)")
                TokenStore().clear()
                completion(.doNotRetryWithError(error))
            }
        }
    }
}
