//
//  URLRequest+Extension.swift
//  EnergyManagementSystemSwiftUI
//
//  Created by Jonashio on 4/8/22.
//

import Foundation

extension URLRequest {
    static var URL_BASE: String = "​https://gitlab.com/carandahe/ems-demo-project/-/raw/main/"

    static func buildRequest(method: String, methodType: MethodType) -> URLRequest? {
        guard let url = URL(string: (URL_BASE + method).trimmingCharacters(in: .urlFragmentAllowed.inverted)) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = methodType.rawValue
        
        return request
    }
}
