//
//  CoinMarketTests.swift
//  CoinMarketTests
//
//  Created by Александр on 03.02.2020.
//  Copyright © 2020 Александр. All rights reserved.
//

import XCTest
@testable import CoinMarket

class CoinMarketTests: XCTestCase {

    var marketService: MarketService!
    override func setUp() {
        super.setUp()
        marketService = MarketService()
    }

    func testListReloading() {
        
        let expectFirstUpdate = expectation(description: "waiting for full updated list")
        let expectSecondUpdate = expectation(description: "waiting reloading list")
        var testStep = 0
        let subscriber = marketService.$coinList.sink { list in
            guard testStep != 0 else { testStep += 1; return }
            if testStep == 1 {
                expectFirstUpdate.fulfill()
            } else if testStep == 2 {
                expectSecondUpdate.fulfill()
            }
            
            testStep += 1
            
        }
        
        marketService.reloadList(with: TestData.firstList)
        wait(for: [expectFirstUpdate], timeout: 1)
        
        XCTAssertEqual(marketService.coinList.count, 5)
        guard marketService.coinList.count > 0 else { return }
        XCTAssertEqual(marketService.coinList[0].priceUsd, "9999.99")
        
        marketService.reloadList(with: TestData.secondTestList)
        
        wait(for: [expectSecondUpdate], timeout: 1)
        XCTAssertEqual(marketService.coinList.count, 5)
        XCTAssertEqual(marketService.coinList[0].priceUsd, "10000.0")
        XCTAssertEqual(marketService.coinList[1].priceUsd, "190.0")
        
    }

}

