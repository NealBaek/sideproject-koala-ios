//
//  CalendarData.swift
//  Koala
//
//  Created by 백수호 on 2023/07/05.
//

import Foundation
import Combine

enum CalendarConstants {
//    static let NUM_DAYS_IN_MONTH = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}
    static let numberOfDaysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    static let daysOfWeek = [ "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" ] // .localized
    
    static let daySeqOfSaturday = 6
    
    static let totalDayCountInCalendarView = 42;
}

class CalendarData: ObservableObject {
//    @State var selectedMonthIdx = 0
    @Published var monthList: [MonthData]
    
    init(monthList: [MonthData]) {
        self.monthList = monthList
    }
    
    class MonthData: ObservableObject, Identifiable {
        let id = UUID()
        let month: Int
        let year: Int
        let numberOfDaysInTheMonth: Int
        let index: Int
        
        @Published var dayList: [DayData]
        
        init(month: Int, year: Int, numberOfDaysInTheMonth: Int, index: Int, dayList: [DayData]) {
            self.month = month
            self.year = year
            self.numberOfDaysInTheMonth = numberOfDaysInTheMonth
            self.index = index
            
            self.dayList = dayList
        }
        
        static let dummy = MonthData(month: 0, year: 0, numberOfDaysInTheMonth: 0, index: 0, dayList: [])
        
        class DayData: ObservableObject, Identifiable {
            let id = UUID()
            let year: Int
            let month: Int
            let day: Int
            var date: Date?
            let dayOfTheWeek: String
            let daySeq: Int // 일주일 중 몇 번째 요일 인지
            var isOutMonth: Bool

            let dayIdx: Int //
            let monthIdx: Int //
            let yearIdx: Int //

            @Published var drunkLevel: Int
    //            ArrayList<Friend> friendList = new ArrayList<>()
    //            ArrayList<Food> foodList = new ArrayList<>()
    //            ArrayList<Drink> drinkList = new ArrayList<>()
            @Published var expense: Double
            @Published var memo: String
            @Published var isSaved: Bool // 한번이라도 저장되었는지 확인.
            
            init(year: Int, month: Int, day: Int, date: Date? = nil, dayOfTheWeek: String, daySeq: Int, isOutMonth: Bool, dayIdx: Int, monthIdx: Int, yearIdx: Int) {
                self.year = year
                self.month = month
                self.day = day
                self.date = date
                self.dayOfTheWeek = dayOfTheWeek
                self.daySeq = daySeq
                self.isOutMonth = isOutMonth
                self.dayIdx = dayIdx
                self.monthIdx = monthIdx
                self.yearIdx = yearIdx
                
                self.drunkLevel = 0
                self.expense = 0
                self.memo = ""
                self.isSaved = false
            }
            
            func copy() -> DayData {
                return .init(
                    year: self.year,
                    month: self.month,
                    day: self.day,
                    date: self.date,
                    dayOfTheWeek: self.dayOfTheWeek,
                    daySeq: self.daySeq,
                    isOutMonth: self.isOutMonth,
                    dayIdx: self.dayIdx,
                    monthIdx: self.monthIdx,
                    yearIdx: self.yearIdx)
            }
        }
    }

}
