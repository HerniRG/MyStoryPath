// CharacterSetupSheet.swift
import SwiftUI

struct CharacterSetupSheet: View {
    @Binding var hero: HeroDraft
    var onStart: () -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var isLoading = false
    @State private var showNarrativeTransition = false

    enum Field: Hashable { case name, role, personality }
    @FocusState private var focusedField: Field?

    var body: some View {
        ZStack {
            if !showNarrativeTransition {
                NavigationStack {
                    Form {
                        Section("Protagonist name") {
                            TextField("e.g. Aria", text: $hero.name)
                                .autocorrectionDisabled(true)
                                .focused($focusedField, equals: .name)
                                .submitLabel(.next)
                                .onSubmit { focusedField = .role }
                        }
                        Section("Role / profession") {
                            TextField("e.g. Alchemist", text: $hero.role)
                                .autocorrectionDisabled(true)
                                .focused($focusedField, equals: .role)
                                .submitLabel(.next)
                                .onSubmit { focusedField = .personality }
                        }
                        Section("Personality") {
                            TextField("e.g. Brave but impulsive", text: $hero.personality)
                                .autocorrectionDisabled(true)
                                .focused($focusedField, equals: .personality)
                                .submitLabel(.done)
                        }
                        Section("World") {
                            Picker("World", selection: $hero.world) {
                                ForEach(WorldTheme.all, id: \.self) { Text($0) }
                            }
                        }
                        Section("Genre") {
                            Picker("Genre", selection: $hero.genre) {
                                ForEach(["Random","Adventure","Horror","Comedy","Romance","Mystery","Drama","Science Fiction"], id:\.self) { Text($0) }
                            }
                        }
                        Button {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            isLoading = true
                            withAnimation { showNarrativeTransition = true }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                dismiss()
                                onStart()
                            }
                        } label: {
                            Label {
                                Text("Start")
                                    .foregroundColor(hero.incomplete ? .gray : .primary)
                                    .animation(.easeInOut(duration: 0.3), value: hero.incomplete)
                            } icon: {
                                Image(systemName: "book.fill")
                                    .foregroundColor(hero.incomplete ? .gray : Color("IvoryAccent"))
                                    .animation(.easeInOut(duration: 0.3), value: hero.incomplete)
                            }
                        }
                        .buttonStyle(StoryButtonStyle())
                        .frame(maxWidth: .infinity, alignment: .center)
                        .disabled(hero.incomplete)
                        .padding(.top, 24)
                        .listRowBackground(Color.clear)
                    }
                    .font(.system(.body, design: .serif))
                    .navigationTitle("Your hero")
                }
                .transition(.opacity)
            }
            if showNarrativeTransition {
                VStack(spacing: 20) {
                    TypewriterText(fullText: "📜 Preparing your adventure…", allowVibration: true)
                        .font(.system(.title2, design: .serif))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    ProgressView().progressViewStyle(.circular)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("Ivory").ignoresSafeArea())
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: showNarrativeTransition)
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
        .background(Color("Ivory").ignoresSafeArea())
    }
}
