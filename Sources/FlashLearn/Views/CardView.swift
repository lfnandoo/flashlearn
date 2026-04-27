import SwiftUI

struct CardView: View {
    let card: Card
    let showingAnswer: Bool
    let onReveal: () -> Void
    let onGrade: (Grade) -> Void

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(card.front)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    if showingAnswer {
                        Divider()

                        Text(card.back)
                            .font(.body)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .transition(.opacity)
                    }
                }
                .padding(24)
            }

            Spacer()

            if showingAnswer {
                gradeButtons
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            } else {
                Button(action: onReveal) {
                    HStack(spacing: 8) {
                        Text("Show Answer")
                        Text("Space")
                            .font(.caption)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(.quaternary)
                            .cornerRadius(4)
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding(24)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: showingAnswer)
    }

    private var gradeButtons: some View {
        HStack(spacing: 12) {
            GradeButton(label: "Again", shortcut: "1", color: .red, grade: .again, action: onGrade)
            GradeButton(label: "Hard", shortcut: "2", color: .orange, grade: .hard, action: onGrade)
            GradeButton(label: "Good", shortcut: "3", color: .green, grade: .good, action: onGrade)
            GradeButton(label: "Easy", shortcut: "4", color: .blue, grade: .easy, action: onGrade)
        }
        .padding(24)
    }
}

struct GradeButton: View {
    let label: String
    let shortcut: String
    let color: Color
    let grade: Grade
    let action: (Grade) -> Void

    var body: some View {
        Button(action: { action(grade) }) {
            HStack(spacing: 6) {
                Text(label)
                    .fontWeight(.medium)
                Text(shortcut)
                    .font(.caption)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(.quaternary)
                    .cornerRadius(4)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
        .buttonStyle(.bordered)
        .tint(color)
        .controlSize(.large)
    }
}
