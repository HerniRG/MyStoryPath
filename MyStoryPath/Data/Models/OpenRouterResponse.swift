import Foundation

struct OpenRouterResponse: Decodable {
    struct Choice: Decodable {
        let message: Message
    }

    struct Message: Decodable {
        let content: String
    }

    let choices: [Choice]
}
