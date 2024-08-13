//
//  WorkingHoursModel.swift
//  ShopUrFood_Customer
//
//  Created by Aitor Pagán on 12/8/24.
//  Copyright © 2024 apple4. All rights reserved.
//

import Foundation

struct OpeningTime {
    let start: String // TODO: Change to Date
    let end: String // TODO: Change to Date
}

extension OpeningTime {
    init(from: String, to: String) {
        self.start = from
        self.end = to
    }
}

struct DailySchedule {
    let day: String
    let availability: String?
    let openingTimes: [OpeningTime]
    
    var isAvailable: Bool {
        availability == "Available"
    }
}

extension DailySchedule {
    init?(from dictionary: NSDictionary) {
        guard let day = dictionary.object(forKey: "working_date") as? String else {
            return nil
        }
        self.day = day
        self.availability = dictionary.object(forKey: "available_status") as? String
        var openingTimes = [OpeningTime]()
        if let dailyStart = dictionary.object(forKey: "working_from_time") as? String,
           let dailyEnd = dictionary.object(forKey: "working_end_time") as? String {
            openingTimes.append(.init(from: dailyStart, to: dailyEnd))
        }
        if let afternoonStart = dictionary.object(forKey: "old_from_time") as? String,
           let afternoonEnd = dictionary.object(forKey: "old_end_time") as? String {
            openingTimes.append(.init(from: afternoonStart, to: afternoonEnd))
        }
        self.openingTimes = openingTimes
    }
}

struct WorkingHours {
    let schedule: [DailySchedule]
}

extension WorkingHours {
    init(from array: NSArray) {
        var schedule = [DailySchedule]()
        for value in array {
            guard let dict = value as? NSDictionary,
                  let dailySchedule = DailySchedule(from: dict) else {
                assert(false, "Received a daily schedule but could not parse \(value)")
                continue
            }
            schedule.append(dailySchedule)
        }
        self.schedule = schedule
    }
}
