import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var noteManager: NoteManager
    @State private var selectedNote: Note?
    @State private var isPlusButtonHovering: Bool = false
    @State private var isFolderButtonHovering: Bool = false

    var body: some View {
        NavigationSplitView {
            VStack {
                Spacer().frame(height: 10) // Add space above the list
                Divider()
                    .background(Color("separator"))
                    .padding(/*@START_MENU_TOKEN@*/.horizontal, 40.0/*@END_MENU_TOKEN@*/)
                    .padding(/*@START_MENU_TOKEN@*/.vertical, 10.0/*@END_MENU_TOKEN@*/)
                    .foregroundColor(Color("separator"))
                List(selection: $selectedNote) {
                    ForEach($noteManager.notes) { $note in
                        NavigationLink(value: note) {
                            Text(note.title)
                        }
                        .contextMenu {
                            Button(action: {
                                delete(note: note)
                            }) {
                                Text("Delete")
                                Image(systemName: "trash")
                            }
                        }
                    }
                    .onDelete(perform: deleteNotes)
                }
                .listStyle(SidebarListStyle())
                .background(Color("secondary"))

                Spacer()

                HStack {
                    Spacer()
                    Button(action: openStorageDirectory) {
                        Image(systemName: "folder")
                            .padding()
                            .background(isFolderButtonHovering ? Color.gray.opacity(0.2) : Color.clear)
                            .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.trailing, 8)
                    .padding(.bottom, 16)
                    .onHover { hovering in
                        isFolderButtonHovering = hovering
                    }

                    Button(action: noteManager.addNote) {
                        Image(systemName: "plus")
                            .padding()
                            .background(isPlusButtonHovering ? Color.gray.opacity(0.2) : Color.clear)
                            .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.trailing, 16)
                    .padding(.bottom, 16)
                    .onHover { hovering in
                        isPlusButtonHovering = hovering
                    }
                }
            }
            .frame(minWidth: 200)
            .background(Color("secondary"))
            .navigationTitle("Notes")
        } detail: {
            if let selectedNote = selectedNote {
                NoteEditorView(note: Binding(
                    get: { selectedNote },
                    set: {
                        if let index = noteManager.notes.firstIndex(where: { $0.id == selectedNote.id }) {
                            noteManager.notes[index] = $0
                        }
                        noteManager.save(note: $0)
                        self.selectedNote = $0
                    }
                ), onSave: {
                    noteManager.save(note: selectedNote)
                })
            } else {
                Text("Select a note to edit")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .background(Color("bgcolor"))
        .frame(minWidth: 800, minHeight: 600)
        .onAppear {
            hideToolbar()
        }
    }

    private func delete(note: Note) {
        if let index = noteManager.notes.firstIndex(where: { $0.id == note.id }) {
            noteManager.notes.remove(at: index)
            noteManager.delete(note: note)
            if selectedNote?.id == note.id {
                selectedNote = nil
            }
        }
    }

    private func deleteNotes(at offsets: IndexSet) {
        offsets.sorted(by: >).forEach { index in
            if index < noteManager.notes.count {
                let note = noteManager.notes[index]
                delete(note: note)
            }
        }
    }

    private func openStorageDirectory() {
        NSWorkspace.shared.open(noteManager.getNotesDirectory())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(NoteManager())
    }
}
