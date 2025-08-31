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
    case deleteAlarm(Int, ReasonDTO)
    case getPlaceDetail(String, String)
    case logout
    case signout
    case checkInAlarm(Int, AlarmCheckInRequestDTO)
    case offCount
}

extension DefaultTargetType: TargetType {
    
    public var validationType: ValidationType { .successCodes }
    
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
        case let .deleteAlarm(alarmId, _):
            return "/api/alarms/\(alarmId)"
        case let .getPlaceDetail(latitude, longitude):
            return "/api/places/detail"
        case .logout:
            return "/api/auth/logout"
        case .signout:
            return "/api/members"
        case let .checkInAlarm(alarmId, _):
            return "/api/alarms/\(alarmId)/checkin"
        case .offCount:
            return "/api/alarms/off-count"
            
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
        case .deleteAlarm:
            return .delete
        case .getPlaceDetail:
            return .get
        case .logout:
            return .post
        case .signout:
            return .delete
        case .checkInAlarm:
            return .post
        case .offCount:
            return .get
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
        case let .deleteAlarm(_, request):
            return .requestJSONEncodable(request)
        case let .getPlaceDetail(latitude, longitude):
            return .requestParameters(parameters: ["latitude": latitude,
                                                   "longitude" : longitude],
                                      encoding: URLEncoding.default)
        case .logout:
            return .requestPlain
        case .signout:
            return .requestPlain
        case let .checkInAlarm(_, request):
            return .requestJSONEncodable(request)
        case .offCount:
            return .requestPlain
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
