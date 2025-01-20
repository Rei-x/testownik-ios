//
//  QuestionView.swift
//  Quiz&Friz
//
//  Created by Solvro on 04/01/2025.
//

import SwiftUI

struct QuestionView: View {
    var onCorrectAnswer: (_ questionId: String) -> Void
    var onIncorrectAnswer: (_ questionId: String) -> Void
    var onFinish: () -> Void
 
    let questions: [QuestionData]
    @State private var selectedAnswer: String?
    @State private var currentQuestionIndex = 0
    @Binding var isNavigating: Bool

    var currentQuestion: QuestionData {
        questions[currentQuestionIndex]
    }

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Button(action: {
                    withAnimation(.easeInOut) {
                        isNavigating = false
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.blue)
                    Text("Powrót")
                        .foregroundColor(.blue)
                }
                .padding(.leading)
                Spacer()
            }

            Text("Pytanie nr \(currentQuestionIndex + 1)")
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(20)

           
            Text(currentQuestion.question)
                .font(.title3)
                .padding()
                .multilineTextAlignment(.center)

       
            ForEach(currentQuestion.options, id: \.self) { option in
                Button(action: {
                    if selectedAnswer == nil {
                        selectedAnswer = option
                        if option == currentQuestion.correct_answer {
                            onCorrectAnswer(currentQuestion.id)
                        } else {
                            onIncorrectAnswer(currentQuestion.id)
                        }
                    }
                }) {
                    Text(option)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(backgroundColor(for: option))
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
                .disabled(selectedAnswer != nil)
            }

            Spacer()

            if selectedAnswer != nil {
                Button(action: {
                    if currentQuestionIndex < questions.count - 1 {
                        currentQuestionIndex += 1
                        selectedAnswer = nil
                    } else {
                        onFinish()
                    }
                }) {
                    Text("Następne")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }
        .padding()
    }

    private func backgroundColor(for option: String) -> Color {
        guard let selectedAnswer = selectedAnswer else {
            return Color(.systemGray6)
        }

        if option == currentQuestion.correct_answer {
            return Color.green.opacity(0.3)
        }
        if option == selectedAnswer && option != currentQuestion.correct_answer
        {
            return Color.red.opacity(0.3)
        }
        return Color(.systemGray6)
    }
}
