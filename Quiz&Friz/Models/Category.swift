//
//  Category.swift
//  Quiz&Friz
//
//  Created by Solvro on 06/01/2025.
//

struct Category: Identifiable, Hashable {
    let id: String
    let name: String
    let icon: String
    let userCategory: UserCategory
    let questions: [QuestionData]

    var numberOfQuestions: Int {
        questions.count
    }

    var numberOfCorrectQuestions: Int {
        userCategory.questions?.count ?? 0
    }

    var progress: Double {
        Double(numberOfCorrectQuestions) / Double(numberOfQuestions)
    }

    var unansweredQuestions: [QuestionData] {
        guard let userQuestions = userCategory.questions as? Set<UserQuestion> else {
            return questions
        }
        
        return questions.filter { question in
            !userQuestions.contains(where: { $0.id == question.id })
        }
    }
    static func fromId(id: String) -> Category {
        let quizCategories = quiz.categories
        let categoryData = quizCategories.first(where: { $0.id == id })!

        var userCategoryInstance = CoreDataManager.shared.getCategory(id: id)

        if userCategoryInstance == nil {
            let newUserCategory = UserCategory(
                context: CoreDataManager.shared.context)
            newUserCategory.id = id
            newUserCategory.numberOfQuestions = 10
            newUserCategory.isRandomAnswerOrder = false
            newUserCategory.isRandomQuestionOrder = false

            CoreDataManager.shared.saveContext()

            userCategoryInstance = newUserCategory
        }

        return Category(
            id: categoryData.id,
            name: categoryData.name,
            icon: categoryData.icon,
            userCategory: userCategoryInstance!,
            questions: categoryData.questions
        )
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Category, rhs: Category) -> Bool {
        lhs.id == rhs.id
    }
}
