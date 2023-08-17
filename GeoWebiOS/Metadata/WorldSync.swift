//
//  WorldSync.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-08-17.
//

import SwiftData
import Web3

@Model
final class WorldSync {
    @Attribute(.unique) var worldAddress: String
    var lastBlock: UInt
    
    init(worldAddress: EthereumAddress, lastBlock: UInt) {
        self.worldAddress = worldAddress.hex(eip55: true)
        self.lastBlock = lastBlock
    }
}
