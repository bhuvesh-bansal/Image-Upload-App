//
//  napApp.swift
//  nap
//
//  Created by Bhuvesh Bansal on 09/06/25.
//

import SwiftUI
import FirebaseCore

@main

struct napApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
