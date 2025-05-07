//
//  FinishStoryUseCase.swift
//  MyStoryPath
//
//  Created by Hernán Rodríguez on 4/5/25.
//

import Foundation

/// Caso de uso que solicita al repositorio generar un epílogo a partir del historial narrativo.
final class FinishStoryUseCase {
    private let repository: StoryRepositoryProtocol

    init(repository: StoryRepositoryProtocol) {
        self.repository = repository
    }

    /// - Parameter history: Array de párrafos narrativos (sin las decisiones del jugador)
    func execute(history: [String]) async throws -> StoryStep {
        try await repository.finishStory(history: history)
    }
}
