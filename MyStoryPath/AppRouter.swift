// AppRouter.swift
import SwiftUI

/// Estado de navegación centralizado para la app
@MainActor
final class AppRouter: ObservableObject {
    enum Screen { case splash, setup, reading, ending }

    private let startUseCase: StartStoryUseCase
    private let continueUseCase: ContinueStoryUseCase
    private let finishUseCase: FinishStoryUseCase
    
    static func make() -> AppRouter {
        let startUseCase = Dependencies.makeStartUseCase()
        let continueUseCase = Dependencies.makeContinueUseCase()
        let finishUseCase = Dependencies.makeFinishUseCase()
        return AppRouter(
            startUseCase: startUseCase,
            continueUseCase: continueUseCase,
            finishUseCase: finishUseCase
        )
    }

    private init(startUseCase: StartStoryUseCase,
                 continueUseCase: ContinueStoryUseCase,
                 finishUseCase: FinishStoryUseCase) {
        self.startUseCase    = startUseCase
        self.continueUseCase = continueUseCase
        self.finishUseCase   = finishUseCase
        _storyVM = Published(
            initialValue: InteractiveStoryViewModel(
                startUseCase: startUseCase,
                continueUseCase: continueUseCase,
                finishUseCase: finishUseCase
            )
        )
    }

    @Published var screen: Screen = .splash
    @Published var heroDraft = HeroDraft()
    @Published var storyVM: InteractiveStoryViewModel

    func startStory() {
        let resolvedWorld = heroDraft.world == "Random"
            ? ["Medieval Fantasy", "Outer Space", "Cyber Reality", "Post‑apocalyptic"].randomElement()!
            : heroDraft.world
        let resolvedGenre = heroDraft.genre == "Random"
            ? ["Adventure", "Drama", "Comedy", "Horror"].randomElement()!
            : heroDraft.genre
        heroDraft.world = resolvedWorld
        heroDraft.genre = resolvedGenre
        
        Task {
            let character = Character(
                name: heroDraft.name,
                role: heroDraft.role,
                personality: heroDraft.personality,
                world: resolvedWorld,
                genre: resolvedGenre
            )
            await storyVM.start(character: character)
            screen = .reading
        }
    }

    func reset() {
        heroDraft = HeroDraft()
        storyVM   = InteractiveStoryViewModel(
            startUseCase: startUseCase,
            continueUseCase: continueUseCase,
            finishUseCase: finishUseCase
        )
        screen = .splash
    }
}
