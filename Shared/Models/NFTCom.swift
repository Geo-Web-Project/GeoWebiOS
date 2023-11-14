////
////  NFTCom.swift
////  GeoWebiOS
////
////  Created by Cody Hatfield on 2023-10-29.
////
//
//import Foundation
//import RealityKit
//import VarInt
//import CID
//import Multicodec
//import SwiftData
//import SwiftMUD
//import Web3
//import Web3ContractABI
//import CryptoSwift
//
//@Model
//final class NFTCom: Component, Record {
//    var table: Table?
//    
//    @Attribute(.unique) var uniqueKey: String
//    var lastUpdatedAtBlock: UInt
//
//    var key: Data
//    
//    var chainId: UInt64
//    var tokenAddress: String
//    var tokenId: Data
//    
//    @Transient
//    var encodingFormat: ImageEncodingFormat?
//    
//    @Transient
//    var contentUrl: URL?
//    
//    init(uniqueKey: String, lastUpdatedAtBlock: UInt, key: Data, chainId: UInt64, tokenAddress: EthereumAddress, tokenId: BigUInt) {
//        self.uniqueKey = uniqueKey
//        self.lastUpdatedAtBlock = lastUpdatedAtBlock
//
//        self.key = key
//        self.chainId = chainId
//        self.tokenAddress = tokenAddress.hex(eip55: true)
//        self.tokenId = Data(tokenId.makeBytes())
//        
//        Task {
//            await fetchNFTMetadata()
//        }
//    }
//    
//    static func setRecord(modelContext: ModelContext, table: Table, values: [String : Any], blockNumber: EthereumQuantity) throws {
//        guard let keys = values["keyTuple"] as? [Data] else { throw SetRecordError.invalidData }
//        guard let key = try ProtocolParser.decodeStaticField(abiType: SolidityType.bytes(length: 32), data: keys[0].makeBytes()) as? Data else { throw SetRecordError.invalidNativeValue }
//        
//        guard let staticData = values["staticData"] as? Data else { throw SetRecordError.invalidData }
//        let staticDataBytes = staticData.makeBytes()
//        let staticDataLengths: [Int] = [
//            Int(SolidityType.uint64.decodeLength!),
//            Int(SolidityType.address.decodeLength!),
//            Int(SolidityType.uint256.decodeLength!)
//        ]
//        
//        var bytesOffset = 0
//        let chainIdData = Array(staticDataBytes[bytesOffset..<staticDataLengths[0]])
//        bytesOffset += chainIdData.count
//        let tokenAddressData = Array(staticDataBytes[bytesOffset..<(bytesOffset+staticDataLengths[1])])
//        bytesOffset += tokenAddressData.count
//        let tokenIdData = Array(staticDataBytes[bytesOffset...])
//        
//        guard let chainId = try ProtocolParser.decodeStaticField(abiType: SolidityType.uint64, data: chainIdData) as? UInt64 else { throw SetRecordError.invalidNativeValue }
//        guard let tokenAddress = try ProtocolParser.decodeStaticField(abiType: SolidityType.address, data: tokenAddressData) as? EthereumAddress else { throw SetRecordError.invalidNativeValue }
//        guard let tokenId = try ProtocolParser.decodeStaticField(abiType: SolidityType.uint256, data: tokenIdData) as? BigUInt else { throw SetRecordError.invalidNativeValue }
//
//        let digest: Array<UInt8> = Array(table.namespace!.world!.uniqueKey.hexToBytes() + table.namespace!.namespaceId.hexToBytes() + table.tableName.makeBytes() + key.makeBytes())
//        let uniqueKey = SHA3(variant: .keccak256).calculate(for: digest).toHexString()
//        
//        let latestValue = FetchDescriptor<NFTCom>(
//            predicate: #Predicate { $0.uniqueKey == uniqueKey }
//        )
//        let results = try modelContext.fetch(latestValue)
//        let latestBlockNumber = results.first?.lastUpdatedAtBlock
//        
//        if let existingRecord = results.first {
//            existingRecord.chainId = chainId
//            existingRecord.tokenAddress = tokenAddress.hex(eip55: true)
//            existingRecord.tokenId = Data(tokenId.makeBytes())
//            existingRecord.lastUpdatedAtBlock = UInt(blockNumber.quantity)
//        } else if latestBlockNumber == nil || latestBlockNumber! < blockNumber.quantity {
//            let record = NFTCom(
//                uniqueKey: uniqueKey,
//                lastUpdatedAtBlock: UInt(blockNumber.quantity),
//                key: key,
//                chainId: chainId,
//                tokenAddress: tokenAddress,
//                tokenId: tokenId
//            )
//            record.table = table
//            modelContext.insert(record)
//        }
//    }
//    
//    static func spliceStaticData(modelContext: ModelContext, table: Table, values: [String : Any], blockNumber: EthereumQuantity) throws {
//
//    }
//    
//    static func spliceDynamicData(modelContext: ModelContext, table: Table, values: [String : Any], blockNumber: EthereumQuantity) throws {
//
//    }
//    
//    static func deleteRecord(modelContext: ModelContext, table: Table, values: [String : Any], blockNumber: EthereumQuantity) throws {
//        guard let keys = values["keyTuple"] as? [Data] else { throw SetRecordError.invalidData }
//        guard let key = try ProtocolParser.decodeStaticField(abiType: SolidityType.bytes(length: 32), data: keys[0].makeBytes()) as? Data else { throw SetRecordError.invalidNativeValue }
//
//        let digest: Array<UInt8> = Array(table.namespace!.world!.uniqueKey.hexToBytes() + table.namespace!.namespaceId.hexToBytes() + table.tableName.makeBytes() + key.makeBytes())
//        let uniqueKey = SHA3(variant: .keccak256).calculate(for: digest).toHexString()
//        
//        let latestValue = FetchDescriptor<NFTCom>(
//            predicate: #Predicate { $0.uniqueKey == uniqueKey }
//        )
//        let results = try modelContext.fetch(latestValue)
//        let latestBlockNumber = results.first?.lastUpdatedAtBlock
//        
//        if let existingRecord = results.first, (latestBlockNumber == nil || latestBlockNumber! < blockNumber.quantity) {
//            modelContext.delete(existingRecord)
//        }
//    }
//    
//    func fetchNFTMetadata() async {
//        let headers = ["accept": "application/json"]
//
//        let request = NSMutableURLRequest(url: NSURL(string: "https://eth-mainnet.g.alchemy.com/nft/v2/\(Bundle.main.infoDictionary!["ALCHEMY_API_KEY"] as! String)/getNFTMetadata?contractAddress=\(tokenAddress)&tokenId=\(BigUInt(tokenId))&refreshCache=false")! as URL,
//                                                cachePolicy: .useProtocolCachePolicy,
//                                            timeoutInterval: 10.0)
//        request.httpMethod = "GET"
//        request.allHTTPHeaderFields = headers
//
//        let session = URLSession.shared
//        do {
//            let (data, _) = try await session.data(for: request as URLRequest)
//            guard let res = try JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
//            guard let media = res["media"] as? [[String: Any]] else { return }
//            guard let gateway = media[0]["gateway"] as? String else { return }
//            
//            let (url, response) = try await session.download(from: URL(string: gateway)!)
//            var tmpUrl = url
//            if let suggestedFilename = response.suggestedFilename {
//                let newUrl = url.deletingLastPathComponent().appending(path: suggestedFilename)
//                
//                // Rename with suggested name
//                try? FileManager.default.moveItem(at: url, to: newUrl)
//                
//                tmpUrl = newUrl
//            }
//            contentUrl = tmpUrl
//        } catch {
//            print(error)
//        }
//    }
//}
