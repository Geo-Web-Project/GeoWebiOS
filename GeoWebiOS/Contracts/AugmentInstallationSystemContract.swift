//
//  AugmentInstallationSystemContract.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-10-28.
//

import Web3
import Web3ContractABI

class AugmentInstallationSystemContract: StaticContract {
    static let abi = """
      [
        {
          "inputs": [
            {
              "internalType": "contract IAugment",
              "name": "augment",
              "type": "address"
            },
            {
              "internalType": "bytes14",
              "name": "namespace",
              "type": "bytes14"
            },
            {
              "internalType": "bytes",
              "name": "args",
              "type": "bytes"
            }
          ],
          "name": "installAugment",
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
    
    func installAugment(augment: EthereumAddress, namespace: Bytes, args: Bytes) -> SolidityInvocation {
        let inputs = [
            SolidityFunctionParameter(name: "augment", type: .address),
            SolidityFunctionParameter(name: "namespace", type: .bytes(length: 14)),
            SolidityFunctionParameter(name: "args", type: .bytes(length: nil))
        ]
        let method = SolidityNonPayableFunction(name: "installAugment", inputs: inputs, handler: self)
        return method.invoke(augment, namespace, args)
    }
}

