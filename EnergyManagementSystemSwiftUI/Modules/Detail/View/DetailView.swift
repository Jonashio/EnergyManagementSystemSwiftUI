//
//  DetailView.swift
//  EnergyManagementSystemSwiftUI
//
//  Created by Jonashio on 7/8/22.
//

import SwiftUI
import SwiftUICharts

struct DetailView: View {
    @StateObject var viewModel = DetailViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                MultiLineChart(chartData: viewModel.chartData)
                    .touchOverlay(chartData: viewModel.chartData, specifier: "%.01f", unit: .suffix(of: "KW"))
                    .xAxisGrid(chartData: viewModel.chartData)
                    .yAxisGrid(chartData: viewModel.chartData)
                    .yAxisLabels(chartData: viewModel.chartData, specifier: "%.01f")
                    .floatingInfoBox(chartData: viewModel.chartData)
                    .headerBox(chartData: viewModel.chartData)
                    .legends(chartData: viewModel.chartData, columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())])
                    .id(viewModel.chartData.id)
                    .padding(.horizontal)
            }
            
            if viewModel.stateEvents == .loading {
                LoadingView(alpha: 0.15)
                    .zIndex(3.0)
            }
        }
        .navigationTitle("Chart")
        .onAppear {
            DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
                viewModel.fetchData()
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
    }
}
