import SwiftUI

struct NoteEditorView: View {
    @Binding var note: Note
    var onSave: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            TextField("Title", text: $note.title, onCommit: onSave)
                .font(.title2)
                .padding()
                .background(Color("bgcolor"))
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                .textFieldStyle(PlainTextFieldStyle())

            Divider()
                .padding(.horizontal, 40.0)
                .padding(.vertical, 10.0)
                .foregroundColor(Color("separator"))

            CustomTextEditor(text: $note.content)
                .padding()
                .background(Color("bgcolor"))
                .cornerRadius(10)
                .onChange(of: note.content) {
                    onSave()
                }
        }
        .padding()
        .background(Color("bgcolor"))
        .cornerRadius(10)
        .navigationTitle(note.title)
        .onDisappear(perform: onSave)
        .onAppear {
            hideToolbar()
        }
        .onDisappear {
            hideToolbar()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct NoteEditorView_Previews: PreviewProvider {
    static var previews: some View {
        NoteEditorView(note: .constant(Note(id: UUID(), title: "Title", content: "Start writing!")), onSave: {})
    }
}
