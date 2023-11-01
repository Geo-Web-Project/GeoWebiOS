//
//  AccessManagementSystemContract.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-10-29.
//

import Web3
import Web3ContractABI

class AccessManagementSystemContract: StaticContract {
    static let abi = """
      [
        {
            "inputs": [
              {
                "internalType": "ResourceId",
                "name": "resourceId",
                "type": "bytes32"
              },
              {
                "internalType": "address",
                "name": "grantee",
                "type": "address"
              }
            ],
            "name": "grantAccess",
            "outputs": [],
            "stateMutability": "nonpayable",
            "type": "function"
          }
      ]
    """.data(using: .utf8)
    
    var address: EthereumAddress?
    
    var eth: Web3.Eth
    
    var events: [SolidityEvent] = []
    
    required init(address: EthereumAddress?, eth: Web3.Eth) {
        self.address = address
        self.eth = eth
    }
}
