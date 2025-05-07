import Foundation

protocol StoryRepositoryProtocol {
    func startStory(with character: Character) async throws -> StoryStep
    func continueStory(with choice: String, history: [String]) async throws -> StoryStep
    func finishStory(history: [String]) async throws -> StoryStep
}
