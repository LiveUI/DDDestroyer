//
//  AppDelegate.swift
//  DDDestroyer
//
//  Created by Rafaj Design on 22/03/2017.
//  Copyright © 2017 Rafaj Design. All rights reserved.
//

import Cocoa
import AppKit


@NSApplicationMain

class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    var statusItem: NSStatusItem?
    
    var menuItems: [NSMenuItem] = []
    var subDirectories: [URL] = []
    
    var derivedFolderUrl: URL {
        let home: String = NSHomeDirectory()
        var url: URL = URL.init(fileURLWithPath: home)
        url.appendPathComponent("Library/Developer/Xcode/DerivedData")
        return url
    }
    
    // MARK: Application delegate methods
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
        self.statusItem?.image = NSImage(named: "icon")
        self.statusItem?.image?.isTemplate = true
        self.statusItem?.action = #selector(AppDelegate.didTapStatusBarIcon)
    }
    
    // MARK: Actions
    
    func didTapStatusBarIcon() {
        let menu: NSMenu = NSMenu.init()
        
        var item: NSMenuItem = NSMenuItem.init(title: "Clear ALL", action: #selector(AppDelegate.deleteAll), keyEquivalent: "")
        menu.addItem(item)
        
        self.subDirectories = self.derivedFolderUrl.subDirectories
        self.menuItems = []
        for url: URL in self.subDirectories {
            var components: [String] = url.lastPathComponent.components(separatedBy: "-")
            if components.count > 1 {
                components.removeLast()
            }
            let title = components.joined(separator: "-")
            item = NSMenuItem.init(title: title, action: #selector(AppDelegate.deleteOne), keyEquivalent: "")
            menu.addItem(item)
            self.menuItems.append(item)
        }
        
        self.statusItem?.popUpMenu(menu)
    }
    
    func deleteAll() {
        self.deleteDerivedData()
    }
    
    func deleteOne(sender: NSMenuItem) {
        let index: Int = self.menuItems.index(of: sender)!
        let url: URL = self.subDirectories[index]
        self.deleteDerivedData(url.lastPathComponent)
    }
    
    // MARK: Working with derived data
    
    func deleteDerivedData(_ subfolder: String? = nil) {
        do {
            var url: URL = self.derivedFolderUrl
            if subfolder != nil {
                url.appendPathComponent(subfolder!)
            }
            try FileManager.default.removeItem(at: url)
        }
        catch {
            print(error)
        }
    }
    
}

