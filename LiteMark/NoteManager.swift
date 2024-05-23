import Foundation

class NoteManager: ObservableObject {
    @Published var notes: [Note] = []

    private let notesDirectory: URL

    init() {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        notesDirectory = documentsURL.appendingPathComponent("LiteMarkNotes")

        try? fileManager.createDirectory(at: notesDirectory, withIntermediateDirectories: true)

        loadNotes()
    }

    func addNote() {
        let newNote = Note(id: UUID(), title: "New Note", content: "")
        notes.append(newNote)
        save(note: newNote)
    }

    func delete(note: Note) {
        notes.removeAll { $0.id == note.id }
        let fileURL = notesDirectory.appendingPathComponent(note.fileName)
        try? FileManager.default.removeItem(at: fileURL)
    }

    func save(note: Note) {
        let fileURL = notesDirectory.appendingPathComponent(note.fileName)
        let content = "\(note.title)\n\(note.content)"
        try? content.write(to: fileURL, atomically: true, encoding: .utf8)
    }

    private func loadNotes() {
        let fileManager = FileManager.default
        let fileURLs = try? fileManager.contentsOfDirectory(at: notesDirectory, includingPropertiesForKeys: nil)

        notes = fileURLs?.compactMap { fileURL in
            guard let content = try? String(contentsOf: fileURL, encoding: .utf8) else {
                return nil
            }
            let components = content.split(separator: "\n", maxSplits: 1).map(String.init)
            guard components.count == 2 else {
                return nil
            }
            return Note(id: UUID(uuidString: fileURL.deletingPathExtension().lastPathComponent)!, title: components[0], content: components[1])
        } ?? []
    }
}
