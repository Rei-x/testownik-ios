//
//  CategoryViewModel.swift
//  Quiz&Friz
//
//  Created by Solvro on 04/01/2025.
//

import SwiftUI

class CategoryViewModel: ObservableObject {
    @Published private(set) var category: Category
    @Published private(set) var questions: [QuestionData] = []
    
    private var categoryId: String
    private let coreDataManager = CoreDataManager.shared
    
    var numberOfQuestions: Int {
        questions.count
    }
    
    var numberOfCompletedQuestions: Int {
        coreDataManager.getCategory(id: categoryId)?.questions?.count ?? 0
    }
    
    func markQuestionCompleted(id: String) {
        coreDataManager.markQuestionCompleted(category: coreDataManager.getCategory(id: categoryId)!, questionId: id)
        
    }
    
    init(categoryId: String) {
        self.categoryId = categoryId
        let quizCategory = quiz.categories.first { $0.id == categoryId }
        
        guard quizCategory != nil else {
            fatalError("Category with id \(categoryId) not found")
        }
        
        self.category = Category(
            id: quizCategory!.id,
            name: quizCategory!.name,
            icon: quizCategory!.icon,
            lastAccessed: nil
        )
        
        self.questions = quizCategory!.questions
    }
    
  
}
