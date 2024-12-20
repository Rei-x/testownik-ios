//
//  Wizard.swift
//  Landmarks
//
//  Created by stud on 15/10/2024.
//

import Foundation
import SwiftUI
import CoreLocation
//"question": "Jakie zabezpieczenie stosuje się do ochrony sieci bezprzewodowej?",
//"options": [
//  "WEP",
//  "WPA2",
//  "SSL",
//  "HTTP"
//],
//"correct_answer": "WPA2"
struct Question: Hashable, Codable, Identifiable {
    var question: String;
    var options: [String];
    var correct_answer: String;
    
    var id: String {
        question
    }
}

struct Category: Hashable, Codable, Identifiable {
    var name: String;
    var icon: String;
    var id: String {
        name
    }
    
    var questions: [Question];
}

struct Quiz: Codable {
    var categories: [Category]
}
