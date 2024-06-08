import Cocoa
import AVFoundation

class AppDelegate: NSObject, NSApplicationDelegate, AVAudioPlayerDelegate {
    
    var statusItem: NSStatusItem!
    var timer: Timer?
    var timeRemaining: TimeInterval = 0 // Default to 0
    var isTimerRunning = false
    var audioPlayer: AVAudioPlayer?
    var startMenuItem: NSMenuItem!
    var pauseMenuItem: NSMenuItem!
    var resetMenuItem: NSMenuItem!
    var stopMenuItem: NSMenuItem!
    var sliderMenuItem: NSMenuItem!
    var fiveSecondsMenuItem: NSMenuItem!
    var fiveMinutesMenuItem: NSMenuItem!
    var tenMinutesMenuItem: NSMenuItem!
    var twentyMinutesMenuItem: NSMenuItem!
    var selectedTime: Double = 0.0

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Load the sound file
        if let soundURL = Bundle.main.url(forResource: "rainstick", withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.delegate = self
                audioPlayer?.prepareToPlay()
            } catch {
                print("Failed to load sound file: \(error)")
            }
        } else {
            print("Sound file not found")
        }
        
        // Create the status item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            button.title = "⏱️"
        }
        
        // Create the menu
        let menu = NSMenu()
        fiveSecondsMenuItem = NSMenuItem(title: "5 Seconds", action: #selector(setTimerToFiveSeconds), keyEquivalent: "")
        fiveMinutesMenuItem = NSMenuItem(title: "5 Minutes", action: #selector(setTimerToFiveMinutes), keyEquivalent: "")
        tenMinutesMenuItem = NSMenuItem(title: "10 Minutes", action: #selector(setTimerToTenMinutes), keyEquivalent: "")
        twentyMinutesMenuItem = NSMenuItem(title: "20 Minutes", action: #selector(setTimerToTwentyMinutes), keyEquivalent: "")
        
        menu.addItem(fiveSecondsMenuItem)
        menu.addItem(fiveMinutesMenuItem)
        menu.addItem(tenMinutesMenuItem)
        menu.addItem(twentyMinutesMenuItem)
        menu.addItem(NSMenuItem.separator())
        
        startMenuItem = NSMenuItem(title: "Start", action: #selector(startTimer), keyEquivalent: "")
        pauseMenuItem = NSMenuItem(title: "Pause", action: #selector(pauseTimer), keyEquivalent: "")
        resetMenuItem = NSMenuItem(title: "Reset", action: #selector(resetTimer), keyEquivalent: "")
        stopMenuItem = NSMenuItem(title: "Stop", action: #selector(stopSound), keyEquivalent: "")

        menu.addItem(startMenuItem)
        menu.addItem(pauseMenuItem)
        menu.addItem(resetMenuItem)
        menu.addItem(stopMenuItem)
        
        pauseMenuItem.isHidden = true
        resetMenuItem.isHidden = true
        stopMenuItem.isHidden = true
        startMenuItem.isEnabled = false // Initially disable the start button
        
        menu.addItem(NSMenuItem.separator())
        
        // Create the slider
        let sliderView = NSSlider(value: selectedTime, minValue: 0, maxValue: 120, target: self, action: #selector(sliderValueChanged(_:)))
        sliderView.frame.size = CGSize(width: 200, height: 20)
        sliderMenuItem = NSMenuItem()
        sliderMenuItem.view = sliderView
        menu.addItem(sliderMenuItem)
        
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "Q"))
        
        statusItem.menu = menu
    }
    
    @objc func setTimerToFiveSeconds() {
        timeRemaining = 5 // 5 seconds
        startTimer()
    }
    
    @objc func setTimerToFiveMinutes() {
        timeRemaining = 300 // 5 minutes in seconds
        startTimer()
    }
    
    @objc func setTimerToTenMinutes() {
        timeRemaining = 600 // 10 minutes in seconds
        startTimer()
    }
    
    @objc func setTimerToTwentyMinutes() {
        timeRemaining = 1200 // 20 minutes in seconds
        startTimer()
    }

    @objc func sliderValueChanged(_ sender: NSSlider) {
        selectedTime = sender.doubleValue
        startMenuItem.isEnabled = selectedTime > 0
    }

    @objc func startTimer() {
        if !isTimerRunning {
            if selectedTime > 0 {
                timeRemaining = selectedTime * 60 // Convert minutes to seconds
            }
            isTimerRunning = true
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            startMenuItem.isHidden = true
            pauseMenuItem.isHidden = false
            resetMenuItem.isHidden = false
            fiveSecondsMenuItem.isHidden = true
            fiveMinutesMenuItem.isHidden = true
            tenMinutesMenuItem.isHidden = true
            twentyMinutesMenuItem.isHidden = true
            sliderMenuItem.isHidden = true
        }
    }
    
    @objc func pauseTimer() {
        timer?.invalidate()
        isTimerRunning = false
        startMenuItem.isHidden = false
        pauseMenuItem.isHidden = true
        resetMenuItem.isHidden = false
    }
    
    @objc func resetTimer() {
        timer?.invalidate()
        isTimerRunning = false
        timeRemaining = 0
        if let button = statusItem.button {
            button.title = "⏱️"
        }
        startMenuItem.isHidden = false
        pauseMenuItem.isHidden = true
        resetMenuItem.isHidden = true
        stopMenuItem.isHidden = true
        fiveSecondsMenuItem.isHidden = false
        fiveMinutesMenuItem.isHidden = false
        tenMinutesMenuItem.isHidden = false
        twentyMinutesMenuItem.isHidden = false
        sliderMenuItem.isHidden = false
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
            timer?.invalidate()
            isTimerRunning = false
            if let button = statusItem.button {
                button.title = "⏱️ Done!"
            }
            audioPlayer?.play()
            startMenuItem.isHidden = true
            pauseMenuItem.isHidden = true
            resetMenuItem.isHidden = true
            stopMenuItem.isHidden = false // Show the stop button when the sound is playing
            fiveSecondsMenuItem.isHidden = true
            fiveMinutesMenuItem.isHidden = true
            tenMinutesMenuItem.isHidden = true
            twentyMinutesMenuItem.isHidden = true
            sliderMenuItem.isHidden = true
        }
    }

    @objc func stopSound() {
        audioPlayer?.stop()
        resetToOriginalState()
    }

    func resetToOriginalState() {
        if let button = statusItem.button {
            button.title = "⏱️"
        }
        stopMenuItem.isHidden = true
        startMenuItem.isHidden = false
        fiveSecondsMenuItem.isHidden = false
        fiveMinutesMenuItem.isHidden = false
        tenMinutesMenuItem.isHidden = false
        twentyMinutesMenuItem.isHidden = false
        sliderMenuItem.isHidden = false
    }

    // AVAudioPlayerDelegate method
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        resetToOriginalState()
    }
}
