import SwiftUI
import AVFoundation

// MARK: - Models
struct Question2 {
    let text: String
    let answers: [String]
    let correctAnswerIndex: Int
}

// MARK: - Sound Manager
class SoundManager {
    static let shared = SoundManager()
    var audioPlayer: AVAudioPlayer?
    
    func playSound(correct: Bool) {
        // Note: You'll need to add actual sound files to your project for this to work
        let soundName = correct ? "correct" : "incorrect"
        if let path = Bundle.main.path(forResource: soundName, ofType: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                audioPlayer?.play()
            } catch {
                print("Could not play sound file.")
            }
        }
    }
}

// MARK: - Quiz Manager
class QuizManager: ObservableObject {
    @Published var questions: [Question2]
    @Published var currentQuestionIndex = 0
    @Published var score = 0
    @Published var quizCompleted = false
    @Published var timeRemaining = 30
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init() {
        // Sample questions
        self.questions = [
            Question2(text: "What is 2 + 2?",
                    answers: ["3", "4", "5", "6"],
                    correctAnswerIndex: 1),
            Question2(text: "What is the capital of France?",
                    answers: ["London", "Berlin", "Paris", "Madrid"],
                    correctAnswerIndex: 2),
            Question2(text: "Which planet is closest to the Sun?",
                    answers: ["Venus", "Mars", "Mercury", "Earth"],
                    correctAnswerIndex: 2)
        ]
    }
    
    func checkAnswer(_ selectedIndex: Int) {
        if selectedIndex == questions[currentQuestionIndex].correctAnswerIndex {
            score += 1
            SoundManager.shared.playSound(correct: true)
        } else {
            SoundManager.shared.playSound(correct: false)
        }
        
        moveToNextQuestion()
    }
    
    func moveToNextQuestion() {
        withAnimation(.easeInOut(duration: 0.5)) {
            if currentQuestionIndex + 1 < questions.count {
                currentQuestionIndex += 1
                timeRemaining = 30
            } else {
                quizCompleted = true
            }
        }
    }
    
    func restartQuiz() {
        currentQuestionIndex = 0
        score = 0
        quizCompleted = false
        timeRemaining = 30
    }
}

// MARK: - Views
struct QuizView: View {
    @StateObject private var quizManager = QuizManager()
    
    var body: some View {
        ZStack {
            if quizManager.quizCompleted {
                ResultView(quizManager: quizManager)
                    .transition(.slideAndFade)
            } else {
                QuestionView(quizManager: quizManager)
                    .transition(.slideAndFade)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: quizManager.quizCompleted)
    }
}

struct QuestionView: View {
    @ObservedObject var quizManager: QuizManager
    @State private var showFeedback = false
    @State private var selectedAnswerIndex: Int? = nil
    
    var body: some View {
        VStack(spacing: 20) {
            // Progress and Timer
            HStack {
                ProgressView(value: Double(quizManager.currentQuestionIndex + 1),
                            total: Double(quizManager.questions.count))
                Text("\(quizManager.timeRemaining)s")
                    .font(.headline)
                    .foregroundColor(.blue)
            }
            .padding()
            
            // Question Counter
            Text("Question \(quizManager.currentQuestionIndex + 1) of \(quizManager.questions.count)")
                .font(.headline)
                .transition(.move(edge: .top))
            
            // Question Text
            Text(quizManager.questions[quizManager.currentQuestionIndex].text)
                .font(.title)
                .multilineTextAlignment(.center)
                .padding()
                .id("question\(quizManager.currentQuestionIndex)") // Add unique ID for animation
                .transition(.asymmetric(insertion: .move(edge: .trailing),
                                        removal: .move(edge: .leading)))
            
            // Answer Buttons
            VStack(spacing: 12) {
                ForEach(0..<4) { index in
                    Button(action: {
                        withAnimation {
                            selectedAnswerIndex = index
                            showFeedback = true
                        }
                        
                        // Delay to show feedback
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                showFeedback = false
                                quizManager.checkAnswer(index)
                                selectedAnswerIndex = nil
                            }
                        }
                    }) {
                        Text(quizManager.questions[quizManager.currentQuestionIndex].answers[index])
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(buttonBackgroundColor(for: index))
                            .cornerRadius(10)
                            .scaleEffect(selectedAnswerIndex == index ? 0.95 : 1.0)
                    }
                    .disabled(showFeedback)
                    .id("answer\(quizManager.currentQuestionIndex)\(index)") // Add unique ID for animation
                    .transition(.asymmetric(insertion: .scale(scale: 0.8).combined(with: .opacity),
                                            removal: .scale(scale: 0.8).combined(with: .opacity)))
                }
            }
            .padding(.horizontal)
            
            // Score
            Text("Score: \(quizManager.score)")
                .font(.headline)
                .padding()
                .transition(.move(edge: .bottom))
        }
        .animation(.easeInOut(duration: 0.5), value: quizManager.currentQuestionIndex)
        .onReceive(quizManager.timer) { _ in
            if quizManager.timeRemaining > 0 {
                quizManager.timeRemaining -= 1
            } else {
                withAnimation {
                    quizManager.moveToNextQuestion()
                }
            }
        }
    }
    
    private func buttonBackgroundColor(for index: Int) -> Color {
        if showFeedback && index == selectedAnswerIndex {
            return index == quizManager.questions[quizManager.currentQuestionIndex].correctAnswerIndex ? .green : .red
        }
        return .blue
    }
}

struct ResultView: View {
    @ObservedObject var quizManager: QuizManager
    @State private var appear = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Quiz Completed!")
                .font(.title)
                .fontWeight(.bold)
                .scaleEffect(appear ? 1 : 0.5)
                .opacity(appear ? 1 : 0)
            
            Text("Your score: \(quizManager.score) out of \(quizManager.questions.count)")
                .font(.headline)
                .opacity(appear ? 1 : 0)
                .offset(y: appear ? 0 : 20)
            
            Text("Percentage: \(Int((Double(quizManager.score) / Double(quizManager.questions.count)) * 100))%")
                .font(.subheadline)
                .opacity(appear ? 1 : 0)
                .offset(y: appear ? 0 : 20)
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.5)) {
                    quizManager.restartQuiz()
                }
            }) {
                Text("Restart Quiz")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(minWidth: 200)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .scaleEffect(appear ? 1 : 0.5)
            .opacity(appear ? 1 : 0)
        }
        .padding()
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                appear = true
            }
        }
        .onDisappear {
            appear = false
        }
    }
}

// MARK: - App Entry Point
#Preview {
   
            QuizView()
            
    
}

// MARK: - Custom Transitions
extension AnyTransition {
    static var slideAndFade: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .move(edge: .leading).combined(with: .opacity)
        )
    }
}
