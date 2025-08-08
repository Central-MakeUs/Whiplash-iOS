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
    case reissueToken(TokenReissueRequestDTO)
    case searchPlace(String)
    case addAlarm(AlarmRequestDTO)
    case getAlarmList
    case alarmOff(Int, AlarmOffRequestDTO)
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
            return "/api/auth/social-login"
        case .reissueToken:
            return "/api/auth/reissue"
        case .searchPlace:
            return "/api/places/search"
        case .addAlarm:
            return "/api/alarms"
        case .getAlarmList:
            return "/api/alarms"
        case let .alarmOff(alarmId, _):
            return "/api/alarms/\(alarmId)/off"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .signIn:
            return .post
        case .reissueToken:
            return .post
        case .searchPlace:
            return .get
        case .addAlarm:
            return .post
        case .getAlarmList:
            return .get
        case .alarmOff:
            return .post
        }
    }
    
    public var task: Task {
        switch self {
        case .signIn(let request):
            return .requestJSONEncodable(request)
        case .reissueToken(let request):
            return .requestJSONEncodable(request)
        case .searchPlace(let query):
            return .requestParameters(parameters: ["query": query], encoding: URLEncoding.default)
        case .addAlarm(let request):
            return .requestJSONEncodable(request)
        case .getAlarmList:
            return .requestPlain
        case let .alarmOff(_, request):
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
