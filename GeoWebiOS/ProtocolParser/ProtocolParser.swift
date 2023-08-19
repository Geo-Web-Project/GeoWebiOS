//
//  StaticAbiType.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-08-18.
//

import Foundation
import Web3
import Web3ContractABI

class ProtocolParser {
    enum ParserError: Error {
        case invalidStaticType
        case invalidDynamicType
        case invalidDataLength
        case invalidPackedCounter
        case packedCounterLengthMismatchError
    }
    
    static func decodeStaticField(abiType: SolidityType, data: Bytes) throws -> Any? {
        switch abiType {
        case .type(.int(let bits)):
            switch bits {
            case 8:
                return Int8(hexString: data.toHexString())
            case 16:
                return Int16(hexString: data.toHexString())
            case 17...32:
                return Int32(hexString: data.toHexString())
            case 33...64:
                return Int64(hexString: data.toHexString())
            default:
                return BigInt(hexString: data.toHexString())
            }
        case .type(.uint(let bits)):
            switch bits {
            case 8:
                return UInt8(hexString: data.toHexString())
            case 16:
                return UInt16(hexString: data.toHexString())
            case 17...32:
                return UInt32(hexString: data.toHexString())
            case 33...64:
                return UInt64(hexString: data.toHexString())
            default:
                return BigUInt(hexString: data.toHexString())
            }
        case .type(.bytes(let length)) where length != nil && length! <= 32:
            return Data(hexString: data.toHexString(), length: UInt(data.count))
        case .type(.bool):
            return Bool(hexString: data.toHexString())
        case .type(.address):
            return EthereumAddress(hexString: data.toHexString())
        default:
            throw ParserError.invalidStaticType
        }
    }
    
    static func decodeDynamicField(abiType: SolidityType, data: Bytes) throws -> Any? {
        switch abiType {
        case .type(.bytes(_)):
            return Data(hexString: data.toHexString(), length: UInt(data.count))
        case .type(.string):
            guard let d = Data(hexString: data.toHexString(), length: UInt(data.count)) else { return nil }
            return String(data: d, encoding: .utf8)
        case .array(let type, _):
            guard let decodeLengthUInt = type.decodeLength else { throw ParserError.invalidDynamicType }
            let decodeLength = Int(decodeLengthUInt)
            guard data.count % decodeLength == 0 else { throw ParserError.invalidDataLength }
            let items: [Any?] = Array(repeating: nil, count: data.count / decodeLength)
            return try items.enumerated().map { (index, _) in
                let itemData = Array(data[index*decodeLength..<(index+1)*decodeLength])
                return try ProtocolParser.decodeStaticField(abiType: type, data: itemData)
            }
        default:
            throw ParserError.invalidDynamicType
        }
    }
    
    static func hexToPackedCounter(data: Bytes) throws -> (UInt64, [UInt64]) {
        guard data.count == 32 else { throw ParserError.invalidPackedCounter }
    
        guard let totalByteLength = try decodeStaticField(abiType: .uint56, data: Array(data[0..<7])) as? UInt64 else { throw ParserError.invalidPackedCounter }
        guard let fieldByteLengths = try decodeDynamicField(abiType: .array(type: .uint40, length: nil), data: Array(data[7...])) as? [UInt64] else { throw ParserError.invalidPackedCounter }
                
        let summedLength = fieldByteLengths.reduce(0, +)
        guard summedLength == totalByteLength else { throw ParserError.packedCounterLengthMismatchError }
        
        return (totalByteLength, fieldByteLengths)
    }
}

extension SolidityType {
    public var decodeLength: UInt? {
        if isDynamic {
            return nil
        }
        
        switch self {
        case .type(.uint(bits: let bits)):
            return UInt(bits) / 8
        case .type(.int(bits: let bits)):
            return UInt(bits) / 8
        case .type(.bytes(length: let length)) where length != nil:
            return length
        case .type(.bool):
            return 1
        case .type(.address):
            return 20
        default:
            return nil
        }
    }
}
