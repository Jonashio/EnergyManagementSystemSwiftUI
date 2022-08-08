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
        NavigationView {
            ZStack {
                ScrollView(.vertical) {
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
                            
                        }.padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20))
                        
                        DashboSourceAndDemandView(data: $viewModel.sourceAndDemand, selectedID: $viewModel.selectedID)
                            .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20))
                        
                        DashboPercentageSourceView(data: $viewModel.sourceAndDemand, selectedID: $viewModel.selectedID) {
                            withAnimation {
                                viewModel.isShowingDetailView.toggle()
                            }
                        }
                        .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20))
                        
                        NavigationLink(destination: DetailView(), isActive: $viewModel.isShowingDetailView) { EmptyView() }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                if viewModel.stateEvents == .loading {
                    LoadingView(alpha: 0.15)
                        .zIndex(3.0)
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
            .navigationTitle("Dashbo Status")
            .onAppear {
                DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
                    viewModel.fetchData()
                }
            }
            .onTapGesture {
                viewModel.selectedID = UUID()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DashboView()
    }
}
