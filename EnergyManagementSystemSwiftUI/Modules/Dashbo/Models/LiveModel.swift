//
//  LiveModel.swift
//  EnergyManagementSystemSwiftUI
//
//  Created by Jonashio on 4/8/22.
//

import Foundation

// MARK: - LiveModel
struct LiveModel: Codable {
    let solarPower, quasarsPower, gridPower, buildingDemand: Double
    let systemSoc: Double
    let totalEnergy, currentEnergy: Int

    enum CodingKeys: String, CodingKey {
        case solarPower = "solar_power"
        case quasarsPower = "quasars_power"
        case gridPower = "grid_power"
        case buildingDemand = "building_demand"
        case systemSoc = "system_soc"
        case totalEnergy = "total_energy"
        case currentEnergy = "current_energy"
    }
}
