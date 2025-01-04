import Foundation
import SwiftUI
import CoreLocation

struct QuestionData: Hashable, Codable, Identifiable {
    var question: String;
    var options: [String];
    var correct_answer: String;
    
    var id: String {
        question
    }
}

struct CategoryData: Hashable, Codable, Identifiable {
    var name: String;
    var icon: String;
    var id: String {
        name
    }
    
    var questions: [QuestionData];
}

struct QuizData: Codable {
    var categories: [CategoryData]
}


var quiz: QuizData = load("questions.json")

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data


    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }


    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }


    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

