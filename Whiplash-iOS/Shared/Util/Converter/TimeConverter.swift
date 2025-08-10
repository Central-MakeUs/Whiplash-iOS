//
//  TimeConverter.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/11/25.
//

// 수정된 TimeConverter.swift

import Foundation

struct TimeConverter {
    
    struct Time12Hour {
        let time: String      // "11:30" 형식
        let ampm: String      // "오전" 또는 "오후"
        
        init(time: String, ampm: String) {
            self.time = time
            self.ampm = ampm
        }
        
        init(hour: Int, minute: Int, ampm: String) {
            self.time = String(format: "%02d:%02d", hour, minute)
            self.ampm = ampm
        }
    }
    
    struct Time24Hour {
        let time: String      // "23:30" 형식
        
        init(time: String) {
            self.time = time
        }
        
        init(hour: Int, minute: Int) {
            self.time = String(format: "%02d:%02d", hour, minute)
        }
    }
    
    // MARK: - 변환 함수들
    static func convert12To24(time: String, ampm: String) -> String? {
        guard let parsed = parseTime12Hour(time) else { return nil }
        
        let hour24 = calculateHour24(hour: parsed.hour, ampm: ampm)
        return String(format: "%02d:%02d", hour24, parsed.minute)
    }
    
    static func convert12To24(_ time12: Time12Hour) -> Time24Hour? {
        guard let converted = convert12To24(time: time12.time, ampm: time12.ampm) else {
            return nil
        }
        return Time24Hour(time: converted)
    }
    
    static func convert24To12(_ time24: String) -> (time: String, ampm: String)? {
        guard let parsed = parseTime24Hour(time24) else { return nil }
        
        let (hour12, ampm) = calculateHour12AndAmPm(hour24: parsed.hour)
        let time12 = String(format: "%02d:%02d", hour12, parsed.minute)
        
        return (time: time12, ampm: ampm)
    }
    
    static func convert24To12(_ time24: Time24Hour) -> Time12Hour? {
        guard let converted = convert24To12(time24.time) else { return nil }
        return Time12Hour(time: converted.time, ampm: converted.ampm)
    }
    
    // MARK: - 파싱 함수들
    /// "00:30" 또는 "11:30" 형식 파싱 (00~12 허용)
    private static func parseTime12Hour(_ timeString: String) -> (hour: Int, minute: Int)? {
        let components = timeString.split(separator: ":")
        guard components.count == 2,
              let hour = Int(components[0]),
              let minute = Int(components[1]),
              hour >= 0 && hour <= 12,
              minute >= 0 && minute <= 59 else {
            return nil
        }
        return (hour: hour, minute: minute)
    }
    
    /// "23:30" 형식 파싱 (변경 없음)
    private static func parseTime24Hour(_ timeString: String) -> (hour: Int, minute: Int)? {
        let components = timeString.split(separator: ":")
        guard components.count == 2,
              let hour = Int(components[0]),
              let minute = Int(components[1]),
              hour >= 0 && hour <= 23,
              minute >= 0 && minute <= 59 else {
            return nil
        }
        return (hour: hour, minute: minute)
    }
    
    // MARK: - 계산 함수들
    /// 12시간 + ampm → 24시간 계산
    private static func calculateHour24(hour: Int, ampm: String) -> Int {
        switch (hour, ampm) {
        case (0, "오전"):
            return 0        // 오전 00시 → 00시 (자정)
        case (0, "오후"):
            return 12       // 오후 00시 → 12시 (정오로 해석)
            
            // 기존 12시 처리
        case (12, "오전"):
            return 0        // 오전 12시 → 00시 (자정)
        case (12, "오후"):
            return 12       // 오후 12시 → 12시 (정오)
            
            // 1~11시 처리
        case (1...11, "오전"):
            return hour     // 오전 1~11시 → 01~11시
        case (1...11, "오후"):
            return hour + 12 // 오후 1~11시 → 13~23시
            
        default:
            return 0        // 기본값
        }
    }
    
    /// 24시간 → 12시간 + ampm 계산 (변경 없음)
    private static func calculateHour12AndAmPm(hour24: Int) -> (hour: Int, ampm: String) {
        switch hour24 {
        case 0:
            return (12, "오전")    // 00시 → 오전 12시 (자정)
        case 1...11:
            return (hour24, "오전") // 01~11시 → 오전 1~11시
        case 12:
            return (12, "오후")    // 12시 → 오후 12시 (정오)
        case 13...23:
            return (hour24 - 12, "오후") // 13~23시 → 오후 1~11시
        default:
            return (12, "오전")    // 기본값
        }
    }
    
    // MARK: - 유틸리티 함수들
    
    static func isValidTime12Hour(_ time: String) -> Bool {
        return parseTime12Hour(time) != nil
    }
    
    static func isValidTime24Hour(_ time: String) -> Bool {
        return parseTime24Hour(time) != nil
    }
    
    static func isValidAmPm(_ ampm: String) -> Bool {
        return ampm == "오전" || ampm == "오후"
    }
    
    static func getCurrentTime12Hour() -> Time12Hour {
        let now = Date()
        let calendar = Calendar.current
        let hour24 = calendar.component(.hour, from: now)
        let minute = calendar.component(.minute, from: now)
        
        let (hour12, ampm) = calculateHour12AndAmPm(hour24: hour24)
        return Time12Hour(hour: hour12, minute: minute, ampm: ampm)
    }
    
    static func getCurrentTime24Hour() -> Time24Hour {
        let now = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: now)
        let minute = calendar.component(.minute, from: now)
        
        return Time24Hour(hour: hour, minute: minute)
    }
    
}

extension TimeConverter.Time12Hour {
    func to24Hour() -> TimeConverter.Time24Hour? {
        return TimeConverter.convert12To24(self)
    }
    
    var fullDisplay: String {
        return "\(ampm) \(time)"
    }
}

extension TimeConverter.Time24Hour {
    func to12Hour() -> TimeConverter.Time12Hour? {
        return TimeConverter.convert24To12(self)
    }
}
