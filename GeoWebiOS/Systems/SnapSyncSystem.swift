//
//  SnapSyncSystem.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-08-08.
//

import Foundation
import Web3
import Web3ContractABI

class SnapSyncSystem: StaticContract, EthereumContract {
    public var address: EthereumAddress?
    public let eth: Web3.Eth
    public var events: [SolidityEvent] = []
    
    public required init(address: EthereumAddress?, eth: Web3.Eth) {
        self.address = address
        self.eth = eth
    }
    
    func getNumKeysInTable(tableId: Data) -> SolidityInvocation {
        let inputs = [SolidityFunctionParameter(name: "tableId", type: .bytes(length: 32))]
        let outputs = [SolidityFunctionParameter(name: "_numKeysInTable", type: .uint256)]
        let method = SolidityConstantFunction(name: "snapSync_system_getNumKeysInTable", inputs: inputs, outputs: outputs, handler: self)
        return method.invoke(tableId)
    }
    
    func getRecords(tableId: Data, limit: BigUInt, offset: BigUInt) -> SolidityInvocation {
        let inputs = [
            SolidityFunctionParameter(name: "tableId", type: .bytes(length: 32)),
            SolidityFunctionParameter(name: "limit", type: .uint256),
            SolidityFunctionParameter(name: "offset", type: .uint256)
        ]
        let outputs = [SolidityFunctionParameter(name: "records", type: .array(type: .tuple([.bytes(length: 32), .array(type: .bytes(length: 32), length: nil), .bytes(length: nil)]), length: nil))]
        let method = SolidityConstantFunction(name: "snapSync_system_getRecords", inputs: inputs, outputs: outputs, handler: self)
        return method.invoke(tableId, limit, offset)
    }
}
