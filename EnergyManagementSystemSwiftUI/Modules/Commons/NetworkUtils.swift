//
//  NetworkUtils.swift
//  EnergyManagementSystemSwiftUI
//
//  Created by Jonashio on 4/8/22.
//

import Foundation
import SwiftUI

public typealias NTParams = [String: String]
public typealias NTResponse<Value> = ((NTResult<Value, NTError<Error>>) -> Void)

public enum NTError<U> {
    case emptyData
    case serverFailure(U?)
    case businessFailure
    case unknown
}

public enum NTResult<T, U> {
    case success(T)
    case error(U)
}

public enum MethodType: String {
    case GET
    case HEAD
    case POST
    case PUT
    case DELETE
}
