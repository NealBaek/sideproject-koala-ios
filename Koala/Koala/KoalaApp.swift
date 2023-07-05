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

    init() {
        // 런치 스크린 타이머
        Thread.sleep(forTimeInterval: 1)
    }
    
    var body: some Scene {
        WindowGroup {
            CalendarView()
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
