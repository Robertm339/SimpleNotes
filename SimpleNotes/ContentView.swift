//
//  ContentView.swift
//  SimpleNotes
//
//  Created by Robert Martinez on 3/10/23.
//

import KeychainAccess
import SwiftUI

extension Date: RawRepresentable {
    public var rawValue: Int {
        Int(self.timeIntervalSinceReferenceDate)
    }
    
    public init?(rawValue: Int) {
        self = Date(timeIntervalSinceReferenceDate: Double(rawValue))
    }
}

struct ContentView: View {
    @AppStorage("lastSaved") private var lastSaved = Date.now
    @AppStorage("fontSize") var fontSize = 13.0
    @State private var notes = ""
    
    @State private var saveTask: Task<Void, Error>?
    
    let keychain = Keychain(service: "me.Martinez.Robert.SimpleNotes")
    
    var body: some View {
        VStack {
            TextEditor(text: $notes)
                .frame(width: 400, height: 400)
                .font(.system(size: fontSize))
            
            HStack{
                ControlGroup {
                    Button {
                        fontSize -= 1
                    } label: {
                        Label("Decrease font size", systemImage: "textformat.size.smaller")
                    }
                    
                    Button {
                        fontSize += 1
                    } label: {
                        Label("increase font size", systemImage: "textformat.size.larger")
                    }
                    
                    Button {
                        fontSize = 13
                    } label: {
                        Label("Reset font size", systemImage: "arrow.counterclockwise")
                    }
                }
                
                ControlGroup {
                    Button {
                        NSPasteboard.general.clearContents()
                        NSPasteboard.general.setString(notes, forType: .string)
                    } label: {
                        Label("Copy", systemImage: "doc.on.doc")
                    }
                    
                    ShareLink(item: notes)
                    
                    Button {
                        NSApp.terminate(nil)
                    } label: {
                        Label("Quit", systemImage: "power")
                    }
                }
            }
            
            Text("Last saved: \(lastSaved.formatted(date: .abbreviated, time: .standard))")
                .foregroundStyle(.secondary)
        }
        .padding()
        .onAppear(perform: load)
        .onChange(of: notes, perform: save)
    }
    
    func load() {
        notes = keychain["notes"] ?? ""
    }
    
    func save(newValue: String) {
        saveTask?.cancel()
        
        saveTask = Task {
            try await Task.sleep(for: .seconds(3))
            keychain["notes"] = newValue
            lastSaved = .now
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
