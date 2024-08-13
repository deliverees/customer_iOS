//
//  WorkingHoursTests.swift
//  ShopUrFood_CustomerTests
//
//  Created by Aitor Pagán on 13/8/24.
//  Copyright © 2024 apple4. All rights reserved.
//

import XCTest
@testable import ShopUrFood_Customer

final class WorkingHoursTests: XCTestCase {
    func testCreation() throws {
        let sut = WrokingHoursViewController()
        
        XCTAssertNotNil(sut)
    }
    
    func testWorkingHoursParsingContract() async throws {
        let dictionary = [
            "working_date": "sab.",
            "available_status": "Available",
            "working_from_time": "9:00am",
            "working_end_time": "12:00pm",
            "old_from_time": "13:00pm",
            "old_end_time": "16:00pm"
        ]
        
        let array = [dictionary]
        
        let sut = WorkingHours(from: array as NSArray)
        
        XCTAssertEqual(sut.schedule.count, 1)
        
        let schedule = sut.schedule.first
        
        XCTAssertEqual(schedule?.day, "sab.")
        XCTAssertEqual(schedule?.openingTimes.count, 2)
        
        let openingTime = schedule?.openingTimes.first
        
        XCTAssertEqual(openingTime?.start, "9:00am")
    }
    
    @MainActor
    func testDisplayProperly() throws {
        let dictionary = [
            "working_date": "sab.",
            "available_status": "Available",
            "working_from_time": "9:00am",
            "working_end_time": "12:00pm",
            "old_from_time": "13:00pm",
            "old_end_time": "16:00pm"
        ]
        
        let array = [dictionary]
        
        let workingHours = WorkingHours(from: array as NSArray)
        let sut = UIStoryboard(name: "Main", bundle: Bundle(for: WrokingHoursViewController.self)).instantiateViewController(identifier: "WrokingHoursViewController") as! WrokingHoursViewController
        sut.workingHours = workingHours
        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()
        sut.viewDidLoad()
        
        XCTAssertEqual(sut.tableView(sut.hoursTable,
                                     numberOfRowsInSection: 0), 1)
        
        let cell = sut.tableView(sut.hoursTable, cellForRowAt: .init(row: 0, section: 0)) as? WorkingHoursTableViewCell
        
        XCTAssertEqual(cell?.dayLbl.text, "sab")
        XCTAssertEqual(cell?.hoursStackView.subviews.count, 2)
        XCTAssertEqual(cell?.statusLbl.text, "Available")
        
        let firstLabel = cell?.hoursStackView.subviews.first as? UILabel
        
        XCTAssertEqual("opening_from: 9:00am opening_to: 12:00pm", firstLabel?.text)
    }
}
