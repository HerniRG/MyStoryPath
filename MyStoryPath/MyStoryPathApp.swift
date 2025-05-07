import SwiftUI

@main
struct MyStoryPathApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .tint(Color("IvoryAccent"))
                .preferredColorScheme(.light)
        }
    }
}
