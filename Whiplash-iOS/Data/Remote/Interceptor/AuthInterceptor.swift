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
                print("로그인 성공: \(data)")
                KeychainProvider.shared.save(data.accessToken, key: .accessToken)
                KeychainProvider.shared.save(data.refreshToken, key: .refreshToken)

            case .failure(let error):
                print("로그인 실패: \(error.localizedDescription)")
                self.deleteAllTokens()
            }
        }
    }
    
    private func deleteAllTokens() {
        KeychainProvider.shared.delete(.accessToken)
        KeychainProvider.shared.delete(.refreshToken)
    }
}
