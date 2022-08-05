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
            VStack {
                HStack {
                    Spacer()
                    DashboWidgetCircleView(textTitle: "Quasar Discharged",
                                     value: $viewModel.negativeQuasars,
                                     selectedID: $viewModel.selectedID)
                    .padding(.trailing, 30)
                    
                    DashboWidgetCircleView(textTitle: "Quasar charged",
                                     value: $viewModel.positiveQuasars,
                                     selectedID: $viewModel.selectedID)
                    Spacer()
                    
                }.padding(.horizontal, 25)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            if viewModel.stateEvents == .loading {
                LoadingView(alpha: 0.15)
                    .zIndex(3.0)
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .onAppear {
            viewModel.fetchData()
        }
        .onTapGesture {
            viewModel.selectedID = UUID()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DashboView()
    }
}
