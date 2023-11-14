//
//  AugmentPreviewView.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-10-28.
//

import SwiftUI
import RealityKit
import Combine
import VarInt
import Web3
import SwiftMUD
import SwiftData

struct EthereumSimObject: Codable {
    let logs: [EthereumLogObject]
}

@MainActor
struct AugmentPreviewView: View {
    @Environment(\.web3) var web3: Task<Web3, Error>
    @Environment(\.storeActor) private var storeActor: StoreActor?

    let augmentAddress: EthereumAddress
    
    private var storeSync: Task<StoreSync, Error> {
        Task.init {
            let web3 = try await web3.value
            let store = Store(storeActor: storeActor!)
            store.registerRecordType(tableName: "ImageCom", handler: ImageCom.self)
//            store.registerRecordType(tableName: "NFTCom", handler: NFTCom.self)
            return StoreSync(web3: web3, store: store)
        }
    }
    private let arView: ARView = ARView(frame: .zero)
    private let tableIds: [Data: Component.Type] = [
        Data("PositionCom".makeBytes() + Array(repeating: UInt8(0), count: 3)): PositionCom.self,
        Data("ModelCom".makeBytes() + Array(repeating: UInt8(0), count: 6)): ModelCom.self,
        Data("ImageCom".makeBytes() + Array(repeating: UInt8(0), count: 6)): ImageCom.self
    ]
    
    @State var cancellable: Cancellable? = nil
    @State var inputComponentTypes: [[Component.Type]]? = nil
    @State var overrideLogs: [EthereumLogObject]? = nil

    var body: some View {
        if let overrideLogs, let inputComponentTypes {
            AugmentCameraViewRepresentable(arView: arView, inputComponents: inputComponentTypes)
                .task {
                    Task {
                        do {
                            let storeSync = try await storeSync.value
                            
                            try await Task.sleep(nanoseconds: 4_000_000_000)

                            let chainId = try await storeSync.getChainId()
                            cancellable = arView.scene.subscribe(to: SceneEvents.Update.self) { event in
//                                guard let nftComs = try? context.fetch(FetchDescriptor<NFTCom>()) else { return }
                                Task.detached {
                                    guard let imageComs = try await storeActor?.fetchImageComs() else { return }
                                    
                                    for log in overrideLogs {
                                        await storeSync.handleLog(chainId: chainId, log: log)
                                    }
                                    
                                    //                                for com in nftComs {
                                    //                                    guard let i = UInt(hexString: com.key.toHexString()) else { continue }
                                    //                                    guard let entity = event.scene.findEntity(named: "\(i)") else { continue }
                                    //
                                    //                                    entity.components.set(com)
                                    //
                                    //                                }
                                    
                                    for com in imageComs {
                                        guard let i = UInt(hexString: com.key.toHexString()) else { continue }
                                        guard let entity = await event.scene.findEntity(named: "\(i)") else { continue }
                                        
                                        await entity.components.set(com)
                                    }
                                }
                            }
                        } catch {
                            print(error)
                        }
                    }
                }
                .onDisappear {
                    cancellable?.cancel()
                    arView.session.pause()
                }
        } else {
            Text("Loading...")
                .task {
                    do {
                        let web3 = try await web3.value
                        let worldAddress = try EthereumAddress(hex: "0xd5F989dcbdF610Fa9051a67E2B530B33C437F6E6", eip55: true)
                        let augment = web3.eth.Contract(type: AugmentContract.self, address: augmentAddress)

                        // 1. Get component types
//                        let componentTypes: [[Data]] = try await withCheckedThrowingContinuation { continuation in
//                            augment.getComponentTypes().call { result, error in
//                                if let error {
//                                    return continuation.resume(throwing: error)
//                                }
//                                
//                                guard let componentTypes = result?["componentTypes"] as? [[Data]] else { return }
//                                return continuation.resume(returning: componentTypes)
//                            }
//                        }
                        
//                        inputComponentTypes = componentTypes.map { entity in
//                            return entity.compactMap { component in
//                                return tableIds[component]
//                            }
//                        }
                        
                        inputComponentTypes = [[PositionCom.self]]
                        
                        try await Task.sleep(nanoseconds: 2_000_000_000)
                        
                        // 2. Perform overrides
                        let augmentBytes = try augmentAddress.makeBytes()
                        let req = RPCRequest<[EthereumCall]>(
                            id: web3.properties.rpcId,
                            jsonrpc: Web3.jsonrpc,
                            method: "alchemy_simulateExecution",
                            params: [EthereumCall(
                                from: try EthereumAddress(hex: "0xfF5Be16460704eFd0263dB1444Eaa216b77477c5", eip55: true),
                                to: worldAddress,
                                value: EthereumQuantity(quantity: 0),
                                data: EthereumData(Bytes(hex: "0x529adb38000000000000000000000000") + augmentBytes + Bytes(hex: "33323000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000")))
                            ]
                        )
                        overrideLogs = try await withCheckedThrowingContinuation { continuation in
                            web3.provider.send(request: req) { (resp: Web3Response<EthereumSimObject>) in
                                if let error = resp.error {
                                    return continuation.resume(throwing: error)
                                }
                                return continuation.resume(returning: resp.result!.logs)
                            }
                        }
                    } catch {
                        print(error)
                    }
                }
        }
    }
}
