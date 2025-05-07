// OpeningBookView.swift
import SwiftUI

/// Vista de “toca para abrir” inicial
struct OpeningBookView: View {
    var onFinish: () -> Void
    @State private var open = false
    
    var body: some View {
        ZStack {
            Color("Ivory").ignoresSafeArea()
            
            Image("closed_book")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaleEffect(open ? 450 : 1)
                .opacity(open ? 0 : 1)
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.8)) {
                open = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                onFinish()
            }
        }
    }
}
