//
//  QuestionView.swift
//  Quiz&Friz
//
//  Created by Solvro on 04/01/2025.
//

import SwiftUI

struct QuestionView: View {
    @State private var selectedAnswer: String?
    @State private var currentQuestion = 0
    @Binding var isNavigating: Bool
    
    
    var body: some View {
        VStack {
            
        }
//        VStack(spacing: 20) {
//            // Back button
//            HStack {
//                Button(action: {
//                    isNavigating = false
//                }) {
//                    Image(systemName: "chevron.left")
//                        .foregroundColor(.blue)
//                    Text("Powrót")
//                        .foregroundColor(.blue)
//                }
//                .padding(.leading)
//                Spacer()
//            }
//            
//            Text("Pytanie nr \(currentQuestion + 1)")
//                .padding(.horizontal, 20)
//                .padding(.vertical, 8)
//                .background(Color.gray.opacity(0.2))
//                .cornerRadius(20)
//            
//            // Question text
//            Text(question.question)
//                .font(.title3)
//                .padding()
//                .multilineTextAlignment(.center)
//            
//            // Answer options
//            ForEach(question.options, id: \.self) { option in
//                Button(action: {
//                    if selectedAnswer == nil {
//                        selectedAnswer = option
//                        if option == question.correct_answer {
//                            progress.markQuestionCompleted(subjectId: subject.id, questionIndex: currentQuestion)
//                        }
//                    }
//                }) {
//                    Text(option)
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(backgroundColor(for: option))
//                        .foregroundColor(.black)
//                        .cornerRadius(10)
//                }
//                .disabled(selectedAnswer != nil)
//            }
//            
//            Spacer()
//            
//            // Next question button
//            if selectedAnswer != nil {
//                Button(action: {
//                    if currentQuestion < subject.questions.count - 1 {
//                        currentQuestion += 1
//                        selectedAnswer = nil
//                    } else {
//                        isNavigating = false
//                    }
//                }) {
//                    Text("Następne")
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                }
//                .padding(.horizontal)
//                .padding(.bottom, 20)
//            }
//        }
//        .padding()
    }
}
