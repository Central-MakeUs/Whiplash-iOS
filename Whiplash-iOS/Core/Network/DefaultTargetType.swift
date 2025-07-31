//
//  DefaultTargetType.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 7/8/25.
//

import Foundation
import Moya

public enum DefaultTargetType {
    /// 로그인
    case signIn(SignInRequestDTO)
}

extension DefaultTargetType: TargetType {
    public var baseURL: URL {
        guard let baseUrlString = Bundle.current.object(forInfoDictionaryKey: "BASE_URL") as? String else {
            fatalError("BASE_URL not found in Info.plist")
        }
        guard let url = URL(string: baseUrlString) else {
            fatalError("URL 타입 변환 실패")
        }
        return url
    }
    
    public var path: String {
        switch self {
        case .signIn:
            print("\(baseURL)/signIn")
            return "/signIn"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .signIn:
            return .get
        }
    }
    
    public var task: Task {
        switch self {
        case .signIn(let request):
            return .requestJSONEncodable(request)
        }
    }
    
    
    public var headers: [String: String]? {
        return [
            "Content-Type": "application/json",
        ]
    }
}

// FIXME: Bundle
extension Bundle {
    static var current: Bundle {
        class __ { }
        return Bundle(for: __.self)
    }
}
