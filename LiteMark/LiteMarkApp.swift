import SwiftUI

@main
struct LiteMarkApp: App {
    @StateObject private var noteManager = NoteManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(noteManager)
                .onAppear {
                    hideToolbar()
                }
        }
    }

    private func hideToolbar() {
        DispatchQueue.main.async {
            if let window = NSApplication.shared.windows.first {
                window.titleVisibility = .hidden
                window.titlebarAppearsTransparent = true
                window.isMovableByWindowBackground = true
            }
        }
    }
}
