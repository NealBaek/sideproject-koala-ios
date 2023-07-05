//
//  KoalaApp.swift
//  Koala
//
//  Created by 백수호 on 2022/11/13.
//

import SwiftUI

@main
struct KoalaApp: App {
    let persistenceController = PersistenceController.shared

    @State var selection = 0
    
    let tabBarHeight: CGFloat = 70
    
    init() {
        // 런치 스크린 타이머
        Thread.sleep(forTimeInterval: 1)
    }
    
    var body: some Scene {
        WindowGroup {
            GeometryReader { proxy in
                VStack(spacing: 0) {
                    TabView(selection: $selection) {
                        CalendarView()
                            .tag(0)
                        Text("요즘")
                            .tag(1)
                        Text("통계")
                            .tag(2)
                        Text("설정")
                            .tag(3)
                    }.frame(height: proxy.size.height - tabBarHeight)
                    
                    HStack(spacing: 0) {
                        let tabItemWidth = proxy.size.width / 4
                        Text("기록")
                            .foregroundColor(selection == 0 ? .green : .gray)
                            .font(.system(size: 20))
                            .frame(width: tabItemWidth, height: tabBarHeight)
                            .onTapGesture { selection = 0 }
                        Text("요즘")
                            .foregroundColor(selection == 1 ? .green : .gray)
                            .font(.system(size: 20))
                            .frame(width: tabItemWidth, height: tabBarHeight)
                            .onTapGesture { selection = 1 }
                        Text("통계")
                            .foregroundColor(selection == 2 ? .green : .gray)
                            .font(.system(size: 20))
                            .frame(width: tabItemWidth, height: tabBarHeight)
                            .onTapGesture { selection = 2 }
                        Text("설정")
                            .foregroundColor(selection == 3 ? .green : .gray)
                            .font(.system(size: 20))
                            .frame(width: tabItemWidth, height: tabBarHeight)
                            .onTapGesture { selection = 3 }
                    }
                    .frame(height: tabBarHeight)
                    .background(Color.white)
                }
            }
            
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
