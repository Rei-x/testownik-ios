import SwiftUI

struct QuizResultView: View {
    let category: Category
    let correctQuestions: Int
    let incorrectQuestions: Int
    let averageTime: Int
    var onGoBack: () -> Void
    var onGoNext: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Image("achievement_star")
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 100)

            Text("Nauczono")

            ZStack {
                Circle()
                    .stroke(Color(.systemGray5), lineWidth: 14)
                    .frame(width: 150, height: 150)

                Circle()
                    .trim(from: 0, to: category.progress)
                    .stroke(Color(.chart).opacity(0.5), lineWidth: 14)
                    .frame(width: 150, height: 150)
                    .rotationEffect(.degrees(-90))

                VStack {
                    Text("\(Int(category.progress * 100))%")
                        .font(.title2)
                        .fontWeight(.bold)
                }
            }

            Text(
                String(category.numberOfCorrectQuestions) + " / "
                    + String(category.numberOfQuestions))

            LazyVGrid(
                columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                ], spacing: 10
            ) {
                StatBox(
                    number: String(correctQuestions), label: "poprawne",
                    icon: "checkmark.circle.fill", color: .green)
                StatBox(
                    number: String(incorrectQuestions), label: "błędne",
                    icon: "xmark", color: .red)
                StatBox(
                    number: String(averageTime) + "s",
                    label: "średnio na pytanie",
                    icon: "clock.fill", color: .blue)
                StatBox(
                    number: String(category.unansweredQuestions.count),
                    label: "pozostało pytań",
                    icon: "arrow.clockwise", color: .gray)
            }
            .padding(.horizontal)

            Spacer()

            VStack(spacing: 16) {
                Button("Powrót") {
                    onGoBack()
                }

                Button(action: {
                    onGoNext()
                }) {
                    Text(
                         category.unansweredQuestions.count
                            == category.numberOfQuestions
                         ? "Reset" : "Dalej"
                    )
                    .fontWeight(.medium).frame(maxWidth: .infinity)

                }.buttonStyle(.borderedProminent)
                    .controlSize(.large)

            }
            .padding()
        }
        .padding(.top, 40)
    }
}

struct StatBox: View {
    let number: String
    let label: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(number)
                    .font(.title3)

                Spacer()
                Image(systemName: icon)
                    .foregroundColor(color)
            }
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

#Preview {
    QuizResultView(
        category: Category.fromId(id: quiz.categories.first!.id),
        correctQuestions: 2,
        incorrectQuestions: 3,
        averageTime: 10,
        onGoBack: {}, onGoNext: {}
    )
}
