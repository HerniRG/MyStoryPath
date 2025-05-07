// SetupSheetWithDelay.swift
import SwiftUI

/// Presentación retardada de la hoja de configuración de personaje
struct SetupSheetWithDelay: View {
    @ObservedObject var router: AppRouter
    @State private var showSetupSheet = false

    var body: some View {
        ZStack {
            Color("Ivory").ignoresSafeArea()
            if showSetupSheet {
                CharacterSetupSheet(hero: $router.heroDraft) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        router.startStory()
                    }
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.easeInOut(duration: 0.5), value: showSetupSheet)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation { showSetupSheet = true }
            }
        }
    }
}
