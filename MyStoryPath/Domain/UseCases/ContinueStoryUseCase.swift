import Foundation

final class ContinueStoryUseCase {
    private let repository: StoryRepositoryProtocol

    init(repository: StoryRepositoryProtocol) {
        self.repository = repository
    }

    func execute(choice: String, history: [String]) async throws -> StoryStep {
        try await repository.continueStory(with: choice, history: history)
    }
}
