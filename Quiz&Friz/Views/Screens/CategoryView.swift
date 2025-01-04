//
//  SubjectDetailView.swift
//  Quiz&Friz
//
//  Created by Solvro on 30/12/2024.
//

import SwiftUI

struct CategoryView: View {
    @StateObject private var viewModel: CategoryViewModel
    @Binding var isNavigating: Bool
    @State private var isSettings = false
    
    init(categoryId: String, isNavigating: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: CategoryViewModel(categoryId: categoryId))
        _isNavigating = isNavigating
    }
    
    var body: some View {
        if isNavigating {
            QuestionView(isNavigating: $isNavigating)
        } else {
            mainView
        }
    }
    
    private var mainView: some View {
        VStack(spacing: 0) {
            headerSection
            progressSection
            Spacer()
            bottomButtons
        }
    }
    
    private var headerSection: some View {
        VStack {
            Text(viewModel.category.name)
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.top, 40)
            
            Text("\(viewModel.numberOfQuestions) pytań")
                .font(.body)
                .padding(.top, 10)
        }
    }
    
    private var progressSection: some View {
        VStack(spacing: 10) {
            Text("Nauczono")
                .font(.body)
            
            ZStack {
                Circle()
                    .stroke(Color(.systemGray5), lineWidth: 20)
                    .frame(width: 150, height: 150)
                
                Circle()
                    .trim(from: 0, to: progressPercentage)
                    .stroke(Color.blue, lineWidth: 20)
                    .frame(width: 150, height: 150)
                    .rotationEffect(.degrees(-90))
                
                VStack {
                    Text("\(Int(progressPercentage * 100))%")
                        .font(.title2)
                        .fontWeight(.bold)
                }
            }
            .padding(.top, 10)
            
            HStack(spacing: 5) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                
                Text("\(viewModel.numberOfCompletedQuestions) / \(viewModel.numberOfQuestions)")
            }
            .padding(.top, 10)
        }
        .padding(.top, 87)
    }
    
    private var bottomButtons: some View {
        VStack {
            NavigationLink(destination: SettingsView(), isActive: $isSettings) {
                EmptyView()
            }
            
            Button("Ustawienia") {
                isSettings = true
            }
            .padding(.bottom, 23)
            
            Button {
                isNavigating = true
            } label: {
                Text("Graj")
                    .font(.title3)
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 52)
            .padding(.bottom, 30)
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
    }
    
    private var progressPercentage: CGFloat {
        guard viewModel.numberOfQuestions > 0 else { return 0 }
        return CGFloat(viewModel.numberOfCompletedQuestions) / CGFloat(viewModel.numberOfQuestions)
    }
}



#Preview {
    let category = quiz.categories.first!
    
    CategoryView(categoryId: category.id, isNavigating: .constant(false))
}
