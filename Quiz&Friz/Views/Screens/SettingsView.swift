import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("numberOfQuestions") private var numberOfQuestions = 10
    @AppStorage("randomAnswerOrder") private var randomAnswerOrder = false
    @AppStorage("randomQuestionOrder") private var randomQuestionOrder = false
    
    private let minQuestions = 5
    private let maxQuestions = 30
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(uiColor: .systemGray6)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    settingsContent
                    Spacer()
                }
            }
            .navigationTitle("Ustawienia")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(.white, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
    
    private var settingsContent: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                questionCountRow
                Divider()
                toggleRow(title: "Losowa kolejność odpowiedzi", isOn: $randomAnswerOrder)
                Divider()
                toggleRow(title: "Losowa kolejność pytań", isOn: $randomQuestionOrder)
            }
            .background(Color.white)
            .cornerRadius(10)
            .padding()
        }
    }
    
    private var questionCountRow: some View {
        HStack {
            Text("Liczba pytań")
            Spacer()
            
            HStack(spacing: 15) {
                Button(action: { decrementQuestions() }) {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.gray)
                        .font(.title2)
                }
                
                Text("\(numberOfQuestions)")
                    .frame(minWidth: 30)
                    .multilineTextAlignment(.center)
                
                Button(action: { incrementQuestions() }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.gray)
                        .font(.title2)
                }
            }
        }
        .padding()
    }
    
    private func toggleRow(title: String, isOn: Binding<Bool>) -> some View {
        Toggle(title, isOn: isOn)
            .padding()
            .tint(.green)
    }
    
    private func incrementQuestions() {
        guard numberOfQuestions < maxQuestions else { return }
        numberOfQuestions += 1
    }
    
    private func decrementQuestions() {
        guard numberOfQuestions > minQuestions else { return }
        numberOfQuestions -= 1
    }
}

#Preview {
    SettingsView()
}

