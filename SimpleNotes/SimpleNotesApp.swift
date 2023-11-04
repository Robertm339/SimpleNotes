//
//  SimpleNotesApp.swift
//  SimpleNotes
//
//  Created by Robert Martinez on 3/10/23.
//

import SwiftUI

@main
struct SimpleNotesApp: App {
    var body: some Scene {
        MenuBarExtra("Notes") {
            ContentView()
        }
        .menuBarExtraStyle(.window)
    }
}
