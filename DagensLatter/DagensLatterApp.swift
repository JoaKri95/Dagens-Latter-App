//
//  DagensLatterApp.swift
//  DagensLatter
//
//  Created by Joachim Oug Kristoffersen on 23/02/2024.
//

import SwiftUI

@main
struct DagensLatterApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
