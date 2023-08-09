//
//  TableId.swift
//  MUDTesting
//
//  Created by Cody Hatfield on 2023-08-03.
//

import Web3

struct TableId {
    let namespace: String
    let name: String
    
    init(namespace: String, name: String) {
        self.namespace = namespace.substr(0, 16) ?? namespace
        self.name = name.substr(0, 16) ?? name
    }
    
    func toHex() -> String {
        return TableId.toHex(namespace: self.namespace, name: self.name)
    }
    
    static func toHex(namespace: String, name: String) -> String {
        var namespaceBytes = namespace.makeBytes()
        var nameBytes = name.makeBytes()
        
        if namespaceBytes.count < 16 {
            for _ in 0...(16-namespaceBytes.count-1) {
                namespaceBytes.append(0)
            }
        }
        
        if nameBytes.count < 16 {
            for _ in 0...(16-nameBytes.count-1) {
                nameBytes.append(0)
            }
        }
        
        let concatTableId: Bytes = namespaceBytes + nameBytes
        return concatTableId.hexString(prefix: false)
    }
}

fileprivate let hexMapping = Array("0123456789abcdef")
extension Array where Element == Byte {
    func hexString(prefix: Bool) -> String {
        var charArray: [String.Element] = [String.Element](repeating: "0", count: self.count * 2)
        
        for i in 0..<self.count {
            charArray[i * 2] = hexMapping[Int(self[i]) / 16]
            charArray[(i * 2) + 1] = hexMapping[Int(self[i]) % 16]
        }
        
        if prefix {
            return "0x\(String(charArray))"
        } else {
            return String(charArray)
        }
    }
}
