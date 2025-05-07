import Foundation

protocol OpenRouterServiceProtocol {
    func startStory(with character: Character) async throws -> StoryStep
    func continueStory(with choice: String, history: [String]) async throws -> StoryStep
    func finishStory(history: [String]) async throws -> StoryStep
}

final class OpenRouterService: OpenRouterServiceProtocol {
    private let apiKey: String
    private let model = "mistralai/mistral-7b-instruct:free"
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    private func send(messages: [OpenRouterRequest.Message]) async throws -> String {
        let url = URL(string: "https://openrouter.ai/api/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = OpenRouterRequest(model: model, messages: messages)
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(OpenRouterResponse.self, from: data)
        return response.choices.first?.message.content ?? "Sin respuesta"
    }
    
    func startStory(with character: Character) async throws -> StoryStep {
        let prompt = """
You are an expert narrator creating immersive interactive stories. Begin an original story based on the following protagonist details:

Name: \(character.name)
Profession: \(character.role)
Personality: \(character.personality)
Genre: \(character.genre)
World or setting: \(character.world)

Write the opening passage as if it were the beginning of a novel. Do not use asterisks (*) or markdown formatting.
Limit the opening passage to **one or two short paragraphs** (no more than 120 words total).

End the passage with 2 or 3 clear options the reader can choose from, using this exact format:

Options:
1. ...
2. ...
[If a third one]
3. ...
"""
        let userMessage = OpenRouterRequest.Message(role: "user", content: prompt)
        let raw = try await send(messages: [userMessage])
        return parseResponse(raw)
    }
    
    func continueStory(with choice: String, history: [String]) async throws -> StoryStep {
        let combined = history.map { step in
            if step.contains("Options:") {
                return step
            } else {
                return "\(step)\nPrevious options:\n(Not recorded)"
            }
        }.joined(separator: "\n\n---\n\n") + "\n\nReader’s choice: \(choice)"
        let prompt = """
You are an expert narrator crafting immersive and coherent interactive stories. Based on the story history and the reader's last choice, continue the story in the same narrative style.

Do not repeat earlier content, and do not use any markdown formatting or asterisks. Write the next scene as part of a traditional novel.
Limit the new scene to **one or two short paragraphs** (no more than 120 words total).

End with 2 or 3 clear options for the reader to choose from, using this exact format:

Options:
1. ...
2. ...
[If a third one]
3. ...

History:
\(combined)

Reader’s choice: \(choice)
"""
        let userMessage = OpenRouterRequest.Message(role: "user", content: prompt)
        let raw = try await send(messages: [userMessage])
        return parseResponse(raw)
    }
    
    // MARK: - Finish story (epílogo)
    func finishStory(history: [String]) async throws -> StoryStep {
        let narrative = history.joined(separator: "\n\n---\n\n")
        let prompt = """
You are an expert narrator. Below is everything that has happened in the story so far.

\(narrative)

Write a satisfying EPILOGUE in no more than two paragraphs that concludes the story.
Do not include any choices or questions to the reader.
Only return the epilogue text, without headings or "Options:".
"""
        let userMessage = OpenRouterRequest.Message(role: "user", content: prompt)
        let raw = try await send(messages: [userMessage])
        // Sin opciones → devolvemos un StoryStep vacío de choices
        return StoryStep(text: raw.trimmingCharacters(in: .whitespacesAndNewlines), choices: [])
    }
    
    private func parseResponse(_ raw: String) -> StoryStep {
        // Normalise line endings and trim spaces
        let cleanedRaw = raw
            .replacingOccurrences(of: "\r\n", with: "\n")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        let lines = cleanedRaw.split(separator: "\n", omittingEmptySubsequences: false)
        
        var narrativeLines: [Substring] = []
        var optionLines: [Substring] = []
        var foundOptions = false
        
        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            if trimmed.lowercased().hasPrefix("option ") ||
                (trimmed.first?.isNumber == true && (trimmed.contains(".") || trimmed.contains(")"))) {
                foundOptions = true
                optionLines.append(line)
            } else if !foundOptions {
                narrativeLines.append(line)
            }
        }
        
        let narrative = narrativeLines.joined(separator: "\n")
            .replacingOccurrences(of: "\n\n\n", with: "\n\n")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Parse choices
        var choices: [String] = []
        for rawOption in optionLines {
            let trimmed = rawOption.trimmingCharacters(in: .whitespaces)
            
            if trimmed.lowercased().hasPrefix("option ") {
                // "Option 1: text"
                if let colon = trimmed.firstIndex(of: ":") {
                    let after = trimmed[trimmed.index(after: colon)...]
                    choices.append(after.trimmingCharacters(in: .whitespaces))
                }
            } else if let first = trimmed.first, first.isNumber {
                // "1. text"   or  "1) text"
                if let sep = trimmed.firstIndex(where: { $0 == "." || $0 == ")" }) {
                    let after = trimmed[trimmed.index(after: sep)...]
                    choices.append(after.trimmingCharacters(in: .whitespaces))
                }
            }
        }
        
        return StoryStep(text: narrative, choices: choices)
    }
}
