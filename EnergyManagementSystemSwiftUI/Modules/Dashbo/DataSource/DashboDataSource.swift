//
//  DashboDataSource.swift
//  EnergyManagementSystemSwiftUI
//
//  Created by Jonashio on 4/8/22.
//

import Foundation

protocol DashboDataSourceProtocol {
    func fetchLiveRequest(completion: @escaping NTResponse<LiveModel>)
    func fetchHistoricRequest(completion: @escaping NTResponse<HistoricsModels>)
}

final class DashboDataSource: DashboDataSourceProtocol {
    private struct Keys {
        static var methodLive: String = "live_data.json?inline=false"
        static var methodHistoric: String = "historic_data.json?inline=false"
    }
    
    private weak var operation: URLSessionDataTask?
    
    func fetchLiveRequest(completion: @escaping NTResponse<LiveModel>) {
        cancelOperation()
        
        guard let request = URLRequest.buildRequest(method: Keys.methodLive, methodType: .GET) else {
            completion(.error(.unknown))
            return
        }
        
        operation = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.error(.businessFailure))
                return
            }
            
            guard let data = data else {
                completion(.error(.serverFailure(error)))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let model = try decoder.decode(LiveModel.self, from: data)
                
                completion(.success(model))
            } catch {
                completion(.error(.unknown))
            }
        }
        
        operation?.resume()
    }
    
    func fetchHistoricRequest(completion: @escaping NTResponse<HistoricsModels>) {
        cancelOperation()
        
        guard let request = URLRequest.buildRequest(method: Keys.methodLive, methodType: .GET) else {
            completion(.error(.unknown))
            return
        }
        
        operation = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.error(.businessFailure))
                return
            }
            
            guard let data = data else {
                completion(.error(.serverFailure(error)))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let model = try decoder.decode(HistoricsModels.self, from: data)
                
                completion(.success(model))
            } catch {
                completion(.error(.unknown))
            }
        }
        
        operation?.resume()
    }
    
    private func cancelOperation() {
        guard let operation = self.operation else { return }
        
        operation.cancel()
    }
}
