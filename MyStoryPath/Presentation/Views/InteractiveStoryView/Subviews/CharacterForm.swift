// CharacterForm.swift
import SwiftUI

/// Formulario para configurar al personaje antes de empezar la historia
struct CharacterForm: View {
    @Binding var name: String
    @Binding var role: String
    @Binding var personality: String
    @Binding var selectedWorld: String
    @Binding var selectedGenre: String

    let storyWorlds: [String]
    let storyGenres: [String]
    var startAction: () -> Void

    var body: some View {
        ZStack {
            Image("book_background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
                .overlay(Color.black.opacity(0.25))

            ScrollView {
                VStack {
                    GlassCard {
                        VStack(spacing: 24) {
                            Text("Configure your character")
                                .font(.title2)
                                .fontWeight(.semibold)

                            Group {
                                TextField("Enter a name for your protagonist", text: $name)
                                TextField("e.g. Warrior, Sorceress, Engineer…", text: $role)
                                TextField("e.g. Brave, curious, solitary…", text: $personality)
                            }
                            .textFieldStyle(.roundedBorder)
                            .font(.system(.body, design: .serif))

                            VStack(spacing: 12) {
                                Picker("🌍 World", selection: $selectedWorld) {
                                    ForEach(storyWorlds, id: \.self, content: Text.init)
                                }
                                .pickerStyle(.menu)

                                if selectedWorld == "Random" {
                                    Text("A random world will be selected if you don't choose one.")
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                }

                                Picker("🎭 Genre", selection: $selectedGenre) {
                                    ForEach(storyGenres, id: \.self, content: Text.init)
                                }
                                .pickerStyle(.menu)

                                if selectedGenre == "Random" {
                                    Text("A random genre will be selected if you don't choose one.")
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                }
                            }

                            Button("Start story", action: startAction)
                                .buttonStyle(StoryButtonStyle())
                                .disabled(name.isEmpty || role.isEmpty || personality.isEmpty)
                        }
                        .padding()
                    }
                    .frame(maxWidth: 460)
                    .padding(.horizontal, 24)
                    .padding(.top, 60)
                }
            }
            .scrollDismissesKeyboard(.interactively)
        }
    }
}
