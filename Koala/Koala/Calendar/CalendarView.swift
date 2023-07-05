//
//  CalendarView.swift
//  Koala
//
//  Created by 백수호 on 2023/07/05.
//

import SwiftUI

struct CalendarView: View {
    
    enum Constants {
        static let calendarHeaderHeight: CGFloat = 50
    }
    
    @ObservedObject var viewModel = CalendarViewModel()
    
    private let calendarRowCount = 6
    private let calendarColumnCount = 7
    
    var body: some View {

        VStack(spacing: 0) {
            
            calendarHeader
                .frame(height: Constants.calendarHeaderHeight)
                .background(Color.green)
                
            GeometryReader { proxy in
                TabView(selection: $viewModel.selectedMonthIdx) {
                    // 월 단위 탭
                    ForEach(viewModel.calendarData.monthList) { month in

                        let dayViewSpacing: CGFloat = 2
                        
                        LazyVGrid(
                            columns: Array(repeating: .init(.flexible()), count: calendarColumnCount), spacing: dayViewSpacing) {
                                // 일 단위 탭
                                ForEach(month.dayList) { day in

                                    ZStack {
                                        day.isOutMonth ? Color.gray : Color.white
                                        Text("\(day.day)")
                                            .foregroundColor(day.isOutMonth ? Color.white : Color.black)
                                    }
                                    .id(day.id)
                                    .frame(
                                        width: (proxy.size.width) / CGFloat(calendarColumnCount),
                                        height: (proxy.size.height) / CGFloat(calendarRowCount))
                                }
                        }
                        .id(month.id)
                        .frame(height: proxy.size.height + CGFloat(calendarRowCount) * dayViewSpacing)
                        .background(Color.gray.opacity(0.5))
                    }
                }
                .background(Color.blue.opacity(0.5))
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            
        }
    }
    
    var calendarHeader: some View {
        HStack(spacing: 0){
            
            Spacer()
                .frame(width: 70)
            
            Spacer()
            
            Image(systemName: "arrow.left")
                .frame(width: 50)
                .onTapGesture { viewModel.moveToPreviousMonth() }
            
            if let selectedMonth = viewModel.selectedMonth {
                Text("\(selectedMonth.year).\(selectedMonth.month)")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
            }
            
            Image(systemName: "arrow.right")
                .frame(width: 50)
                .onTapGesture { viewModel.moveToNextMonth() }
            
            Spacer()
            
            Text("오늘")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 70)
                .onTapGesture { viewModel.moveToTodayMonth() }
            
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
