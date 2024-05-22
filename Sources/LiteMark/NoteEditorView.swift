import SwiftUI

struct NoteEditorView: View {
    @Binding var note: Note
    var onSave: () -> Void

    var body: some View {
        VStack {
            TextField("Title", text: $note.title, onCommit: onSave)
                .font(.title)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Divider()

            TextEditor(text: $note.content)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                .onChange(of: note.content) { _ in
                    onSave()
                }
        }
        .padding()
        .navigationTitle(note.title)
        .onDisappear(perform: onSave)
    }
}

struct NoteEditorView_Previews: PreviewProvider {
    static var previews: some View {
        NoteEditorView(note: .constant(Note(id: UUID(), title: "Sample Note", content: "This is a sample note.")), onSave: {})
    }
}
