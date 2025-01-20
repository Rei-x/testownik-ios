//
//  CategoryViewModel.swift
//  Quiz&Friz
//
//  Created by Solvro on 04/01/2025.
//

import SwiftUI

class CategoryViewModel: ObservableObject {
    @Published var category: Category
    @Published var numberOfCorrectAnswers = 0
    @Published var numberOfIncorrectAnswers = 0
    @Published var isFinalScreen = false
    private var quizStartTime = Date()
    private var quizEndTime = Date()

    private let coreDataManager = CoreDataManager.shared

    var questions: [QuestionData] = []

    private var differenceInSeconds: TimeInterval {
        quizEndTime.timeIntervalSince(quizStartTime)
    }
    
    var averageTime: Int {
        Int(differenceInSeconds / Double(numberOfCorrectAnswers + numberOfIncorrectAnswers))
    }
    
    var numberOfQuestions: Int {
        category.questions.count
    }

    var numberOfCompletedQuestions: Int {
        category.userCategory.questions?.count ?? 0
    }

    init(categoryId: String) {
        category = Category.fromId(id: categoryId)
    }

    func markQuestionAsCompleted(questionId: String) {
        numberOfCorrectAnswers += 1
        coreDataManager.markQuestionCompleted(
            category: category.userCategory, questionId: questionId)
    }
    
    func markQuestionAsIncorrect() {
        numberOfIncorrectAnswers += 1
    }
    
    func startQuiz() {
        if category.unansweredQuestions.count == 0 {
            resetProgress()
        }
        shuffleQuestions()
        quizStartTime = Date()
        resetQuestionSession()
    }
    
    func endQuiz() {
        quizEndTime = Date()
        isFinalScreen = true
    }
    
    func resetQuestionSession() {
        isFinalScreen = false
        numberOfCorrectAnswers = 0
        numberOfIncorrectAnswers = 0
    }
    
    func resetProgress() {
        coreDataManager.clearProgress(category: category.userCategory)
        coreDataManager.saveContext()
    }
    
    func shuffleQuestions() {
        var questions = category.unansweredQuestions

        if category.userCategory.isRandomAnswerOrder {
            questions = questions.shuffled()
        }

        questions = Array(
            questions.prefix(
                min(
                    questions.count,
                    Int(category.userCategory.numberOfQuestions)
                )
            )
        )

        if category.userCategory.isRandomAnswerOrder {
            questions = questions.map { question in
                var question = question
                question.options = question.options.shuffled()
                return question
            }
        }

        self.questions = questions
    }

}
