// StoryWelcomeView.swift
import SwiftUI

struct StoryWelcomeView: View {
    var onStart: () -> Void
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.indigo, .purple],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text("📖 MyStoryPath")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                
                Text("Create your character and embark on a story like never before.")
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Button("Start") {
                    withAnimation { onStart() }
                }
                .buttonStyle(StoryButtonStyle())
            }
            .padding()
        }
    }
}
