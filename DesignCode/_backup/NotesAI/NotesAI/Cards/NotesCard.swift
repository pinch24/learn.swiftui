import SwiftUI

struct NotesCard: View {
    @Binding var inputText: String
    @Binding var isLoading: Bool
    @Binding var isAnimating: Bool
    var errorMessage: String?
    var onGenerate: () async -> Void
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(spacing: 20) {
            if !isLoading {
                Text("Generate Notes")
                    .customAttribute(EmphasisAttribute())
                    .foregroundStyle(.primary)
                    .font(.title).fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .transition(TextTransition())
                    .padding(.horizontal, 32)
                    .padding(.top, 32)
                    .id("top")
            }

            Text("Transform your thoughts into well-structured notes using artificial intelligence.")
                .foregroundStyle(.primary.opacity(0.7))
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .transition(.asymmetric(
                    insertion: .opacity.animation(.easeInOut.delay(0.5)),
                    removal: .opacity.animation(.easeInOut)
                ))
                .padding(.horizontal, 32)
                .padding(.top, !isLoading ? 0 : 32)

            // Prompt buttons
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(presetPrompts) { prompt in
                        Button(action: {
                            inputText = prompt.content
                            withAnimation(.spring) {
                                isAnimating = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                withAnimation(.spring) {
                                    isAnimating = false
                                }
                            }
                        }) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(prompt.title)
                                    .font(.system(size: 15, weight: .semibold))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(.primary)

                                Text(prompt.description)
                                    .font(.system(size: 13))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                            }
                            .frame(width: 190)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(.primary.opacity(0.1), lineWidth: 1)
                            )
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemBackground))
                                    .shadow(color: .primary.opacity(0.05), radius: 8, x: 0, y: 2)
                            )
                        }
                        .tint(.primary)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.vertical)
            }

            TextEditor(text: $inputText)
                .font(.system(size: 16)).fontWeight(.medium)
                .frame(height: 200)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.primary.opacity(0.1), lineWidth: 1)
                )
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemBackground))
                        .shadow(color: .black.opacity(0.05), radius: 15, x: 0, y: 5)
                )
                .padding(.horizontal, 32)
                .scaleEffect(isAnimating ? 1.1 : 1)
                .overlay(
                    ZStack {
                        if isAnimating {
                            AnimatedMeshGradient2().blendMode(colorScheme == .dark ? .colorBurn :.screen)
                        }
                    }
                )

            Divider()

            PrimaryButton(
                title: "Generate Notes",
                isLoading: isLoading,
                isDisabled: inputText.isEmpty
            ) {
                Task {
                    await onGenerate()
                }
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 32)

            if let errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.horizontal)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 44, style: .continuous)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
        )
        .padding(.horizontal)
    }
}

#Preview {
    NotesCard(
        inputText: .constant(""),
        isLoading: .constant(false),
        isAnimating: .constant(false),
        errorMessage: nil
    ) {
        // Preview generate action
    }
}
