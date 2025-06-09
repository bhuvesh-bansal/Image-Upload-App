//
//  ContentView.swift
//  nap
//
//  Created by Bhuvesh Bansal on 09/06/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            UploadView()
                .tabItem {
                    Label("Upload", systemImage: "house.fill")
                }
            
            ImagesGalleryView()
                .tabItem {
                    Label("Images", systemImage: "person.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
