// InteractiveStoryView.swift
import SwiftUI

/// Vista que contiene el “setup rápido” y la experiencia completa de lectura en una sola pantalla.
/// (Si usas el enrutador **RootView**, esta pantalla no será necesaria; mantenla solo si prefieres
/// un flujo simplificado).
struct InteractiveStoryView: View {
    @StateObject var viewModel: InteractiveStoryViewModel
    
    @State private var name = ""
    @State private var role = ""
    @State private var personality = ""
    @State private var selectedWorld = "Random"
    @State private var selectedGenre = "Random"
    @State private var resolvedWorld: String = ""
    @State private var resolvedGenre: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var hasStarted = false
    
    let storyWorlds = WorldTheme.all
    let storyGenres = ["Random", "Adventure", "Horror", "Comedy", "Romance", "Mystery", "Drama", "Science Fiction", "Psychological Thriller"]

    var body: some View {
        ZStack {
            if !hasStarted {
                StoryWelcomeView {
                    withAnimation(.easeInOut(duration: 0.6)) {
                        hasStarted = true
                    }
                }
                .transition(.move(edge: .leading).combined(with: .opacity))
            } else {
                let currentWorld = resolvedWorld.isEmpty
                    ? (selectedWorld == "Random" ? "Medieval Fantasy" : selectedWorld)
                    : resolvedWorld
                let theme = WorldTheme.theme(for: currentWorld)
                
                ZStack {
                    LinearGradient(colors: theme.gradient,
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 12) {
                        if viewModel.storySteps.isEmpty {
                            CharacterForm(
                                name: $name,
                                role: $role,
                                personality: $personality,
                                selectedWorld: $selectedWorld,
                                selectedGenre: $selectedGenre,
                                storyWorlds: storyWorlds,
                                storyGenres: storyGenres,
                                startAction: startStory
                            )
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                        } else {
                            StoryAndChoices(
                                name: name,
                                role: role,
                                personality: personality,
                                currentWorld: currentWorld,
                                resolvedGenre: resolvedGenre,
                                viewModel: viewModel
                            )
                        }
                        if viewModel.isLoading {
                            ProgressView().padding()
                        }
                        if let error = viewModel.error {
                            Text(error).foregroundColor(.red).padding(.horizontal)
                        }
                    }
                    .padding(.bottom, 20)
                }
                .navigationTitle("MyStoryPath")
            }
        }
    }
    
    // MARK: - Helpers
    private func startStory() {
        resolvedWorld = selectedWorld == "Random"
            ? storyWorlds.filter { $0 != "Random" }.randomElement() ?? "Medieval Fantasy"
            : selectedWorld
        resolvedGenre = selectedGenre == "Random"
            ? storyGenres.filter { $0 != "Random" }.randomElement() ?? "Adventure"
            : selectedGenre
        
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        
        Task {
            let character = Character(
                name: name,
                role: role,
                personality: personality,
                world: resolvedWorld,
                genre: resolvedGenre
            )
            await viewModel.start(character: character)
        }
    }
}
