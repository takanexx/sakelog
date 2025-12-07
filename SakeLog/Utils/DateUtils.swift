//
//  DateUtils.swift
//  SakeLog
//
//  Created by Takane on 2025/12/08.
//
import Foundation

extension Date {
    static var startOfThisMonth: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: Date())
        return calendar.date(from: components)!
    }

    static var endOfThisMonth: Date {
        let calendar = Calendar.current
        var comps = DateComponents()
        comps.month = 1
        comps.day = -1
        let start = startOfThisMonth
        return calendar.date(byAdding: comps, to: start)!
    }
}
