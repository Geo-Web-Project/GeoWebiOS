//
//  MUDStore.swift
//  MUDTesting
//
//  Created by Cody Hatfield on 2023-07-26.
//

import Web3
import Web3ContractABI
import SwiftData
import Foundation

struct Store {
    enum StoreError: Error {
        case invalidTableId
        case unknownTableId
    }
    
    static var StoreSetField: SolidityEvent {
        let inputs: [SolidityEvent.Parameter] = [
            SolidityEvent.Parameter(name: "table", type: .bytes(length: 32), indexed: false),
            SolidityEvent.Parameter(name: "key", type: .array(type: .bytes(length: 32), length: nil), indexed: false),
            SolidityEvent.Parameter(name: "schemaIndex", type: .uint8, indexed: false),
            SolidityEvent.Parameter(name: "data", type: .bytes(length: nil), indexed: false)
        ]
        return SolidityEvent(name: "StoreSetField", anonymous: false, inputs: inputs)
    }
    
    static var StoreSetRecord: SolidityEvent {
        let inputs: [SolidityEvent.Parameter] = [
            SolidityEvent.Parameter(name: "table", type: .bytes(length: 32), indexed: false),
            SolidityEvent.Parameter(name: "key", type: .array(type: .bytes(length: 32), length: nil), indexed: false),
            SolidityEvent.Parameter(name: "data", type: .bytes(length: nil), indexed: false)
        ]
        return SolidityEvent(name: "StoreSetRecord", anonymous: false, inputs: inputs)
    }
    
    static let tables = [
        Name.tableId.toHex(): Name.setField,
        Url.tableId.toHex(): Url.setField,
        MediaObject.tableId.toHex(): MediaObject.setRecord,
        IsAnchorComponent.tableId.toHex(): IsAnchorComponent.setRecord,
        Model3DComponent.tableId.toHex(): Model3DComponent.setRecord,
        PositionComponent.tableId.toHex(): PositionComponent.setRecord,
        AnchorComponent.tableId.toHex(): AnchorComponent.setRecord
    ]
    
    static func handleStoreSetFieldEvent(modelContext: ModelContext, address: EthereumAddress, event: [String: Any], blockNumber: EthereumQuantity) throws {
        guard let tableId = event["table"] as? Data else { throw StoreError.invalidTableId }
        guard let tableFunc = tables[tableId.toHexString()] else { throw StoreError.unknownTableId }
        
        try tableFunc(modelContext, address, event, blockNumber)
    }
}
