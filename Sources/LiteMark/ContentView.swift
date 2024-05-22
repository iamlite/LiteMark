import SwiftUI

struct ContentView: View {
    @StateObject private var noteManager = NoteManager()
    @State private var selectedNote: Note?

    var body: some View {
        NavigationView {
            List(selection: $selectedNote) {
                ForEach($noteManager.notes) { $note in
                    NavigationLink(destination: NoteEditorView(note: $note, onSave: {
                        noteManager.save(note: note)
                    })) {
                        Text(note.title)
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        let note = noteManager.notes[index]
                        noteManager.delete(note: note)
                    }
                }
            }
            .listStyle(SidebarListStyle())
            .frame(minWidth: 200)

            if let selectedNote = selectedNote {
                NoteEditorView(note: Binding(
                    get: { selectedNote },
                    set: {
                        if let index = noteManager.notes.firstIndex(where: { $0.id == selectedNote.id }) {
                            noteManager.notes[index] = $0
                        }
                        @State var selectedNote = $0
                        noteManager.save(note: selectedNote)
                    }
                ), onSave: {
                    noteManager.save(note: selectedNote)
                })
            } else {
                Text("Select a note to edit")
                    .foregroundColor(.secondary)
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .automatic) {
                Button(action: noteManager.addNote) {
                    Label("Add Note", systemImage: "plus")
                }
                if let selectedNote = selectedNote {
                    Button(action: {
                        noteManager.delete(note: selectedNote)
                        self.selectedNote = nil
                    }) {
                        Label("Delete Note", systemImage: "trash")
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
