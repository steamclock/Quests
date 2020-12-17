// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class AuthenticateQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query Authenticate {
      viewer {
        __typename
        login
      }
    }
    """

  public let operationName: String = "Authenticate"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("viewer", type: .nonNull(.object(Viewer.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(viewer: Viewer) {
      self.init(unsafeResultMap: ["__typename": "Query", "viewer": viewer.resultMap])
    }

    /// The currently authenticated user.
    public var viewer: Viewer {
      get {
        return Viewer(unsafeResultMap: resultMap["viewer"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "viewer")
      }
    }

    public struct Viewer: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["User"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("login", type: .nonNull(.scalar(String.self))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(login: String) {
        self.init(unsafeResultMap: ["__typename": "User", "login": login])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// The username used to login.
      public var login: String {
        get {
          return resultMap["login"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "login")
        }
      }
    }
  }
}

public final class GetTicketsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query GetTickets($queryString: String!, $after: String) {
      search(first: 50, type: ISSUE, query: $queryString, after: $after) {
        __typename
        issueCount
        pageInfo {
          __typename
          hasNextPage
          endCursor
        }
        edges {
          __typename
          node {
            __typename
            ... on PullRequest {
              ...PRDetails
            }
            ... on Issue {
              ...IssueDetails
            }
          }
        }
      }
    }
    """

  public let operationName: String = "GetTickets"

  public var queryDocument: String { return operationDefinition.appending(PrDetails.fragmentDefinition).appending(AssignedDetails.fragmentDefinition).appending(LabelDetails.fragmentDefinition).appending(IssueDetails.fragmentDefinition) }

  public var queryString: String
  public var after: String?

  public init(queryString: String, after: String? = nil) {
    self.queryString = queryString
    self.after = after
  }

  public var variables: GraphQLMap? {
    return ["queryString": queryString, "after": after]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("search", arguments: ["first": 50, "type": "ISSUE", "query": GraphQLVariable("queryString"), "after": GraphQLVariable("after")], type: .nonNull(.object(Search.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(search: Search) {
      self.init(unsafeResultMap: ["__typename": "Query", "search": search.resultMap])
    }

    /// Perform a search across resources.
    public var search: Search {
      get {
        return Search(unsafeResultMap: resultMap["search"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "search")
      }
    }

    public struct Search: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["SearchResultItemConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("issueCount", type: .nonNull(.scalar(Int.self))),
        GraphQLField("pageInfo", type: .nonNull(.object(PageInfo.selections))),
        GraphQLField("edges", type: .list(.object(Edge.selections))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(issueCount: Int, pageInfo: PageInfo, edges: [Edge?]? = nil) {
        self.init(unsafeResultMap: ["__typename": "SearchResultItemConnection", "issueCount": issueCount, "pageInfo": pageInfo.resultMap, "edges": edges.flatMap { (value: [Edge?]) -> [ResultMap?] in value.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } } }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// The number of issues that matched the search query.
      public var issueCount: Int {
        get {
          return resultMap["issueCount"]! as! Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "issueCount")
        }
      }

      /// Information to aid in pagination.
      public var pageInfo: PageInfo {
        get {
          return PageInfo(unsafeResultMap: resultMap["pageInfo"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "pageInfo")
        }
      }

      /// A list of edges.
      public var edges: [Edge?]? {
        get {
          return (resultMap["edges"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Edge?] in value.map { (value: ResultMap?) -> Edge? in value.flatMap { (value: ResultMap) -> Edge in Edge(unsafeResultMap: value) } } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [Edge?]) -> [ResultMap?] in value.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } } }, forKey: "edges")
        }
      }

      public struct PageInfo: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["PageInfo"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("hasNextPage", type: .nonNull(.scalar(Bool.self))),
          GraphQLField("endCursor", type: .scalar(String.self)),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(hasNextPage: Bool, endCursor: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "PageInfo", "hasNextPage": hasNextPage, "endCursor": endCursor])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// When paginating forwards, are there more items?
        public var hasNextPage: Bool {
          get {
            return resultMap["hasNextPage"]! as! Bool
          }
          set {
            resultMap.updateValue(newValue, forKey: "hasNextPage")
          }
        }

        /// When paginating forwards, the cursor to continue.
        public var endCursor: String? {
          get {
            return resultMap["endCursor"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "endCursor")
          }
        }
      }

      public struct Edge: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["SearchResultItemEdge"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("node", type: .object(Node.selections)),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(node: Node? = nil) {
          self.init(unsafeResultMap: ["__typename": "SearchResultItemEdge", "node": node.flatMap { (value: Node) -> ResultMap in value.resultMap }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// The item at the end of the edge.
        public var node: Node? {
          get {
            return (resultMap["node"] as? ResultMap).flatMap { Node(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "node")
          }
        }

        public struct Node: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Issue", "PullRequest", "Repository", "User", "Organization", "MarketplaceListing"]

          public static let selections: [GraphQLSelection] = [
            GraphQLTypeCase(
              variants: ["PullRequest": AsPullRequest.selections, "Issue": AsIssue.selections],
              default: [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              ]
            )
          ]

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public static func makeRepository() -> Node {
            return Node(unsafeResultMap: ["__typename": "Repository"])
          }

          public static func makeUser() -> Node {
            return Node(unsafeResultMap: ["__typename": "User"])
          }

          public static func makeOrganization() -> Node {
            return Node(unsafeResultMap: ["__typename": "Organization"])
          }

          public static func makeMarketplaceListing() -> Node {
            return Node(unsafeResultMap: ["__typename": "MarketplaceListing"])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var asPullRequest: AsPullRequest? {
            get {
              if !AsPullRequest.possibleTypes.contains(__typename) { return nil }
              return AsPullRequest(unsafeResultMap: resultMap)
            }
            set {
              guard let newValue = newValue else { return }
              resultMap = newValue.resultMap
            }
          }

          public struct AsPullRequest: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["PullRequest"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLFragmentSpread(PrDetails.self),
            ]

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var fragments: Fragments {
              get {
                return Fragments(unsafeResultMap: resultMap)
              }
              set {
                resultMap += newValue.resultMap
              }
            }

            public struct Fragments {
              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public var prDetails: PrDetails {
                get {
                  return PrDetails(unsafeResultMap: resultMap)
                }
                set {
                  resultMap += newValue.resultMap
                }
              }
            }
          }

          public var asIssue: AsIssue? {
            get {
              if !AsIssue.possibleTypes.contains(__typename) { return nil }
              return AsIssue(unsafeResultMap: resultMap)
            }
            set {
              guard let newValue = newValue else { return }
              resultMap = newValue.resultMap
            }
          }

          public struct AsIssue: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Issue"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLFragmentSpread(IssueDetails.self),
            ]

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var fragments: Fragments {
              get {
                return Fragments(unsafeResultMap: resultMap)
              }
              set {
                resultMap += newValue.resultMap
              }
            }

            public struct Fragments {
              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public var issueDetails: IssueDetails {
                get {
                  return IssueDetails(unsafeResultMap: resultMap)
                }
                set {
                  resultMap += newValue.resultMap
                }
              }
            }
          }
        }
      }
    }
  }
}

public final class GetWatchedReposQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query GetWatchedRepos($after: String) {
      viewer {
        __typename
        watching(first: 50, after: $after) {
          __typename
          pageInfo {
            __typename
            hasNextPage
            startCursor
            endCursor
          }
          edges {
            __typename
            node {
              __typename
              ... on Repository {
                name
                url
                isArchived
                owner {
                  __typename
                  login
                }
              }
            }
          }
        }
      }
    }
    """

  public let operationName: String = "GetWatchedRepos"

  public var after: String?

  public init(after: String? = nil) {
    self.after = after
  }

  public var variables: GraphQLMap? {
    return ["after": after]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("viewer", type: .nonNull(.object(Viewer.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(viewer: Viewer) {
      self.init(unsafeResultMap: ["__typename": "Query", "viewer": viewer.resultMap])
    }

    /// The currently authenticated user.
    public var viewer: Viewer {
      get {
        return Viewer(unsafeResultMap: resultMap["viewer"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "viewer")
      }
    }

    public struct Viewer: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["User"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("watching", arguments: ["first": 50, "after": GraphQLVariable("after")], type: .nonNull(.object(Watching.selections))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(watching: Watching) {
        self.init(unsafeResultMap: ["__typename": "User", "watching": watching.resultMap])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// A list of repositories the given user is watching.
      public var watching: Watching {
        get {
          return Watching(unsafeResultMap: resultMap["watching"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "watching")
        }
      }

      public struct Watching: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["RepositoryConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("pageInfo", type: .nonNull(.object(PageInfo.selections))),
          GraphQLField("edges", type: .list(.object(Edge.selections))),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(pageInfo: PageInfo, edges: [Edge?]? = nil) {
          self.init(unsafeResultMap: ["__typename": "RepositoryConnection", "pageInfo": pageInfo.resultMap, "edges": edges.flatMap { (value: [Edge?]) -> [ResultMap?] in value.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } } }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Information to aid in pagination.
        public var pageInfo: PageInfo {
          get {
            return PageInfo(unsafeResultMap: resultMap["pageInfo"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "pageInfo")
          }
        }

        /// A list of edges.
        public var edges: [Edge?]? {
          get {
            return (resultMap["edges"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Edge?] in value.map { (value: ResultMap?) -> Edge? in value.flatMap { (value: ResultMap) -> Edge in Edge(unsafeResultMap: value) } } }
          }
          set {
            resultMap.updateValue(newValue.flatMap { (value: [Edge?]) -> [ResultMap?] in value.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } } }, forKey: "edges")
          }
        }

        public struct PageInfo: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["PageInfo"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("hasNextPage", type: .nonNull(.scalar(Bool.self))),
            GraphQLField("startCursor", type: .scalar(String.self)),
            GraphQLField("endCursor", type: .scalar(String.self)),
          ]

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(hasNextPage: Bool, startCursor: String? = nil, endCursor: String? = nil) {
            self.init(unsafeResultMap: ["__typename": "PageInfo", "hasNextPage": hasNextPage, "startCursor": startCursor, "endCursor": endCursor])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// When paginating forwards, are there more items?
          public var hasNextPage: Bool {
            get {
              return resultMap["hasNextPage"]! as! Bool
            }
            set {
              resultMap.updateValue(newValue, forKey: "hasNextPage")
            }
          }

          /// When paginating backwards, the cursor to continue.
          public var startCursor: String? {
            get {
              return resultMap["startCursor"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "startCursor")
            }
          }

          /// When paginating forwards, the cursor to continue.
          public var endCursor: String? {
            get {
              return resultMap["endCursor"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "endCursor")
            }
          }
        }

        public struct Edge: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["RepositoryEdge"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("node", type: .object(Node.selections)),
          ]

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(node: Node? = nil) {
            self.init(unsafeResultMap: ["__typename": "RepositoryEdge", "node": node.flatMap { (value: Node) -> ResultMap in value.resultMap }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// The item at the end of the edge.
          public var node: Node? {
            get {
              return (resultMap["node"] as? ResultMap).flatMap { Node(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "node")
            }
          }

          public struct Node: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Repository"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("name", type: .nonNull(.scalar(String.self))),
              GraphQLField("url", type: .nonNull(.scalar(String.self))),
              GraphQLField("isArchived", type: .nonNull(.scalar(Bool.self))),
              GraphQLField("owner", type: .nonNull(.object(Owner.selections))),
            ]

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(name: String, url: String, isArchived: Bool, owner: Owner) {
              self.init(unsafeResultMap: ["__typename": "Repository", "name": name, "url": url, "isArchived": isArchived, "owner": owner.resultMap])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            /// The name of the repository.
            public var name: String {
              get {
                return resultMap["name"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "name")
              }
            }

            /// The HTTP URL for this repository
            public var url: String {
              get {
                return resultMap["url"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "url")
              }
            }

            /// Indicates if the repository is unmaintained.
            public var isArchived: Bool {
              get {
                return resultMap["isArchived"]! as! Bool
              }
              set {
                resultMap.updateValue(newValue, forKey: "isArchived")
              }
            }

            /// The User owner of the repository.
            public var owner: Owner {
              get {
                return Owner(unsafeResultMap: resultMap["owner"]! as! ResultMap)
              }
              set {
                resultMap.updateValue(newValue.resultMap, forKey: "owner")
              }
            }

            public struct Owner: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Organization", "User"]

              public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("login", type: .nonNull(.scalar(String.self))),
              ]

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public static func makeOrganization(login: String) -> Owner {
                return Owner(unsafeResultMap: ["__typename": "Organization", "login": login])
              }

              public static func makeUser(login: String) -> Owner {
                return Owner(unsafeResultMap: ["__typename": "User", "login": login])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              /// The username used to login.
              public var login: String {
                get {
                  return resultMap["login"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "login")
                }
              }
            }
          }
        }
      }
    }
  }
}

public final class TestGetTicketsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query TestGetTickets($queryString: String!) {
      search(first: 1, type: ISSUE, query: $queryString) {
        __typename
        issueCount
        pageInfo {
          __typename
          hasNextPage
          endCursor
        }
        edges {
          __typename
          node {
            __typename
            ... on PullRequest {
              ...PRDetails
            }
            ... on Issue {
              ...IssueDetails
            }
          }
        }
      }
    }
    """

  public let operationName: String = "TestGetTickets"

  public var queryDocument: String { return operationDefinition.appending(PrDetails.fragmentDefinition).appending(AssignedDetails.fragmentDefinition).appending(LabelDetails.fragmentDefinition).appending(IssueDetails.fragmentDefinition) }

  public var queryString: String

  public init(queryString: String) {
    self.queryString = queryString
  }

  public var variables: GraphQLMap? {
    return ["queryString": queryString]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("search", arguments: ["first": 1, "type": "ISSUE", "query": GraphQLVariable("queryString")], type: .nonNull(.object(Search.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(search: Search) {
      self.init(unsafeResultMap: ["__typename": "Query", "search": search.resultMap])
    }

    /// Perform a search across resources.
    public var search: Search {
      get {
        return Search(unsafeResultMap: resultMap["search"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "search")
      }
    }

    public struct Search: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["SearchResultItemConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("issueCount", type: .nonNull(.scalar(Int.self))),
        GraphQLField("pageInfo", type: .nonNull(.object(PageInfo.selections))),
        GraphQLField("edges", type: .list(.object(Edge.selections))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(issueCount: Int, pageInfo: PageInfo, edges: [Edge?]? = nil) {
        self.init(unsafeResultMap: ["__typename": "SearchResultItemConnection", "issueCount": issueCount, "pageInfo": pageInfo.resultMap, "edges": edges.flatMap { (value: [Edge?]) -> [ResultMap?] in value.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } } }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// The number of issues that matched the search query.
      public var issueCount: Int {
        get {
          return resultMap["issueCount"]! as! Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "issueCount")
        }
      }

      /// Information to aid in pagination.
      public var pageInfo: PageInfo {
        get {
          return PageInfo(unsafeResultMap: resultMap["pageInfo"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "pageInfo")
        }
      }

      /// A list of edges.
      public var edges: [Edge?]? {
        get {
          return (resultMap["edges"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Edge?] in value.map { (value: ResultMap?) -> Edge? in value.flatMap { (value: ResultMap) -> Edge in Edge(unsafeResultMap: value) } } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [Edge?]) -> [ResultMap?] in value.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } } }, forKey: "edges")
        }
      }

      public struct PageInfo: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["PageInfo"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("hasNextPage", type: .nonNull(.scalar(Bool.self))),
          GraphQLField("endCursor", type: .scalar(String.self)),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(hasNextPage: Bool, endCursor: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "PageInfo", "hasNextPage": hasNextPage, "endCursor": endCursor])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// When paginating forwards, are there more items?
        public var hasNextPage: Bool {
          get {
            return resultMap["hasNextPage"]! as! Bool
          }
          set {
            resultMap.updateValue(newValue, forKey: "hasNextPage")
          }
        }

        /// When paginating forwards, the cursor to continue.
        public var endCursor: String? {
          get {
            return resultMap["endCursor"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "endCursor")
          }
        }
      }

      public struct Edge: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["SearchResultItemEdge"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("node", type: .object(Node.selections)),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(node: Node? = nil) {
          self.init(unsafeResultMap: ["__typename": "SearchResultItemEdge", "node": node.flatMap { (value: Node) -> ResultMap in value.resultMap }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// The item at the end of the edge.
        public var node: Node? {
          get {
            return (resultMap["node"] as? ResultMap).flatMap { Node(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "node")
          }
        }

        public struct Node: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Issue", "PullRequest", "Repository", "User", "Organization", "MarketplaceListing"]

          public static let selections: [GraphQLSelection] = [
            GraphQLTypeCase(
              variants: ["PullRequest": AsPullRequest.selections, "Issue": AsIssue.selections],
              default: [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              ]
            )
          ]

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public static func makeRepository() -> Node {
            return Node(unsafeResultMap: ["__typename": "Repository"])
          }

          public static func makeUser() -> Node {
            return Node(unsafeResultMap: ["__typename": "User"])
          }

          public static func makeOrganization() -> Node {
            return Node(unsafeResultMap: ["__typename": "Organization"])
          }

          public static func makeMarketplaceListing() -> Node {
            return Node(unsafeResultMap: ["__typename": "MarketplaceListing"])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var asPullRequest: AsPullRequest? {
            get {
              if !AsPullRequest.possibleTypes.contains(__typename) { return nil }
              return AsPullRequest(unsafeResultMap: resultMap)
            }
            set {
              guard let newValue = newValue else { return }
              resultMap = newValue.resultMap
            }
          }

          public struct AsPullRequest: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["PullRequest"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLFragmentSpread(PrDetails.self),
            ]

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var fragments: Fragments {
              get {
                return Fragments(unsafeResultMap: resultMap)
              }
              set {
                resultMap += newValue.resultMap
              }
            }

            public struct Fragments {
              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public var prDetails: PrDetails {
                get {
                  return PrDetails(unsafeResultMap: resultMap)
                }
                set {
                  resultMap += newValue.resultMap
                }
              }
            }
          }

          public var asIssue: AsIssue? {
            get {
              if !AsIssue.possibleTypes.contains(__typename) { return nil }
              return AsIssue(unsafeResultMap: resultMap)
            }
            set {
              guard let newValue = newValue else { return }
              resultMap = newValue.resultMap
            }
          }

          public struct AsIssue: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Issue"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLFragmentSpread(IssueDetails.self),
            ]

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var fragments: Fragments {
              get {
                return Fragments(unsafeResultMap: resultMap)
              }
              set {
                resultMap += newValue.resultMap
              }
            }

            public struct Fragments {
              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public var issueDetails: IssueDetails {
                get {
                  return IssueDetails(unsafeResultMap: resultMap)
                }
                set {
                  resultMap += newValue.resultMap
                }
              }
            }
          }
        }
      }
    }
  }
}

public struct LabelDetails: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment LabelDetails on Label {
      __typename
      color
      name
    }
    """

  public static let possibleTypes: [String] = ["Label"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("color", type: .nonNull(.scalar(String.self))),
    GraphQLField("name", type: .nonNull(.scalar(String.self))),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(color: String, name: String) {
    self.init(unsafeResultMap: ["__typename": "Label", "color": color, "name": name])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  /// Identifies the label color.
  public var color: String {
    get {
      return resultMap["color"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "color")
    }
  }

  /// Identifies the label name.
  public var name: String {
    get {
      return resultMap["name"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "name")
    }
  }
}

public struct AssignedDetails: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment AssignedDetails on AssignedEvent {
      __typename
      actor {
        __typename
        login
      }
      user {
        __typename
        login
      }
    }
    """

  public static let possibleTypes: [String] = ["AssignedEvent"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("actor", type: .object(Actor.selections)),
    GraphQLField("user", type: .object(User.selections)),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(actor: Actor? = nil, user: User? = nil) {
    self.init(unsafeResultMap: ["__typename": "AssignedEvent", "actor": actor.flatMap { (value: Actor) -> ResultMap in value.resultMap }, "user": user.flatMap { (value: User) -> ResultMap in value.resultMap }])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  /// Identifies the actor who performed the event.
  public var actor: Actor? {
    get {
      return (resultMap["actor"] as? ResultMap).flatMap { Actor(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "actor")
    }
  }

  /// Identifies the user who was assigned.
  public var user: User? {
    get {
      return (resultMap["user"] as? ResultMap).flatMap { User(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "user")
    }
  }

  public struct Actor: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Organization", "User", "Bot"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("login", type: .nonNull(.scalar(String.self))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public static func makeOrganization(login: String) -> Actor {
      return Actor(unsafeResultMap: ["__typename": "Organization", "login": login])
    }

    public static func makeUser(login: String) -> Actor {
      return Actor(unsafeResultMap: ["__typename": "User", "login": login])
    }

    public static func makeBot(login: String) -> Actor {
      return Actor(unsafeResultMap: ["__typename": "Bot", "login": login])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    /// The username of the actor.
    public var login: String {
      get {
        return resultMap["login"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "login")
      }
    }
  }

  public struct User: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["User"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("login", type: .nonNull(.scalar(String.self))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(login: String) {
      self.init(unsafeResultMap: ["__typename": "User", "login": login])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    /// The username used to login.
    public var login: String {
      get {
        return resultMap["login"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "login")
      }
    }
  }
}

public struct PrDetails: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment PRDetails on PullRequest {
      __typename
      author {
        __typename
        login
      }
      title
      updatedAt
      url
      timeline(last: 1) {
        __typename
        nodes {
          __typename
          ...AssignedDetails
        }
      }
      labels(first: 10) {
        __typename
        edges {
          __typename
          node {
            __typename
            ...LabelDetails
          }
        }
      }
      repository {
        __typename
        name
        url
        isArchived
        owner {
          __typename
          login
        }
      }
    }
    """

  public static let possibleTypes: [String] = ["PullRequest"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("author", type: .object(Author.selections)),
    GraphQLField("title", type: .nonNull(.scalar(String.self))),
    GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
    GraphQLField("url", type: .nonNull(.scalar(String.self))),
    GraphQLField("timeline", arguments: ["last": 1], type: .nonNull(.object(Timeline.selections))),
    GraphQLField("labels", arguments: ["first": 10], type: .object(Label.selections)),
    GraphQLField("repository", type: .nonNull(.object(Repository.selections))),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(author: Author? = nil, title: String, updatedAt: String, url: String, timeline: Timeline, labels: Label? = nil, repository: Repository) {
    self.init(unsafeResultMap: ["__typename": "PullRequest", "author": author.flatMap { (value: Author) -> ResultMap in value.resultMap }, "title": title, "updatedAt": updatedAt, "url": url, "timeline": timeline.resultMap, "labels": labels.flatMap { (value: Label) -> ResultMap in value.resultMap }, "repository": repository.resultMap])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  /// The actor who authored the comment.
  public var author: Author? {
    get {
      return (resultMap["author"] as? ResultMap).flatMap { Author(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "author")
    }
  }

  /// Identifies the pull request title.
  public var title: String {
    get {
      return resultMap["title"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "title")
    }
  }

  /// Identifies the date and time when the object was last updated.
  public var updatedAt: String {
    get {
      return resultMap["updatedAt"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "updatedAt")
    }
  }

  /// The HTTP URL for this pull request.
  public var url: String {
    get {
      return resultMap["url"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "url")
    }
  }

  /// A list of events, comments, commits, etc. associated with the pull request.
  public var timeline: Timeline {
    get {
      return Timeline(unsafeResultMap: resultMap["timeline"]! as! ResultMap)
    }
    set {
      resultMap.updateValue(newValue.resultMap, forKey: "timeline")
    }
  }

  /// A list of labels associated with the object.
  public var labels: Label? {
    get {
      return (resultMap["labels"] as? ResultMap).flatMap { Label(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "labels")
    }
  }

  /// The repository associated with this node.
  public var repository: Repository {
    get {
      return Repository(unsafeResultMap: resultMap["repository"]! as! ResultMap)
    }
    set {
      resultMap.updateValue(newValue.resultMap, forKey: "repository")
    }
  }

  public struct Author: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Organization", "User", "Bot"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("login", type: .nonNull(.scalar(String.self))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public static func makeOrganization(login: String) -> Author {
      return Author(unsafeResultMap: ["__typename": "Organization", "login": login])
    }

    public static func makeUser(login: String) -> Author {
      return Author(unsafeResultMap: ["__typename": "User", "login": login])
    }

    public static func makeBot(login: String) -> Author {
      return Author(unsafeResultMap: ["__typename": "Bot", "login": login])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    /// The username of the actor.
    public var login: String {
      get {
        return resultMap["login"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "login")
      }
    }
  }

  public struct Timeline: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["PullRequestTimelineConnection"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("nodes", type: .list(.object(Node.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(nodes: [Node?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "PullRequestTimelineConnection", "nodes": nodes.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    /// A list of nodes.
    public var nodes: [Node?]? {
      get {
        return (resultMap["nodes"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Node?] in value.map { (value: ResultMap?) -> Node? in value.flatMap { (value: ResultMap) -> Node in Node(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }, forKey: "nodes")
      }
    }

    public struct Node: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Commit", "CommitCommentThread", "PullRequestReview", "PullRequestReviewThread", "PullRequestReviewComment", "IssueComment", "ClosedEvent", "ReopenedEvent", "SubscribedEvent", "UnsubscribedEvent", "MergedEvent", "ReferencedEvent", "CrossReferencedEvent", "AssignedEvent", "UnassignedEvent", "LabeledEvent", "UnlabeledEvent", "MilestonedEvent", "DemilestonedEvent", "RenamedTitleEvent", "LockedEvent", "UnlockedEvent", "DeployedEvent", "HeadRefDeletedEvent", "HeadRefRestoredEvent", "HeadRefForcePushedEvent", "BaseRefForcePushedEvent", "ReviewRequestedEvent", "ReviewRequestRemovedEvent", "ReviewDismissedEvent"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(AssignedDetails.self),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public static func makeCommit() -> Node {
        return Node(unsafeResultMap: ["__typename": "Commit"])
      }

      public static func makeCommitCommentThread() -> Node {
        return Node(unsafeResultMap: ["__typename": "CommitCommentThread"])
      }

      public static func makePullRequestReview() -> Node {
        return Node(unsafeResultMap: ["__typename": "PullRequestReview"])
      }

      public static func makePullRequestReviewThread() -> Node {
        return Node(unsafeResultMap: ["__typename": "PullRequestReviewThread"])
      }

      public static func makePullRequestReviewComment() -> Node {
        return Node(unsafeResultMap: ["__typename": "PullRequestReviewComment"])
      }

      public static func makeIssueComment() -> Node {
        return Node(unsafeResultMap: ["__typename": "IssueComment"])
      }

      public static func makeClosedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "ClosedEvent"])
      }

      public static func makeReopenedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "ReopenedEvent"])
      }

      public static func makeSubscribedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "SubscribedEvent"])
      }

      public static func makeUnsubscribedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "UnsubscribedEvent"])
      }

      public static func makeMergedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "MergedEvent"])
      }

      public static func makeReferencedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "ReferencedEvent"])
      }

      public static func makeCrossReferencedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "CrossReferencedEvent"])
      }

      public static func makeUnassignedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "UnassignedEvent"])
      }

      public static func makeLabeledEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "LabeledEvent"])
      }

      public static func makeUnlabeledEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "UnlabeledEvent"])
      }

      public static func makeMilestonedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "MilestonedEvent"])
      }

      public static func makeDemilestonedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "DemilestonedEvent"])
      }

      public static func makeRenamedTitleEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "RenamedTitleEvent"])
      }

      public static func makeLockedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "LockedEvent"])
      }

      public static func makeUnlockedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "UnlockedEvent"])
      }

      public static func makeDeployedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "DeployedEvent"])
      }

      public static func makeHeadRefDeletedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "HeadRefDeletedEvent"])
      }

      public static func makeHeadRefRestoredEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "HeadRefRestoredEvent"])
      }

      public static func makeHeadRefForcePushedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "HeadRefForcePushedEvent"])
      }

      public static func makeBaseRefForcePushedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "BaseRefForcePushedEvent"])
      }

      public static func makeReviewRequestedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "ReviewRequestedEvent"])
      }

      public static func makeReviewRequestRemovedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "ReviewRequestRemovedEvent"])
      }

      public static func makeReviewDismissedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "ReviewDismissedEvent"])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var assignedDetails: AssignedDetails? {
          get {
            if !AssignedDetails.possibleTypes.contains(resultMap["__typename"]! as! String) { return nil }
            return AssignedDetails(unsafeResultMap: resultMap)
          }
          set {
            guard let newValue = newValue else { return }
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }

  public struct Label: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["LabelConnection"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("edges", type: .list(.object(Edge.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(edges: [Edge?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "LabelConnection", "edges": edges.flatMap { (value: [Edge?]) -> [ResultMap?] in value.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } } }])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    /// A list of edges.
    public var edges: [Edge?]? {
      get {
        return (resultMap["edges"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Edge?] in value.map { (value: ResultMap?) -> Edge? in value.flatMap { (value: ResultMap) -> Edge in Edge(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [Edge?]) -> [ResultMap?] in value.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } } }, forKey: "edges")
      }
    }

    public struct Edge: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["LabelEdge"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("node", type: .object(Node.selections)),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(node: Node? = nil) {
        self.init(unsafeResultMap: ["__typename": "LabelEdge", "node": node.flatMap { (value: Node) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// The item at the end of the edge.
      public var node: Node? {
        get {
          return (resultMap["node"] as? ResultMap).flatMap { Node(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "node")
        }
      }

      public struct Node: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Label"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(LabelDetails.self),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(color: String, name: String) {
          self.init(unsafeResultMap: ["__typename": "Label", "color": color, "name": name])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var fragments: Fragments {
          get {
            return Fragments(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }

        public struct Fragments {
          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public var labelDetails: LabelDetails {
            get {
              return LabelDetails(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }
        }
      }
    }
  }

  public struct Repository: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Repository"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("name", type: .nonNull(.scalar(String.self))),
      GraphQLField("url", type: .nonNull(.scalar(String.self))),
      GraphQLField("isArchived", type: .nonNull(.scalar(Bool.self))),
      GraphQLField("owner", type: .nonNull(.object(Owner.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(name: String, url: String, isArchived: Bool, owner: Owner) {
      self.init(unsafeResultMap: ["__typename": "Repository", "name": name, "url": url, "isArchived": isArchived, "owner": owner.resultMap])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    /// The name of the repository.
    public var name: String {
      get {
        return resultMap["name"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "name")
      }
    }

    /// The HTTP URL for this repository
    public var url: String {
      get {
        return resultMap["url"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "url")
      }
    }

    /// Indicates if the repository is unmaintained.
    public var isArchived: Bool {
      get {
        return resultMap["isArchived"]! as! Bool
      }
      set {
        resultMap.updateValue(newValue, forKey: "isArchived")
      }
    }

    /// The User owner of the repository.
    public var owner: Owner {
      get {
        return Owner(unsafeResultMap: resultMap["owner"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "owner")
      }
    }

    public struct Owner: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Organization", "User"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("login", type: .nonNull(.scalar(String.self))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public static func makeOrganization(login: String) -> Owner {
        return Owner(unsafeResultMap: ["__typename": "Organization", "login": login])
      }

      public static func makeUser(login: String) -> Owner {
        return Owner(unsafeResultMap: ["__typename": "User", "login": login])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// The username used to login.
      public var login: String {
        get {
          return resultMap["login"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "login")
        }
      }
    }
  }
}

public struct IssueDetails: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment IssueDetails on Issue {
      __typename
      title
      updatedAt
      url
      timeline(last: 1) {
        __typename
        nodes {
          __typename
          ...AssignedDetails
        }
      }
      labels(first: 10) {
        __typename
        edges {
          __typename
          node {
            __typename
            ...LabelDetails
          }
        }
      }
      repository {
        __typename
        name
        url
        isArchived
        owner {
          __typename
          login
        }
      }
    }
    """

  public static let possibleTypes: [String] = ["Issue"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("title", type: .nonNull(.scalar(String.self))),
    GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
    GraphQLField("url", type: .nonNull(.scalar(String.self))),
    GraphQLField("timeline", arguments: ["last": 1], type: .nonNull(.object(Timeline.selections))),
    GraphQLField("labels", arguments: ["first": 10], type: .object(Label.selections)),
    GraphQLField("repository", type: .nonNull(.object(Repository.selections))),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(title: String, updatedAt: String, url: String, timeline: Timeline, labels: Label? = nil, repository: Repository) {
    self.init(unsafeResultMap: ["__typename": "Issue", "title": title, "updatedAt": updatedAt, "url": url, "timeline": timeline.resultMap, "labels": labels.flatMap { (value: Label) -> ResultMap in value.resultMap }, "repository": repository.resultMap])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  /// Identifies the issue title.
  public var title: String {
    get {
      return resultMap["title"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "title")
    }
  }

  /// Identifies the date and time when the object was last updated.
  public var updatedAt: String {
    get {
      return resultMap["updatedAt"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "updatedAt")
    }
  }

  /// The HTTP URL for this issue
  public var url: String {
    get {
      return resultMap["url"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "url")
    }
  }

  /// A list of events, comments, commits, etc. associated with the issue.
  public var timeline: Timeline {
    get {
      return Timeline(unsafeResultMap: resultMap["timeline"]! as! ResultMap)
    }
    set {
      resultMap.updateValue(newValue.resultMap, forKey: "timeline")
    }
  }

  /// A list of labels associated with the object.
  public var labels: Label? {
    get {
      return (resultMap["labels"] as? ResultMap).flatMap { Label(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "labels")
    }
  }

  /// The repository associated with this node.
  public var repository: Repository {
    get {
      return Repository(unsafeResultMap: resultMap["repository"]! as! ResultMap)
    }
    set {
      resultMap.updateValue(newValue.resultMap, forKey: "repository")
    }
  }

  public struct Timeline: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["IssueTimelineConnection"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("nodes", type: .list(.object(Node.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(nodes: [Node?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "IssueTimelineConnection", "nodes": nodes.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    /// A list of nodes.
    public var nodes: [Node?]? {
      get {
        return (resultMap["nodes"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Node?] in value.map { (value: ResultMap?) -> Node? in value.flatMap { (value: ResultMap) -> Node in Node(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }, forKey: "nodes")
      }
    }

    public struct Node: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Commit", "IssueComment", "CrossReferencedEvent", "ClosedEvent", "ReopenedEvent", "SubscribedEvent", "UnsubscribedEvent", "ReferencedEvent", "AssignedEvent", "UnassignedEvent", "LabeledEvent", "UnlabeledEvent", "MilestonedEvent", "DemilestonedEvent", "RenamedTitleEvent", "LockedEvent", "UnlockedEvent"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(AssignedDetails.self),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public static func makeCommit() -> Node {
        return Node(unsafeResultMap: ["__typename": "Commit"])
      }

      public static func makeIssueComment() -> Node {
        return Node(unsafeResultMap: ["__typename": "IssueComment"])
      }

      public static func makeCrossReferencedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "CrossReferencedEvent"])
      }

      public static func makeClosedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "ClosedEvent"])
      }

      public static func makeReopenedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "ReopenedEvent"])
      }

      public static func makeSubscribedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "SubscribedEvent"])
      }

      public static func makeUnsubscribedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "UnsubscribedEvent"])
      }

      public static func makeReferencedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "ReferencedEvent"])
      }

      public static func makeUnassignedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "UnassignedEvent"])
      }

      public static func makeLabeledEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "LabeledEvent"])
      }

      public static func makeUnlabeledEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "UnlabeledEvent"])
      }

      public static func makeMilestonedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "MilestonedEvent"])
      }

      public static func makeDemilestonedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "DemilestonedEvent"])
      }

      public static func makeRenamedTitleEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "RenamedTitleEvent"])
      }

      public static func makeLockedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "LockedEvent"])
      }

      public static func makeUnlockedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "UnlockedEvent"])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var assignedDetails: AssignedDetails? {
          get {
            if !AssignedDetails.possibleTypes.contains(resultMap["__typename"]! as! String) { return nil }
            return AssignedDetails(unsafeResultMap: resultMap)
          }
          set {
            guard let newValue = newValue else { return }
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }

  public struct Label: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["LabelConnection"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("edges", type: .list(.object(Edge.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(edges: [Edge?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "LabelConnection", "edges": edges.flatMap { (value: [Edge?]) -> [ResultMap?] in value.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } } }])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    /// A list of edges.
    public var edges: [Edge?]? {
      get {
        return (resultMap["edges"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Edge?] in value.map { (value: ResultMap?) -> Edge? in value.flatMap { (value: ResultMap) -> Edge in Edge(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [Edge?]) -> [ResultMap?] in value.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } } }, forKey: "edges")
      }
    }

    public struct Edge: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["LabelEdge"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("node", type: .object(Node.selections)),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(node: Node? = nil) {
        self.init(unsafeResultMap: ["__typename": "LabelEdge", "node": node.flatMap { (value: Node) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// The item at the end of the edge.
      public var node: Node? {
        get {
          return (resultMap["node"] as? ResultMap).flatMap { Node(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "node")
        }
      }

      public struct Node: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Label"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(LabelDetails.self),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(color: String, name: String) {
          self.init(unsafeResultMap: ["__typename": "Label", "color": color, "name": name])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var fragments: Fragments {
          get {
            return Fragments(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }

        public struct Fragments {
          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public var labelDetails: LabelDetails {
            get {
              return LabelDetails(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }
        }
      }
    }
  }

  public struct Repository: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Repository"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("name", type: .nonNull(.scalar(String.self))),
      GraphQLField("url", type: .nonNull(.scalar(String.self))),
      GraphQLField("isArchived", type: .nonNull(.scalar(Bool.self))),
      GraphQLField("owner", type: .nonNull(.object(Owner.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(name: String, url: String, isArchived: Bool, owner: Owner) {
      self.init(unsafeResultMap: ["__typename": "Repository", "name": name, "url": url, "isArchived": isArchived, "owner": owner.resultMap])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    /// The name of the repository.
    public var name: String {
      get {
        return resultMap["name"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "name")
      }
    }

    /// The HTTP URL for this repository
    public var url: String {
      get {
        return resultMap["url"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "url")
      }
    }

    /// Indicates if the repository is unmaintained.
    public var isArchived: Bool {
      get {
        return resultMap["isArchived"]! as! Bool
      }
      set {
        resultMap.updateValue(newValue, forKey: "isArchived")
      }
    }

    /// The User owner of the repository.
    public var owner: Owner {
      get {
        return Owner(unsafeResultMap: resultMap["owner"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "owner")
      }
    }

    public struct Owner: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Organization", "User"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("login", type: .nonNull(.scalar(String.self))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public static func makeOrganization(login: String) -> Owner {
        return Owner(unsafeResultMap: ["__typename": "Organization", "login": login])
      }

      public static func makeUser(login: String) -> Owner {
        return Owner(unsafeResultMap: ["__typename": "User", "login": login])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// The username used to login.
      public var login: String {
        get {
          return resultMap["login"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "login")
        }
      }
    }
  }
}
