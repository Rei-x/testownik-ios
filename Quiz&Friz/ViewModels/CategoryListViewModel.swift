//
//  SubjectProgress.swift
//  Quiz&Friz
//
//  Created by Solvro on 30/12/2024.
//

import SwiftUI

struct Category: Identifiable {
    let id: String
    let name: String
    let icon: String
    let lastAccessed: Date?
}

class CategoryListViewModel: ObservableObject {
    @Published var allCategories = [Category]()
    @Published var latestCategories = [Category]()
    
    private let coreDataManager = CoreDataManager.shared
  
    init() {
        allCategories = getCategories()
        latestCategories = getLatestCategories()
    }
    
    private func getCategory(id: String) -> Category? {
        let userCategory = coreDataManager.getCategory(id: id)
        let quizCategories = quiz.categories
        
        guard let category = quizCategories.first(where: { $0.id == id }) else {
            return nil
        }
        
        let lastAccessed = userCategory?.lastAccessDate
        
        return Category(id: category.id, name: category.name, icon: category.icon, lastAccessed: lastAccessed)
    }
    
    func getCategories() -> [Category] {
        let quizCategories = quiz.categories
        
        var categories = [Category]()
        
        for category in quizCategories {
            if let category = getCategory(id: category.id) {
                categories.append(category)
            }
        }
        
        return categories
    }
    
    func getLatestCategories() -> [Category] {
        let userCategories = coreDataManager.getCategories()
        
        var categories = [Category]()
        
        for userCategory in userCategories {
            if let category = getCategory(id: userCategory.id!) {
                categories.append(category)
            }
        }
        
        
        return categories
    }
}
