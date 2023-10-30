//
//  AugmentContract.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-10-28.
//

import Web3
import Web3ContractABI

class AugmentContract: StaticContract {
    var address: EthereumAddress?
    
    var eth: Web3.Eth
    
    var events: [SolidityEvent] = []
    
    required init(address: EthereumAddress?, eth: Web3.Eth) {
        self.address = address
        self.eth = eth
    }
    
    func getComponentTypes() -> SolidityInvocation {
        let outputs = [
            SolidityFunctionParameter(name: "componentTypes", type: .array(type: .array(type: .bytes(length: 14), length: nil), length: nil))
        ]
        let method = SolidityConstantFunction(name: "getComponentTypes", inputs: [], outputs: outputs, handler: self)
        return method.invoke()
    }
    
    func performOverrides(namespace: Bytes) -> SolidityInvocation {
        let inputs = [
            SolidityFunctionParameter(name: "namespace", type: .bytes(length: 14))
        ]
        let method = SolidityNonPayableFunction(name: "performOverrides", inputs: inputs, handler: self)
        return method.invoke(namespace)
    }
}
