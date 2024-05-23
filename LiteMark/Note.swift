import Foundation

struct Note: Identifiable, Hashable {
    let id: UUID
    var title: String
    var content: String

    var fileName: String {
        "\(id.uuidString).txt"
    }
}
