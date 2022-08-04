//
//  DashboView.swift
//  EnergyManagementSystemSwiftUI
//
//  Created by Jonashio on 3/8/22.
//

import SwiftUI

struct DashboView: View {
    
    @StateObject var viewModel = DashboViewModel()
    
    var body: some View {
        ZStack {
            Text("Hello, world!")
                .padding()
            
            if viewModel.stateEvents == .loading {
                LoadingView(alpha: 0.15)
                    .zIndex(3.0)
            }
            
        }.onAppear {
            viewModel.fetchData()
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DashboView()
    }
}
