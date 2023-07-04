//
//  CalendarView.swift
//  Koala
//
//  Created by 백수호 on 2023/07/05.
//

import SwiftUI

struct CalendarView: View {
    
    @ObservedObject var viewModel = CalendarViewModel()
    
    private let calendarRowCount = 6
    private let calendarColumnCount = 7
    
    var body: some View {

        VStack(spacing: 0) {
            GeometryReader { proxy in
                
                VStack {
                    Button("100으로 이동") {
                        viewModel.selectedMonthIdx = viewModel.calendarData.monthList[100].id
                    }
                }
                
                LazyHStack {
                    TabView(selection: $viewModel.selectedMonthIdx) {
                        ForEach(viewModel.calendarData.monthList) { month in
                            VStack {
                                Text("\(month.year).\(month.month)")
                                GeometryReader { proxy2 in
                                    LazyVGrid(
                                        columns: Array(repeating: .init(.flexible()), count: calendarColumnCount)) {
                                        ForEach(month.dayList) { day in
                                            
                                            ZStack {
                                                day.isOutMonth ? Color.gray : Color.white
                                                Text("\(day.day)")
                                                    .foregroundColor(day.isOutMonth ? Color.white : Color.black)
                                            }
                                            .id(day.id)
                                            .frame(height: (proxy2.size.height - 100) / CGFloat(calendarRowCount))
//                                            .frame(height: 100)
                                        }
                                    }
                                }
                                Spacer()
                            }
                            .id(month.id)
                            .frame(width: proxy.size.width, height: proxy.size.height - 50)
                        }
                    }
                    .frame(width: proxy.size.width, height: proxy.size.height - 50)
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                }
                
            }
        }.background(Color.green)
        .navigationBarTitle("캘린더 테스트")
    }
    
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
