//
//  MenuBarTimerApp.swift
//  MenuBarTimer
//
//  Created by Daniel on 07/06/2024.
//
import SwiftUI

@main
struct MenuBarTimerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
