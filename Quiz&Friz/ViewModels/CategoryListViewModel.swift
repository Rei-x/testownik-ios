//
//  SubjectProgress.swift
//  Quiz&Friz
//
//  Created by Solvro on 30/12/2024.
//

import SwiftUI

class CategoryListViewModel: ObservableObject {
    @Published var allCategories = [Category]()
    @Published var latestCategories = [Category]()

    private let coreDataManager = CoreDataManager.shared

    init() {
        allCategories = getCategories()
        latestCategories = getLatestCategories()
    }

    private func getCategory(id: String) -> Category? {
        return Category.fromId(id: id)
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

        return categories.filter({ $0.userCategory.lastAccessDate != nil })
            .sorted(by: {
                $0.userCategory.lastAccessDate! > $1.userCategory
                    .lastAccessDate!
            })
    }
}
