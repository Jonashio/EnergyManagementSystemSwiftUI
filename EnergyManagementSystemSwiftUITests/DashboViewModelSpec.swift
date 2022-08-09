//
//  EnergyManagementSystemSwiftUITests.swift
//  EnergyManagementSystemSwiftUITests
//
//  Created by Jonashio on 3/8/22.
//

import XCTest
import Combine
@testable import EnergyManagementSystemSwiftUI

class DashboViewModelSpec: XCTestCase {
    
    private var viewModel: DashboViewModel!
    private var mockDataSource: DashboDataSourceProtocol!
    private var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        mockDataSource = MockDashboDataSource()
        viewModel = .init(dataSource: mockDataSource)
    }
    
    func testFetchDataWithCorrectResponse() {
        let expectation = XCTestExpectation(description: "Load correctly data")
        
        viewModel.$sourceAndDemand.dropFirst().sink { data in
            XCTAssertEqual(data.solar, Double(5), "Incorrect data load")
            expectation.fulfill()
        }.store(in: &cancellables)
        
        viewModel.fetchData()
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetchDataWithIncorrectResponse() {
        let expectation = XCTestExpectation(description: "Load correctly data")
        
        viewModel.$sourceAndDemand.dropFirst().sink { data in
            XCTAssertNotEqual(data.solar, Double(6), "Incorrect data load")
            expectation.fulfill()
        }.store(in: &cancellables)
        
        viewModel.fetchData()
        
        wait(for: [expectation], timeout: 1)
    }
    
}
