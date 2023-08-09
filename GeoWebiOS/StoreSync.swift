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
    
    init(modelContext: ModelContext, web3: Web3, worldAddress: EthereumAddress) {
        self.modelContext = modelContext
        self.web3 = web3
        self.worldAddress = worldAddress
    }
    
    func syncLogs() {
        // 1. If no data, snap sync
        let contractAddress = try! EthereumAddress(hex: "0x5FbDB2315678afecb367f032d93F642f64180aa3", eip55: true)
        let contract = web3.eth.Contract(type: SnapSyncSystem.self, address: contractAddress)

        firstly {
            contract.getRecords(tableId: Data(hex: Name.tableId.toHex()), limit: 10, offset: 0).call()
        }.done { outputs in
            for record in outputs {
                
            }
        }.catch { error in
            print(error)
        }
    }
    
    func subscribeToLogs() throws {
        try web3.eth.subscribeToLogs(topics: [[EthereumData.string(ABI.encodeEventSignature(Store.StoreSetField))]]) {_ in } onEvent: { resp in
            if let res = resp.result {
                do {
                    let event = try ABIDecoder.decodeEvent(Store.StoreSetField, from: res)
                    try Store.handleStoreSetEvent(modelContext: self.modelContext, address: res.address, event: event, blockNumber: res.blockNumber!)
                } catch {
                   print(error)
                }
            }
        }
    }
}
