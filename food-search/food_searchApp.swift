//
//  food_searchApp.swift
//  food-search
//
//  Created by John Riselvato on 2024/8/8.
//

import SwiftUI

@main
struct food_searchApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
