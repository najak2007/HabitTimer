//
//  Date+Extension.swift
//  TodayToDoList
//
//  Created by najak on 6/30/25.
//

import Foundation
import SwiftUI

enum DateFormat: String {
    case HHmm = "HH:mm"
    case HHmmss = "HH:mm:ss"
    case Mde = "M/d(E)"
    case yyMMdd = "yy:MM:dd"
    case yyMMddDot = "yy.MM.dd"
    case EEEEMMMMddyyyy = "EEEE MMMM dd,yyyy"
    case yyyyMMdd = "yyyyMMdd"
    case yyyyMMddHyphen = "yyyy-MM-dd"
    case yyyyMMddDot = "yyyy.MM.dd"
    case yyMMddDotE = "yy.MM.dd'('E')'"
    case MMdd = "MM/dd"
    case iso8601 = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    case iso86012 = "yyyy-MM-dd'T'HH:mm:ss.SS'Z'"
    case yyyyMMddHHmmss = "yyyy.MM.dd' 'HH:mm:ss"
    case yyyyMMddHyphenHHmmssColon = "yyyy-MM-dd' 'HH:mm:ss"
    case yyyyMMddHHmm = "yyyy/MM/dd' 'HH:mm"
    case yyyyMMddKR = "yyyy'년 'M'월 'd'일"
    case yyyyMMKR = "yyyy'년 'M'월"
    case MMddE = "MM/dd'('E')'"
    case HHmmForWeather = "HHmm"
    case yearWeek = "yyyyw"
    case ahmm = "a' 'h':'mm"
    case yearKR = "yyyy'년"
    case MMddDot = "MM.dd"
}

enum TimeZoneFormat: String {
    case Locale
    case UTC = "UTC"
    case KST = "Asia/Seoul"
    
    func getTimeZone() -> TimeZone {
        return (self == .Locale) ? .autoupdatingCurrent : TimeZone(identifier: self.rawValue)!
    }
}

extension Date {
    public func dateCompare(fromDate: Date) -> String {
        let dateFormatter: DateFormatter = .init()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let fromDateString: String = dateFormatter.string(from: fromDate)
        let selfDateString: String = dateFormatter.string(from: self)
        
        if fromDateString == selfDateString {
            return "S"      // 동일
        } else if fromDateString > selfDateString {
            return "F"      // 미래
        } else if fromDateString < selfDateString {
            return "P"      // 과거
        }

        return ""
    }
    
    func getAllDates() -> [Date] {
        let calendar = Calendar.current
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
        let range = calendar.range(of: .day, in: .month, for: startDate)!
        
        return range.compactMap { day -> Date in
            calendar.date(byAdding: .day, value: day - 1, to: startDate) ?? Date()
        }
    }
    
    func asString(format: DateFormat, timeZone: TimeZone? = TimeZone(abbreviation: "KST")) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = format.rawValue
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: self)
    }
    
    func now() -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter.string(from: now)
    }
    
    func getDataID() -> String {
        let date: Date = Date()
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let newID: String = dateFormatter.string(from: date)
        return newID
    }
        
    var weekDay: String {
        let weekDay = Calendar.current.component(.weekday, from: self)
        if weekDay > 0 && weekDay < 8 {
            return Config.WEEKDAY_TITLE[weekDay - 1]
        }
        return ""
    }
    
    var startOfToday: Date {
        let now = Date()
        let calendar = Calendar.current
        return calendar.startOfDay(for: now)
    }
    
    var toDoListID: String {
        return "TODO\(getDataID())"
    }
    
    var HHmm: String{
        return asString(format: .HHmm)
    }
    
    var HHmmss: String{
        return asString(format: .HHmmss)
    }
    
    var Mde: String {
        return asString(format: .Mde)
    }
    
    var MMddDot: String {
        return asString(format: .MMddDot)
    }
    
    var yyMMdd: String{
        return asString(format: .yyMMdd)
    }
    
    var yyMMddDot: String {
        return asString(format: .yyMMddDot)
    }
    
    var yyMMddDotE: String {
        return asString(format: .yyMMddDotE)
    }
    
    var EEEEMMMMddyyyy: String{
        return asString(format: .EEEEMMMMddyyyy)
    }
    
    var yyyyMMdd: String{
        return asString(format: .yyyyMMdd)
    }
    
    var yyyyMMddHyphen: String{
        return asString(format: .yyyyMMddHyphen)
    }
    
    var yyyyMMddDot: String {
        return asString(format: .yyyyMMddDot)
    }
    
    var MMddHHmm: String{
        return asString(format: .MMdd)
    }
    
    var yyyyMMddHHmmss: String {
        return asString(format: .yyyyMMddHHmmss)
    }
    
    var yyyyMMddHHmm: String {
        return asString(format: .yyyyMMddHHmm)
    }
    
    var yyyyMMddKR: String {
        return asString(format: .yyyyMMddKR)
    }
    
    var yyyyMMKR: String {
        return asString(format: .yyyyMMKR)
    }
    
    var yyyyKR: String {
        return asString(format: .yearKR)
    }
    
    var MMddE: String {
        return asString(format: .MMddE)
    }
    
    var HHmmForWeather: String {
        return asString(format: .HHmmForWeather)
    }
    
    var yearWeek: String {
        return asString(format: .yearWeek)
    }
    
    var ahmm: String {
        return asString(format: .ahmm)
    }
}
