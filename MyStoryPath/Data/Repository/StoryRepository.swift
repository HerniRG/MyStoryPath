import Foundation

final class StoryRepository: StoryRepositoryProtocol {
    
    private let service: OpenRouterServiceProtocol

    init(service: OpenRouterServiceProtocol) {
        self.service = service
    }

    func startStory(with character: Character) async throws -> StoryStep {
        try await service.startStory(with: character)
    }

    func continueStory(with choice: String, history: [String]) async throws -> StoryStep {
        try await service.continueStory(with: choice, history: history)
    }
    
    func finishStory(history: [String]) async throws -> StoryStep {
        try await service.finishStory(history: history)
    }
}
