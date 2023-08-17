//
//  StoreSync.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-08-08.
//

import Foundation
import SwiftData
import Web3
import Web3ContractABI
import Web3PromiseKit

class StoreSync {
    private let modelContext: ModelContext
    private let web3: Web3
    private let worldAddress: EthereumAddress
    private static let topics = [[try! EthereumData.string(ABI.encodeEventSignature(Store.StoreSetField))]]
    
    init(modelContext: ModelContext, web3: Web3, worldAddress: EthereumAddress) {
        self.modelContext = modelContext
        self.web3 = web3
        self.worldAddress = worldAddress
    }
    
    func syncLogs() throws {
        let addressStr = worldAddress.hex(eip55: true)
        let lastBlockFetch = FetchDescriptor<WorldSync>(
            predicate: #Predicate { $0.worldAddress == addressStr }
        )
        let results = try modelContext.fetch(lastBlockFetch)
        let lastBlock = results.count > 0 ? results[0].lastBlock : nil
        var fromBlock: EthereumQuantityTag = .earliest
        if let lastBlock {
            fromBlock = .block(BigUInt(lastBlock))
        }
        firstly {
            web3.eth.getLogs(addresses: [worldAddress], topics: StoreSync.topics, fromBlock: fromBlock, toBlock: .latest)
        }.done { logs in
            for log in logs {
                self.handleLog(log: log)
            }
        }.catch { error in
            print(error)
        }
    }
    
    func subscribeToLogs() throws {
        try web3.eth.subscribeToLogs(addresses: [worldAddress], topics: StoreSync.topics) {_ in } onEvent: { resp in
            if let res = resp.result {
                self.handleLog(log: res)
            }
        }
    }
    
    private func handleLog(log: EthereumLogObject) {
        do {
            // 1. Handle event
            let event = try ABIDecoder.decodeEvent(Store.StoreSetField, from: log)
            try Store.handleStoreSetEvent(modelContext: self.modelContext, address: log.address, event: event, blockNumber: log.blockNumber!)
            
            // 2. Mark block as synced
            self.modelContext.insert(WorldSync(worldAddress: self.worldAddress, lastBlock: UInt(log.blockNumber!.quantity)))
        } catch {
           print(error)
        }
    }
}
