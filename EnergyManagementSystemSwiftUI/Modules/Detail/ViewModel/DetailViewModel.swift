//
//  DetailViewModel.swift
//  EnergyManagementSystemSwiftUI
//
//  Created by Jonashio on 7/8/22.
//

import Foundation
import Combine
import SwiftUI
import SwiftUICharts

final class DetailViewModel: ObservableObject {
    var objectWillChange = ObservableObjectPublisher()
    
    @Published var stateEvents: StateEvents = .loading { didSet { objectWillChange.send() } }
    @Published var chartData: MultiLineChartData = MultiLineChartData(dataSets: MultiLineDataSet(dataSets: [])) { didSet { objectWillChange.send() } }
    
    private var historicData: HistoricsModels = HistoricsModels()
    private var dataSource: DashboDataSourceProtocol
    
    init(dataSource: DashboDataSourceProtocol = DashboDataSource()) {
        self.dataSource = dataSource
    }
    
    func setupChartsView() {
        var solarDataPoints: [LineChartDataPoint] = []
        var gridDataPoints: [LineChartDataPoint] = []
        var quasarDataPoints: [LineChartDataPoint] = []
        
        var counter = 0
        var modAverage = 1.00
        
        if historicData.count > 50 {
            modAverage = round(Double(historicData.count) / 50.00)
        }
        
        for item in historicData {
            if counter % Int(modAverage) == 0 {
                solarDataPoints.append(LineChartDataPoint(value: item.pvActivePower,  xAxisLabel: "\(counter)", description: item.timestamp.description))
                gridDataPoints.append(LineChartDataPoint(value: item.gridActivePower,  xAxisLabel: "\(counter)", description: item.timestamp.description))
                quasarDataPoints.append(LineChartDataPoint(value: item.quasarsActivePower,  xAxisLabel: "\(counter)", description: item.timestamp.description))
            }
            counter+=1
        }
        
        
        let data = MultiLineDataSet(dataSets: [
            LineDataSet(dataPoints: solarDataPoints,
                        legendTitle: "Solar",
                        pointStyle: PointStyle(pointType: .outline, pointShape: .circle),
                        style: LineStyle(lineColour: ColourStyle(colour: .red), lineType: .line)),
            
            LineDataSet(dataPoints: gridDataPoints,
                        legendTitle: "Grid",
                        pointStyle: PointStyle(pointType: .outline, pointShape: .square),
                        style: LineStyle(lineColour: ColourStyle(colour: .blue), lineType: .line)),
            
            LineDataSet(dataPoints: quasarDataPoints,
                        legendTitle: "Quasar",
                        style: LineStyle(lineColour: ColourStyle(colour: .green),lineType: .line)),
        ])
        
        let dataset = MultiLineChartData(dataSets: data,
                                         metadata: ChartMetadata(title: "Historic balance"),
                                         chartStyle: LineChartStyle(infoBoxPlacement: .floating,
                                                                    xAxisGridStyle: GridStyle(numberOfLines: 12),
                                                                    xAxisTitle: "Day",
                                                                    yAxisGridStyle: GridStyle(numberOfLines: 5),
                                                                    yAxisNumberOfLabels: 5,
                                                                    yAxisTitle: "KW",
                                                                    baseline: .minimumValue,
                                                                    topLine: .maximumValue))

        DispatchQueue.main.async {
            self.chartData = dataset
        }
        
    }
    
    func fetchData() {
        changeStateEvents(.loading)
        
        self.fetchHistoric { responseHistoric in
            switch responseHistoric {
            case .success:
                self.changeStateEvents(.normal)
            case .error:
                self.changeStateEvents(.error)
            }
        }
    }
    
    private func fetchHistoric(completion: @escaping NTResponse<Void>) {
        dataSource.fetchHistoricRequest { response in
            switch response {
            case .success(let model):
                self.historicData = model
                self.setupChartsView()
                completion(.success(()))
            case .error(let error):
                print(error)
                completion(.error(error))
            }
        }
    }
    
    private func changeStateEvents(_ state: StateEvents) {
        DispatchQueue.main.async {
            withAnimation { self.stateEvents = state }
        }
    }
}
