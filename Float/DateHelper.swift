//
//  DateHelper.swift
//  Float
//
//  Created by Matt Deuschle on 6/6/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import Foundation

class DateHelper {

    static func convertDateToString() -> String {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: currentDate)
    }

    static func calcuateTimeStamp(dateString: String) -> String {
        var result = ""
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let orginalDate = formatter.date(from: dateString) {
            let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: orginalDate, to: currentDate)
            if let year = dateComponents.year,
                let month = dateComponents.month,
                let day = dateComponents.day,
                let hour = dateComponents.hour,
                let minute = dateComponents.minute,
                let second = dateComponents.second {
                if year > 1 {
                    result = "\(year) years ago"
                } else if year == 1 {
                    result = "\(year) year ago"
                } else if month > 1 {
                    result = "\(month) months ago"
                } else if month == 1 {
                    result = "\(month) month ago"
                } else if day > 1 {
                    result = "\(day) days ago"
                } else if day  == 1 {
                    result = "\(day) day ago"
                } else if hour > 1 {
                    result = "\(hour) hours ago"
                } else if hour == 1 {
                    result = "\(hour) hour ago"
                } else if minute > 1 {
                    result = "\(minute) minutes ago"
                } else if minute == 1 {
                    result = "\(minute) minute ago"
                } else if second > 1 {
                    result = "\(second) seconds ago"
                } else {
                    result = "\(second) second ago"
                }
            }
        }
        return result
    }
}
