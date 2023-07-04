//
//  CalendarViewModel.swift
//  Koala
//
//  Created by 백수호 on 2023/07/05.
//

import Foundation
import Combine
import SwiftUI

final class CalendarViewModel: ObservableObject {
    
    typealias MonthData = CalendarData.MonthData
    typealias DayData = CalendarData.MonthData.DayData
    
    var calendarDataSubject = PassthroughSubject<CalendarData, Never>()
    @Published var calendarData = CalendarData(monthList: [])
    @Published var selectedMonthIdx: UUID = .init()
    
    private var bag = Set<AnyCancellable>()
    
    init() {
        bind()
        
        DispatchQueue.global().async {
            let calendarData = self.createCalendarModel()
            self.calendarDataSubject.send(calendarData)
        }
    }
    
}

extension CalendarViewModel {
    private func bind() {
        calendarDataSubject
            .receive(on: RunLoop.main)
            .sink { result in
                self.calendarData = result
                if let todayMonth = self.calendarData.monthList.filter({$0.year == 2021 && $0.month == 9}).first {
                    print("### todayMonth: \(todayMonth.year), \(todayMonth.month)")
                    self.selectedMonthIdx = todayMonth.id
                }
            }.store(in: &bag)
    }
}

extension CalendarViewModel {
    
    // TODO:
    // 1. 생성한 캘린더 데이터 -> CoreData 로 저장
    // 2. Application 에서 @ObservedObject 로 관리 + Injection
    
    private func createCalendarModel() -> CalendarData {
        // 시작 날짜 정하기 (2017.01.01 부터 시작)
        var startYear = 2017
        var startMonth = 1
        var startDay = 1
        var dayIdx = 0
        var monthIdx = 0
        var yearIdx = 0
        var isLeapYear = false

        // 오늘 날짜 구하기
        let nowDate = Date()
        let dfYear = DateFormatter()
        let dfMonth = DateFormatter()
        dfYear.dateFormat = "yyyy"
        dfMonth.dateFormat = "MM"
        
        let thisYear = Int(dfYear.string(from: nowDate)) ?? 0
        let thisMonth = Int(dfMonth.string(from: nowDate)) ?? 0
        
        // 끝나는 날짜 구하기
        let endYear = thisYear + 2
        let endMonth = thisMonth

        var dayDataList = [DayData]()
        
        let calendarData = CalendarData(monthList: [])

        // 계산할 연 갯구 카운트
        let toCalYearCnt = 1 + endYear - startYear
        
        // 연 계산
        for i in 0..<toCalYearCnt {

            // 만약 마지막 계산 연이면 종료 달까지/ 아니면 12개월
            let toCalMonthCnt = ((i == toCalYearCnt) ? endMonth : 12)

            // 윤년 계산
            if startYear % 400 == 0 { isLeapYear = true }       // 1. 연도가 400의 배수이면 윤년
            else if startYear % 100 == 0 { isLeapYear = false } // 2. 연도가 100의 배수이면 윤년이 아님.
            else if startYear % 4 == 0 { isLeapYear = true }    // 3. 연도가 4의 배수이면 윤년.
            else { isLeapYear = false }

            // 월 계산
            for j in 0..<toCalMonthCnt {

                // 일 계산
                var daysCnt = CalendarConstants.numberOfDaysInMonth[j%12]

                // 윤월에 1일 추가
                if j == 1 { daysCnt += isLeapYear ? 1 : 0 }
                
                let monthData = MonthData(
                    month: startMonth,
                    year: startYear,
                    numberOfDaysInTheMonth: daysCnt,
                    index: monthIdx,
                    dayList: [])
                
                let hasPMonth = (monthIdx == 0) ? false : calendarData.monthList.count > monthIdx - 1
                var pMonthData: MonthData?
                
                if hasPMonth {
                    pMonthData = calendarData.monthList[monthIdx - 1]
                }

                // 전월 일 추가

                // 전월의 마지막날의 요일 + 1일한 요일
                //  1. 만약 일요일이면 pDayCnt == 0
                //  2. 아니면 전월 마지막 요일 에서 역순으로 일요일까지 데이터 세팅
                var pDayCnt = 0
                let lastDaySeq = (pMonthData == nil) ?
                    CalendarConstants.daySeqOfSaturday : dayDataList[dayDataList.count - 1].daySeq
                
                if lastDaySeq != CalendarConstants.daySeqOfSaturday {
                    pDayCnt = lastDaySeq + 1
                    let lastMonthCnt = dayDataList.count - 1

                    for k in 0..<pDayCnt {
                        let pDayData = dayDataList[lastMonthCnt - ((pDayCnt-1) - k)].copy()
                        pDayData.isOutMonth = true
                        monthData.dayList.append(pDayData)
                    }
                }

                // 해당 일 추가
                for _ in 0..<daysCnt {

                    let daySeq = ((dayIdx)%7)
                    
                    let dateformatter = DateFormatter()
                    dateformatter.dateFormat = "yyyy.MM.dd"
                    let date = dateformatter.date(
                        from: "\(startYear).\("\(startMonth < 10 ? "0" : "")\(startMonth)").\("\(startDay < 10 ? "0" : "")\(startDay)")")
                    
                    // 데이 값 입력
                    let dayData = DayData(
                        year: startYear, month: startMonth, day: startDay, date: date,
                        dayOfTheWeek: CalendarConstants.daysOfWeek[daySeq], daySeq: daySeq,
                        isOutMonth: false, dayIdx: dayIdx, monthIdx: monthIdx, yearIdx: yearIdx)

                    dayDataList.append(dayData)
                    monthData.dayList.append(dayData)

                    startDay += 1
                    dayIdx += 1

                }

                // 익월 일 추가
                let nDayCnt = CalendarConstants.totalDayCountInCalendarView - daysCnt - pDayCnt
                if nDayCnt > 0 {
                    let isNextYear = (((pMonthData == nil) ? startMonth : pMonthData!.month) == 12)
                    var nDayIdx = dayIdx + 1

                    for k in 0..<nDayCnt {
                        
                        let daySeq = ((nDayIdx - 1)%7)
                        let year = isNextYear ? startYear - 1 : startYear
                        let month = isNextYear ? 1 : startMonth - 1
                        let day = k + 1
                        
                        let dateformatter = DateFormatter()
                        dateformatter.dateFormat = "yyyy.MM.dd"
                        let date = dateformatter.date(
                            from: "\(year).\("\(month < 10 ? "0" : "")\(month)").\("\(day < 10 ? "0" : "")\(day)")")
                        
                        let nDayData = DayData(
                            year: year, month: month, day: day, date: date,
                            dayOfTheWeek: CalendarConstants.daysOfWeek[daySeq], daySeq: daySeq,
                            isOutMonth: true, dayIdx: nDayIdx, monthIdx: monthIdx, yearIdx: yearIdx)
                        
                        monthData.dayList.append(nDayData)

                        nDayIdx += 1
                    }
                }

                calendarData.monthList.append(monthData)

                startDay = 1
                startMonth += 1
                monthIdx += 1
            }

            // 연 증가
            startDay = 1
            startMonth = 1
            startYear += 1
            yearIdx += 1
        }
        
        return calendarData
    }
}
