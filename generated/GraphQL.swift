// This file was auto-generated using maticzav/swift-graphql. DO NOT EDIT MANUALLY!
import Foundation
import GraphQL
import SwiftGraphQL

// MARK: - Operations
public enum Operations {}
extension Objects.Query: GraphQLHttpOperation {
  public static var operation: GraphQLOperationKind { .query }
}
extension Objects.Subscription: GraphQLWebSocketOperation {
  public static var operation: GraphQLOperationKind { .subscription }
}

// MARK: - Objects
public enum Objects {}
extension Objects {
  public struct Bid {}
}

extension Fields where TypeLock == Objects.Bid {

  public func id() throws -> String {
    let field = GraphQLField.leaf(
      field: "id",
      parent: "Bid",
      arguments: []
    )
    self.__select(field)

    switch self.__state {
    case .decoding:
      return try self.__decode(field: field.alias!) { try String(from: $0) }
    case .selecting:
      return String.mockValue
    }
  }

  public func timestamp() throws -> AnyCodable {
    let field = GraphQLField.leaf(
      field: "timestamp",
      parent: "Bid",
      arguments: []
    )
    self.__select(field)

    switch self.__state {
    case .decoding:
      return try self.__decode(field: field.alias!) { try AnyCodable(from: $0) }
    case .selecting:
      return AnyCodable.mockValue
    }
  }

  public func bidder<T>(selection: Selection<T, Objects.Bidder>) throws -> T {
    let field = GraphQLField.composite(
      field: "bidder",
      parent: "Bid",
      type: "Bidder",
      arguments: [],
      selection: selection.__selection()
    )
    self.__select(field)

    switch self.__state {
    case .decoding:
      return try self.__decode(field: field.alias!) { try selection.__decode(data: $0) }
    case .selecting:
      return try selection.__mock()
    }
  }

  public func contributionRate() throws -> AnyCodable {
    let field = GraphQLField.leaf(
      field: "contributionRate",
      parent: "Bid",
      arguments: []
    )
    self.__select(field)

    switch self.__state {
    case .decoding:
      return try self.__decode(field: field.alias!) { try AnyCodable(from: $0) }
    case .selecting:
      return AnyCodable.mockValue
    }
  }

  public func perSecondFeeNumerator() throws -> AnyCodable {
    let field = GraphQLField.leaf(
      field: "perSecondFeeNumerator",
      parent: "Bid",
      arguments: []
    )
    self.__select(field)

    switch self.__state {
    case .decoding:
      return try self.__decode(field: field.alias!) { try AnyCodable(from: $0) }
    case .selecting:
      return AnyCodable.mockValue
    }
  }

  public func perSecondFeeDenominator() throws -> AnyCodable {
    let field = GraphQLField.leaf(
      field: "perSecondFeeDenominator",
      parent: "Bid",
      arguments: []
    )
    self.__select(field)

    switch self.__state {
    case .decoding:
      return try self.__decode(field: field.alias!) { try AnyCodable(from: $0) }
    case .selecting:
      return AnyCodable.mockValue
    }
  }

  public func forSalePrice() throws -> AnyCodable {
    let field = GraphQLField.leaf(
      field: "forSalePrice",
      parent: "Bid",
      arguments: []
    )
    self.__select(field)

    switch self.__state {
    case .decoding:
      return try self.__decode(field: field.alias!) { try AnyCodable(from: $0) }
    case .selecting:
      return AnyCodable.mockValue
    }
  }

  public func parcel<T>(selection: Selection<T, Objects.GeoWebParcel>) throws -> T {
    let field = GraphQLField.composite(
      field: "parcel",
      parent: "Bid",
      type: "GeoWebParcel",
      arguments: [],
      selection: selection.__selection()
    )
    self.__select(field)

    switch self.__state {
    case .decoding:
      return try self.__decode(field: field.alias!) { try selection.__decode(data: $0) }
    case .selecting:
      return try selection.__mock()
    }
  }

  public func contentHash() throws -> AnyCodable? {
    let field = GraphQLField.leaf(
      field: "contentHash",
      parent: "Bid",
      arguments: []
    )
    self.__select(field)

    switch self.__state {
    case .decoding:
      return try self.__decode(field: field.alias!) { try AnyCodable?(from: $0) }
    case .selecting:
      return nil
    }
  }
}
extension Selection where T == Never, TypeLock == Never {
  public typealias Bid<W> = Selection<W, Objects.Bid>
}
extension Objects {
  public struct Bidder {}
}

extension Fields where TypeLock == Objects.Bidder {

  public func id() throws -> String {
    let field = GraphQLField.leaf(
      field: "id",
      parent: "Bidder",
      arguments: []
    )
    self.__select(field)

    switch self.__state {
    case .decoding:
      return try self.__decode(field: field.alias!) { try String(from: $0) }
    case .selecting:
      return String.mockValue
    }
  }

  public func bids<T>(
    skip: OptionalArgument<Int> = .init(), first: OptionalArgument<Int> = .init(),
    orderBy: OptionalArgument<Enums.BidOrderBy> = .init(),
    orderDirection: OptionalArgument<Enums.OrderDirection> = .init(),
    `where`: OptionalArgument<InputObjects.BidFilter> = .init(),
    selection: Selection<T, [Objects.Bid]>
  ) throws -> T {
    let field = GraphQLField.composite(
      field: "bids",
      parent: "Bidder",
      type: "Bid",
      arguments: [
        Argument(name: "skip", type: "Int", value: skip),
        Argument(name: "first", type: "Int", value: first),
        Argument(name: "orderBy", type: "Bid_orderBy", value: orderBy),
        Argument(name: "orderDirection", type: "OrderDirection", value: orderDirection),
        Argument(name: "where", type: "Bid_filter", value: `where`),
      ],
      selection: selection.__selection()
    )
    self.__select(field)

    switch self.__state {
    case .decoding:
      return try self.__decode(field: field.alias!) { try selection.__decode(data: $0) }
    case .selecting:
      return try selection.__mock()
    }
  }
}
extension Selection where T == Never, TypeLock == Never {
  public typealias Bidder<W> = Selection<W, Objects.Bidder>
}
extension Objects {
  public struct GeoWebParcel {}
}

extension Fields where TypeLock == Objects.GeoWebParcel {

  public func id() throws -> String {
    let field = GraphQLField.leaf(
      field: "id",
      parent: "GeoWebParcel",
      arguments: []
    )
    self.__select(field)

    switch self.__state {
    case .decoding:
      return try self.__decode(field: field.alias!) { try String(from: $0) }
    case .selecting:
      return String.mockValue
    }
  }

  public func createdAtBlock() throws -> AnyCodable {
    let field = GraphQLField.leaf(
      field: "createdAtBlock",
      parent: "GeoWebParcel",
      arguments: []
    )
    self.__select(field)

    switch self.__state {
    case .decoding:
      return try self.__decode(field: field.alias!) { try AnyCodable(from: $0) }
    case .selecting:
      return AnyCodable.mockValue
    }
  }

  public func licenseOwner() throws -> AnyCodable? {
    let field = GraphQLField.leaf(
      field: "licenseOwner",
      parent: "GeoWebParcel",
      arguments: []
    )
    self.__select(field)

    switch self.__state {
    case .decoding:
      return try self.__decode(field: field.alias!) { try AnyCodable?(from: $0) }
    case .selecting:
      return nil
    }
  }

  public func currentBid<T>(selection: Selection<T, Objects.Bid?>) throws -> T {
    let field = GraphQLField.composite(
      field: "currentBid",
      parent: "GeoWebParcel",
      type: "Bid",
      arguments: [],
      selection: selection.__selection()
    )
    self.__select(field)

    switch self.__state {
    case .decoding:
      return try self.__decode(field: field.alias!) { try selection.__decode(data: $0) }
    case .selecting:
      return try selection.__mock()
    }
  }

  public func pendingBid<T>(selection: Selection<T, Objects.Bid?>) throws -> T {
    let field = GraphQLField.composite(
      field: "pendingBid",
      parent: "GeoWebParcel",
      type: "Bid",
      arguments: [],
      selection: selection.__selection()
    )
    self.__select(field)

    switch self.__state {
    case .decoding:
      return try self.__decode(field: field.alias!) { try selection.__decode(data: $0) }
    case .selecting:
      return try selection.__mock()
    }
  }

  public func licenseDiamond() throws -> AnyCodable? {
    let field = GraphQLField.leaf(
      field: "licenseDiamond",
      parent: "GeoWebParcel",
      arguments: []
    )
    self.__select(field)

    switch self.__state {
    case .decoding:
      return try self.__decode(field: field.alias!) { try AnyCodable?(from: $0) }
    case .selecting:
      return nil
    }
  }

  public func coordinates() throws -> [AnyCodable]? {
    let field = GraphQLField.leaf(
      field: "coordinates",
      parent: "GeoWebParcel",
      arguments: []
    )
    self.__select(field)

    switch self.__state {
    case .decoding:
      return try self.__decode(field: field.alias!) { try [AnyCodable]?(from: $0) }
    case .selecting:
      return nil
    }
  }

  public func bboxN() throws -> AnyCodable? {
    let field = GraphQLField.leaf(
      field: "bboxN",
      parent: "GeoWebParcel",
      arguments: []
    )
    self.__select(field)

    switch self.__state {
    case .decoding:
      return try self.__decode(field: field.alias!) { try AnyCodable?(from: $0) }
    case .selecting:
      return nil
    }
  }

  public func bboxS() throws -> AnyCodable? {
    let field = GraphQLField.leaf(
      field: "bboxS",
      parent: "GeoWebParcel",
      arguments: []
    )
    self.__select(field)

    switch self.__state {
    case .decoding:
      return try self.__decode(field: field.alias!) { try AnyCodable?(from: $0) }
    case .selecting:
      return nil
    }
  }

  public func bboxE() throws -> AnyCodable? {
    let field = GraphQLField.leaf(
      field: "bboxE",
      parent: "GeoWebParcel",
      arguments: []
    )
    self.__select(field)

    switch self.__state {
    case .decoding:
      return try self.__decode(field: field.alias!) { try AnyCodable?(from: $0) }
    case .selecting:
      return nil
    }
  }

  public func bboxW() throws -> AnyCodable? {
    let field = GraphQLField.leaf(
      field: "bboxW",
      parent: "GeoWebParcel",
      arguments: []
    )
    self.__select(field)

    switch self.__state {
    case .decoding:
      return try self.__decode(field: field.alias!) { try AnyCodable?(from: $0) }
    case .selecting:
      return nil
    }
  }

  public func contentHash() throws -> AnyCodable? {
    let field = GraphQLField.leaf(
      field: "contentHash",
      parent: "GeoWebParcel",
      arguments: []
    )
    self.__select(field)

    switch self.__state {
    case .decoding:
      return try self.__decode(field: field.alias!) { try AnyCodable?(from: $0) }
    case .selecting:
      return nil
    }
  }

  public func tokenUri() throws -> String? {
    let field = GraphQLField.leaf(
      field: "tokenURI",
      parent: "GeoWebParcel",
      arguments: []
    )
    self.__select(field)

    switch self.__state {
    case .decoding:
      return try self.__decode(field: field.alias!) { try String?(from: $0) }
    case .selecting:
      return nil
    }
  }
}
extension Selection where T == Never, TypeLock == Never {
  public typealias GeoWebParcel<W> = Selection<W, Objects.GeoWebParcel>
}
extension Objects {
  public struct Query {}
}

extension Fields where TypeLock == Objects.Query {

  public func bid<T>(
    id: String, block: OptionalArgument<InputObjects.BlockHeight> = .init(),
    subgraphError: Enums.SubgraphErrorPolicy, selection: Selection<T, Objects.Bid?>
  ) throws -> T {
    let field = GraphQLField.composite(
      field: "bid",
      parent: "Query",
      type: "Bid",
      arguments: [
        Argument(name: "id", type: "ID!", value: id),
        Argument(name: "block", type: "Block_height", value: block),
        Argument(name: "subgraphError", type: "_SubgraphErrorPolicy_!", value: subgraphError),
      ],
      selection: selection.__selection()
    )
    self.__select(field)

    switch self.__state {
    case .decoding:
      return try self.__decode(field: field.alias!) { try selection.__decode(data: $0) }
    case .selecting:
      return try selection.__mock()
    }
  }

  public func bids<T>(
    skip: OptionalArgument<Int> = .init(), first: OptionalArgument<Int> = .init(),
    orderBy: OptionalArgument<Enums.BidOrderBy> = .init(),
    orderDirection: OptionalArgument<Enums.OrderDirection> = .init(),
    `where`: OptionalArgument<InputObjects.BidFilter> = .init(),
    block: OptionalArgument<InputObjects.BlockHeight> = .init(),
    subgraphError: Enums.SubgraphErrorPolicy, selection: Selection<T, [Objects.Bid]>
  ) throws -> T {
    let field = GraphQLField.composite(
      field: "bids",
      parent: "Query",
      type: "Bid",
      arguments: [
        Argument(name: "skip", type: "Int", value: skip),
        Argument(name: "first", type: "Int", value: first),
        Argument(name: "orderBy", type: "Bid_orderBy", value: orderBy),
        Argument(name: "orderDirection", type: "OrderDirection", value: orderDirection),
        Argument(name: "where", type: "Bid_filter", value: `where`),
        Argument(name: "block", type: "Block_height", value: block),
        Argument(name: "subgraphError", type: "_SubgraphErrorPolicy_!", value: subgraphError),
      ],
      selection: selection.__selection()
    )
    self.__select(field)

    switch self.__state {
    case .decoding:
      return try self.__decode(field: field.alias!) { try selection.__decode(data: $0) }
    case .selecting:
      return try selection.__mock()
    }
  }

  public func bidder<T>(
    id: String, block: OptionalArgument<InputObjects.BlockHeight> = .init(),
    subgraphError: Enums.SubgraphErrorPolicy, selection: Selection<T, Objects.Bidder?>
  ) throws -> T {
    let field = GraphQLField.composite(
      field: "bidder",
      parent: "Query",
      type: "Bidder",
      arguments: [
        Argument(name: "id", type: "ID!", value: id),
        Argument(name: "block", type: "Block_height", value: block),
        Argument(name: "subgraphError", type: "_SubgraphErrorPolicy_!", value: subgraphError),
      ],
      selection: selection.__selection()
    )
    self.__select(field)

    switch self.__state {
    case .decoding:
      return try self.__decode(field: field.alias!) { try selection.__decode(data: $0) }
    case .selecting:
      return try selection.__mock()
    }
  }

  public func bidders<T>(
    skip: OptionalArgument<Int> = .init(), first: OptionalArgument<Int> = .init(),
    orderBy: OptionalArgument<Enums.BidderOrderBy> = .init(),
    orderDirection: OptionalArgument<Enums.OrderDirection> = .init(),
    `where`: OptionalArgument<InputObjects.BidderFilter> = .init(),
    block: OptionalArgument<InputObjects.BlockHeight> = .init(),
    subgraphError: Enums.SubgraphErrorPolicy, selection: Selection<T, [Objects.Bidder]>
  ) throws -> T {
    let field = GraphQLField.composite(
      field: "bidders",
      parent: "Query",
      type: "Bidder",
      arguments: [
        Argument(name: "skip", type: "Int", value: skip),
        Argument(name: "first", type: "Int", value: first),
        Argument(name: "orderBy", type: "Bidder_orderBy", value: orderBy),
        Argument(name: "orderDirection", type: "OrderDirection", value: orderDirection),
        Argument(name: "where", type: "Bidder_filter", value: `where`),
        Argument(name: "block", type: "Block_height", value: block),
        Argument(name: "subgraphError", type: "_SubgraphErrorPolicy_!", value: subgraphError),
      ],
      selection: selection.__selection()
    )
    self.__select(field)

    switch self.__state {
    case .decoding:
      return try self.__decode(field: field.alias!) { try selection.__decode(data: $0) }
    case .selecting:
      return try selection.__mock()
    }
  }

  public func geoWebParcel<T>(
    id: String, block: OptionalArgument<InputObjects.BlockHeight> = .init(),
    subgraphError: Enums.SubgraphErrorPolicy, selection: Selection<T, Objects.GeoWebParcel?>
  ) throws -> T {
    let field = GraphQLField.composite(
      field: "geoWebParcel",
      parent: "Query",
      type: "GeoWebParcel",
      arguments: [
        Argument(name: "id", type: "ID!", value: id),
        Argument(name: "block", type: "Block_height", value: block),
        Argument(name: "subgraphError", type: "_SubgraphErrorPolicy_!", value: subgraphError),
      ],
      selection: selection.__selection()
    )
    self.__select(field)

    switch self.__state {
    case .decoding:
      return try self.__decode(field: field.alias!) { try selection.__decode(data: $0) }
    case .selecting:
      return try selection.__mock()
    }
  }

  public func geoWebParcels<T>(
    skip: OptionalArgument<Int> = .init(), first: OptionalArgument<Int> = .init(),
    orderBy: OptionalArgument<Enums.GeoWebParcelOrderBy> = .init(),
    orderDirection: OptionalArgument<Enums.OrderDirection> = .init(),
    `where`: OptionalArgument<InputObjects.GeoWebParcelFilter> = .init(),
    block: OptionalArgument<InputObjects.BlockHeight> = .init(),
    subgraphError: Enums.SubgraphErrorPolicy, selection: Selection<T, [Objects.GeoWebParcel]>
  ) throws -> T {
    let field = GraphQLField.composite(
      field: "geoWebParcels",
      parent: "Query",
      type: "GeoWebParcel",
      arguments: [
        Argument(name: "skip", type: "Int", value: skip),
        Argument(name: "first", type: "Int", value: first),
        Argument(name: "orderBy", type: "GeoWebParcel_orderBy", value: orderBy),
        Argument(name: "orderDirection", type: "OrderDirection", value: orderDirection),
        Argument(name: "where", type: "GeoWebParcel_filter", value: `where`),
        Argument(name: "block", type: "Block_height", value: block),
        Argument(name: "subgraphError", type: "_SubgraphErrorPolicy_!", value: subgraphError),
      ],
      selection: selection.__selection()
    )
    self.__select(field)

    switch self.__state {
    case .decoding:
      return try self.__decode(field: field.alias!) { try selection.__decode(data: $0) }
    case .selecting:
      return try selection.__mock()
    }
  }
  /// Access to subgraph metadata

  public func _meta<T>(
    block: OptionalArgument<InputObjects.BlockHeight> = .init(),
    selection: Selection<T, Objects.Meta?>
  ) throws -> T {
    let field = GraphQLField.composite(
      field: "_meta",
      parent: "Query",
      type: "_Meta_",
      arguments: [Argument(name: "block", type: "Block_height", value: block)],
      selection: selection.__selection()
    )
    self.__select(field)

    switch self.__state {
    case .decoding:
      return try self.__decode(field: field.alias!) { try selection.__decode(data: $0) }
    case .selecting:
      return try selection.__mock()
    }
  }
}
extension Selection where T == Never, TypeLock == Never {
  public typealias Query<W> = Selection<W, Objects.Query>
}
extension Objects {
  public struct Subscription {}
}

extension Fields where TypeLock == Objects.Subscription {

  public func bid<T>(
    id: String, block: OptionalArgument<InputObjects.BlockHeight> = .init(),
    subgraphError: Enums.SubgraphErrorPolicy, selection: Selection<T, Objects.Bid?>
  ) throws -> T {
    let field = GraphQLField.composite(
      field: "bid",
      parent: "Subscription",
      type: "Bid",
      arguments: [
        Argument(name: "id", type: "ID!", value: id),
        Argument(name: "block", type: "Block_height", value: block),
        Argument(name: "subgraphError", type: "_SubgraphErrorPolicy_!", value: subgraphError),
      ],
      selection: selection.__selection()
    )
    self.__select(field)

    switch self.__state {
    case .decoding:
      return try self.__decode(field: field.alias!) { try selection.__decode(data: $0) }
    case .selecting:
      return try selection.__mock()
    }
  }

  public func bids<T>(
    skip: OptionalArgument<Int> = .init(), first: OptionalArgument<Int> = .init(),
    orderBy: OptionalArgument<Enums.BidOrderBy> = .init(),
    orderDirection: OptionalArgument<Enums.OrderDirection> = .init(),
    `where`: OptionalArgument<InputObjects.BidFilter> = .init(),
    block: OptionalArgument<InputObjects.BlockHeight> = .init(),
    subgraphError: Enums.SubgraphErrorPolicy, selection: Selection<T, [Objects.Bid]>
  ) throws -> T {
    let field = GraphQLField.composite(
      field: "bids",
      parent: "Subscription",
      type: "Bid",
      arguments: [
        Argument(name: "skip", type: "Int", value: skip),
        Argument(name: "first", type: "Int", value: first),
        Argument(name: "orderBy", type: "Bid_orderBy", value: orderBy),
        Argument(name: "orderDirection", type: "OrderDirection", value: orderDirection),
        Argument(name: "where", type: "Bid_filter", value: `where`),
        Argument(name: "block", type: "Block_height", value: block),
        Argument(name: "subgraphError", type: "_SubgraphErrorPolicy_!", value: subgraphError),
      ],
      selection: selection.__selection()
    )
    self.__select(field)

    switch self.__state {
    case .decoding:
      return try self.__decode(field: field.alias!) { try selection.__decode(data: $0) }
    case .selecting:
      return try selection.__mock()
    }
  }

  public func bidder<T>(
    id: String, block: OptionalArgument<InputObjects.BlockHeight> = .init(),
    subgraphError: Enums.SubgraphErrorPolicy, selection: Selection<T, Objects.Bidder?>
  ) throws -> T {
    let field = GraphQLField.composite(
      field: "bidder",
      parent: "Subscription",
      type: "Bidder",
      arguments: [
        Argument(name: "id", type: "ID!", value: id),
        Argument(name: "block", type: "Block_height", value: block),
        Argument(name: "subgraphError", type: "_SubgraphErrorPolicy_!", value: subgraphError),
      ],
      selection: selection.__selection()
    )
    self.__select(field)

    switch self.__state {
    case .decoding:
      return try self.__decode(field: field.alias!) { try selection.__decode(data: $0) }
    case .selecting:
      return try selection.__mock()
    }
  }

  public func bidders<T>(
    skip: OptionalArgument<Int> = .init(), first: OptionalArgument<Int> = .init(),
    orderBy: OptionalArgument<Enums.BidderOrderBy> = .init(),
    orderDirection: OptionalArgument<Enums.OrderDirection> = .init(),
    `where`: OptionalArgument<InputObjects.BidderFilter> = .init(),
    block: OptionalArgument<InputObjects.BlockHeight> = .init(),
    subgraphError: Enums.SubgraphErrorPolicy, selection: Selection<T, [Objects.Bidder]>
  ) throws -> T {
    let field = GraphQLField.composite(
      field: "bidders",
      parent: "Subscription",
      type: "Bidder",
      arguments: [
        Argument(name: "skip", type: "Int", value: skip),
        Argument(name: "first", type: "Int", value: first),
        Argument(name: "orderBy", type: "Bidder_orderBy", value: orderBy),
        Argument(name: "orderDirection", type: "OrderDirection", value: orderDirection),
        Argument(name: "where", type: "Bidder_filter", value: `where`),
        Argument(name: "block", type: "Block_height", value: block),
        Argument(name: "subgraphError", type: "_SubgraphErrorPolicy_!", value: subgraphError),
      ],
      selection: selection.__selection()
    )
    self.__select(field)

    switch self.__state {
    case .decoding:
      return try self.__decode(field: field.alias!) { try selection.__decode(data: $0) }
    case .selecting:
      return try selection.__mock()
    }
  }

  public func geoWebParcel<T>(
    id: String, block: OptionalArgument<InputObjects.BlockHeight> = .init(),
    subgraphError: Enums.SubgraphErrorPolicy, selection: Selection<T, Objects.GeoWebParcel?>
  ) throws -> T {
    let field = GraphQLField.composite(
      field: "geoWebParcel",
      parent: "Subscription",
      type: "GeoWebParcel",
      arguments: [
        Argument(name: "id", type: "ID!", value: id),
        Argument(name: "block", type: "Block_height", value: block),
        Argument(name: "subgraphError", type: "_SubgraphErrorPolicy_!", value: subgraphError),
      ],
      selection: selection.__selection()
    )
    self.__select(field)

    switch self.__state {
    case .decoding:
      return try self.__decode(field: field.alias!) { try selection.__decode(data: $0) }
    case .selecting:
      return try selection.__mock()
    }
  }

  public func geoWebParcels<T>(
    skip: OptionalArgument<Int> = .init(), first: OptionalArgument<Int> = .init(),
    orderBy: OptionalArgument<Enums.GeoWebParcelOrderBy> = .init(),
    orderDirection: OptionalArgument<Enums.OrderDirection> = .init(),
    `where`: OptionalArgument<InputObjects.GeoWebParcelFilter> = .init(),
    block: OptionalArgument<InputObjects.BlockHeight> = .init(),
    subgraphError: Enums.SubgraphErrorPolicy, selection: Selection<T, [Objects.GeoWebParcel]>
  ) throws -> T {
    let field = GraphQLField.composite(
      field: "geoWebParcels",
      parent: "Subscription",
      type: "GeoWebParcel",
      arguments: [
        Argument(name: "skip", type: "Int", value: skip),
        Argument(name: "first", type: "Int", value: first),
        Argument(name: "orderBy", type: "GeoWebParcel_orderBy", value: orderBy),
        Argument(name: "orderDirection", type: "OrderDirection", value: orderDirection),
        Argument(name: "where", type: "GeoWebParcel_filter", value: `where`),
        Argument(name: "block", type: "Block_height", value: block),
        Argument(name: "subgraphError", type: "_SubgraphErrorPolicy_!", value: subgraphError),
      ],
      selection: selection.__selection()
    )
    self.__select(field)

    switch self.__state {
    case .decoding:
      return try self.__decode(field: field.alias!) { try selection.__decode(data: $0) }
    case .selecting:
      return try selection.__mock()
    }
  }
  /// Access to subgraph metadata

  public func _meta<T>(
    block: OptionalArgument<InputObjects.BlockHeight> = .init(),
    selection: Selection<T, Objects.Meta?>
  ) throws -> T {
    let field = GraphQLField.composite(
      field: "_meta",
      parent: "Subscription",
      type: "_Meta_",
      arguments: [Argument(name: "block", type: "Block_height", value: block)],
      selection: selection.__selection()
    )
    self.__select(field)

    switch self.__state {
    case .decoding:
      return try self.__decode(field: field.alias!) { try selection.__decode(data: $0) }
    case .selecting:
      return try selection.__mock()
    }
  }
}

extension Objects {
  public struct Block {}
}

extension Fields where TypeLock == Objects.Block {
  /// The hash of the block

  public func hash() throws -> AnyCodable? {
    let field = GraphQLField.leaf(
      field: "hash",
      parent: "_Block_",
      arguments: []
    )
    self.__select(field)

    switch self.__state {
    case .decoding:
      return try self.__decode(field: field.alias!) { try AnyCodable?(from: $0) }
    case .selecting:
      return nil
    }
  }
  /// The block number

  public func number() throws -> Int {
    let field = GraphQLField.leaf(
      field: "number",
      parent: "_Block_",
      arguments: []
    )
    self.__select(field)

    switch self.__state {
    case .decoding:
      return try self.__decode(field: field.alias!) { try Int(from: $0) }
    case .selecting:
      return Int.mockValue
    }
  }
  /// Integer representation of the timestamp stored in blocks for the chain

  public func timestamp() throws -> Int? {
    let field = GraphQLField.leaf(
      field: "timestamp",
      parent: "_Block_",
      arguments: []
    )
    self.__select(field)

    switch self.__state {
    case .decoding:
      return try self.__decode(field: field.alias!) { try Int?(from: $0) }
    case .selecting:
      return nil
    }
  }
}
extension Selection where T == Never, TypeLock == Never {
  public typealias Block<W> = Selection<W, Objects.Block>
}
extension Objects {
  public struct Meta {}
}

extension Fields where TypeLock == Objects.Meta {
  /// Information about a specific subgraph block. The hash of the block
  /// will be null if the _meta field has a block constraint that asks for
  /// a block number. It will be filled if the _meta field has no block constraint
  /// and therefore asks for the latest  block

  public func block<T>(selection: Selection<T, Objects.Block>) throws -> T {
    let field = GraphQLField.composite(
      field: "block",
      parent: "_Meta_",
      type: "_Block_",
      arguments: [],
      selection: selection.__selection()
    )
    self.__select(field)

    switch self.__state {
    case .decoding:
      return try self.__decode(field: field.alias!) { try selection.__decode(data: $0) }
    case .selecting:
      return try selection.__mock()
    }
  }
  /// The deployment ID

  public func deployment() throws -> String {
    let field = GraphQLField.leaf(
      field: "deployment",
      parent: "_Meta_",
      arguments: []
    )
    self.__select(field)

    switch self.__state {
    case .decoding:
      return try self.__decode(field: field.alias!) { try String(from: $0) }
    case .selecting:
      return String.mockValue
    }
  }
  /// If `true`, the subgraph encountered indexing errors at some past block

  public func hasIndexingErrors() throws -> Bool {
    let field = GraphQLField.leaf(
      field: "hasIndexingErrors",
      parent: "_Meta_",
      arguments: []
    )
    self.__select(field)

    switch self.__state {
    case .decoding:
      return try self.__decode(field: field.alias!) { try Bool(from: $0) }
    case .selecting:
      return Bool.mockValue
    }
  }
}
extension Selection where T == Never, TypeLock == Never {
  public typealias Meta<W> = Selection<W, Objects.Meta>
}
extension Objects.Bid {

  public static func id() -> Selection<String, Objects.Bid> {
    Selection<String, Objects.Bid> {
      try $0.id()
    }
  }

  public static func timestamp() -> Selection<AnyCodable, Objects.Bid> {
    Selection<AnyCodable, Objects.Bid> {
      try $0.timestamp()
    }
  }

  public static func bidder<T>(selection: Selection<T, Objects.Bidder>) -> Selection<T, Objects.Bid>
  {
    Selection<T, Objects.Bid> {
      try $0.bidder(selection: selection)
    }
  }

  public static func contributionRate() -> Selection<AnyCodable, Objects.Bid> {
    Selection<AnyCodable, Objects.Bid> {
      try $0.contributionRate()
    }
  }

  public static func perSecondFeeNumerator() -> Selection<AnyCodable, Objects.Bid> {
    Selection<AnyCodable, Objects.Bid> {
      try $0.perSecondFeeNumerator()
    }
  }

  public static func perSecondFeeDenominator() -> Selection<AnyCodable, Objects.Bid> {
    Selection<AnyCodable, Objects.Bid> {
      try $0.perSecondFeeDenominator()
    }
  }

  public static func forSalePrice() -> Selection<AnyCodable, Objects.Bid> {
    Selection<AnyCodable, Objects.Bid> {
      try $0.forSalePrice()
    }
  }

  public static func parcel<T>(selection: Selection<T, Objects.GeoWebParcel>) -> Selection<
    T, Objects.Bid
  > {
    Selection<T, Objects.Bid> {
      try $0.parcel(selection: selection)
    }
  }

  public static func contentHash() -> Selection<AnyCodable?, Objects.Bid> {
    Selection<AnyCodable?, Objects.Bid> {
      try $0.contentHash()
    }
  }
}
extension Objects.Bidder {

  public static func id() -> Selection<String, Objects.Bidder> {
    Selection<String, Objects.Bidder> {
      try $0.id()
    }
  }

  public static func bids<T>(
    skip: OptionalArgument<Int> = .init(), first: OptionalArgument<Int> = .init(),
    orderBy: OptionalArgument<Enums.BidOrderBy> = .init(),
    orderDirection: OptionalArgument<Enums.OrderDirection> = .init(),
    `where`: OptionalArgument<InputObjects.BidFilter> = .init(),
    selection: Selection<T, [Objects.Bid]>
  ) -> Selection<T, Objects.Bidder> {
    Selection<T, Objects.Bidder> {
      try $0.bids(
        skip: skip, first: first, orderBy: orderBy, orderDirection: orderDirection, where: `where`,
        selection: selection)
    }
  }
}
extension Objects.GeoWebParcel {

  public static func id() -> Selection<String, Objects.GeoWebParcel> {
    Selection<String, Objects.GeoWebParcel> {
      try $0.id()
    }
  }

  public static func createdAtBlock() -> Selection<AnyCodable, Objects.GeoWebParcel> {
    Selection<AnyCodable, Objects.GeoWebParcel> {
      try $0.createdAtBlock()
    }
  }

  public static func licenseOwner() -> Selection<AnyCodable?, Objects.GeoWebParcel> {
    Selection<AnyCodable?, Objects.GeoWebParcel> {
      try $0.licenseOwner()
    }
  }

  public static func currentBid<T>(selection: Selection<T, Objects.Bid?>) -> Selection<
    T, Objects.GeoWebParcel
  > {
    Selection<T, Objects.GeoWebParcel> {
      try $0.currentBid(selection: selection)
    }
  }

  public static func pendingBid<T>(selection: Selection<T, Objects.Bid?>) -> Selection<
    T, Objects.GeoWebParcel
  > {
    Selection<T, Objects.GeoWebParcel> {
      try $0.pendingBid(selection: selection)
    }
  }

  public static func licenseDiamond() -> Selection<AnyCodable?, Objects.GeoWebParcel> {
    Selection<AnyCodable?, Objects.GeoWebParcel> {
      try $0.licenseDiamond()
    }
  }

  public static func coordinates() -> Selection<[AnyCodable]?, Objects.GeoWebParcel> {
    Selection<[AnyCodable]?, Objects.GeoWebParcel> {
      try $0.coordinates()
    }
  }

  public static func bboxN() -> Selection<AnyCodable?, Objects.GeoWebParcel> {
    Selection<AnyCodable?, Objects.GeoWebParcel> {
      try $0.bboxN()
    }
  }

  public static func bboxS() -> Selection<AnyCodable?, Objects.GeoWebParcel> {
    Selection<AnyCodable?, Objects.GeoWebParcel> {
      try $0.bboxS()
    }
  }

  public static func bboxE() -> Selection<AnyCodable?, Objects.GeoWebParcel> {
    Selection<AnyCodable?, Objects.GeoWebParcel> {
      try $0.bboxE()
    }
  }

  public static func bboxW() -> Selection<AnyCodable?, Objects.GeoWebParcel> {
    Selection<AnyCodable?, Objects.GeoWebParcel> {
      try $0.bboxW()
    }
  }

  public static func contentHash() -> Selection<AnyCodable?, Objects.GeoWebParcel> {
    Selection<AnyCodable?, Objects.GeoWebParcel> {
      try $0.contentHash()
    }
  }

  public static func tokenUri() -> Selection<String?, Objects.GeoWebParcel> {
    Selection<String?, Objects.GeoWebParcel> {
      try $0.tokenUri()
    }
  }
}
extension Objects.Query {

  public static func bid<T>(
    id: String, block: OptionalArgument<InputObjects.BlockHeight> = .init(),
    subgraphError: Enums.SubgraphErrorPolicy, selection: Selection<T, Objects.Bid?>
  ) -> Selection<T, Objects.Query> {
    Selection<T, Objects.Query> {
      try $0.bid(id: id, block: block, subgraphError: subgraphError, selection: selection)
    }
  }

  public static func bids<T>(
    skip: OptionalArgument<Int> = .init(), first: OptionalArgument<Int> = .init(),
    orderBy: OptionalArgument<Enums.BidOrderBy> = .init(),
    orderDirection: OptionalArgument<Enums.OrderDirection> = .init(),
    `where`: OptionalArgument<InputObjects.BidFilter> = .init(),
    block: OptionalArgument<InputObjects.BlockHeight> = .init(),
    subgraphError: Enums.SubgraphErrorPolicy, selection: Selection<T, [Objects.Bid]>
  ) -> Selection<T, Objects.Query> {
    Selection<T, Objects.Query> {
      try $0.bids(
        skip: skip, first: first, orderBy: orderBy, orderDirection: orderDirection, where: `where`,
        block: block, subgraphError: subgraphError, selection: selection)
    }
  }

  public static func bidder<T>(
    id: String, block: OptionalArgument<InputObjects.BlockHeight> = .init(),
    subgraphError: Enums.SubgraphErrorPolicy, selection: Selection<T, Objects.Bidder?>
  ) -> Selection<T, Objects.Query> {
    Selection<T, Objects.Query> {
      try $0.bidder(id: id, block: block, subgraphError: subgraphError, selection: selection)
    }
  }

  public static func bidders<T>(
    skip: OptionalArgument<Int> = .init(), first: OptionalArgument<Int> = .init(),
    orderBy: OptionalArgument<Enums.BidderOrderBy> = .init(),
    orderDirection: OptionalArgument<Enums.OrderDirection> = .init(),
    `where`: OptionalArgument<InputObjects.BidderFilter> = .init(),
    block: OptionalArgument<InputObjects.BlockHeight> = .init(),
    subgraphError: Enums.SubgraphErrorPolicy, selection: Selection<T, [Objects.Bidder]>
  ) -> Selection<T, Objects.Query> {
    Selection<T, Objects.Query> {
      try $0.bidders(
        skip: skip, first: first, orderBy: orderBy, orderDirection: orderDirection, where: `where`,
        block: block, subgraphError: subgraphError, selection: selection)
    }
  }

  public static func geoWebParcel<T>(
    id: String, block: OptionalArgument<InputObjects.BlockHeight> = .init(),
    subgraphError: Enums.SubgraphErrorPolicy, selection: Selection<T, Objects.GeoWebParcel?>
  ) -> Selection<T, Objects.Query> {
    Selection<T, Objects.Query> {
      try $0.geoWebParcel(id: id, block: block, subgraphError: subgraphError, selection: selection)
    }
  }

  public static func geoWebParcels<T>(
    skip: OptionalArgument<Int> = .init(), first: OptionalArgument<Int> = .init(),
    orderBy: OptionalArgument<Enums.GeoWebParcelOrderBy> = .init(),
    orderDirection: OptionalArgument<Enums.OrderDirection> = .init(),
    `where`: OptionalArgument<InputObjects.GeoWebParcelFilter> = .init(),
    block: OptionalArgument<InputObjects.BlockHeight> = .init(),
    subgraphError: Enums.SubgraphErrorPolicy, selection: Selection<T, [Objects.GeoWebParcel]>
  ) -> Selection<T, Objects.Query> {
    Selection<T, Objects.Query> {
      try $0.geoWebParcels(
        skip: skip, first: first, orderBy: orderBy, orderDirection: orderDirection, where: `where`,
        block: block, subgraphError: subgraphError, selection: selection)
    }
  }
  /// Access to subgraph metadata

  public static func _meta<T>(
    block: OptionalArgument<InputObjects.BlockHeight> = .init(),
    selection: Selection<T, Objects.Meta?>
  ) -> Selection<T, Objects.Query> {
    Selection<T, Objects.Query> {
      try $0._meta(block: block, selection: selection)
    }
  }
}
extension Objects.Subscription {

  public static func bid<T>(
    id: String, block: OptionalArgument<InputObjects.BlockHeight> = .init(),
    subgraphError: Enums.SubgraphErrorPolicy, selection: Selection<T, Objects.Bid?>
  ) -> Selection<T, Objects.Subscription> {
    Selection<T, Objects.Subscription> {
      try $0.bid(id: id, block: block, subgraphError: subgraphError, selection: selection)
    }
  }

  public static func bids<T>(
    skip: OptionalArgument<Int> = .init(), first: OptionalArgument<Int> = .init(),
    orderBy: OptionalArgument<Enums.BidOrderBy> = .init(),
    orderDirection: OptionalArgument<Enums.OrderDirection> = .init(),
    `where`: OptionalArgument<InputObjects.BidFilter> = .init(),
    block: OptionalArgument<InputObjects.BlockHeight> = .init(),
    subgraphError: Enums.SubgraphErrorPolicy, selection: Selection<T, [Objects.Bid]>
  ) -> Selection<T, Objects.Subscription> {
    Selection<T, Objects.Subscription> {
      try $0.bids(
        skip: skip, first: first, orderBy: orderBy, orderDirection: orderDirection, where: `where`,
        block: block, subgraphError: subgraphError, selection: selection)
    }
  }

  public static func bidder<T>(
    id: String, block: OptionalArgument<InputObjects.BlockHeight> = .init(),
    subgraphError: Enums.SubgraphErrorPolicy, selection: Selection<T, Objects.Bidder?>
  ) -> Selection<T, Objects.Subscription> {
    Selection<T, Objects.Subscription> {
      try $0.bidder(id: id, block: block, subgraphError: subgraphError, selection: selection)
    }
  }

  public static func bidders<T>(
    skip: OptionalArgument<Int> = .init(), first: OptionalArgument<Int> = .init(),
    orderBy: OptionalArgument<Enums.BidderOrderBy> = .init(),
    orderDirection: OptionalArgument<Enums.OrderDirection> = .init(),
    `where`: OptionalArgument<InputObjects.BidderFilter> = .init(),
    block: OptionalArgument<InputObjects.BlockHeight> = .init(),
    subgraphError: Enums.SubgraphErrorPolicy, selection: Selection<T, [Objects.Bidder]>
  ) -> Selection<T, Objects.Subscription> {
    Selection<T, Objects.Subscription> {
      try $0.bidders(
        skip: skip, first: first, orderBy: orderBy, orderDirection: orderDirection, where: `where`,
        block: block, subgraphError: subgraphError, selection: selection)
    }
  }

  public static func geoWebParcel<T>(
    id: String, block: OptionalArgument<InputObjects.BlockHeight> = .init(),
    subgraphError: Enums.SubgraphErrorPolicy, selection: Selection<T, Objects.GeoWebParcel?>
  ) -> Selection<T, Objects.Subscription> {
    Selection<T, Objects.Subscription> {
      try $0.geoWebParcel(id: id, block: block, subgraphError: subgraphError, selection: selection)
    }
  }

  public static func geoWebParcels<T>(
    skip: OptionalArgument<Int> = .init(), first: OptionalArgument<Int> = .init(),
    orderBy: OptionalArgument<Enums.GeoWebParcelOrderBy> = .init(),
    orderDirection: OptionalArgument<Enums.OrderDirection> = .init(),
    `where`: OptionalArgument<InputObjects.GeoWebParcelFilter> = .init(),
    block: OptionalArgument<InputObjects.BlockHeight> = .init(),
    subgraphError: Enums.SubgraphErrorPolicy, selection: Selection<T, [Objects.GeoWebParcel]>
  ) -> Selection<T, Objects.Subscription> {
    Selection<T, Objects.Subscription> {
      try $0.geoWebParcels(
        skip: skip, first: first, orderBy: orderBy, orderDirection: orderDirection, where: `where`,
        block: block, subgraphError: subgraphError, selection: selection)
    }
  }
  /// Access to subgraph metadata

  public static func _meta<T>(
    block: OptionalArgument<InputObjects.BlockHeight> = .init(),
    selection: Selection<T, Objects.Meta?>
  ) -> Selection<T, Objects.Subscription> {
    Selection<T, Objects.Subscription> {
      try $0._meta(block: block, selection: selection)
    }
  }
}
extension Objects.Block {
  /// The hash of the block

  public static func hash() -> Selection<AnyCodable?, Objects.Block> {
    Selection<AnyCodable?, Objects.Block> {
      try $0.hash()
    }
  }
  /// The block number

  public static func number() -> Selection<Int, Objects.Block> {
    Selection<Int, Objects.Block> {
      try $0.number()
    }
  }
  /// Integer representation of the timestamp stored in blocks for the chain

  public static func timestamp() -> Selection<Int?, Objects.Block> {
    Selection<Int?, Objects.Block> {
      try $0.timestamp()
    }
  }
}
extension Objects.Meta {
  /// Information about a specific subgraph block. The hash of the block
  /// will be null if the _meta field has a block constraint that asks for
  /// a block number. It will be filled if the _meta field has no block constraint
  /// and therefore asks for the latest  block

  public static func block<T>(selection: Selection<T, Objects.Block>) -> Selection<T, Objects.Meta>
  {
    Selection<T, Objects.Meta> {
      try $0.block(selection: selection)
    }
  }
  /// The deployment ID

  public static func deployment() -> Selection<String, Objects.Meta> {
    Selection<String, Objects.Meta> {
      try $0.deployment()
    }
  }
  /// If `true`, the subgraph encountered indexing errors at some past block

  public static func hasIndexingErrors() -> Selection<Bool, Objects.Meta> {
    Selection<Bool, Objects.Meta> {
      try $0.hasIndexingErrors()
    }
  }
}

// MARK: - Interfaces
public enum Interfaces {}

// MARK: - Unions
public enum Unions {}

// MARK: - Enums
public enum Enums {}
extension Enums {
  /// Bid_orderBy
  public enum BidOrderBy: String, CaseIterable, Codable {

    case id = "id"

    case timestamp = "timestamp"

    case bidder = "bidder"

    case bidderId = "bidder__id"

    case contributionRate = "contributionRate"

    case perSecondFeeNumerator = "perSecondFeeNumerator"

    case perSecondFeeDenominator = "perSecondFeeDenominator"

    case forSalePrice = "forSalePrice"

    case parcel = "parcel"

    case parcelId = "parcel__id"

    case parcelCreatedAtBlock = "parcel__createdAtBlock"

    case parcelLicenseOwner = "parcel__licenseOwner"

    case parcelLicenseDiamond = "parcel__licenseDiamond"

    case parcelBboxN = "parcel__bboxN"

    case parcelBboxS = "parcel__bboxS"

    case parcelBboxE = "parcel__bboxE"

    case parcelBboxW = "parcel__bboxW"

    case parcelContentHash = "parcel__contentHash"

    case parcelTokenUri = "parcel__tokenURI"

    case contentHash = "contentHash"
  }
}

extension Enums.BidOrderBy: GraphQLScalar {
  public init(from data: AnyCodable) throws {
    switch data.value {
    case let string as String:
      if let value = Enums.BidOrderBy(rawValue: string) {
        self = value
      } else {
        throw ScalarDecodingError.unknownEnumCase(value: string)
      }
    default:
      throw ScalarDecodingError.unexpectedScalarType(
        expected: "Bid_orderBy",
        received: data.value
      )
    }
  }

  public static var mockValue = Self.id
}
extension Enums {
  /// Bidder_orderBy
  public enum BidderOrderBy: String, CaseIterable, Codable {

    case id = "id"

    case bids = "bids"
  }
}

extension Enums.BidderOrderBy: GraphQLScalar {
  public init(from data: AnyCodable) throws {
    switch data.value {
    case let string as String:
      if let value = Enums.BidderOrderBy(rawValue: string) {
        self = value
      } else {
        throw ScalarDecodingError.unknownEnumCase(value: string)
      }
    default:
      throw ScalarDecodingError.unexpectedScalarType(
        expected: "Bidder_orderBy",
        received: data.value
      )
    }
  }

  public static var mockValue = Self.id
}
extension Enums {
  /// GeoWebParcel_orderBy
  public enum GeoWebParcelOrderBy: String, CaseIterable, Codable {

    case id = "id"

    case createdAtBlock = "createdAtBlock"

    case licenseOwner = "licenseOwner"

    case currentBid = "currentBid"

    case currentBidId = "currentBid__id"

    case currentBidTimestamp = "currentBid__timestamp"

    case currentBidContributionRate = "currentBid__contributionRate"

    case currentBidPerSecondFeeNumerator = "currentBid__perSecondFeeNumerator"

    case currentBidPerSecondFeeDenominator = "currentBid__perSecondFeeDenominator"

    case currentBidForSalePrice = "currentBid__forSalePrice"

    case currentBidContentHash = "currentBid__contentHash"

    case pendingBid = "pendingBid"

    case pendingBidId = "pendingBid__id"

    case pendingBidTimestamp = "pendingBid__timestamp"

    case pendingBidContributionRate = "pendingBid__contributionRate"

    case pendingBidPerSecondFeeNumerator = "pendingBid__perSecondFeeNumerator"

    case pendingBidPerSecondFeeDenominator = "pendingBid__perSecondFeeDenominator"

    case pendingBidForSalePrice = "pendingBid__forSalePrice"

    case pendingBidContentHash = "pendingBid__contentHash"

    case licenseDiamond = "licenseDiamond"

    case coordinates = "coordinates"

    case bboxN = "bboxN"

    case bboxS = "bboxS"

    case bboxE = "bboxE"

    case bboxW = "bboxW"

    case contentHash = "contentHash"

    case tokenUri = "tokenURI"
  }
}

extension Enums.GeoWebParcelOrderBy: GraphQLScalar {
  public init(from data: AnyCodable) throws {
    switch data.value {
    case let string as String:
      if let value = Enums.GeoWebParcelOrderBy(rawValue: string) {
        self = value
      } else {
        throw ScalarDecodingError.unknownEnumCase(value: string)
      }
    default:
      throw ScalarDecodingError.unexpectedScalarType(
        expected: "GeoWebParcel_orderBy",
        received: data.value
      )
    }
  }

  public static var mockValue = Self.id
}
extension Enums {
  /// Defines the order direction, either ascending or descending
  public enum OrderDirection: String, CaseIterable, Codable {

    case asc = "asc"

    case desc = "desc"
  }
}

extension Enums.OrderDirection: GraphQLScalar {
  public init(from data: AnyCodable) throws {
    switch data.value {
    case let string as String:
      if let value = Enums.OrderDirection(rawValue: string) {
        self = value
      } else {
        throw ScalarDecodingError.unknownEnumCase(value: string)
      }
    default:
      throw ScalarDecodingError.unexpectedScalarType(
        expected: "OrderDirection",
        received: data.value
      )
    }
  }

  public static var mockValue = Self.asc
}
extension Enums {
  /// _SubgraphErrorPolicy_
  public enum SubgraphErrorPolicy: String, CaseIterable, Codable {
    /// Data will be returned even if the subgraph has indexing errors
    case allow = "allow"
    /// If the subgraph has indexing errors, data will be omitted. The default.
    case deny = "deny"
  }
}

extension Enums.SubgraphErrorPolicy: GraphQLScalar {
  public init(from data: AnyCodable) throws {
    switch data.value {
    case let string as String:
      if let value = Enums.SubgraphErrorPolicy(rawValue: string) {
        self = value
      } else {
        throw ScalarDecodingError.unknownEnumCase(value: string)
      }
    default:
      throw ScalarDecodingError.unexpectedScalarType(
        expected: "_SubgraphErrorPolicy_",
        received: data.value
      )
    }
  }

  public static var mockValue = Self.allow
}

// MARK: - Input Objects

/// Utility pointer to InputObjects.
public typealias Inputs = InputObjects

public enum InputObjects {}
extension InputObjects {
  public struct BidFilter: Encodable, Hashable {

    public var id: OptionalArgument<String>

    public var idNot: OptionalArgument<String>

    public var idGt: OptionalArgument<String>

    public var idLt: OptionalArgument<String>

    public var idGte: OptionalArgument<String>

    public var idLte: OptionalArgument<String>

    public var idIn: OptionalArgument<[String]>

    public var idNotIn: OptionalArgument<[String]>

    public var timestamp: OptionalArgument<AnyCodable>

    public var timestampNot: OptionalArgument<AnyCodable>

    public var timestampGt: OptionalArgument<AnyCodable>

    public var timestampLt: OptionalArgument<AnyCodable>

    public var timestampGte: OptionalArgument<AnyCodable>

    public var timestampLte: OptionalArgument<AnyCodable>

    public var timestampIn: OptionalArgument<[AnyCodable]>

    public var timestampNotIn: OptionalArgument<[AnyCodable]>

    public var bidder: OptionalArgument<String>

    public var bidderNot: OptionalArgument<String>

    public var bidderGt: OptionalArgument<String>

    public var bidderLt: OptionalArgument<String>

    public var bidderGte: OptionalArgument<String>

    public var bidderLte: OptionalArgument<String>

    public var bidderIn: OptionalArgument<[String]>

    public var bidderNotIn: OptionalArgument<[String]>

    public var bidderContains: OptionalArgument<String>

    public var bidderContainsNocase: OptionalArgument<String>

    public var bidderNotContains: OptionalArgument<String>

    public var bidderNotContainsNocase: OptionalArgument<String>

    public var bidderStartsWith: OptionalArgument<String>

    public var bidderStartsWithNocase: OptionalArgument<String>

    public var bidderNotStartsWith: OptionalArgument<String>

    public var bidderNotStartsWithNocase: OptionalArgument<String>

    public var bidderEndsWith: OptionalArgument<String>

    public var bidderEndsWithNocase: OptionalArgument<String>

    public var bidderNotEndsWith: OptionalArgument<String>

    public var bidderNotEndsWithNocase: OptionalArgument<String>

    public var bidder_: OptionalArgument<InputObjects.BidderFilter>

    public var contributionRate: OptionalArgument<AnyCodable>

    public var contributionRateNot: OptionalArgument<AnyCodable>

    public var contributionRateGt: OptionalArgument<AnyCodable>

    public var contributionRateLt: OptionalArgument<AnyCodable>

    public var contributionRateGte: OptionalArgument<AnyCodable>

    public var contributionRateLte: OptionalArgument<AnyCodable>

    public var contributionRateIn: OptionalArgument<[AnyCodable]>

    public var contributionRateNotIn: OptionalArgument<[AnyCodable]>

    public var perSecondFeeNumerator: OptionalArgument<AnyCodable>

    public var perSecondFeeNumeratorNot: OptionalArgument<AnyCodable>

    public var perSecondFeeNumeratorGt: OptionalArgument<AnyCodable>

    public var perSecondFeeNumeratorLt: OptionalArgument<AnyCodable>

    public var perSecondFeeNumeratorGte: OptionalArgument<AnyCodable>

    public var perSecondFeeNumeratorLte: OptionalArgument<AnyCodable>

    public var perSecondFeeNumeratorIn: OptionalArgument<[AnyCodable]>

    public var perSecondFeeNumeratorNotIn: OptionalArgument<[AnyCodable]>

    public var perSecondFeeDenominator: OptionalArgument<AnyCodable>

    public var perSecondFeeDenominatorNot: OptionalArgument<AnyCodable>

    public var perSecondFeeDenominatorGt: OptionalArgument<AnyCodable>

    public var perSecondFeeDenominatorLt: OptionalArgument<AnyCodable>

    public var perSecondFeeDenominatorGte: OptionalArgument<AnyCodable>

    public var perSecondFeeDenominatorLte: OptionalArgument<AnyCodable>

    public var perSecondFeeDenominatorIn: OptionalArgument<[AnyCodable]>

    public var perSecondFeeDenominatorNotIn: OptionalArgument<[AnyCodable]>

    public var forSalePrice: OptionalArgument<AnyCodable>

    public var forSalePriceNot: OptionalArgument<AnyCodable>

    public var forSalePriceGt: OptionalArgument<AnyCodable>

    public var forSalePriceLt: OptionalArgument<AnyCodable>

    public var forSalePriceGte: OptionalArgument<AnyCodable>

    public var forSalePriceLte: OptionalArgument<AnyCodable>

    public var forSalePriceIn: OptionalArgument<[AnyCodable]>

    public var forSalePriceNotIn: OptionalArgument<[AnyCodable]>

    public var parcel: OptionalArgument<String>

    public var parcelNot: OptionalArgument<String>

    public var parcelGt: OptionalArgument<String>

    public var parcelLt: OptionalArgument<String>

    public var parcelGte: OptionalArgument<String>

    public var parcelLte: OptionalArgument<String>

    public var parcelIn: OptionalArgument<[String]>

    public var parcelNotIn: OptionalArgument<[String]>

    public var parcelContains: OptionalArgument<String>

    public var parcelContainsNocase: OptionalArgument<String>

    public var parcelNotContains: OptionalArgument<String>

    public var parcelNotContainsNocase: OptionalArgument<String>

    public var parcelStartsWith: OptionalArgument<String>

    public var parcelStartsWithNocase: OptionalArgument<String>

    public var parcelNotStartsWith: OptionalArgument<String>

    public var parcelNotStartsWithNocase: OptionalArgument<String>

    public var parcelEndsWith: OptionalArgument<String>

    public var parcelEndsWithNocase: OptionalArgument<String>

    public var parcelNotEndsWith: OptionalArgument<String>

    public var parcelNotEndsWithNocase: OptionalArgument<String>

    public var parcel_: OptionalArgument<InputObjects.GeoWebParcelFilter>

    public var contentHash: OptionalArgument<AnyCodable>

    public var contentHashNot: OptionalArgument<AnyCodable>

    public var contentHashGt: OptionalArgument<AnyCodable>

    public var contentHashLt: OptionalArgument<AnyCodable>

    public var contentHashGte: OptionalArgument<AnyCodable>

    public var contentHashLte: OptionalArgument<AnyCodable>

    public var contentHashIn: OptionalArgument<[AnyCodable]>

    public var contentHashNotIn: OptionalArgument<[AnyCodable]>

    public var contentHashContains: OptionalArgument<AnyCodable>

    public var contentHashNotContains: OptionalArgument<AnyCodable>
    /// Filter for the block changed event.
    public var _changeBlock: OptionalArgument<InputObjects.BlockChangedFilter>

    public var `and`: OptionalArgument<[OptionalArgument<InputObjects.BidFilter>]>

    public var `or`: OptionalArgument<[OptionalArgument<InputObjects.BidFilter>]>

    public init(
      id: OptionalArgument<String> = .init(),
      idNot: OptionalArgument<String> = .init(),
      idGt: OptionalArgument<String> = .init(),
      idLt: OptionalArgument<String> = .init(),
      idGte: OptionalArgument<String> = .init(),
      idLte: OptionalArgument<String> = .init(),
      idIn: OptionalArgument<[String]> = .init(),
      idNotIn: OptionalArgument<[String]> = .init(),
      timestamp: OptionalArgument<AnyCodable> = .init(),
      timestampNot: OptionalArgument<AnyCodable> = .init(),
      timestampGt: OptionalArgument<AnyCodable> = .init(),
      timestampLt: OptionalArgument<AnyCodable> = .init(),
      timestampGte: OptionalArgument<AnyCodable> = .init(),
      timestampLte: OptionalArgument<AnyCodable> = .init(),
      timestampIn: OptionalArgument<[AnyCodable]> = .init(),
      timestampNotIn: OptionalArgument<[AnyCodable]> = .init(),
      bidder: OptionalArgument<String> = .init(),
      bidderNot: OptionalArgument<String> = .init(),
      bidderGt: OptionalArgument<String> = .init(),
      bidderLt: OptionalArgument<String> = .init(),
      bidderGte: OptionalArgument<String> = .init(),
      bidderLte: OptionalArgument<String> = .init(),
      bidderIn: OptionalArgument<[String]> = .init(),
      bidderNotIn: OptionalArgument<[String]> = .init(),
      bidderContains: OptionalArgument<String> = .init(),
      bidderContainsNocase: OptionalArgument<String> = .init(),
      bidderNotContains: OptionalArgument<String> = .init(),
      bidderNotContainsNocase: OptionalArgument<String> = .init(),
      bidderStartsWith: OptionalArgument<String> = .init(),
      bidderStartsWithNocase: OptionalArgument<String> = .init(),
      bidderNotStartsWith: OptionalArgument<String> = .init(),
      bidderNotStartsWithNocase: OptionalArgument<String> = .init(),
      bidderEndsWith: OptionalArgument<String> = .init(),
      bidderEndsWithNocase: OptionalArgument<String> = .init(),
      bidderNotEndsWith: OptionalArgument<String> = .init(),
      bidderNotEndsWithNocase: OptionalArgument<String> = .init(),
      bidder_: OptionalArgument<InputObjects.BidderFilter> = .init(),
      contributionRate: OptionalArgument<AnyCodable> = .init(),
      contributionRateNot: OptionalArgument<AnyCodable> = .init(),
      contributionRateGt: OptionalArgument<AnyCodable> = .init(),
      contributionRateLt: OptionalArgument<AnyCodable> = .init(),
      contributionRateGte: OptionalArgument<AnyCodable> = .init(),
      contributionRateLte: OptionalArgument<AnyCodable> = .init(),
      contributionRateIn: OptionalArgument<[AnyCodable]> = .init(),
      contributionRateNotIn: OptionalArgument<[AnyCodable]> = .init(),
      perSecondFeeNumerator: OptionalArgument<AnyCodable> = .init(),
      perSecondFeeNumeratorNot: OptionalArgument<AnyCodable> = .init(),
      perSecondFeeNumeratorGt: OptionalArgument<AnyCodable> = .init(),
      perSecondFeeNumeratorLt: OptionalArgument<AnyCodable> = .init(),
      perSecondFeeNumeratorGte: OptionalArgument<AnyCodable> = .init(),
      perSecondFeeNumeratorLte: OptionalArgument<AnyCodable> = .init(),
      perSecondFeeNumeratorIn: OptionalArgument<[AnyCodable]> = .init(),
      perSecondFeeNumeratorNotIn: OptionalArgument<[AnyCodable]> = .init(),
      perSecondFeeDenominator: OptionalArgument<AnyCodable> = .init(),
      perSecondFeeDenominatorNot: OptionalArgument<AnyCodable> = .init(),
      perSecondFeeDenominatorGt: OptionalArgument<AnyCodable> = .init(),
      perSecondFeeDenominatorLt: OptionalArgument<AnyCodable> = .init(),
      perSecondFeeDenominatorGte: OptionalArgument<AnyCodable> = .init(),
      perSecondFeeDenominatorLte: OptionalArgument<AnyCodable> = .init(),
      perSecondFeeDenominatorIn: OptionalArgument<[AnyCodable]> = .init(),
      perSecondFeeDenominatorNotIn: OptionalArgument<[AnyCodable]> = .init(),
      forSalePrice: OptionalArgument<AnyCodable> = .init(),
      forSalePriceNot: OptionalArgument<AnyCodable> = .init(),
      forSalePriceGt: OptionalArgument<AnyCodable> = .init(),
      forSalePriceLt: OptionalArgument<AnyCodable> = .init(),
      forSalePriceGte: OptionalArgument<AnyCodable> = .init(),
      forSalePriceLte: OptionalArgument<AnyCodable> = .init(),
      forSalePriceIn: OptionalArgument<[AnyCodable]> = .init(),
      forSalePriceNotIn: OptionalArgument<[AnyCodable]> = .init(),
      parcel: OptionalArgument<String> = .init(),
      parcelNot: OptionalArgument<String> = .init(),
      parcelGt: OptionalArgument<String> = .init(),
      parcelLt: OptionalArgument<String> = .init(),
      parcelGte: OptionalArgument<String> = .init(),
      parcelLte: OptionalArgument<String> = .init(),
      parcelIn: OptionalArgument<[String]> = .init(),
      parcelNotIn: OptionalArgument<[String]> = .init(),
      parcelContains: OptionalArgument<String> = .init(),
      parcelContainsNocase: OptionalArgument<String> = .init(),
      parcelNotContains: OptionalArgument<String> = .init(),
      parcelNotContainsNocase: OptionalArgument<String> = .init(),
      parcelStartsWith: OptionalArgument<String> = .init(),
      parcelStartsWithNocase: OptionalArgument<String> = .init(),
      parcelNotStartsWith: OptionalArgument<String> = .init(),
      parcelNotStartsWithNocase: OptionalArgument<String> = .init(),
      parcelEndsWith: OptionalArgument<String> = .init(),
      parcelEndsWithNocase: OptionalArgument<String> = .init(),
      parcelNotEndsWith: OptionalArgument<String> = .init(),
      parcelNotEndsWithNocase: OptionalArgument<String> = .init(),
      parcel_: OptionalArgument<InputObjects.GeoWebParcelFilter> = .init(),
      contentHash: OptionalArgument<AnyCodable> = .init(),
      contentHashNot: OptionalArgument<AnyCodable> = .init(),
      contentHashGt: OptionalArgument<AnyCodable> = .init(),
      contentHashLt: OptionalArgument<AnyCodable> = .init(),
      contentHashGte: OptionalArgument<AnyCodable> = .init(),
      contentHashLte: OptionalArgument<AnyCodable> = .init(),
      contentHashIn: OptionalArgument<[AnyCodable]> = .init(),
      contentHashNotIn: OptionalArgument<[AnyCodable]> = .init(),
      contentHashContains: OptionalArgument<AnyCodable> = .init(),
      contentHashNotContains: OptionalArgument<AnyCodable> = .init(),
      _changeBlock: OptionalArgument<InputObjects.BlockChangedFilter> = .init(),
      `and`: OptionalArgument<[OptionalArgument<InputObjects.BidFilter>]> = .init(),
      `or`: OptionalArgument<[OptionalArgument<InputObjects.BidFilter>]> = .init()
    ) {
      self.id = id
      self.idNot = idNot
      self.idGt = idGt
      self.idLt = idLt
      self.idGte = idGte
      self.idLte = idLte
      self.idIn = idIn
      self.idNotIn = idNotIn
      self.timestamp = timestamp
      self.timestampNot = timestampNot
      self.timestampGt = timestampGt
      self.timestampLt = timestampLt
      self.timestampGte = timestampGte
      self.timestampLte = timestampLte
      self.timestampIn = timestampIn
      self.timestampNotIn = timestampNotIn
      self.bidder = bidder
      self.bidderNot = bidderNot
      self.bidderGt = bidderGt
      self.bidderLt = bidderLt
      self.bidderGte = bidderGte
      self.bidderLte = bidderLte
      self.bidderIn = bidderIn
      self.bidderNotIn = bidderNotIn
      self.bidderContains = bidderContains
      self.bidderContainsNocase = bidderContainsNocase
      self.bidderNotContains = bidderNotContains
      self.bidderNotContainsNocase = bidderNotContainsNocase
      self.bidderStartsWith = bidderStartsWith
      self.bidderStartsWithNocase = bidderStartsWithNocase
      self.bidderNotStartsWith = bidderNotStartsWith
      self.bidderNotStartsWithNocase = bidderNotStartsWithNocase
      self.bidderEndsWith = bidderEndsWith
      self.bidderEndsWithNocase = bidderEndsWithNocase
      self.bidderNotEndsWith = bidderNotEndsWith
      self.bidderNotEndsWithNocase = bidderNotEndsWithNocase
      self.bidder_ = bidder_
      self.contributionRate = contributionRate
      self.contributionRateNot = contributionRateNot
      self.contributionRateGt = contributionRateGt
      self.contributionRateLt = contributionRateLt
      self.contributionRateGte = contributionRateGte
      self.contributionRateLte = contributionRateLte
      self.contributionRateIn = contributionRateIn
      self.contributionRateNotIn = contributionRateNotIn
      self.perSecondFeeNumerator = perSecondFeeNumerator
      self.perSecondFeeNumeratorNot = perSecondFeeNumeratorNot
      self.perSecondFeeNumeratorGt = perSecondFeeNumeratorGt
      self.perSecondFeeNumeratorLt = perSecondFeeNumeratorLt
      self.perSecondFeeNumeratorGte = perSecondFeeNumeratorGte
      self.perSecondFeeNumeratorLte = perSecondFeeNumeratorLte
      self.perSecondFeeNumeratorIn = perSecondFeeNumeratorIn
      self.perSecondFeeNumeratorNotIn = perSecondFeeNumeratorNotIn
      self.perSecondFeeDenominator = perSecondFeeDenominator
      self.perSecondFeeDenominatorNot = perSecondFeeDenominatorNot
      self.perSecondFeeDenominatorGt = perSecondFeeDenominatorGt
      self.perSecondFeeDenominatorLt = perSecondFeeDenominatorLt
      self.perSecondFeeDenominatorGte = perSecondFeeDenominatorGte
      self.perSecondFeeDenominatorLte = perSecondFeeDenominatorLte
      self.perSecondFeeDenominatorIn = perSecondFeeDenominatorIn
      self.perSecondFeeDenominatorNotIn = perSecondFeeDenominatorNotIn
      self.forSalePrice = forSalePrice
      self.forSalePriceNot = forSalePriceNot
      self.forSalePriceGt = forSalePriceGt
      self.forSalePriceLt = forSalePriceLt
      self.forSalePriceGte = forSalePriceGte
      self.forSalePriceLte = forSalePriceLte
      self.forSalePriceIn = forSalePriceIn
      self.forSalePriceNotIn = forSalePriceNotIn
      self.parcel = parcel
      self.parcelNot = parcelNot
      self.parcelGt = parcelGt
      self.parcelLt = parcelLt
      self.parcelGte = parcelGte
      self.parcelLte = parcelLte
      self.parcelIn = parcelIn
      self.parcelNotIn = parcelNotIn
      self.parcelContains = parcelContains
      self.parcelContainsNocase = parcelContainsNocase
      self.parcelNotContains = parcelNotContains
      self.parcelNotContainsNocase = parcelNotContainsNocase
      self.parcelStartsWith = parcelStartsWith
      self.parcelStartsWithNocase = parcelStartsWithNocase
      self.parcelNotStartsWith = parcelNotStartsWith
      self.parcelNotStartsWithNocase = parcelNotStartsWithNocase
      self.parcelEndsWith = parcelEndsWith
      self.parcelEndsWithNocase = parcelEndsWithNocase
      self.parcelNotEndsWith = parcelNotEndsWith
      self.parcelNotEndsWithNocase = parcelNotEndsWithNocase
      self.parcel_ = parcel_
      self.contentHash = contentHash
      self.contentHashNot = contentHashNot
      self.contentHashGt = contentHashGt
      self.contentHashLt = contentHashLt
      self.contentHashGte = contentHashGte
      self.contentHashLte = contentHashLte
      self.contentHashIn = contentHashIn
      self.contentHashNotIn = contentHashNotIn
      self.contentHashContains = contentHashContains
      self.contentHashNotContains = contentHashNotContains
      self._changeBlock = _changeBlock
      self.`and` = `and`
      self.`or` = `or`
    }

    public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      if id.hasValue { try container.encode(id, forKey: .id) }
      if idNot.hasValue { try container.encode(idNot, forKey: .idNot) }
      if idGt.hasValue { try container.encode(idGt, forKey: .idGt) }
      if idLt.hasValue { try container.encode(idLt, forKey: .idLt) }
      if idGte.hasValue { try container.encode(idGte, forKey: .idGte) }
      if idLte.hasValue { try container.encode(idLte, forKey: .idLte) }
      if idIn.hasValue { try container.encode(idIn, forKey: .idIn) }
      if idNotIn.hasValue { try container.encode(idNotIn, forKey: .idNotIn) }
      if timestamp.hasValue { try container.encode(timestamp, forKey: .timestamp) }
      if timestampNot.hasValue { try container.encode(timestampNot, forKey: .timestampNot) }
      if timestampGt.hasValue { try container.encode(timestampGt, forKey: .timestampGt) }
      if timestampLt.hasValue { try container.encode(timestampLt, forKey: .timestampLt) }
      if timestampGte.hasValue { try container.encode(timestampGte, forKey: .timestampGte) }
      if timestampLte.hasValue { try container.encode(timestampLte, forKey: .timestampLte) }
      if timestampIn.hasValue { try container.encode(timestampIn, forKey: .timestampIn) }
      if timestampNotIn.hasValue { try container.encode(timestampNotIn, forKey: .timestampNotIn) }
      if bidder.hasValue { try container.encode(bidder, forKey: .bidder) }
      if bidderNot.hasValue { try container.encode(bidderNot, forKey: .bidderNot) }
      if bidderGt.hasValue { try container.encode(bidderGt, forKey: .bidderGt) }
      if bidderLt.hasValue { try container.encode(bidderLt, forKey: .bidderLt) }
      if bidderGte.hasValue { try container.encode(bidderGte, forKey: .bidderGte) }
      if bidderLte.hasValue { try container.encode(bidderLte, forKey: .bidderLte) }
      if bidderIn.hasValue { try container.encode(bidderIn, forKey: .bidderIn) }
      if bidderNotIn.hasValue { try container.encode(bidderNotIn, forKey: .bidderNotIn) }
      if bidderContains.hasValue { try container.encode(bidderContains, forKey: .bidderContains) }
      if bidderContainsNocase.hasValue {
        try container.encode(bidderContainsNocase, forKey: .bidderContainsNocase)
      }
      if bidderNotContains.hasValue {
        try container.encode(bidderNotContains, forKey: .bidderNotContains)
      }
      if bidderNotContainsNocase.hasValue {
        try container.encode(bidderNotContainsNocase, forKey: .bidderNotContainsNocase)
      }
      if bidderStartsWith.hasValue {
        try container.encode(bidderStartsWith, forKey: .bidderStartsWith)
      }
      if bidderStartsWithNocase.hasValue {
        try container.encode(bidderStartsWithNocase, forKey: .bidderStartsWithNocase)
      }
      if bidderNotStartsWith.hasValue {
        try container.encode(bidderNotStartsWith, forKey: .bidderNotStartsWith)
      }
      if bidderNotStartsWithNocase.hasValue {
        try container.encode(bidderNotStartsWithNocase, forKey: .bidderNotStartsWithNocase)
      }
      if bidderEndsWith.hasValue { try container.encode(bidderEndsWith, forKey: .bidderEndsWith) }
      if bidderEndsWithNocase.hasValue {
        try container.encode(bidderEndsWithNocase, forKey: .bidderEndsWithNocase)
      }
      if bidderNotEndsWith.hasValue {
        try container.encode(bidderNotEndsWith, forKey: .bidderNotEndsWith)
      }
      if bidderNotEndsWithNocase.hasValue {
        try container.encode(bidderNotEndsWithNocase, forKey: .bidderNotEndsWithNocase)
      }
      if bidder_.hasValue { try container.encode(bidder_, forKey: .bidder_) }
      if contributionRate.hasValue {
        try container.encode(contributionRate, forKey: .contributionRate)
      }
      if contributionRateNot.hasValue {
        try container.encode(contributionRateNot, forKey: .contributionRateNot)
      }
      if contributionRateGt.hasValue {
        try container.encode(contributionRateGt, forKey: .contributionRateGt)
      }
      if contributionRateLt.hasValue {
        try container.encode(contributionRateLt, forKey: .contributionRateLt)
      }
      if contributionRateGte.hasValue {
        try container.encode(contributionRateGte, forKey: .contributionRateGte)
      }
      if contributionRateLte.hasValue {
        try container.encode(contributionRateLte, forKey: .contributionRateLte)
      }
      if contributionRateIn.hasValue {
        try container.encode(contributionRateIn, forKey: .contributionRateIn)
      }
      if contributionRateNotIn.hasValue {
        try container.encode(contributionRateNotIn, forKey: .contributionRateNotIn)
      }
      if perSecondFeeNumerator.hasValue {
        try container.encode(perSecondFeeNumerator, forKey: .perSecondFeeNumerator)
      }
      if perSecondFeeNumeratorNot.hasValue {
        try container.encode(perSecondFeeNumeratorNot, forKey: .perSecondFeeNumeratorNot)
      }
      if perSecondFeeNumeratorGt.hasValue {
        try container.encode(perSecondFeeNumeratorGt, forKey: .perSecondFeeNumeratorGt)
      }
      if perSecondFeeNumeratorLt.hasValue {
        try container.encode(perSecondFeeNumeratorLt, forKey: .perSecondFeeNumeratorLt)
      }
      if perSecondFeeNumeratorGte.hasValue {
        try container.encode(perSecondFeeNumeratorGte, forKey: .perSecondFeeNumeratorGte)
      }
      if perSecondFeeNumeratorLte.hasValue {
        try container.encode(perSecondFeeNumeratorLte, forKey: .perSecondFeeNumeratorLte)
      }
      if perSecondFeeNumeratorIn.hasValue {
        try container.encode(perSecondFeeNumeratorIn, forKey: .perSecondFeeNumeratorIn)
      }
      if perSecondFeeNumeratorNotIn.hasValue {
        try container.encode(perSecondFeeNumeratorNotIn, forKey: .perSecondFeeNumeratorNotIn)
      }
      if perSecondFeeDenominator.hasValue {
        try container.encode(perSecondFeeDenominator, forKey: .perSecondFeeDenominator)
      }
      if perSecondFeeDenominatorNot.hasValue {
        try container.encode(perSecondFeeDenominatorNot, forKey: .perSecondFeeDenominatorNot)
      }
      if perSecondFeeDenominatorGt.hasValue {
        try container.encode(perSecondFeeDenominatorGt, forKey: .perSecondFeeDenominatorGt)
      }
      if perSecondFeeDenominatorLt.hasValue {
        try container.encode(perSecondFeeDenominatorLt, forKey: .perSecondFeeDenominatorLt)
      }
      if perSecondFeeDenominatorGte.hasValue {
        try container.encode(perSecondFeeDenominatorGte, forKey: .perSecondFeeDenominatorGte)
      }
      if perSecondFeeDenominatorLte.hasValue {
        try container.encode(perSecondFeeDenominatorLte, forKey: .perSecondFeeDenominatorLte)
      }
      if perSecondFeeDenominatorIn.hasValue {
        try container.encode(perSecondFeeDenominatorIn, forKey: .perSecondFeeDenominatorIn)
      }
      if perSecondFeeDenominatorNotIn.hasValue {
        try container.encode(perSecondFeeDenominatorNotIn, forKey: .perSecondFeeDenominatorNotIn)
      }
      if forSalePrice.hasValue { try container.encode(forSalePrice, forKey: .forSalePrice) }
      if forSalePriceNot.hasValue {
        try container.encode(forSalePriceNot, forKey: .forSalePriceNot)
      }
      if forSalePriceGt.hasValue { try container.encode(forSalePriceGt, forKey: .forSalePriceGt) }
      if forSalePriceLt.hasValue { try container.encode(forSalePriceLt, forKey: .forSalePriceLt) }
      if forSalePriceGte.hasValue {
        try container.encode(forSalePriceGte, forKey: .forSalePriceGte)
      }
      if forSalePriceLte.hasValue {
        try container.encode(forSalePriceLte, forKey: .forSalePriceLte)
      }
      if forSalePriceIn.hasValue { try container.encode(forSalePriceIn, forKey: .forSalePriceIn) }
      if forSalePriceNotIn.hasValue {
        try container.encode(forSalePriceNotIn, forKey: .forSalePriceNotIn)
      }
      if parcel.hasValue { try container.encode(parcel, forKey: .parcel) }
      if parcelNot.hasValue { try container.encode(parcelNot, forKey: .parcelNot) }
      if parcelGt.hasValue { try container.encode(parcelGt, forKey: .parcelGt) }
      if parcelLt.hasValue { try container.encode(parcelLt, forKey: .parcelLt) }
      if parcelGte.hasValue { try container.encode(parcelGte, forKey: .parcelGte) }
      if parcelLte.hasValue { try container.encode(parcelLte, forKey: .parcelLte) }
      if parcelIn.hasValue { try container.encode(parcelIn, forKey: .parcelIn) }
      if parcelNotIn.hasValue { try container.encode(parcelNotIn, forKey: .parcelNotIn) }
      if parcelContains.hasValue { try container.encode(parcelContains, forKey: .parcelContains) }
      if parcelContainsNocase.hasValue {
        try container.encode(parcelContainsNocase, forKey: .parcelContainsNocase)
      }
      if parcelNotContains.hasValue {
        try container.encode(parcelNotContains, forKey: .parcelNotContains)
      }
      if parcelNotContainsNocase.hasValue {
        try container.encode(parcelNotContainsNocase, forKey: .parcelNotContainsNocase)
      }
      if parcelStartsWith.hasValue {
        try container.encode(parcelStartsWith, forKey: .parcelStartsWith)
      }
      if parcelStartsWithNocase.hasValue {
        try container.encode(parcelStartsWithNocase, forKey: .parcelStartsWithNocase)
      }
      if parcelNotStartsWith.hasValue {
        try container.encode(parcelNotStartsWith, forKey: .parcelNotStartsWith)
      }
      if parcelNotStartsWithNocase.hasValue {
        try container.encode(parcelNotStartsWithNocase, forKey: .parcelNotStartsWithNocase)
      }
      if parcelEndsWith.hasValue { try container.encode(parcelEndsWith, forKey: .parcelEndsWith) }
      if parcelEndsWithNocase.hasValue {
        try container.encode(parcelEndsWithNocase, forKey: .parcelEndsWithNocase)
      }
      if parcelNotEndsWith.hasValue {
        try container.encode(parcelNotEndsWith, forKey: .parcelNotEndsWith)
      }
      if parcelNotEndsWithNocase.hasValue {
        try container.encode(parcelNotEndsWithNocase, forKey: .parcelNotEndsWithNocase)
      }
      if parcel_.hasValue { try container.encode(parcel_, forKey: .parcel_) }
      if contentHash.hasValue { try container.encode(contentHash, forKey: .contentHash) }
      if contentHashNot.hasValue { try container.encode(contentHashNot, forKey: .contentHashNot) }
      if contentHashGt.hasValue { try container.encode(contentHashGt, forKey: .contentHashGt) }
      if contentHashLt.hasValue { try container.encode(contentHashLt, forKey: .contentHashLt) }
      if contentHashGte.hasValue { try container.encode(contentHashGte, forKey: .contentHashGte) }
      if contentHashLte.hasValue { try container.encode(contentHashLte, forKey: .contentHashLte) }
      if contentHashIn.hasValue { try container.encode(contentHashIn, forKey: .contentHashIn) }
      if contentHashNotIn.hasValue {
        try container.encode(contentHashNotIn, forKey: .contentHashNotIn)
      }
      if contentHashContains.hasValue {
        try container.encode(contentHashContains, forKey: .contentHashContains)
      }
      if contentHashNotContains.hasValue {
        try container.encode(contentHashNotContains, forKey: .contentHashNotContains)
      }
      if _changeBlock.hasValue { try container.encode(_changeBlock, forKey: ._changeBlock) }
      if `and`.hasValue { try container.encode(`and`, forKey: .`and`) }
      if `or`.hasValue { try container.encode(`or`, forKey: .`or`) }
    }

    public enum CodingKeys: String, CodingKey {
      case id = "id"
      case idNot = "id_not"
      case idGt = "id_gt"
      case idLt = "id_lt"
      case idGte = "id_gte"
      case idLte = "id_lte"
      case idIn = "id_in"
      case idNotIn = "id_not_in"
      case timestamp = "timestamp"
      case timestampNot = "timestamp_not"
      case timestampGt = "timestamp_gt"
      case timestampLt = "timestamp_lt"
      case timestampGte = "timestamp_gte"
      case timestampLte = "timestamp_lte"
      case timestampIn = "timestamp_in"
      case timestampNotIn = "timestamp_not_in"
      case bidder = "bidder"
      case bidderNot = "bidder_not"
      case bidderGt = "bidder_gt"
      case bidderLt = "bidder_lt"
      case bidderGte = "bidder_gte"
      case bidderLte = "bidder_lte"
      case bidderIn = "bidder_in"
      case bidderNotIn = "bidder_not_in"
      case bidderContains = "bidder_contains"
      case bidderContainsNocase = "bidder_contains_nocase"
      case bidderNotContains = "bidder_not_contains"
      case bidderNotContainsNocase = "bidder_not_contains_nocase"
      case bidderStartsWith = "bidder_starts_with"
      case bidderStartsWithNocase = "bidder_starts_with_nocase"
      case bidderNotStartsWith = "bidder_not_starts_with"
      case bidderNotStartsWithNocase = "bidder_not_starts_with_nocase"
      case bidderEndsWith = "bidder_ends_with"
      case bidderEndsWithNocase = "bidder_ends_with_nocase"
      case bidderNotEndsWith = "bidder_not_ends_with"
      case bidderNotEndsWithNocase = "bidder_not_ends_with_nocase"
      case bidder_ = "bidder_"
      case contributionRate = "contributionRate"
      case contributionRateNot = "contributionRate_not"
      case contributionRateGt = "contributionRate_gt"
      case contributionRateLt = "contributionRate_lt"
      case contributionRateGte = "contributionRate_gte"
      case contributionRateLte = "contributionRate_lte"
      case contributionRateIn = "contributionRate_in"
      case contributionRateNotIn = "contributionRate_not_in"
      case perSecondFeeNumerator = "perSecondFeeNumerator"
      case perSecondFeeNumeratorNot = "perSecondFeeNumerator_not"
      case perSecondFeeNumeratorGt = "perSecondFeeNumerator_gt"
      case perSecondFeeNumeratorLt = "perSecondFeeNumerator_lt"
      case perSecondFeeNumeratorGte = "perSecondFeeNumerator_gte"
      case perSecondFeeNumeratorLte = "perSecondFeeNumerator_lte"
      case perSecondFeeNumeratorIn = "perSecondFeeNumerator_in"
      case perSecondFeeNumeratorNotIn = "perSecondFeeNumerator_not_in"
      case perSecondFeeDenominator = "perSecondFeeDenominator"
      case perSecondFeeDenominatorNot = "perSecondFeeDenominator_not"
      case perSecondFeeDenominatorGt = "perSecondFeeDenominator_gt"
      case perSecondFeeDenominatorLt = "perSecondFeeDenominator_lt"
      case perSecondFeeDenominatorGte = "perSecondFeeDenominator_gte"
      case perSecondFeeDenominatorLte = "perSecondFeeDenominator_lte"
      case perSecondFeeDenominatorIn = "perSecondFeeDenominator_in"
      case perSecondFeeDenominatorNotIn = "perSecondFeeDenominator_not_in"
      case forSalePrice = "forSalePrice"
      case forSalePriceNot = "forSalePrice_not"
      case forSalePriceGt = "forSalePrice_gt"
      case forSalePriceLt = "forSalePrice_lt"
      case forSalePriceGte = "forSalePrice_gte"
      case forSalePriceLte = "forSalePrice_lte"
      case forSalePriceIn = "forSalePrice_in"
      case forSalePriceNotIn = "forSalePrice_not_in"
      case parcel = "parcel"
      case parcelNot = "parcel_not"
      case parcelGt = "parcel_gt"
      case parcelLt = "parcel_lt"
      case parcelGte = "parcel_gte"
      case parcelLte = "parcel_lte"
      case parcelIn = "parcel_in"
      case parcelNotIn = "parcel_not_in"
      case parcelContains = "parcel_contains"
      case parcelContainsNocase = "parcel_contains_nocase"
      case parcelNotContains = "parcel_not_contains"
      case parcelNotContainsNocase = "parcel_not_contains_nocase"
      case parcelStartsWith = "parcel_starts_with"
      case parcelStartsWithNocase = "parcel_starts_with_nocase"
      case parcelNotStartsWith = "parcel_not_starts_with"
      case parcelNotStartsWithNocase = "parcel_not_starts_with_nocase"
      case parcelEndsWith = "parcel_ends_with"
      case parcelEndsWithNocase = "parcel_ends_with_nocase"
      case parcelNotEndsWith = "parcel_not_ends_with"
      case parcelNotEndsWithNocase = "parcel_not_ends_with_nocase"
      case parcel_ = "parcel_"
      case contentHash = "contentHash"
      case contentHashNot = "contentHash_not"
      case contentHashGt = "contentHash_gt"
      case contentHashLt = "contentHash_lt"
      case contentHashGte = "contentHash_gte"
      case contentHashLte = "contentHash_lte"
      case contentHashIn = "contentHash_in"
      case contentHashNotIn = "contentHash_not_in"
      case contentHashContains = "contentHash_contains"
      case contentHashNotContains = "contentHash_not_contains"
      case _changeBlock = "_change_block"
      case `and` = "and"
      case `or` = "or"
    }
  }
}
extension InputObjects {
  public struct BidderFilter: Encodable, Hashable {

    public var id: OptionalArgument<String>

    public var idNot: OptionalArgument<String>

    public var idGt: OptionalArgument<String>

    public var idLt: OptionalArgument<String>

    public var idGte: OptionalArgument<String>

    public var idLte: OptionalArgument<String>

    public var idIn: OptionalArgument<[String]>

    public var idNotIn: OptionalArgument<[String]>

    public var bids_: OptionalArgument<InputObjects.BidFilter>
    /// Filter for the block changed event.
    public var _changeBlock: OptionalArgument<InputObjects.BlockChangedFilter>

    public var `and`: OptionalArgument<[OptionalArgument<InputObjects.BidderFilter>]>

    public var `or`: OptionalArgument<[OptionalArgument<InputObjects.BidderFilter>]>

    public init(
      id: OptionalArgument<String> = .init(),
      idNot: OptionalArgument<String> = .init(),
      idGt: OptionalArgument<String> = .init(),
      idLt: OptionalArgument<String> = .init(),
      idGte: OptionalArgument<String> = .init(),
      idLte: OptionalArgument<String> = .init(),
      idIn: OptionalArgument<[String]> = .init(),
      idNotIn: OptionalArgument<[String]> = .init(),
      bids_: OptionalArgument<InputObjects.BidFilter> = .init(),
      _changeBlock: OptionalArgument<InputObjects.BlockChangedFilter> = .init(),
      `and`: OptionalArgument<[OptionalArgument<InputObjects.BidderFilter>]> = .init(),
      `or`: OptionalArgument<[OptionalArgument<InputObjects.BidderFilter>]> = .init()
    ) {
      self.id = id
      self.idNot = idNot
      self.idGt = idGt
      self.idLt = idLt
      self.idGte = idGte
      self.idLte = idLte
      self.idIn = idIn
      self.idNotIn = idNotIn
      self.bids_ = bids_
      self._changeBlock = _changeBlock
      self.`and` = `and`
      self.`or` = `or`
    }

    public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      if id.hasValue { try container.encode(id, forKey: .id) }
      if idNot.hasValue { try container.encode(idNot, forKey: .idNot) }
      if idGt.hasValue { try container.encode(idGt, forKey: .idGt) }
      if idLt.hasValue { try container.encode(idLt, forKey: .idLt) }
      if idGte.hasValue { try container.encode(idGte, forKey: .idGte) }
      if idLte.hasValue { try container.encode(idLte, forKey: .idLte) }
      if idIn.hasValue { try container.encode(idIn, forKey: .idIn) }
      if idNotIn.hasValue { try container.encode(idNotIn, forKey: .idNotIn) }
      if bids_.hasValue { try container.encode(bids_, forKey: .bids_) }
      if _changeBlock.hasValue { try container.encode(_changeBlock, forKey: ._changeBlock) }
      if `and`.hasValue { try container.encode(`and`, forKey: .`and`) }
      if `or`.hasValue { try container.encode(`or`, forKey: .`or`) }
    }

    public enum CodingKeys: String, CodingKey {
      case id = "id"
      case idNot = "id_not"
      case idGt = "id_gt"
      case idLt = "id_lt"
      case idGte = "id_gte"
      case idLte = "id_lte"
      case idIn = "id_in"
      case idNotIn = "id_not_in"
      case bids_ = "bids_"
      case _changeBlock = "_change_block"
      case `and` = "and"
      case `or` = "or"
    }
  }
}
extension InputObjects {
  public struct BlockChangedFilter: Encodable, Hashable {

    public var numberGte: Int

    public init(
      numberGte: Int
    ) {
      self.numberGte = numberGte
    }

    public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(numberGte, forKey: .numberGte)
    }

    public enum CodingKeys: String, CodingKey {
      case numberGte = "number_gte"
    }
  }
}
extension InputObjects {
  public struct BlockHeight: Encodable, Hashable {

    public var hash: OptionalArgument<AnyCodable>

    public var number: OptionalArgument<Int>

    public var numberGte: OptionalArgument<Int>

    public init(
      hash: OptionalArgument<AnyCodable> = .init(),
      number: OptionalArgument<Int> = .init(),
      numberGte: OptionalArgument<Int> = .init()
    ) {
      self.hash = hash
      self.number = number
      self.numberGte = numberGte
    }

    public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      if hash.hasValue { try container.encode(hash, forKey: .hash) }
      if number.hasValue { try container.encode(number, forKey: .number) }
      if numberGte.hasValue { try container.encode(numberGte, forKey: .numberGte) }
    }

    public enum CodingKeys: String, CodingKey {
      case hash = "hash"
      case number = "number"
      case numberGte = "number_gte"
    }
  }
}
extension InputObjects {
  public struct GeoWebParcelFilter: Encodable, Hashable {

    public var id: OptionalArgument<String>

    public var idNot: OptionalArgument<String>

    public var idGt: OptionalArgument<String>

    public var idLt: OptionalArgument<String>

    public var idGte: OptionalArgument<String>

    public var idLte: OptionalArgument<String>

    public var idIn: OptionalArgument<[String]>

    public var idNotIn: OptionalArgument<[String]>

    public var createdAtBlock: OptionalArgument<AnyCodable>

    public var createdAtBlockNot: OptionalArgument<AnyCodable>

    public var createdAtBlockGt: OptionalArgument<AnyCodable>

    public var createdAtBlockLt: OptionalArgument<AnyCodable>

    public var createdAtBlockGte: OptionalArgument<AnyCodable>

    public var createdAtBlockLte: OptionalArgument<AnyCodable>

    public var createdAtBlockIn: OptionalArgument<[AnyCodable]>

    public var createdAtBlockNotIn: OptionalArgument<[AnyCodable]>

    public var licenseOwner: OptionalArgument<AnyCodable>

    public var licenseOwnerNot: OptionalArgument<AnyCodable>

    public var licenseOwnerGt: OptionalArgument<AnyCodable>

    public var licenseOwnerLt: OptionalArgument<AnyCodable>

    public var licenseOwnerGte: OptionalArgument<AnyCodable>

    public var licenseOwnerLte: OptionalArgument<AnyCodable>

    public var licenseOwnerIn: OptionalArgument<[AnyCodable]>

    public var licenseOwnerNotIn: OptionalArgument<[AnyCodable]>

    public var licenseOwnerContains: OptionalArgument<AnyCodable>

    public var licenseOwnerNotContains: OptionalArgument<AnyCodable>

    public var currentBid: OptionalArgument<String>

    public var currentBidNot: OptionalArgument<String>

    public var currentBidGt: OptionalArgument<String>

    public var currentBidLt: OptionalArgument<String>

    public var currentBidGte: OptionalArgument<String>

    public var currentBidLte: OptionalArgument<String>

    public var currentBidIn: OptionalArgument<[String]>

    public var currentBidNotIn: OptionalArgument<[String]>

    public var currentBidContains: OptionalArgument<String>

    public var currentBidContainsNocase: OptionalArgument<String>

    public var currentBidNotContains: OptionalArgument<String>

    public var currentBidNotContainsNocase: OptionalArgument<String>

    public var currentBidStartsWith: OptionalArgument<String>

    public var currentBidStartsWithNocase: OptionalArgument<String>

    public var currentBidNotStartsWith: OptionalArgument<String>

    public var currentBidNotStartsWithNocase: OptionalArgument<String>

    public var currentBidEndsWith: OptionalArgument<String>

    public var currentBidEndsWithNocase: OptionalArgument<String>

    public var currentBidNotEndsWith: OptionalArgument<String>

    public var currentBidNotEndsWithNocase: OptionalArgument<String>

    public var currentBid_: OptionalArgument<InputObjects.BidFilter>

    public var pendingBid: OptionalArgument<String>

    public var pendingBidNot: OptionalArgument<String>

    public var pendingBidGt: OptionalArgument<String>

    public var pendingBidLt: OptionalArgument<String>

    public var pendingBidGte: OptionalArgument<String>

    public var pendingBidLte: OptionalArgument<String>

    public var pendingBidIn: OptionalArgument<[String]>

    public var pendingBidNotIn: OptionalArgument<[String]>

    public var pendingBidContains: OptionalArgument<String>

    public var pendingBidContainsNocase: OptionalArgument<String>

    public var pendingBidNotContains: OptionalArgument<String>

    public var pendingBidNotContainsNocase: OptionalArgument<String>

    public var pendingBidStartsWith: OptionalArgument<String>

    public var pendingBidStartsWithNocase: OptionalArgument<String>

    public var pendingBidNotStartsWith: OptionalArgument<String>

    public var pendingBidNotStartsWithNocase: OptionalArgument<String>

    public var pendingBidEndsWith: OptionalArgument<String>

    public var pendingBidEndsWithNocase: OptionalArgument<String>

    public var pendingBidNotEndsWith: OptionalArgument<String>

    public var pendingBidNotEndsWithNocase: OptionalArgument<String>

    public var pendingBid_: OptionalArgument<InputObjects.BidFilter>

    public var licenseDiamond: OptionalArgument<AnyCodable>

    public var licenseDiamondNot: OptionalArgument<AnyCodable>

    public var licenseDiamondGt: OptionalArgument<AnyCodable>

    public var licenseDiamondLt: OptionalArgument<AnyCodable>

    public var licenseDiamondGte: OptionalArgument<AnyCodable>

    public var licenseDiamondLte: OptionalArgument<AnyCodable>

    public var licenseDiamondIn: OptionalArgument<[AnyCodable]>

    public var licenseDiamondNotIn: OptionalArgument<[AnyCodable]>

    public var licenseDiamondContains: OptionalArgument<AnyCodable>

    public var licenseDiamondNotContains: OptionalArgument<AnyCodable>

    public var coordinates: OptionalArgument<[AnyCodable]>

    public var coordinatesNot: OptionalArgument<[AnyCodable]>

    public var coordinatesContains: OptionalArgument<[AnyCodable]>

    public var coordinatesContainsNocase: OptionalArgument<[AnyCodable]>

    public var coordinatesNotContains: OptionalArgument<[AnyCodable]>

    public var coordinatesNotContainsNocase: OptionalArgument<[AnyCodable]>

    public var bboxN: OptionalArgument<AnyCodable>

    public var bboxNNot: OptionalArgument<AnyCodable>

    public var bboxNGt: OptionalArgument<AnyCodable>

    public var bboxNLt: OptionalArgument<AnyCodable>

    public var bboxNGte: OptionalArgument<AnyCodable>

    public var bboxNLte: OptionalArgument<AnyCodable>

    public var bboxNIn: OptionalArgument<[AnyCodable]>

    public var bboxNNotIn: OptionalArgument<[AnyCodable]>

    public var bboxS: OptionalArgument<AnyCodable>

    public var bboxSNot: OptionalArgument<AnyCodable>

    public var bboxSGt: OptionalArgument<AnyCodable>

    public var bboxSLt: OptionalArgument<AnyCodable>

    public var bboxSGte: OptionalArgument<AnyCodable>

    public var bboxSLte: OptionalArgument<AnyCodable>

    public var bboxSIn: OptionalArgument<[AnyCodable]>

    public var bboxSNotIn: OptionalArgument<[AnyCodable]>

    public var bboxE: OptionalArgument<AnyCodable>

    public var bboxENot: OptionalArgument<AnyCodable>

    public var bboxEGt: OptionalArgument<AnyCodable>

    public var bboxELt: OptionalArgument<AnyCodable>

    public var bboxEGte: OptionalArgument<AnyCodable>

    public var bboxELte: OptionalArgument<AnyCodable>

    public var bboxEIn: OptionalArgument<[AnyCodable]>

    public var bboxENotIn: OptionalArgument<[AnyCodable]>

    public var bboxW: OptionalArgument<AnyCodable>

    public var bboxWNot: OptionalArgument<AnyCodable>

    public var bboxWGt: OptionalArgument<AnyCodable>

    public var bboxWLt: OptionalArgument<AnyCodable>

    public var bboxWGte: OptionalArgument<AnyCodable>

    public var bboxWLte: OptionalArgument<AnyCodable>

    public var bboxWIn: OptionalArgument<[AnyCodable]>

    public var bboxWNotIn: OptionalArgument<[AnyCodable]>

    public var contentHash: OptionalArgument<AnyCodable>

    public var contentHashNot: OptionalArgument<AnyCodable>

    public var contentHashGt: OptionalArgument<AnyCodable>

    public var contentHashLt: OptionalArgument<AnyCodable>

    public var contentHashGte: OptionalArgument<AnyCodable>

    public var contentHashLte: OptionalArgument<AnyCodable>

    public var contentHashIn: OptionalArgument<[AnyCodable]>

    public var contentHashNotIn: OptionalArgument<[AnyCodable]>

    public var contentHashContains: OptionalArgument<AnyCodable>

    public var contentHashNotContains: OptionalArgument<AnyCodable>

    public var tokenUri: OptionalArgument<String>

    public var tokenUriNot: OptionalArgument<String>

    public var tokenUriGt: OptionalArgument<String>

    public var tokenUriLt: OptionalArgument<String>

    public var tokenUriGte: OptionalArgument<String>

    public var tokenUriLte: OptionalArgument<String>

    public var tokenUriIn: OptionalArgument<[String]>

    public var tokenUriNotIn: OptionalArgument<[String]>

    public var tokenUriContains: OptionalArgument<String>

    public var tokenUriContainsNocase: OptionalArgument<String>

    public var tokenUriNotContains: OptionalArgument<String>

    public var tokenUriNotContainsNocase: OptionalArgument<String>

    public var tokenUriStartsWith: OptionalArgument<String>

    public var tokenUriStartsWithNocase: OptionalArgument<String>

    public var tokenUriNotStartsWith: OptionalArgument<String>

    public var tokenUriNotStartsWithNocase: OptionalArgument<String>

    public var tokenUriEndsWith: OptionalArgument<String>

    public var tokenUriEndsWithNocase: OptionalArgument<String>

    public var tokenUriNotEndsWith: OptionalArgument<String>

    public var tokenUriNotEndsWithNocase: OptionalArgument<String>
    /// Filter for the block changed event.
    public var _changeBlock: OptionalArgument<InputObjects.BlockChangedFilter>

    public var `and`: OptionalArgument<[OptionalArgument<InputObjects.GeoWebParcelFilter>]>

    public var `or`: OptionalArgument<[OptionalArgument<InputObjects.GeoWebParcelFilter>]>

    public init(
      id: OptionalArgument<String> = .init(),
      idNot: OptionalArgument<String> = .init(),
      idGt: OptionalArgument<String> = .init(),
      idLt: OptionalArgument<String> = .init(),
      idGte: OptionalArgument<String> = .init(),
      idLte: OptionalArgument<String> = .init(),
      idIn: OptionalArgument<[String]> = .init(),
      idNotIn: OptionalArgument<[String]> = .init(),
      createdAtBlock: OptionalArgument<AnyCodable> = .init(),
      createdAtBlockNot: OptionalArgument<AnyCodable> = .init(),
      createdAtBlockGt: OptionalArgument<AnyCodable> = .init(),
      createdAtBlockLt: OptionalArgument<AnyCodable> = .init(),
      createdAtBlockGte: OptionalArgument<AnyCodable> = .init(),
      createdAtBlockLte: OptionalArgument<AnyCodable> = .init(),
      createdAtBlockIn: OptionalArgument<[AnyCodable]> = .init(),
      createdAtBlockNotIn: OptionalArgument<[AnyCodable]> = .init(),
      licenseOwner: OptionalArgument<AnyCodable> = .init(),
      licenseOwnerNot: OptionalArgument<AnyCodable> = .init(),
      licenseOwnerGt: OptionalArgument<AnyCodable> = .init(),
      licenseOwnerLt: OptionalArgument<AnyCodable> = .init(),
      licenseOwnerGte: OptionalArgument<AnyCodable> = .init(),
      licenseOwnerLte: OptionalArgument<AnyCodable> = .init(),
      licenseOwnerIn: OptionalArgument<[AnyCodable]> = .init(),
      licenseOwnerNotIn: OptionalArgument<[AnyCodable]> = .init(),
      licenseOwnerContains: OptionalArgument<AnyCodable> = .init(),
      licenseOwnerNotContains: OptionalArgument<AnyCodable> = .init(),
      currentBid: OptionalArgument<String> = .init(),
      currentBidNot: OptionalArgument<String> = .init(),
      currentBidGt: OptionalArgument<String> = .init(),
      currentBidLt: OptionalArgument<String> = .init(),
      currentBidGte: OptionalArgument<String> = .init(),
      currentBidLte: OptionalArgument<String> = .init(),
      currentBidIn: OptionalArgument<[String]> = .init(),
      currentBidNotIn: OptionalArgument<[String]> = .init(),
      currentBidContains: OptionalArgument<String> = .init(),
      currentBidContainsNocase: OptionalArgument<String> = .init(),
      currentBidNotContains: OptionalArgument<String> = .init(),
      currentBidNotContainsNocase: OptionalArgument<String> = .init(),
      currentBidStartsWith: OptionalArgument<String> = .init(),
      currentBidStartsWithNocase: OptionalArgument<String> = .init(),
      currentBidNotStartsWith: OptionalArgument<String> = .init(),
      currentBidNotStartsWithNocase: OptionalArgument<String> = .init(),
      currentBidEndsWith: OptionalArgument<String> = .init(),
      currentBidEndsWithNocase: OptionalArgument<String> = .init(),
      currentBidNotEndsWith: OptionalArgument<String> = .init(),
      currentBidNotEndsWithNocase: OptionalArgument<String> = .init(),
      currentBid_: OptionalArgument<InputObjects.BidFilter> = .init(),
      pendingBid: OptionalArgument<String> = .init(),
      pendingBidNot: OptionalArgument<String> = .init(),
      pendingBidGt: OptionalArgument<String> = .init(),
      pendingBidLt: OptionalArgument<String> = .init(),
      pendingBidGte: OptionalArgument<String> = .init(),
      pendingBidLte: OptionalArgument<String> = .init(),
      pendingBidIn: OptionalArgument<[String]> = .init(),
      pendingBidNotIn: OptionalArgument<[String]> = .init(),
      pendingBidContains: OptionalArgument<String> = .init(),
      pendingBidContainsNocase: OptionalArgument<String> = .init(),
      pendingBidNotContains: OptionalArgument<String> = .init(),
      pendingBidNotContainsNocase: OptionalArgument<String> = .init(),
      pendingBidStartsWith: OptionalArgument<String> = .init(),
      pendingBidStartsWithNocase: OptionalArgument<String> = .init(),
      pendingBidNotStartsWith: OptionalArgument<String> = .init(),
      pendingBidNotStartsWithNocase: OptionalArgument<String> = .init(),
      pendingBidEndsWith: OptionalArgument<String> = .init(),
      pendingBidEndsWithNocase: OptionalArgument<String> = .init(),
      pendingBidNotEndsWith: OptionalArgument<String> = .init(),
      pendingBidNotEndsWithNocase: OptionalArgument<String> = .init(),
      pendingBid_: OptionalArgument<InputObjects.BidFilter> = .init(),
      licenseDiamond: OptionalArgument<AnyCodable> = .init(),
      licenseDiamondNot: OptionalArgument<AnyCodable> = .init(),
      licenseDiamondGt: OptionalArgument<AnyCodable> = .init(),
      licenseDiamondLt: OptionalArgument<AnyCodable> = .init(),
      licenseDiamondGte: OptionalArgument<AnyCodable> = .init(),
      licenseDiamondLte: OptionalArgument<AnyCodable> = .init(),
      licenseDiamondIn: OptionalArgument<[AnyCodable]> = .init(),
      licenseDiamondNotIn: OptionalArgument<[AnyCodable]> = .init(),
      licenseDiamondContains: OptionalArgument<AnyCodable> = .init(),
      licenseDiamondNotContains: OptionalArgument<AnyCodable> = .init(),
      coordinates: OptionalArgument<[AnyCodable]> = .init(),
      coordinatesNot: OptionalArgument<[AnyCodable]> = .init(),
      coordinatesContains: OptionalArgument<[AnyCodable]> = .init(),
      coordinatesContainsNocase: OptionalArgument<[AnyCodable]> = .init(),
      coordinatesNotContains: OptionalArgument<[AnyCodable]> = .init(),
      coordinatesNotContainsNocase: OptionalArgument<[AnyCodable]> = .init(),
      bboxN: OptionalArgument<AnyCodable> = .init(),
      bboxNNot: OptionalArgument<AnyCodable> = .init(),
      bboxNGt: OptionalArgument<AnyCodable> = .init(),
      bboxNLt: OptionalArgument<AnyCodable> = .init(),
      bboxNGte: OptionalArgument<AnyCodable> = .init(),
      bboxNLte: OptionalArgument<AnyCodable> = .init(),
      bboxNIn: OptionalArgument<[AnyCodable]> = .init(),
      bboxNNotIn: OptionalArgument<[AnyCodable]> = .init(),
      bboxS: OptionalArgument<AnyCodable> = .init(),
      bboxSNot: OptionalArgument<AnyCodable> = .init(),
      bboxSGt: OptionalArgument<AnyCodable> = .init(),
      bboxSLt: OptionalArgument<AnyCodable> = .init(),
      bboxSGte: OptionalArgument<AnyCodable> = .init(),
      bboxSLte: OptionalArgument<AnyCodable> = .init(),
      bboxSIn: OptionalArgument<[AnyCodable]> = .init(),
      bboxSNotIn: OptionalArgument<[AnyCodable]> = .init(),
      bboxE: OptionalArgument<AnyCodable> = .init(),
      bboxENot: OptionalArgument<AnyCodable> = .init(),
      bboxEGt: OptionalArgument<AnyCodable> = .init(),
      bboxELt: OptionalArgument<AnyCodable> = .init(),
      bboxEGte: OptionalArgument<AnyCodable> = .init(),
      bboxELte: OptionalArgument<AnyCodable> = .init(),
      bboxEIn: OptionalArgument<[AnyCodable]> = .init(),
      bboxENotIn: OptionalArgument<[AnyCodable]> = .init(),
      bboxW: OptionalArgument<AnyCodable> = .init(),
      bboxWNot: OptionalArgument<AnyCodable> = .init(),
      bboxWGt: OptionalArgument<AnyCodable> = .init(),
      bboxWLt: OptionalArgument<AnyCodable> = .init(),
      bboxWGte: OptionalArgument<AnyCodable> = .init(),
      bboxWLte: OptionalArgument<AnyCodable> = .init(),
      bboxWIn: OptionalArgument<[AnyCodable]> = .init(),
      bboxWNotIn: OptionalArgument<[AnyCodable]> = .init(),
      contentHash: OptionalArgument<AnyCodable> = .init(),
      contentHashNot: OptionalArgument<AnyCodable> = .init(),
      contentHashGt: OptionalArgument<AnyCodable> = .init(),
      contentHashLt: OptionalArgument<AnyCodable> = .init(),
      contentHashGte: OptionalArgument<AnyCodable> = .init(),
      contentHashLte: OptionalArgument<AnyCodable> = .init(),
      contentHashIn: OptionalArgument<[AnyCodable]> = .init(),
      contentHashNotIn: OptionalArgument<[AnyCodable]> = .init(),
      contentHashContains: OptionalArgument<AnyCodable> = .init(),
      contentHashNotContains: OptionalArgument<AnyCodable> = .init(),
      tokenUri: OptionalArgument<String> = .init(),
      tokenUriNot: OptionalArgument<String> = .init(),
      tokenUriGt: OptionalArgument<String> = .init(),
      tokenUriLt: OptionalArgument<String> = .init(),
      tokenUriGte: OptionalArgument<String> = .init(),
      tokenUriLte: OptionalArgument<String> = .init(),
      tokenUriIn: OptionalArgument<[String]> = .init(),
      tokenUriNotIn: OptionalArgument<[String]> = .init(),
      tokenUriContains: OptionalArgument<String> = .init(),
      tokenUriContainsNocase: OptionalArgument<String> = .init(),
      tokenUriNotContains: OptionalArgument<String> = .init(),
      tokenUriNotContainsNocase: OptionalArgument<String> = .init(),
      tokenUriStartsWith: OptionalArgument<String> = .init(),
      tokenUriStartsWithNocase: OptionalArgument<String> = .init(),
      tokenUriNotStartsWith: OptionalArgument<String> = .init(),
      tokenUriNotStartsWithNocase: OptionalArgument<String> = .init(),
      tokenUriEndsWith: OptionalArgument<String> = .init(),
      tokenUriEndsWithNocase: OptionalArgument<String> = .init(),
      tokenUriNotEndsWith: OptionalArgument<String> = .init(),
      tokenUriNotEndsWithNocase: OptionalArgument<String> = .init(),
      _changeBlock: OptionalArgument<InputObjects.BlockChangedFilter> = .init(),
      `and`: OptionalArgument<[OptionalArgument<InputObjects.GeoWebParcelFilter>]> = .init(),
      `or`: OptionalArgument<[OptionalArgument<InputObjects.GeoWebParcelFilter>]> = .init()
    ) {
      self.id = id
      self.idNot = idNot
      self.idGt = idGt
      self.idLt = idLt
      self.idGte = idGte
      self.idLte = idLte
      self.idIn = idIn
      self.idNotIn = idNotIn
      self.createdAtBlock = createdAtBlock
      self.createdAtBlockNot = createdAtBlockNot
      self.createdAtBlockGt = createdAtBlockGt
      self.createdAtBlockLt = createdAtBlockLt
      self.createdAtBlockGte = createdAtBlockGte
      self.createdAtBlockLte = createdAtBlockLte
      self.createdAtBlockIn = createdAtBlockIn
      self.createdAtBlockNotIn = createdAtBlockNotIn
      self.licenseOwner = licenseOwner
      self.licenseOwnerNot = licenseOwnerNot
      self.licenseOwnerGt = licenseOwnerGt
      self.licenseOwnerLt = licenseOwnerLt
      self.licenseOwnerGte = licenseOwnerGte
      self.licenseOwnerLte = licenseOwnerLte
      self.licenseOwnerIn = licenseOwnerIn
      self.licenseOwnerNotIn = licenseOwnerNotIn
      self.licenseOwnerContains = licenseOwnerContains
      self.licenseOwnerNotContains = licenseOwnerNotContains
      self.currentBid = currentBid
      self.currentBidNot = currentBidNot
      self.currentBidGt = currentBidGt
      self.currentBidLt = currentBidLt
      self.currentBidGte = currentBidGte
      self.currentBidLte = currentBidLte
      self.currentBidIn = currentBidIn
      self.currentBidNotIn = currentBidNotIn
      self.currentBidContains = currentBidContains
      self.currentBidContainsNocase = currentBidContainsNocase
      self.currentBidNotContains = currentBidNotContains
      self.currentBidNotContainsNocase = currentBidNotContainsNocase
      self.currentBidStartsWith = currentBidStartsWith
      self.currentBidStartsWithNocase = currentBidStartsWithNocase
      self.currentBidNotStartsWith = currentBidNotStartsWith
      self.currentBidNotStartsWithNocase = currentBidNotStartsWithNocase
      self.currentBidEndsWith = currentBidEndsWith
      self.currentBidEndsWithNocase = currentBidEndsWithNocase
      self.currentBidNotEndsWith = currentBidNotEndsWith
      self.currentBidNotEndsWithNocase = currentBidNotEndsWithNocase
      self.currentBid_ = currentBid_
      self.pendingBid = pendingBid
      self.pendingBidNot = pendingBidNot
      self.pendingBidGt = pendingBidGt
      self.pendingBidLt = pendingBidLt
      self.pendingBidGte = pendingBidGte
      self.pendingBidLte = pendingBidLte
      self.pendingBidIn = pendingBidIn
      self.pendingBidNotIn = pendingBidNotIn
      self.pendingBidContains = pendingBidContains
      self.pendingBidContainsNocase = pendingBidContainsNocase
      self.pendingBidNotContains = pendingBidNotContains
      self.pendingBidNotContainsNocase = pendingBidNotContainsNocase
      self.pendingBidStartsWith = pendingBidStartsWith
      self.pendingBidStartsWithNocase = pendingBidStartsWithNocase
      self.pendingBidNotStartsWith = pendingBidNotStartsWith
      self.pendingBidNotStartsWithNocase = pendingBidNotStartsWithNocase
      self.pendingBidEndsWith = pendingBidEndsWith
      self.pendingBidEndsWithNocase = pendingBidEndsWithNocase
      self.pendingBidNotEndsWith = pendingBidNotEndsWith
      self.pendingBidNotEndsWithNocase = pendingBidNotEndsWithNocase
      self.pendingBid_ = pendingBid_
      self.licenseDiamond = licenseDiamond
      self.licenseDiamondNot = licenseDiamondNot
      self.licenseDiamondGt = licenseDiamondGt
      self.licenseDiamondLt = licenseDiamondLt
      self.licenseDiamondGte = licenseDiamondGte
      self.licenseDiamondLte = licenseDiamondLte
      self.licenseDiamondIn = licenseDiamondIn
      self.licenseDiamondNotIn = licenseDiamondNotIn
      self.licenseDiamondContains = licenseDiamondContains
      self.licenseDiamondNotContains = licenseDiamondNotContains
      self.coordinates = coordinates
      self.coordinatesNot = coordinatesNot
      self.coordinatesContains = coordinatesContains
      self.coordinatesContainsNocase = coordinatesContainsNocase
      self.coordinatesNotContains = coordinatesNotContains
      self.coordinatesNotContainsNocase = coordinatesNotContainsNocase
      self.bboxN = bboxN
      self.bboxNNot = bboxNNot
      self.bboxNGt = bboxNGt
      self.bboxNLt = bboxNLt
      self.bboxNGte = bboxNGte
      self.bboxNLte = bboxNLte
      self.bboxNIn = bboxNIn
      self.bboxNNotIn = bboxNNotIn
      self.bboxS = bboxS
      self.bboxSNot = bboxSNot
      self.bboxSGt = bboxSGt
      self.bboxSLt = bboxSLt
      self.bboxSGte = bboxSGte
      self.bboxSLte = bboxSLte
      self.bboxSIn = bboxSIn
      self.bboxSNotIn = bboxSNotIn
      self.bboxE = bboxE
      self.bboxENot = bboxENot
      self.bboxEGt = bboxEGt
      self.bboxELt = bboxELt
      self.bboxEGte = bboxEGte
      self.bboxELte = bboxELte
      self.bboxEIn = bboxEIn
      self.bboxENotIn = bboxENotIn
      self.bboxW = bboxW
      self.bboxWNot = bboxWNot
      self.bboxWGt = bboxWGt
      self.bboxWLt = bboxWLt
      self.bboxWGte = bboxWGte
      self.bboxWLte = bboxWLte
      self.bboxWIn = bboxWIn
      self.bboxWNotIn = bboxWNotIn
      self.contentHash = contentHash
      self.contentHashNot = contentHashNot
      self.contentHashGt = contentHashGt
      self.contentHashLt = contentHashLt
      self.contentHashGte = contentHashGte
      self.contentHashLte = contentHashLte
      self.contentHashIn = contentHashIn
      self.contentHashNotIn = contentHashNotIn
      self.contentHashContains = contentHashContains
      self.contentHashNotContains = contentHashNotContains
      self.tokenUri = tokenUri
      self.tokenUriNot = tokenUriNot
      self.tokenUriGt = tokenUriGt
      self.tokenUriLt = tokenUriLt
      self.tokenUriGte = tokenUriGte
      self.tokenUriLte = tokenUriLte
      self.tokenUriIn = tokenUriIn
      self.tokenUriNotIn = tokenUriNotIn
      self.tokenUriContains = tokenUriContains
      self.tokenUriContainsNocase = tokenUriContainsNocase
      self.tokenUriNotContains = tokenUriNotContains
      self.tokenUriNotContainsNocase = tokenUriNotContainsNocase
      self.tokenUriStartsWith = tokenUriStartsWith
      self.tokenUriStartsWithNocase = tokenUriStartsWithNocase
      self.tokenUriNotStartsWith = tokenUriNotStartsWith
      self.tokenUriNotStartsWithNocase = tokenUriNotStartsWithNocase
      self.tokenUriEndsWith = tokenUriEndsWith
      self.tokenUriEndsWithNocase = tokenUriEndsWithNocase
      self.tokenUriNotEndsWith = tokenUriNotEndsWith
      self.tokenUriNotEndsWithNocase = tokenUriNotEndsWithNocase
      self._changeBlock = _changeBlock
      self.`and` = `and`
      self.`or` = `or`
    }

    public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      if id.hasValue { try container.encode(id, forKey: .id) }
      if idNot.hasValue { try container.encode(idNot, forKey: .idNot) }
      if idGt.hasValue { try container.encode(idGt, forKey: .idGt) }
      if idLt.hasValue { try container.encode(idLt, forKey: .idLt) }
      if idGte.hasValue { try container.encode(idGte, forKey: .idGte) }
      if idLte.hasValue { try container.encode(idLte, forKey: .idLte) }
      if idIn.hasValue { try container.encode(idIn, forKey: .idIn) }
      if idNotIn.hasValue { try container.encode(idNotIn, forKey: .idNotIn) }
      if createdAtBlock.hasValue { try container.encode(createdAtBlock, forKey: .createdAtBlock) }
      if createdAtBlockNot.hasValue {
        try container.encode(createdAtBlockNot, forKey: .createdAtBlockNot)
      }
      if createdAtBlockGt.hasValue {
        try container.encode(createdAtBlockGt, forKey: .createdAtBlockGt)
      }
      if createdAtBlockLt.hasValue {
        try container.encode(createdAtBlockLt, forKey: .createdAtBlockLt)
      }
      if createdAtBlockGte.hasValue {
        try container.encode(createdAtBlockGte, forKey: .createdAtBlockGte)
      }
      if createdAtBlockLte.hasValue {
        try container.encode(createdAtBlockLte, forKey: .createdAtBlockLte)
      }
      if createdAtBlockIn.hasValue {
        try container.encode(createdAtBlockIn, forKey: .createdAtBlockIn)
      }
      if createdAtBlockNotIn.hasValue {
        try container.encode(createdAtBlockNotIn, forKey: .createdAtBlockNotIn)
      }
      if licenseOwner.hasValue { try container.encode(licenseOwner, forKey: .licenseOwner) }
      if licenseOwnerNot.hasValue {
        try container.encode(licenseOwnerNot, forKey: .licenseOwnerNot)
      }
      if licenseOwnerGt.hasValue { try container.encode(licenseOwnerGt, forKey: .licenseOwnerGt) }
      if licenseOwnerLt.hasValue { try container.encode(licenseOwnerLt, forKey: .licenseOwnerLt) }
      if licenseOwnerGte.hasValue {
        try container.encode(licenseOwnerGte, forKey: .licenseOwnerGte)
      }
      if licenseOwnerLte.hasValue {
        try container.encode(licenseOwnerLte, forKey: .licenseOwnerLte)
      }
      if licenseOwnerIn.hasValue { try container.encode(licenseOwnerIn, forKey: .licenseOwnerIn) }
      if licenseOwnerNotIn.hasValue {
        try container.encode(licenseOwnerNotIn, forKey: .licenseOwnerNotIn)
      }
      if licenseOwnerContains.hasValue {
        try container.encode(licenseOwnerContains, forKey: .licenseOwnerContains)
      }
      if licenseOwnerNotContains.hasValue {
        try container.encode(licenseOwnerNotContains, forKey: .licenseOwnerNotContains)
      }
      if currentBid.hasValue { try container.encode(currentBid, forKey: .currentBid) }
      if currentBidNot.hasValue { try container.encode(currentBidNot, forKey: .currentBidNot) }
      if currentBidGt.hasValue { try container.encode(currentBidGt, forKey: .currentBidGt) }
      if currentBidLt.hasValue { try container.encode(currentBidLt, forKey: .currentBidLt) }
      if currentBidGte.hasValue { try container.encode(currentBidGte, forKey: .currentBidGte) }
      if currentBidLte.hasValue { try container.encode(currentBidLte, forKey: .currentBidLte) }
      if currentBidIn.hasValue { try container.encode(currentBidIn, forKey: .currentBidIn) }
      if currentBidNotIn.hasValue {
        try container.encode(currentBidNotIn, forKey: .currentBidNotIn)
      }
      if currentBidContains.hasValue {
        try container.encode(currentBidContains, forKey: .currentBidContains)
      }
      if currentBidContainsNocase.hasValue {
        try container.encode(currentBidContainsNocase, forKey: .currentBidContainsNocase)
      }
      if currentBidNotContains.hasValue {
        try container.encode(currentBidNotContains, forKey: .currentBidNotContains)
      }
      if currentBidNotContainsNocase.hasValue {
        try container.encode(currentBidNotContainsNocase, forKey: .currentBidNotContainsNocase)
      }
      if currentBidStartsWith.hasValue {
        try container.encode(currentBidStartsWith, forKey: .currentBidStartsWith)
      }
      if currentBidStartsWithNocase.hasValue {
        try container.encode(currentBidStartsWithNocase, forKey: .currentBidStartsWithNocase)
      }
      if currentBidNotStartsWith.hasValue {
        try container.encode(currentBidNotStartsWith, forKey: .currentBidNotStartsWith)
      }
      if currentBidNotStartsWithNocase.hasValue {
        try container.encode(currentBidNotStartsWithNocase, forKey: .currentBidNotStartsWithNocase)
      }
      if currentBidEndsWith.hasValue {
        try container.encode(currentBidEndsWith, forKey: .currentBidEndsWith)
      }
      if currentBidEndsWithNocase.hasValue {
        try container.encode(currentBidEndsWithNocase, forKey: .currentBidEndsWithNocase)
      }
      if currentBidNotEndsWith.hasValue {
        try container.encode(currentBidNotEndsWith, forKey: .currentBidNotEndsWith)
      }
      if currentBidNotEndsWithNocase.hasValue {
        try container.encode(currentBidNotEndsWithNocase, forKey: .currentBidNotEndsWithNocase)
      }
      if currentBid_.hasValue { try container.encode(currentBid_, forKey: .currentBid_) }
      if pendingBid.hasValue { try container.encode(pendingBid, forKey: .pendingBid) }
      if pendingBidNot.hasValue { try container.encode(pendingBidNot, forKey: .pendingBidNot) }
      if pendingBidGt.hasValue { try container.encode(pendingBidGt, forKey: .pendingBidGt) }
      if pendingBidLt.hasValue { try container.encode(pendingBidLt, forKey: .pendingBidLt) }
      if pendingBidGte.hasValue { try container.encode(pendingBidGte, forKey: .pendingBidGte) }
      if pendingBidLte.hasValue { try container.encode(pendingBidLte, forKey: .pendingBidLte) }
      if pendingBidIn.hasValue { try container.encode(pendingBidIn, forKey: .pendingBidIn) }
      if pendingBidNotIn.hasValue {
        try container.encode(pendingBidNotIn, forKey: .pendingBidNotIn)
      }
      if pendingBidContains.hasValue {
        try container.encode(pendingBidContains, forKey: .pendingBidContains)
      }
      if pendingBidContainsNocase.hasValue {
        try container.encode(pendingBidContainsNocase, forKey: .pendingBidContainsNocase)
      }
      if pendingBidNotContains.hasValue {
        try container.encode(pendingBidNotContains, forKey: .pendingBidNotContains)
      }
      if pendingBidNotContainsNocase.hasValue {
        try container.encode(pendingBidNotContainsNocase, forKey: .pendingBidNotContainsNocase)
      }
      if pendingBidStartsWith.hasValue {
        try container.encode(pendingBidStartsWith, forKey: .pendingBidStartsWith)
      }
      if pendingBidStartsWithNocase.hasValue {
        try container.encode(pendingBidStartsWithNocase, forKey: .pendingBidStartsWithNocase)
      }
      if pendingBidNotStartsWith.hasValue {
        try container.encode(pendingBidNotStartsWith, forKey: .pendingBidNotStartsWith)
      }
      if pendingBidNotStartsWithNocase.hasValue {
        try container.encode(pendingBidNotStartsWithNocase, forKey: .pendingBidNotStartsWithNocase)
      }
      if pendingBidEndsWith.hasValue {
        try container.encode(pendingBidEndsWith, forKey: .pendingBidEndsWith)
      }
      if pendingBidEndsWithNocase.hasValue {
        try container.encode(pendingBidEndsWithNocase, forKey: .pendingBidEndsWithNocase)
      }
      if pendingBidNotEndsWith.hasValue {
        try container.encode(pendingBidNotEndsWith, forKey: .pendingBidNotEndsWith)
      }
      if pendingBidNotEndsWithNocase.hasValue {
        try container.encode(pendingBidNotEndsWithNocase, forKey: .pendingBidNotEndsWithNocase)
      }
      if pendingBid_.hasValue { try container.encode(pendingBid_, forKey: .pendingBid_) }
      if licenseDiamond.hasValue { try container.encode(licenseDiamond, forKey: .licenseDiamond) }
      if licenseDiamondNot.hasValue {
        try container.encode(licenseDiamondNot, forKey: .licenseDiamondNot)
      }
      if licenseDiamondGt.hasValue {
        try container.encode(licenseDiamondGt, forKey: .licenseDiamondGt)
      }
      if licenseDiamondLt.hasValue {
        try container.encode(licenseDiamondLt, forKey: .licenseDiamondLt)
      }
      if licenseDiamondGte.hasValue {
        try container.encode(licenseDiamondGte, forKey: .licenseDiamondGte)
      }
      if licenseDiamondLte.hasValue {
        try container.encode(licenseDiamondLte, forKey: .licenseDiamondLte)
      }
      if licenseDiamondIn.hasValue {
        try container.encode(licenseDiamondIn, forKey: .licenseDiamondIn)
      }
      if licenseDiamondNotIn.hasValue {
        try container.encode(licenseDiamondNotIn, forKey: .licenseDiamondNotIn)
      }
      if licenseDiamondContains.hasValue {
        try container.encode(licenseDiamondContains, forKey: .licenseDiamondContains)
      }
      if licenseDiamondNotContains.hasValue {
        try container.encode(licenseDiamondNotContains, forKey: .licenseDiamondNotContains)
      }
      if coordinates.hasValue { try container.encode(coordinates, forKey: .coordinates) }
      if coordinatesNot.hasValue { try container.encode(coordinatesNot, forKey: .coordinatesNot) }
      if coordinatesContains.hasValue {
        try container.encode(coordinatesContains, forKey: .coordinatesContains)
      }
      if coordinatesContainsNocase.hasValue {
        try container.encode(coordinatesContainsNocase, forKey: .coordinatesContainsNocase)
      }
      if coordinatesNotContains.hasValue {
        try container.encode(coordinatesNotContains, forKey: .coordinatesNotContains)
      }
      if coordinatesNotContainsNocase.hasValue {
        try container.encode(coordinatesNotContainsNocase, forKey: .coordinatesNotContainsNocase)
      }
      if bboxN.hasValue { try container.encode(bboxN, forKey: .bboxN) }
      if bboxNNot.hasValue { try container.encode(bboxNNot, forKey: .bboxNNot) }
      if bboxNGt.hasValue { try container.encode(bboxNGt, forKey: .bboxNGt) }
      if bboxNLt.hasValue { try container.encode(bboxNLt, forKey: .bboxNLt) }
      if bboxNGte.hasValue { try container.encode(bboxNGte, forKey: .bboxNGte) }
      if bboxNLte.hasValue { try container.encode(bboxNLte, forKey: .bboxNLte) }
      if bboxNIn.hasValue { try container.encode(bboxNIn, forKey: .bboxNIn) }
      if bboxNNotIn.hasValue { try container.encode(bboxNNotIn, forKey: .bboxNNotIn) }
      if bboxS.hasValue { try container.encode(bboxS, forKey: .bboxS) }
      if bboxSNot.hasValue { try container.encode(bboxSNot, forKey: .bboxSNot) }
      if bboxSGt.hasValue { try container.encode(bboxSGt, forKey: .bboxSGt) }
      if bboxSLt.hasValue { try container.encode(bboxSLt, forKey: .bboxSLt) }
      if bboxSGte.hasValue { try container.encode(bboxSGte, forKey: .bboxSGte) }
      if bboxSLte.hasValue { try container.encode(bboxSLte, forKey: .bboxSLte) }
      if bboxSIn.hasValue { try container.encode(bboxSIn, forKey: .bboxSIn) }
      if bboxSNotIn.hasValue { try container.encode(bboxSNotIn, forKey: .bboxSNotIn) }
      if bboxE.hasValue { try container.encode(bboxE, forKey: .bboxE) }
      if bboxENot.hasValue { try container.encode(bboxENot, forKey: .bboxENot) }
      if bboxEGt.hasValue { try container.encode(bboxEGt, forKey: .bboxEGt) }
      if bboxELt.hasValue { try container.encode(bboxELt, forKey: .bboxELt) }
      if bboxEGte.hasValue { try container.encode(bboxEGte, forKey: .bboxEGte) }
      if bboxELte.hasValue { try container.encode(bboxELte, forKey: .bboxELte) }
      if bboxEIn.hasValue { try container.encode(bboxEIn, forKey: .bboxEIn) }
      if bboxENotIn.hasValue { try container.encode(bboxENotIn, forKey: .bboxENotIn) }
      if bboxW.hasValue { try container.encode(bboxW, forKey: .bboxW) }
      if bboxWNot.hasValue { try container.encode(bboxWNot, forKey: .bboxWNot) }
      if bboxWGt.hasValue { try container.encode(bboxWGt, forKey: .bboxWGt) }
      if bboxWLt.hasValue { try container.encode(bboxWLt, forKey: .bboxWLt) }
      if bboxWGte.hasValue { try container.encode(bboxWGte, forKey: .bboxWGte) }
      if bboxWLte.hasValue { try container.encode(bboxWLte, forKey: .bboxWLte) }
      if bboxWIn.hasValue { try container.encode(bboxWIn, forKey: .bboxWIn) }
      if bboxWNotIn.hasValue { try container.encode(bboxWNotIn, forKey: .bboxWNotIn) }
      if contentHash.hasValue { try container.encode(contentHash, forKey: .contentHash) }
      if contentHashNot.hasValue { try container.encode(contentHashNot, forKey: .contentHashNot) }
      if contentHashGt.hasValue { try container.encode(contentHashGt, forKey: .contentHashGt) }
      if contentHashLt.hasValue { try container.encode(contentHashLt, forKey: .contentHashLt) }
      if contentHashGte.hasValue { try container.encode(contentHashGte, forKey: .contentHashGte) }
      if contentHashLte.hasValue { try container.encode(contentHashLte, forKey: .contentHashLte) }
      if contentHashIn.hasValue { try container.encode(contentHashIn, forKey: .contentHashIn) }
      if contentHashNotIn.hasValue {
        try container.encode(contentHashNotIn, forKey: .contentHashNotIn)
      }
      if contentHashContains.hasValue {
        try container.encode(contentHashContains, forKey: .contentHashContains)
      }
      if contentHashNotContains.hasValue {
        try container.encode(contentHashNotContains, forKey: .contentHashNotContains)
      }
      if tokenUri.hasValue { try container.encode(tokenUri, forKey: .tokenUri) }
      if tokenUriNot.hasValue { try container.encode(tokenUriNot, forKey: .tokenUriNot) }
      if tokenUriGt.hasValue { try container.encode(tokenUriGt, forKey: .tokenUriGt) }
      if tokenUriLt.hasValue { try container.encode(tokenUriLt, forKey: .tokenUriLt) }
      if tokenUriGte.hasValue { try container.encode(tokenUriGte, forKey: .tokenUriGte) }
      if tokenUriLte.hasValue { try container.encode(tokenUriLte, forKey: .tokenUriLte) }
      if tokenUriIn.hasValue { try container.encode(tokenUriIn, forKey: .tokenUriIn) }
      if tokenUriNotIn.hasValue { try container.encode(tokenUriNotIn, forKey: .tokenUriNotIn) }
      if tokenUriContains.hasValue {
        try container.encode(tokenUriContains, forKey: .tokenUriContains)
      }
      if tokenUriContainsNocase.hasValue {
        try container.encode(tokenUriContainsNocase, forKey: .tokenUriContainsNocase)
      }
      if tokenUriNotContains.hasValue {
        try container.encode(tokenUriNotContains, forKey: .tokenUriNotContains)
      }
      if tokenUriNotContainsNocase.hasValue {
        try container.encode(tokenUriNotContainsNocase, forKey: .tokenUriNotContainsNocase)
      }
      if tokenUriStartsWith.hasValue {
        try container.encode(tokenUriStartsWith, forKey: .tokenUriStartsWith)
      }
      if tokenUriStartsWithNocase.hasValue {
        try container.encode(tokenUriStartsWithNocase, forKey: .tokenUriStartsWithNocase)
      }
      if tokenUriNotStartsWith.hasValue {
        try container.encode(tokenUriNotStartsWith, forKey: .tokenUriNotStartsWith)
      }
      if tokenUriNotStartsWithNocase.hasValue {
        try container.encode(tokenUriNotStartsWithNocase, forKey: .tokenUriNotStartsWithNocase)
      }
      if tokenUriEndsWith.hasValue {
        try container.encode(tokenUriEndsWith, forKey: .tokenUriEndsWith)
      }
      if tokenUriEndsWithNocase.hasValue {
        try container.encode(tokenUriEndsWithNocase, forKey: .tokenUriEndsWithNocase)
      }
      if tokenUriNotEndsWith.hasValue {
        try container.encode(tokenUriNotEndsWith, forKey: .tokenUriNotEndsWith)
      }
      if tokenUriNotEndsWithNocase.hasValue {
        try container.encode(tokenUriNotEndsWithNocase, forKey: .tokenUriNotEndsWithNocase)
      }
      if _changeBlock.hasValue { try container.encode(_changeBlock, forKey: ._changeBlock) }
      if `and`.hasValue { try container.encode(`and`, forKey: .`and`) }
      if `or`.hasValue { try container.encode(`or`, forKey: .`or`) }
    }

    public enum CodingKeys: String, CodingKey {
      case id = "id"
      case idNot = "id_not"
      case idGt = "id_gt"
      case idLt = "id_lt"
      case idGte = "id_gte"
      case idLte = "id_lte"
      case idIn = "id_in"
      case idNotIn = "id_not_in"
      case createdAtBlock = "createdAtBlock"
      case createdAtBlockNot = "createdAtBlock_not"
      case createdAtBlockGt = "createdAtBlock_gt"
      case createdAtBlockLt = "createdAtBlock_lt"
      case createdAtBlockGte = "createdAtBlock_gte"
      case createdAtBlockLte = "createdAtBlock_lte"
      case createdAtBlockIn = "createdAtBlock_in"
      case createdAtBlockNotIn = "createdAtBlock_not_in"
      case licenseOwner = "licenseOwner"
      case licenseOwnerNot = "licenseOwner_not"
      case licenseOwnerGt = "licenseOwner_gt"
      case licenseOwnerLt = "licenseOwner_lt"
      case licenseOwnerGte = "licenseOwner_gte"
      case licenseOwnerLte = "licenseOwner_lte"
      case licenseOwnerIn = "licenseOwner_in"
      case licenseOwnerNotIn = "licenseOwner_not_in"
      case licenseOwnerContains = "licenseOwner_contains"
      case licenseOwnerNotContains = "licenseOwner_not_contains"
      case currentBid = "currentBid"
      case currentBidNot = "currentBid_not"
      case currentBidGt = "currentBid_gt"
      case currentBidLt = "currentBid_lt"
      case currentBidGte = "currentBid_gte"
      case currentBidLte = "currentBid_lte"
      case currentBidIn = "currentBid_in"
      case currentBidNotIn = "currentBid_not_in"
      case currentBidContains = "currentBid_contains"
      case currentBidContainsNocase = "currentBid_contains_nocase"
      case currentBidNotContains = "currentBid_not_contains"
      case currentBidNotContainsNocase = "currentBid_not_contains_nocase"
      case currentBidStartsWith = "currentBid_starts_with"
      case currentBidStartsWithNocase = "currentBid_starts_with_nocase"
      case currentBidNotStartsWith = "currentBid_not_starts_with"
      case currentBidNotStartsWithNocase = "currentBid_not_starts_with_nocase"
      case currentBidEndsWith = "currentBid_ends_with"
      case currentBidEndsWithNocase = "currentBid_ends_with_nocase"
      case currentBidNotEndsWith = "currentBid_not_ends_with"
      case currentBidNotEndsWithNocase = "currentBid_not_ends_with_nocase"
      case currentBid_ = "currentBid_"
      case pendingBid = "pendingBid"
      case pendingBidNot = "pendingBid_not"
      case pendingBidGt = "pendingBid_gt"
      case pendingBidLt = "pendingBid_lt"
      case pendingBidGte = "pendingBid_gte"
      case pendingBidLte = "pendingBid_lte"
      case pendingBidIn = "pendingBid_in"
      case pendingBidNotIn = "pendingBid_not_in"
      case pendingBidContains = "pendingBid_contains"
      case pendingBidContainsNocase = "pendingBid_contains_nocase"
      case pendingBidNotContains = "pendingBid_not_contains"
      case pendingBidNotContainsNocase = "pendingBid_not_contains_nocase"
      case pendingBidStartsWith = "pendingBid_starts_with"
      case pendingBidStartsWithNocase = "pendingBid_starts_with_nocase"
      case pendingBidNotStartsWith = "pendingBid_not_starts_with"
      case pendingBidNotStartsWithNocase = "pendingBid_not_starts_with_nocase"
      case pendingBidEndsWith = "pendingBid_ends_with"
      case pendingBidEndsWithNocase = "pendingBid_ends_with_nocase"
      case pendingBidNotEndsWith = "pendingBid_not_ends_with"
      case pendingBidNotEndsWithNocase = "pendingBid_not_ends_with_nocase"
      case pendingBid_ = "pendingBid_"
      case licenseDiamond = "licenseDiamond"
      case licenseDiamondNot = "licenseDiamond_not"
      case licenseDiamondGt = "licenseDiamond_gt"
      case licenseDiamondLt = "licenseDiamond_lt"
      case licenseDiamondGte = "licenseDiamond_gte"
      case licenseDiamondLte = "licenseDiamond_lte"
      case licenseDiamondIn = "licenseDiamond_in"
      case licenseDiamondNotIn = "licenseDiamond_not_in"
      case licenseDiamondContains = "licenseDiamond_contains"
      case licenseDiamondNotContains = "licenseDiamond_not_contains"
      case coordinates = "coordinates"
      case coordinatesNot = "coordinates_not"
      case coordinatesContains = "coordinates_contains"
      case coordinatesContainsNocase = "coordinates_contains_nocase"
      case coordinatesNotContains = "coordinates_not_contains"
      case coordinatesNotContainsNocase = "coordinates_not_contains_nocase"
      case bboxN = "bboxN"
      case bboxNNot = "bboxN_not"
      case bboxNGt = "bboxN_gt"
      case bboxNLt = "bboxN_lt"
      case bboxNGte = "bboxN_gte"
      case bboxNLte = "bboxN_lte"
      case bboxNIn = "bboxN_in"
      case bboxNNotIn = "bboxN_not_in"
      case bboxS = "bboxS"
      case bboxSNot = "bboxS_not"
      case bboxSGt = "bboxS_gt"
      case bboxSLt = "bboxS_lt"
      case bboxSGte = "bboxS_gte"
      case bboxSLte = "bboxS_lte"
      case bboxSIn = "bboxS_in"
      case bboxSNotIn = "bboxS_not_in"
      case bboxE = "bboxE"
      case bboxENot = "bboxE_not"
      case bboxEGt = "bboxE_gt"
      case bboxELt = "bboxE_lt"
      case bboxEGte = "bboxE_gte"
      case bboxELte = "bboxE_lte"
      case bboxEIn = "bboxE_in"
      case bboxENotIn = "bboxE_not_in"
      case bboxW = "bboxW"
      case bboxWNot = "bboxW_not"
      case bboxWGt = "bboxW_gt"
      case bboxWLt = "bboxW_lt"
      case bboxWGte = "bboxW_gte"
      case bboxWLte = "bboxW_lte"
      case bboxWIn = "bboxW_in"
      case bboxWNotIn = "bboxW_not_in"
      case contentHash = "contentHash"
      case contentHashNot = "contentHash_not"
      case contentHashGt = "contentHash_gt"
      case contentHashLt = "contentHash_lt"
      case contentHashGte = "contentHash_gte"
      case contentHashLte = "contentHash_lte"
      case contentHashIn = "contentHash_in"
      case contentHashNotIn = "contentHash_not_in"
      case contentHashContains = "contentHash_contains"
      case contentHashNotContains = "contentHash_not_contains"
      case tokenUri = "tokenURI"
      case tokenUriNot = "tokenURI_not"
      case tokenUriGt = "tokenURI_gt"
      case tokenUriLt = "tokenURI_lt"
      case tokenUriGte = "tokenURI_gte"
      case tokenUriLte = "tokenURI_lte"
      case tokenUriIn = "tokenURI_in"
      case tokenUriNotIn = "tokenURI_not_in"
      case tokenUriContains = "tokenURI_contains"
      case tokenUriContainsNocase = "tokenURI_contains_nocase"
      case tokenUriNotContains = "tokenURI_not_contains"
      case tokenUriNotContainsNocase = "tokenURI_not_contains_nocase"
      case tokenUriStartsWith = "tokenURI_starts_with"
      case tokenUriStartsWithNocase = "tokenURI_starts_with_nocase"
      case tokenUriNotStartsWith = "tokenURI_not_starts_with"
      case tokenUriNotStartsWithNocase = "tokenURI_not_starts_with_nocase"
      case tokenUriEndsWith = "tokenURI_ends_with"
      case tokenUriEndsWithNocase = "tokenURI_ends_with_nocase"
      case tokenUriNotEndsWith = "tokenURI_not_ends_with"
      case tokenUriNotEndsWithNocase = "tokenURI_not_ends_with_nocase"
      case _changeBlock = "_change_block"
      case `and` = "and"
      case `or` = "or"
    }
  }
}