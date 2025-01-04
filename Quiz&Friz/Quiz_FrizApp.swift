//
//  Quiz_FrizApp.swift
//  Quiz&Friz
//
//  Created by stud on 05/11/2024.
//

import SwiftUI

@main
struct Quiz_FrizApp: App {
    let persistentContainer = CoreDataManager.shared.persistentContainer
    
    var body: some Scene {
        WindowGroup {
            CategoryListView().environment(\.managedObjectContext, persistentContainer.viewContext)
        }
    }
}
