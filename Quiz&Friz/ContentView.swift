import SwiftUI

struct ContentView: View {
    @State private var isNavigating = false
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Wybierz przedmiot")
                    .font(.title)
                    .padding(.top, 20)
                
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(quiz.categories) { subject in
                        NavigationLink(destination: SubjectDetailView(subject: subject, isNavigating: $isNavigating).navigationBarBackButtonHidden(isNavigating)) {
                            SubjectCard(title: subject.name, iconName: subject.icon)
                        }
                    }
                }
                .padding()
                
                Spacer()
            }
            .navigationTitle("Quiz&Friz").navigationBarBackButtonHidden(true)
        }.navigationBarBackButtonHidden(true)
    }
}

struct SubjectCard: View {
    let title: String
    let iconName: String
  
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: iconName)
                .font(.system(size: 30))
                .foregroundColor(.black)
            
            Text(title)
                .font(.system(size: 14))
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 120)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

class SubjectProgress: ObservableObject {
    @Published var completedQuestions: [String: Set<Int>] = [:]
    
    init() {
        loadProgress()
    }
    
    func markQuestionCompleted(subjectId: String, questionIndex: Int) {
        var completed = completedQuestions[subjectId] ?? Set<Int>()
        completed.insert(questionIndex)
        completedQuestions[subjectId] = completed
        saveProgress()
    }
    
    func getProgress(for subjectId: String) -> (completed: Int, total: Int) {
        let completed = completedQuestions[subjectId]?.count ?? 0
        let total = quiz.categories.first(where: { $0.id == subjectId })?.questions.count ?? 0
        return (completed, total)
    }
    
    private func saveProgress() {
        if let encoded = try? JSONEncoder().encode(completedQuestions) {
            UserDefaults.standard.set(encoded, forKey: "SubjectProgress")
        }
    }
    
    private func loadProgress() {
        if let data = UserDefaults.standard.data(forKey: "SubjectProgress"),
           let decoded = try? JSONDecoder().decode([String: Set<Int>].self, from: data) {
            completedQuestions = decoded
        }
    }
}

struct SubjectDetailView: View {
    let subject: Category
    @Binding var isNavigating: Bool
    @State var currentQuestion: Int = 0
    @State private var selectedAnswer: String?
    @State private var showFeedback = false
    @StateObject private var progress = SubjectProgress()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        if (isNavigating) {
            let question = subject.questions[currentQuestion]
            
            VStack(spacing: 20) {
                // Back button
                HStack {
                    Button(action: {
                        isNavigating = false
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.blue)
                        Text("Powrót")
                            .foregroundColor(.blue)
                    }
                    .padding(.leading)
                    Spacer()
                }
                
                Text("Pytanie nr \(currentQuestion + 1)")
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(20)
                
                // Question text
                Text(question.question)
                    .font(.title3)
                    .padding()
                    .multilineTextAlignment(.center)
                
                // Answer options
                ForEach(question.options, id: \.self) { option in
                    Button(action: {
                        if selectedAnswer == nil {
                            selectedAnswer = option
                            if option == question.correct_answer {
                                progress.markQuestionCompleted(subjectId: subject.id, questionIndex: currentQuestion)
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
                
                // Next question button
                if selectedAnswer != nil {
                    Button(action: {
                        if currentQuestion < subject.questions.count - 1 {
                            currentQuestion += 1
                            selectedAnswer = nil
                        } else {
                            isNavigating = false
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
        } else {
            let progressStats = progress.getProgress(for: subject.id)
            
            VStack(spacing: 30) {
                Text(subject.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.top, 40)
                
                Text("\(subject.questions.count) pytań")
                    .font(.title2)
                    .foregroundColor(.secondary)
                
                VStack(spacing: 10) {
                    Text("Nauczone")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    ZStack {
                        Circle()
                            .stroke(Color(.systemGray5), lineWidth: 20)
                            .frame(width: 200, height: 200)
                        
                        Circle()
                            .trim(from: 0, to: CGFloat(progressStats.completed) / CGFloat(progressStats.total))
                            .stroke(Color.blue, lineWidth: 20)
                            .frame(width: 200, height: 200)
                            .rotationEffect(.degrees(-90))
                        
                        VStack {
                            Text("\(Int((Double(progressStats.completed) / Double(progressStats.total)) * 100))%")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Text("\(progressStats.completed)/\(progressStats.total)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Spacer()
                
                Button(action: {
                    isNavigating = true
                }) {
                    Text("Graj")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
        }
    }
    
    private func backgroundColor(for option: String) -> Color {
        guard let selectedAnswer = selectedAnswer else { return Color(.systemGray6) }
        
        if option == subject.questions[currentQuestion].correct_answer {
            return Color.green.opacity(0.3)
        }
        if option == selectedAnswer && option != subject.questions[currentQuestion].correct_answer {
            return Color.red.opacity(0.3)
        }
        return Color(.systemGray6)
    }
}

#Preview {
    ContentView()
}
