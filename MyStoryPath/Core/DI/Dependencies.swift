import Foundation

final class Dependencies {
    @MainActor static func makeInteractiveStoryViewModel() -> InteractiveStoryViewModel {
        let apiKey = APIKeys.openRouterKey
        let service = OpenRouterService(apiKey: apiKey)
        let repository = StoryRepository(service: service)
        let startUseCase = StartStoryUseCase(repository: repository)
        let continueUseCase = ContinueStoryUseCase(repository: repository)
        let finishUseCase   = FinishStoryUseCase(repository: repository)
        return InteractiveStoryViewModel(startUseCase: startUseCase,
                                         continueUseCase: continueUseCase,
                                         finishUseCase:   finishUseCase)
    }
    
    @MainActor static func makeStartUseCase() -> StartStoryUseCase {
        let apiKey = APIKeys.openRouterKey
        let service = OpenRouterService(apiKey: apiKey)
        let repository = StoryRepository(service: service)
        return StartStoryUseCase(repository: repository)
    }

    @MainActor static func makeContinueUseCase() -> ContinueStoryUseCase {
        let apiKey = APIKeys.openRouterKey
        let service = OpenRouterService(apiKey: apiKey)
        let repository = StoryRepository(service: service)
        return ContinueStoryUseCase(repository: repository)
    }
    
    @MainActor static func makeFinishUseCase() -> FinishStoryUseCase {
        let apiKey = APIKeys.openRouterKey
        let service = OpenRouterService(apiKey: apiKey)
        let repository = StoryRepository(service: service)
        return FinishStoryUseCase(repository: repository)
    }
}
