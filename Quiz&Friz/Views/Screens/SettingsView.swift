import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss

    @Binding var category: Category
    @State private var numberOfQuestions: Int32
    @State private var randomAnswerOrder: Bool
    @State private var randomQuestionOrder: Bool

    private let minQuestions = 1
    private let maxQuestions: Int

    init(category: Binding<Category>) {
        self._category = category
        self._numberOfQuestions = State(
            initialValue: category.wrappedValue.userCategory.numberOfQuestions)
        self._randomAnswerOrder = State(
            initialValue: category.wrappedValue.userCategory.isRandomAnswerOrder
        )
        self._randomQuestionOrder = State(
            initialValue: category.wrappedValue.userCategory
                .isRandomQuestionOrder)
        self.maxQuestions = category.wrappedValue.questions.count
    }

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
        }.onDisappear {
            saveData()
        }
    }

    private var settingsContent: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                questionCountRow
                Divider()
                toggleRow(
                    title: "Losowa kolejność odpowiedzi",
                    isOn: $randomAnswerOrder)
                Divider()
                toggleRow(
                    title: "Losowa kolejność pytań", isOn: $randomQuestionOrder)
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

    private func saveData() {
        category.userCategory.isRandomAnswerOrder = randomAnswerOrder
        category.userCategory.isRandomQuestionOrder = randomQuestionOrder
        category.userCategory.numberOfQuestions = numberOfQuestions
        print("Saving data!")
        category = category
        CoreDataManager.shared.saveContext()
    }
}

#Preview {
    let context = CoreDataManager.shared.context

    let userCategory = UserCategory(context: context)
    userCategory.numberOfQuestions = 10
    userCategory.isRandomAnswerOrder = false
    userCategory.isRandomQuestionOrder = false

    return SettingsView(
        category: .constant(
            Category(
                id: "Hello",
                name: "Jello",
                icon: "home",
                userCategory: userCategory,
                questions: []
            )))
}
