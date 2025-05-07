// RootView.swift
import SwiftUI

/// Punto de entrada que decide qué pantalla mostrar con transiciones suaves
struct RootView: View {
    @StateObject private var router = AppRouter.make()
    
    var body: some View {
        ZStack {
            switch router.screen {
            case .splash:
                OpeningBookView {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        router.screen = .setup
                    }
                }
                .transition(.opacity)
                
            case .setup:
                SetupSheetWithDelay(router: router)
                    .transition(.opacity)
                
            case .reading:
                StoryReaderView(
                    viewModel: router.storyVM,
                    onFinish: {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            router.screen = .ending
                        }
                    },
                    world: router.heroDraft.world,
                    genre: router.heroDraft.genre
                )
                .transition(.move(edge: .trailing).combined(with: .opacity))
                
            case .ending:
                StoryEndingView(steps: router.storyVM.storySteps) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        router.reset()
                    }
                }
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: router.screen)
    }
}
