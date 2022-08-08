//
//  HistoricModel.swift
//  EnergyManagementSystemSwiftUI
//
//  Created by Jonashio on 4/8/22.
//

import Foundation

// MARK: - HistoricModel
struct HistoricModel: Codable, Identifiable {
    let id = UUID()
    let buildingActivePower, gridActivePower, pvActivePower, quasarsActivePower: Double
    let timestamp: Date

    enum CodingKeys: String, CodingKey {
        case buildingActivePower = "building_active_power"
        case gridActivePower = "grid_active_power"
        case pvActivePower = "pv_active_power"
        case quasarsActivePower = "quasars_active_power"
        case timestamp
    }
}

typealias HistoricsModels = [HistoricModel]
