//
//  MockDashboDataSource.swift
//  EnergyManagementSystemSwiftUITests
//
//  Created by Jonashio on 9/8/22.
//

@testable import EnergyManagementSystemSwiftUI
import Foundation

final class MockDashboDataSource: DashboDataSourceProtocol {
    
    var liveModel = LiveModel(solarPower: 5, quasarsPower: 10, gridPower: 20, buildingDemand: 30, systemSoc: 40, totalEnergy: 50, currentEnergy: 60)
    var historicsModels = [HistoricModel(buildingActivePower: 10, gridActivePower: 20, pvActivePower: 30, quasarsActivePower: 40, timestamp: Date() )]
    
    func fetchLiveRequest(completion: @escaping NTResponse<LiveModel>) {
        completion(.success(liveModel))
    }
    
    func fetchHistoricRequest(completion: @escaping NTResponse<HistoricsModels>) {
        completion(.success(historicsModels))
    }
}
