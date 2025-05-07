import Foundation
import Combine

@MainActor
final class InteractiveStoryViewModel: ObservableObject {
    @Published var storySteps: [StoryStep] = []
    @Published var currentStep: StoryStep?
    @Published var isLoading = false
    @Published var error: String?

    /// Indica si estamos solicitando el epílogo (botón Fin)
    @Published var isFinishing = false

    private let startUseCase: StartStoryUseCase
    private let continueUseCase: ContinueStoryUseCase
    private let finishUseCase: FinishStoryUseCase

    init(startUseCase: StartStoryUseCase,
         continueUseCase: ContinueStoryUseCase,
         finishUseCase: FinishStoryUseCase) {
        self.startUseCase = startUseCase
        self.continueUseCase = continueUseCase
        self.finishUseCase   = finishUseCase
    }

    func start(character: Character) async {
        isLoading = true
        error = nil
        do {
            let step = try await startUseCase.execute(character: character)
            storySteps = [step]
            currentStep = step
        } catch {
            self.error = error.localizedDescription
        }
        isLoading = false
    }

    func continueStory(with choice: String) async {
        isLoading = true
        error = nil
        do {
            // Prepara un historial compuesto solo por los fragmentos narrativos (sin las decisiones)
            let narrativeHistory = storySteps
                .filter { !$0.text.hasPrefix("➡️") }
                .map(\.text)

            // Solicita al caso de uso la continuación de la historia usando ese historial limpio
            let nextStep = try await continueUseCase.execute(
                choice: choice,
                history: narrativeHistory
            )

            // Una vez recibida la respuesta, añadimos la decisión del usuario y el nuevo fragmento
            let choiceStep = StoryStep(
                text: "➡️ Choice: \(choice)",
                choices: []
            )
            storySteps.append(contentsOf: [choiceStep, nextStep])

            // Marcamos el nuevo fragmento como paso actual
            currentStep = nextStep
        } catch {
            self.error = error.localizedDescription
        }
        isLoading = false
    }

    // MARK: - Terminar la historia manualmente
    func finishStory() async {
        guard !isFinishing else { return }
        isFinishing = true
        error = nil
        do {
            // Solo texto narrativo (sin flechas de decisión)
            let narrativeHistory = storySteps
                .filter { !$0.text.hasPrefix("➡️") }
                .map(\.text)

            let epilogue = try await finishUseCase.execute(history: narrativeHistory)
            storySteps.append(epilogue)
            currentStep = epilogue
        } catch {
            self.error = error.localizedDescription
        }
        isFinishing = false
    }
}
