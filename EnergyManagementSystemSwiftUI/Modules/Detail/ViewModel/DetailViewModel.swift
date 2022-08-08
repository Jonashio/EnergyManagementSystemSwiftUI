//
//  DetailViewModel.swift
//  EnergyManagementSystemSwiftUI
//
//  Created by Jonashio on 7/8/22.
//
import Combine
import SwiftUI
import SwiftUICharts

final class DetailViewModel: ObservableObject {
    var objectWillChange = ObservableObjectPublisher()
    
    @Published var stateEvents: StateEvents = .loading { didSet { objectWillChange.send() } }
    var chartData: MultiLineChartData = MultiLineChartData(dataSets: MultiLineDataSet(dataSets: []))
    
    private var historicData: HistoricsModels = HistoricsModels()
    private var dataSource: DashboDataSourceProtocol
    
    init(dataSource: DashboDataSourceProtocol = DashboDataSource()) {
        self.dataSource = dataSource
    }
    
    func setupChartsView() {
        let dps = getDataPoints()
        
        let data = MultiLineDataSet(dataSets: [
            generateSingleDataSet(data: dps.solar, title: "Solar", color: .red),
            generateSingleDataSet(data: dps.grid, title: "Grid", color: .blue),
            generateSingleDataSet(data: dps.quasar, title: "Quasar", color: .green)
        ])
        
        let dataset = MultiLineChartData(dataSets: data,
                                         metadata: ChartMetadata(title: "Historic data"),
                                         chartStyle: getLineChartStyle())
        
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
    
    func changeStateEvents(_ state: StateEvents) {
        DispatchQueue.main.async {
            withAnimation { self.stateEvents = state }
        }
    }
}
extension DetailViewModel {
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
    
    private func getDataPoints() -> (solar: [LineChartDataPoint], grid: [LineChartDataPoint], quasar: [LineChartDataPoint]) {
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
        
        return (solarDataPoints, gridDataPoints, quasarDataPoints)
    }
    
    private func generateSingleDataSet(data: [LineChartDataPoint], title: String, color: Color) -> LineDataSet {
        return LineDataSet(dataPoints: data,
                           legendTitle: title,
                           style: LineStyle(lineColour: ColourStyle(colour: color), lineType: .line))
    }
    
    private func getLineChartStyle() -> LineChartStyle {
        return LineChartStyle(infoBoxPlacement: .floating,
                              xAxisGridStyle: GridStyle(numberOfLines: 12),
                              xAxisTitle: "Day",
                              yAxisGridStyle: GridStyle(numberOfLines: 5),
                              yAxisNumberOfLabels: 5,
                              yAxisTitle: "KW",
                              baseline: .minimumValue,
                              topLine: .maximumValue)
    }
}
