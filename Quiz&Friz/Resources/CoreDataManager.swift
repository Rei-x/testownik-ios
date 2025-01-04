//
//  CoreDataManager.swift
//  Quiz&Friz
//
//  Created by Solvro on 04/01/2025.
//
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "QuizProgress")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    // Mark a question as completed
    func markQuestionCompleted(category: UserCategory, questionId: String) {
        let question = category.questions!.filter { ($0 as AnyObject).id  == questionId } .first
        
        do {
            if question == nil {
                let completedQuestion = UserQuestion(context: context)
                completedQuestion.id = questionId
                completedQuestion.category = category
                completedQuestion.isCorrect = true
                
                try context.save()
            }
        } catch {
            print("Error marking question completed: \(error)")
        }
    }
    
    func getCategory(id: String) -> UserCategory? {
        let fetchRequest: NSFetchRequest<UserCategory> = UserCategory.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.first
        } catch {
            print("Error fetching category: \(error)")
            
            return nil
        }
    }
    
    func getCategories() -> [UserCategory] {
        let fetchRequest: NSFetchRequest<UserCategory> = UserCategory.fetchRequest()
        
        let sort = NSSortDescriptor(key: "lastAccessDate", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching categories: \(error)")
            
            return []
        }
    }


        
    
}
