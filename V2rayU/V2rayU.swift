//
//  V2rayU.swift
//  V2rayU
//
//  Created by yanue on 2022/8/26.

import Cocoa
import SwiftUI

class AppState: ObservableObject {
}

@main
struct V2rayUApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) private var scenePhase
    @StateObject var appState = AppState()
    
    // This is our Scene. We are not using Settings
    var body: some Scene {
        
        WindowGroup("MainView") {
            ContentView().environmentObject(appState)   // inject to update
            // selected book
        }.handlesExternalEvents(matching: Set(arrayLiteral: WinHelper.mainView.rawValue))
        
        
        WindowGroup("OtherView") {
            OtherView()
        }.handlesExternalEvents(matching: Set(arrayLiteral: WinHelper.helperView.rawValue))
    }
}

// Our AppDelegae will handle our menu
class AppDelegate: NSObject, NSApplicationDelegate {
    static private(set) var instance: AppDelegate!
    
    // The NSStatusBar manages a collection of status items displayed within a system-wide menu bar.
    lazy var statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    // Create an instance of our custom main menu we are building
    let menu = MainMenu()
    
    override init() {
        // This plumbs in the 3rd party Sparkle updater framework
        // If you want to start the updater manually, pass false to startingUpdater and call .startUpdater() later
        // This is where you can also pass an updater delegate if you need one
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        AppDelegate.instance = self
        
        // Here we are using a custom icon found in Assets.xcassets
        statusBarItem.button?.image = NSImage(named: NSImage.Name("IconOn"))
        statusBarItem.button?.imagePosition = .imageLeading
        // Assign our custom menu to the status bar
        statusBarItem.menu = menu.build()
    }
}

// magic here
enum WinHelper: String, CaseIterable {
    case mainView   = "MainView"
    case helperView = "OtherView"
    
    func open(){
        if let url = URL(string: "V2rayU://\(self.rawValue)") {
            print("opening \(self.rawValue)")
            NSWorkspace.shared.open(url)
        }
    }
}
