//
//  StringArrayConverter.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/11/25.
//

import Foundation

struct StringArrayConverter {
    
    /// 문자열을 배열로 변환 (기본: 쉼표 구분)
    /// - Parameter string: "a, b, c" 형태의 문자열
    /// - Returns: ["a", "b", "c"] 배열
    static func stringToArray(_ string: String) -> [String] {
        return stringToArray(string, separator: ",")
    }
    
    /// 배열을 문자열로 변환 (기본: 쉼표 구분)
    /// - Parameter array: ["a", "b", "c"] 형태의 배열
    /// - Returns: "a, b, c" 문자열
    static func arrayToString(_ array: [String]) -> String {
        return arrayToString(array, separator: ", ")
    }
    
    static func stringToArray(_ string: String, separator: String) -> [String] {
        guard !string.isEmpty else { return [] }
        
        return string
            .split(separator: separator)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }
    
    static func arrayToString(_ array: [String], separator: String) -> String {
        return array
            .filter { !$0.isEmpty }
            .joined(separator: separator)
    }
}
