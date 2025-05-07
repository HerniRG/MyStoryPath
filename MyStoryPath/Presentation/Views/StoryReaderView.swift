// StoryReaderView.swift
import SwiftUI

/// Lector “puro” una vez arrancada la historia
struct StoryReaderView: View {
    @ObservedObject var viewModel: InteractiveStoryViewModel
    var onFinish: () -> Void
    let world: String
    let genre: String
    @State private var navTitle: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Ivory").ignoresSafeArea()
                
                let steps = viewModel.storySteps   // ayuda al compilador
                
                if viewModel.isFinishing {
                    Overlay(text: "📜 Generating epilogue…")
                } else if viewModel.isLoading {
                    Overlay(text: "📜 Continuing the adventure…")
                } else if let latest = steps.last {
                    StoryPage(
                        step: latest,
                        isLast: true,
                        onChoice: { choice in Task { await viewModel.continueStory(with: choice) } },
                        onEnd: onFinish
                    )
                }
            }
            .animation(.easeInOut(duration: 0.3), value: viewModel.isLoading)
            .animation(.easeInOut(duration: 0.3), value: viewModel.isFinishing)
            .onAppear { navTitle = "\(genre) · \(world)" }
            .navigationTitle(navTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("End") {
                        Task { await viewModel.finishStory() }
                    }
                    .disabled(viewModel.isFinishing || viewModel.storySteps.isEmpty)
                }
            }
        }
    }
    
    // Pequeña vista superpuesta reutilizable
    private struct Overlay: View {
        let text: String
        var body: some View {
            VStack(spacing: 20) {
                TypewriterText(fullText: text, allowVibration: true)
                    .font(.system(.title2, design: .serif))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                ProgressView().progressViewStyle(.circular)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("Ivory").opacity(0.95).ignoresSafeArea())
            .transition(.opacity)
        }
    }
}

// Sub‑vista interna (se queda en el mismo archivo para encapsular detalles)
private struct StoryPage: View {
    let step: StoryStep
    let isLast: Bool
    var onChoice: (String) -> Void
    var onEnd: () -> Void
    
    @State private var hasAppeared = false
    @State private var visibleChoices: Int = 0
    @State private var showEndButton: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        TypewriterText(
                            fullText: step.text,
                            allowVibration: false,
                            onFinished: revealChoicesSequentially,
                            onUpdate: { withAnimation(.linear(duration: 0.1)) { proxy.scrollTo("BOTTOM", anchor: .bottom) } }
                        )
                        .id(step.text)
                        .padding(.horizontal)
                        Divider().padding(.horizontal).opacity(0.15)
                        Color.clear.frame(height: 1).id("BOTTOM")
                    }
                }
            }
            .padding(.bottom, 12)

            if !step.choices.isEmpty {
                VStack(spacing: 16) {
                    Divider().padding(.horizontal, 16).opacity(0.3)
                    HStack(spacing: 8) {
                        Image(systemName: "flame.fill").foregroundColor(.orange)
                        Text("What do you decide to do?").font(.headline)
                    }
                    .padding(.horizontal)
                    .transition(.opacity)
                    Color.clear.frame(height: 0).onAppear {
                        if !hasAppeared {
                            hasAppeared = true
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        }
                    }
                }
            }
            ForEach(step.choices.prefix(visibleChoices), id: \.self) { choice in
                Button(choice) {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    onChoice(choice)
                }
                .buttonStyle(StoryButtonStyle())
                .frame(maxWidth: .infinity)
                .scaleEffect(0.95)
                .transition(.opacity.combined(with: .scale))
                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: visibleChoices)
            }
            if isLast && step.choices.isEmpty && showEndButton {
                Button("End", action: onEnd)
                    .buttonStyle(StoryButtonStyle())
                    .frame(maxWidth: .infinity)
                    .transition(.opacity)
            }
        }
        .padding(.top, 8)
        .padding(.bottom, 28)
        .onChange(of: step.text) {
            visibleChoices = 0
            showEndButton  = false
        }
    }
    
    // MARK: - Helpers
    private func revealChoicesSequentially() {
        visibleChoices = 0
        showEndButton  = false
        
        if step.choices.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                withAnimation(.easeInOut(duration: 0.4)) { showEndButton = true }
            }
        } else {
            for index in 0..<step.choices.count {
                let delay = Double(index) * 0.4
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    withAnimation(.easeInOut(duration: 0.4)) { visibleChoices = index + 1 }
                }
            }
        }
    }
}
