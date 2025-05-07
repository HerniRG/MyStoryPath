import Foundation

final class StartStoryUseCase {
    private let repository: StoryRepositoryProtocol

    init(repository: StoryRepositoryProtocol) {
        self.repository = repository
    }

    func execute(character: Character) async throws -> StoryStep {
        try await repository.startStory(with: character)
    }
}
