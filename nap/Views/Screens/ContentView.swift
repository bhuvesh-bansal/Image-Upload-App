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
                    VStack {
                        Image(systemName: "house.fill")
                        Text("Upload")
                    }
                }
            
            ImagesGalleryView()
                .tabItem {
        VStack {
                        Image(systemName: "person.fill")
                        Text("Images")
                    }
                }
        }
        .tint(.green)
    }
}

#Preview {
    ContentView()
}
