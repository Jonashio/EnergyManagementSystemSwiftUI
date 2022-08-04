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
    @Published var liveData: LiveModel = LiveModel(solarPower: 0, quasarsPower: 0, gridPower: 0, buildingDemand: 0, systemSoc: 0, totalEnergy: 0, currentEnergy: 0)
    @Published var historicData: HistoricsModels = HistoricsModels()
    
    private var dataSource: DashboDataSourceProtocol
    
    init(dataSource: DashboDataSourceProtocol = DashboDataSource()) {
        self.dataSource = dataSource
    }
    
    func fetchData() {
        changeStateEvents(.loading)
        fetchLive { response in
            switch response {
            case .success():
                self.fetchHistoric { responseHistoric in
                    print("Jona termino el historic: \(responseHistoric)")
                    self.changeStateEvents(.normal)
                }
                
            case .error(_):
                self.changeStateEvents(.error)
            }
        }
    }
    
    private func fetchLive(completion: @escaping NTResponse<Void>) {
//        changeStateEvents(.loading)
        
        dataSource.fetchLiveRequest { response in
            switch response {
            case .success(let model):
                self.liveData = model
//                self.changeStateEvents(.normal)
                completion(.success(()))
            case .error(let error):
                print(error)
//                self.changeStateEvents(.error)
                completion(.error(error))
            }
        }
    }
    
    private func fetchHistoric(completion: @escaping NTResponse<Void>) {
//        changeStateEvents(.loading)
        
        dataSource.fetchHistoricRequest { response in
            switch response {
            case .success(let model):
                self.historicData = model
//                self.changeStateEvents(.normal)
                completion(.success(()))
            case .error(let error):
                print(error)
//                self.changeStateEvents(.error)
                completion(.error(error))
            }
        }
    }
    
    func changeStateEvents(_ state: StateEvents) {
        DispatchQueue.main.async {
            withAnimation { self.stateEvents = state }
        }
    }
}
