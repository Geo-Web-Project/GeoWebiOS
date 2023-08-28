//
//  SavedWorld.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-08-28.
//

import SwiftData
import Web3

@Model
final class SavedWorld {
    var chainId: Int
    @Attribute(.unique) var worldAddress: String
    
    init(chainId: Int, worldAddress: EthereumAddress) {
        self.chainId = chainId
        self.worldAddress = worldAddress.hex(eip55: true)
    }
}
