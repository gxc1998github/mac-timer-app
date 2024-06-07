//
//  AppDelegate.swift
//  MenuBarTimer
//
//  Created by Daniel on 07/06/2024.
//

import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    
    var statusItem: NSStatusItem!
    var timer: Timer?
    var timeRemaining: TimeInterval = 60 // Default to 1 minute
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the status item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            button.title = "⏱️"
        }
        
        // Create the menu
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Start Timer", action: #selector(startTimer), keyEquivalent: "S"))
        menu.addItem(NSMenuItem(title: "Stop Timer", action: #selector(stopTimer), keyEquivalent: "T"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "Q"))
        
        statusItem.menu = menu
    }
    
    @objc func startTimer() {
        stopTimer() // Ensure no timer is running
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        timeRemaining = 60 // Reset the timer
    }
    
    @objc func stopTimer() {
        timer?.invalidate()
        timer = nil
        if let button = statusItem.button {
            button.title = "⏱️"
        }
    }
    
    @objc func updateTimer() {
        if timeRemaining > 0 {
            timeRemaining -= 1
            let minutes = Int(timeRemaining) / 60
            let seconds = Int(timeRemaining) % 60
            if let button = statusItem.button {
                button.title = String(format: "%02d:%02d", minutes, seconds)
            }
        } else {
            stopTimer()
            if let button = statusItem.button {
                button.title = "⏱️ Done!"
            }
        }
    }
}
