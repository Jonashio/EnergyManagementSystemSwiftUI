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
    @Published var isShowingDetailView: Bool = false { didSet { objectWillChange.send() } }
    
    private var liveData: LiveModel?
    
    private var dataSource: DashboDataSourceProtocol
    
    init(dataSource: DashboDataSourceProtocol = DashboDataSource()) {
        self.dataSource = dataSource
    }

    func fetchData() {
        guard liveData == nil else { return }
        changeStateEvents(.loading)
        
        fetchLive { response in
            switch response {
            case .success:
                self.changeStateEvents(.normal)
            case .error:
                self.changeStateEvents(.error)
            }
        }
    }
}

extension DashboViewModel {
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
    
    private func changeStateEvents(_ state: StateEvents) {
        DispatchQueue.main.async {
            withAnimation { self.stateEvents = state }
        }
    }
    
    private func setupDataView(_ model: LiveModel) {
        liveData = model
        setupPositiveQuasar(model)
        setupNegativeQuasar(model)
        setupSourceAndDemand(model)
    }
    
    private func setupSourceAndDemand(_ model: LiveModel) {
        DispatchQueue.main.async {
            self.sourceAndDemand = (demand: model.buildingDemand,
                                    solar: model.solarPower,
                                    grid: model.gridPower,
                                    quasar: model.quasarsPower)
        }
    }
    
    private func setupPositiveQuasar(_ model: LiveModel) {
        let value = model.quasarsPower
        DispatchQueue.main.async {
            self.positiveQuasars = Float(value >= 0 ? value : 0.0)
        }
    }
    
    private func setupNegativeQuasar(_ model: LiveModel) {
        let value = -1 * model.quasarsPower
        DispatchQueue.main.async {
            self.negativeQuasars = Float(value >= 0 ? value : 0.0)
        }
    }
}
