// TypewriterText.swift
import SwiftUI

/// Texto que se va “escribiendo” carácter a carácter
struct TypewriterText: View {
    let fullText: String
    let allowVibration: Bool
    var onFinished: (() -> Void)? = nil
    var onUpdate: (() -> Void)? = nil
    @State private var displayedText = ""
    @State private var isTyping = true
    @State private var showCursor = true

    var body: some View {
        Text(displayedText + (isTyping && showCursor ? "|" : ""))
            .font(.system(.title3, design: .serif))
            .lineSpacing(6)
            .onAppear {
                typeText()
                blinkCursor()
            }
    }

    private func typeText() {
        displayedText = ""
        let characters = Array(fullText)
        var index = 0

        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            if index < characters.count {
                displayedText.append(characters[index])
                index += 1
                onUpdate?()
                if allowVibration {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }
            } else {
                timer.invalidate()
                isTyping = false
                onFinished?()
            }
        }
    }

    private func blinkCursor() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            if isTyping {
                showCursor.toggle()
            } else {
                showCursor = false
            }
        }
    }
}
