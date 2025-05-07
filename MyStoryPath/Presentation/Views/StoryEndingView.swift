// StoryEndingView.swift
import SwiftUI

/// Vista de resumen / epílogo de la aventura
struct StoryEndingView: View {
    let steps: [StoryStep]      // se pasa toda la historia completa
    var onRestart: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Your adventure summary")
                .font(.title)
                .fontWeight(.semibold)

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(steps.indices, id: \.self) { idx in
                        let text = steps[idx].text
                        if text.starts(with: "➡️ Choice:") {
                            Text(text)
                                .italic()
                                .foregroundColor(.secondary)
                        } else {
                            Text(text)
                        }
                    }
                }
                .padding()
            }
            .frame(maxHeight: 400)

            Button("Start over", action: onRestart)
                .buttonStyle(StoryButtonStyle())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("Ivory").ignoresSafeArea())
    }
}
