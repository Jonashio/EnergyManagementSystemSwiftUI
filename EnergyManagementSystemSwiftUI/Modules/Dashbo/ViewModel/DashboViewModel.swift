//
//  DashboViewModel.swift
//  EnergyManagementSystemSwiftUI
//
//  Created by Jonashio on 4/8/22.
//

import Foundation
import Combine
import SwiftUI

final class DashboViewModel: ObservableObject {
    var objectWillChange = ObservableObjectPublisher()
    
    @Published var stateEvents: StateEvents = .loading { didSet { objectWillChange.send() } }
    @Published var selectedID: UUID = UUID() { didSet { objectWillChange.send() } }
    @Published var positiveQuasars: Float = 0 { didSet { objectWillChange.send() } }
    @Published var negativeQuasars: Float = 0 { didSet { objectWillChange.send() } }
    @Published var sourceAndDemand: DashboWidgetRectangleData = (demand: 0, solar: 0, grid: 0, quasar: 0) { didSet { objectWillChange.send() } }
    
    private var historicData: HistoricsModels = HistoricsModels()
    private var liveData: LiveModel = LiveModel(solarPower: 0,
                                        quasarsPower: 0,
                                        gridPower: 0,
                                        buildingDemand: 0,
                                        systemSoc: 0,
                                        totalEnergy: 0,
                                        currentEnergy: 0)
    
    private var dataSource: DashboDataSourceProtocol
    
    init(dataSource: DashboDataSourceProtocol = DashboDataSource()) {
        self.dataSource = dataSource
    }
    
    private func setupDataView(_ model: LiveModel) {
        liveData = model
        setupPositiveQuasar()
        setupNegativeQuasar()
        setupSourceAndDemand()
    }
    
    private func setupSourceAndDemand() {
        DispatchQueue.main.async {
            self.sourceAndDemand = (demand: self.liveData.buildingDemand,
                                    solar: self.liveData.solarPower,
                                    grid: self.liveData.gridPower,
                                    quasar: self.liveData.quasarsPower)
        }
    }
    
    private func setupPositiveQuasar() {
        let value = liveData.quasarsPower
        DispatchQueue.main.async {
            self.positiveQuasars = Float(value >= 0 ? value : 0.0)
        }
    }
    
    private func setupNegativeQuasar() {
        let value = -1 * liveData.quasarsPower
        DispatchQueue.main.async {
            self.negativeQuasars = Float(value >= 0 ? value : 0.0)
        }
    }
    
    func fetchData() {
        changeStateEvents(.loading)
        
        fetchLive { response in
            switch response {
            case .success:
                self.fetchHistoric { responseHistoric in
                    switch responseHistoric {
                    case .success:
                        self.changeStateEvents(.normal)
                    case .error:
                        self.changeStateEvents(.error)
                    }
                }
            case .error:
                self.changeStateEvents(.error)
            }
        }
    }
    
    private func fetchLive(completion: @escaping NTResponse<Void>) {
        dataSource.fetchLiveRequest { response in
            switch response {
            case .success(let model):
                self.setupDataView(model)
                completion(.success(()))
            case .error(let error):
                print(error)
                completion(.error(error))
            }
        }
    }
    
    private func fetchHistoric(completion: @escaping NTResponse<Void>) {
        dataSource.fetchHistoricRequest { response in
            switch response {
            case .success(let model):
                self.historicData = model
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
