import SwiftUI

func hideToolbar() {
    DispatchQueue.main.async {
        if let window = NSApplication.shared.windows.first {
            window.titleVisibility = .hidden
            window.titlebarAppearsTransparent = true
            window.isMovableByWindowBackground = true
        }
    }
}
