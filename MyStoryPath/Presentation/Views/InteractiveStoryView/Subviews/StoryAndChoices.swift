// StoryAndChoices.swift
import SwiftUI

/// Muestra los pasos ya generados y las elecciones disponibles
struct StoryAndChoices: View {
    let name: String
    let role: String
    let personality: String
    let currentWorld: String
    let resolvedGenre: String

    @ObservedObject var viewModel: InteractiveStoryViewModel

    var body: some View {
        VStack(spacing: 12) {
            GlassCard {
                VStack(alignment: .leading, spacing: 6) {
                    Text("🌟 Character").font(.headline)
                    Text("Name: \(name)")
                    Text("Role: \(role)")
                    Text("Personality: \(personality)")
                    Text("World: \(currentWorld)")
                    Text("Genre: \(resolvedGenre)")
                }
            }
            .padding(.horizontal)
            .transition(.opacity.combined(with: .move(edge: .top)))

            TabView {
                ForEach(viewModel.storySteps.indices, id: \.self) { idx in
                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            TypewriterText(fullText: viewModel.storySteps[idx].text,
                                           allowVibration: false)

                            if idx == viewModel.storySteps.count - 1 {
                                ForEach(viewModel.storySteps[idx].choices, id: \.self) { choice in
                                    Button(choice) {
                                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                        Task { await viewModel.continueStory(with: choice) }
                                    }
                                    .buttonStyle(StoryButtonStyle())
                                    .controlSize(.regular)
                                    .clipShape(Capsule())
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut(duration: 0.5),
                       value: viewModel.storySteps.count)
        }
    }
}
