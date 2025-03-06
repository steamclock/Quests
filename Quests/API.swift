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

    /// Perform a search across resources, returning a maximum of 1,000 results.
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

      /// The total number of issues that matched the search query. Regardless of the
      /// total number of matches, a maximum of 1,000 results will be available across all types.
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
          public static let possibleTypes: [String] = ["App", "Discussion", "Issue", "MarketplaceListing", "Organization", "PullRequest", "Repository", "User"]

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

          public static func makeApp() -> Node {
            return Node(unsafeResultMap: ["__typename": "App"])
          }

          public static func makeDiscussion() -> Node {
            return Node(unsafeResultMap: ["__typename": "Discussion"])
          }

          public static func makeMarketplaceListing() -> Node {
            return Node(unsafeResultMap: ["__typename": "MarketplaceListing"])
          }

          public static func makeOrganization() -> Node {
            return Node(unsafeResultMap: ["__typename": "Organization"])
          }

          public static func makeRepository() -> Node {
            return Node(unsafeResultMap: ["__typename": "Repository"])
          }

          public static func makeUser() -> Node {
            return Node(unsafeResultMap: ["__typename": "User"])
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

    /// Perform a search across resources, returning a maximum of 1,000 results.
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

      /// The total number of issues that matched the search query. Regardless of the
      /// total number of matches, a maximum of 1,000 results will be available across all types.
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
          public static let possibleTypes: [String] = ["App", "Discussion", "Issue", "MarketplaceListing", "Organization", "PullRequest", "Repository", "User"]

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

          public static func makeApp() -> Node {
            return Node(unsafeResultMap: ["__typename": "App"])
          }

          public static func makeDiscussion() -> Node {
            return Node(unsafeResultMap: ["__typename": "Discussion"])
          }

          public static func makeMarketplaceListing() -> Node {
            return Node(unsafeResultMap: ["__typename": "MarketplaceListing"])
          }

          public static func makeOrganization() -> Node {
            return Node(unsafeResultMap: ["__typename": "Organization"])
          }

          public static func makeRepository() -> Node {
            return Node(unsafeResultMap: ["__typename": "Repository"])
          }

          public static func makeUser() -> Node {
            return Node(unsafeResultMap: ["__typename": "User"])
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
  @available(*, deprecated, message: "Assignees can now be mannequins. Use the `assignee` field instead. Removal on 2020-01-01 UTC.")
  public var user: User? {
    get {
      return (resultMap["user"] as? ResultMap).flatMap { User(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "user")
    }
  }

  public struct Actor: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["EnterpriseUserAccount", "Organization", "User", "Bot", "Mannequin"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("login", type: .nonNull(.scalar(String.self))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public static func makeEnterpriseUserAccount(login: String) -> Actor {
      return Actor(unsafeResultMap: ["__typename": "EnterpriseUserAccount", "login": login])
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

    public static func makeMannequin(login: String) -> Actor {
      return Actor(unsafeResultMap: ["__typename": "Mannequin", "login": login])
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
      timelineItems(last: 1) {
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
    GraphQLField("timelineItems", arguments: ["last": 1], type: .nonNull(.object(TimelineItem.selections))),
    GraphQLField("labels", arguments: ["first": 10], type: .object(Label.selections)),
    GraphQLField("repository", type: .nonNull(.object(Repository.selections))),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(author: Author? = nil, title: String, updatedAt: String, url: String, timelineItems: TimelineItem, labels: Label? = nil, repository: Repository) {
    self.init(unsafeResultMap: ["__typename": "PullRequest", "author": author.flatMap { (value: Author) -> ResultMap in value.resultMap }, "title": title, "updatedAt": updatedAt, "url": url, "timelineItems": timelineItems.resultMap, "labels": labels.flatMap { (value: Label) -> ResultMap in value.resultMap }, "repository": repository.resultMap])
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
  public var timelineItems: TimelineItem {
    get {
      return TimelineItem(unsafeResultMap: resultMap["timelineItems"]! as! ResultMap)
    }
    set {
      resultMap.updateValue(newValue.resultMap, forKey: "timelineItems")
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
    public static let possibleTypes: [String] = ["EnterpriseUserAccount", "Organization", "User", "Bot", "Mannequin"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("login", type: .nonNull(.scalar(String.self))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public static func makeEnterpriseUserAccount(login: String) -> Author {
      return Author(unsafeResultMap: ["__typename": "EnterpriseUserAccount", "login": login])
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

    public static func makeMannequin(login: String) -> Author {
      return Author(unsafeResultMap: ["__typename": "Mannequin", "login": login])
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

  public struct TimelineItem: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["PullRequestTimelineItemsConnection"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("nodes", type: .list(.object(Node.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(nodes: [Node?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "PullRequestTimelineItemsConnection", "nodes": nodes.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }])
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
      public static let possibleTypes: [String] = ["AddedToMergeQueueEvent", "AddedToProjectEvent", "AssignedEvent", "AutoMergeDisabledEvent", "AutoMergeEnabledEvent", "AutoRebaseEnabledEvent", "AutoSquashEnabledEvent", "AutomaticBaseChangeFailedEvent", "AutomaticBaseChangeSucceededEvent", "BaseRefChangedEvent", "BaseRefDeletedEvent", "BaseRefForcePushedEvent", "ClosedEvent", "CommentDeletedEvent", "ConnectedEvent", "ConvertToDraftEvent", "ConvertedNoteToIssueEvent", "ConvertedToDiscussionEvent", "CrossReferencedEvent", "DemilestonedEvent", "DeployedEvent", "DeploymentEnvironmentChangedEvent", "DisconnectedEvent", "HeadRefDeletedEvent", "HeadRefForcePushedEvent", "HeadRefRestoredEvent", "IssueComment", "LabeledEvent", "LockedEvent", "MarkedAsDuplicateEvent", "MentionedEvent", "MergedEvent", "MilestonedEvent", "MovedColumnsInProjectEvent", "ParentIssueAddedEvent", "ParentIssueRemovedEvent", "PinnedEvent", "PullRequestCommit", "PullRequestCommitCommentThread", "PullRequestReview", "PullRequestReviewThread", "PullRequestRevisionMarker", "ReadyForReviewEvent", "ReferencedEvent", "RemovedFromMergeQueueEvent", "RemovedFromProjectEvent", "RenamedTitleEvent", "ReopenedEvent", "ReviewDismissedEvent", "ReviewRequestRemovedEvent", "ReviewRequestedEvent", "SubIssueAddedEvent", "SubIssueRemovedEvent", "SubscribedEvent", "TransferredEvent", "UnassignedEvent", "UnlabeledEvent", "UnlockedEvent", "UnmarkedAsDuplicateEvent", "UnpinnedEvent", "UnsubscribedEvent", "UserBlockedEvent"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(AssignedDetails.self),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public static func makeAddedToMergeQueueEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "AddedToMergeQueueEvent"])
      }

      public static func makeAddedToProjectEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "AddedToProjectEvent"])
      }

      public static func makeAutoMergeDisabledEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "AutoMergeDisabledEvent"])
      }

      public static func makeAutoMergeEnabledEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "AutoMergeEnabledEvent"])
      }

      public static func makeAutoRebaseEnabledEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "AutoRebaseEnabledEvent"])
      }

      public static func makeAutoSquashEnabledEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "AutoSquashEnabledEvent"])
      }

      public static func makeAutomaticBaseChangeFailedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "AutomaticBaseChangeFailedEvent"])
      }

      public static func makeAutomaticBaseChangeSucceededEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "AutomaticBaseChangeSucceededEvent"])
      }

      public static func makeBaseRefChangedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "BaseRefChangedEvent"])
      }

      public static func makeBaseRefDeletedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "BaseRefDeletedEvent"])
      }

      public static func makeBaseRefForcePushedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "BaseRefForcePushedEvent"])
      }

      public static func makeClosedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "ClosedEvent"])
      }

      public static func makeCommentDeletedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "CommentDeletedEvent"])
      }

      public static func makeConnectedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "ConnectedEvent"])
      }

      public static func makeConvertToDraftEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "ConvertToDraftEvent"])
      }

      public static func makeConvertedNoteToIssueEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "ConvertedNoteToIssueEvent"])
      }

      public static func makeConvertedToDiscussionEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "ConvertedToDiscussionEvent"])
      }

      public static func makeCrossReferencedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "CrossReferencedEvent"])
      }

      public static func makeDemilestonedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "DemilestonedEvent"])
      }

      public static func makeDeployedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "DeployedEvent"])
      }

      public static func makeDeploymentEnvironmentChangedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "DeploymentEnvironmentChangedEvent"])
      }

      public static func makeDisconnectedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "DisconnectedEvent"])
      }

      public static func makeHeadRefDeletedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "HeadRefDeletedEvent"])
      }

      public static func makeHeadRefForcePushedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "HeadRefForcePushedEvent"])
      }

      public static func makeHeadRefRestoredEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "HeadRefRestoredEvent"])
      }

      public static func makeIssueComment() -> Node {
        return Node(unsafeResultMap: ["__typename": "IssueComment"])
      }

      public static func makeLabeledEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "LabeledEvent"])
      }

      public static func makeLockedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "LockedEvent"])
      }

      public static func makeMarkedAsDuplicateEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "MarkedAsDuplicateEvent"])
      }

      public static func makeMentionedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "MentionedEvent"])
      }

      public static func makeMergedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "MergedEvent"])
      }

      public static func makeMilestonedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "MilestonedEvent"])
      }

      public static func makeMovedColumnsInProjectEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "MovedColumnsInProjectEvent"])
      }

      public static func makeParentIssueAddedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "ParentIssueAddedEvent"])
      }

      public static func makeParentIssueRemovedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "ParentIssueRemovedEvent"])
      }

      public static func makePinnedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "PinnedEvent"])
      }

      public static func makePullRequestCommit() -> Node {
        return Node(unsafeResultMap: ["__typename": "PullRequestCommit"])
      }

      public static func makePullRequestCommitCommentThread() -> Node {
        return Node(unsafeResultMap: ["__typename": "PullRequestCommitCommentThread"])
      }

      public static func makePullRequestReview() -> Node {
        return Node(unsafeResultMap: ["__typename": "PullRequestReview"])
      }

      public static func makePullRequestReviewThread() -> Node {
        return Node(unsafeResultMap: ["__typename": "PullRequestReviewThread"])
      }

      public static func makePullRequestRevisionMarker() -> Node {
        return Node(unsafeResultMap: ["__typename": "PullRequestRevisionMarker"])
      }

      public static func makeReadyForReviewEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "ReadyForReviewEvent"])
      }

      public static func makeReferencedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "ReferencedEvent"])
      }

      public static func makeRemovedFromMergeQueueEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "RemovedFromMergeQueueEvent"])
      }

      public static func makeRemovedFromProjectEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "RemovedFromProjectEvent"])
      }

      public static func makeRenamedTitleEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "RenamedTitleEvent"])
      }

      public static func makeReopenedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "ReopenedEvent"])
      }

      public static func makeReviewDismissedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "ReviewDismissedEvent"])
      }

      public static func makeReviewRequestRemovedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "ReviewRequestRemovedEvent"])
      }

      public static func makeReviewRequestedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "ReviewRequestedEvent"])
      }

      public static func makeSubIssueAddedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "SubIssueAddedEvent"])
      }

      public static func makeSubIssueRemovedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "SubIssueRemovedEvent"])
      }

      public static func makeSubscribedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "SubscribedEvent"])
      }

      public static func makeTransferredEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "TransferredEvent"])
      }

      public static func makeUnassignedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "UnassignedEvent"])
      }

      public static func makeUnlabeledEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "UnlabeledEvent"])
      }

      public static func makeUnlockedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "UnlockedEvent"])
      }

      public static func makeUnmarkedAsDuplicateEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "UnmarkedAsDuplicateEvent"])
      }

      public static func makeUnpinnedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "UnpinnedEvent"])
      }

      public static func makeUnsubscribedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "UnsubscribedEvent"])
      }

      public static func makeUserBlockedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "UserBlockedEvent"])
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
      timelineItems(last: 1) {
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
    GraphQLField("timelineItems", arguments: ["last": 1], type: .nonNull(.object(TimelineItem.selections))),
    GraphQLField("labels", arguments: ["first": 10], type: .object(Label.selections)),
    GraphQLField("repository", type: .nonNull(.object(Repository.selections))),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(title: String, updatedAt: String, url: String, timelineItems: TimelineItem, labels: Label? = nil, repository: Repository) {
    self.init(unsafeResultMap: ["__typename": "Issue", "title": title, "updatedAt": updatedAt, "url": url, "timelineItems": timelineItems.resultMap, "labels": labels.flatMap { (value: Label) -> ResultMap in value.resultMap }, "repository": repository.resultMap])
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
  public var timelineItems: TimelineItem {
    get {
      return TimelineItem(unsafeResultMap: resultMap["timelineItems"]! as! ResultMap)
    }
    set {
      resultMap.updateValue(newValue.resultMap, forKey: "timelineItems")
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

  public struct TimelineItem: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["IssueTimelineItemsConnection"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("nodes", type: .list(.object(Node.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(nodes: [Node?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "IssueTimelineItemsConnection", "nodes": nodes.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }])
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
      public static let possibleTypes: [String] = ["AddedToProjectEvent", "AssignedEvent", "ClosedEvent", "CommentDeletedEvent", "ConnectedEvent", "ConvertedNoteToIssueEvent", "ConvertedToDiscussionEvent", "CrossReferencedEvent", "DemilestonedEvent", "DisconnectedEvent", "IssueComment", "LabeledEvent", "LockedEvent", "MarkedAsDuplicateEvent", "MentionedEvent", "MilestonedEvent", "MovedColumnsInProjectEvent", "ParentIssueAddedEvent", "ParentIssueRemovedEvent", "PinnedEvent", "ReferencedEvent", "RemovedFromProjectEvent", "RenamedTitleEvent", "ReopenedEvent", "SubIssueAddedEvent", "SubIssueRemovedEvent", "SubscribedEvent", "TransferredEvent", "UnassignedEvent", "UnlabeledEvent", "UnlockedEvent", "UnmarkedAsDuplicateEvent", "UnpinnedEvent", "UnsubscribedEvent", "UserBlockedEvent"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(AssignedDetails.self),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public static func makeAddedToProjectEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "AddedToProjectEvent"])
      }

      public static func makeClosedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "ClosedEvent"])
      }

      public static func makeCommentDeletedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "CommentDeletedEvent"])
      }

      public static func makeConnectedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "ConnectedEvent"])
      }

      public static func makeConvertedNoteToIssueEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "ConvertedNoteToIssueEvent"])
      }

      public static func makeConvertedToDiscussionEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "ConvertedToDiscussionEvent"])
      }

      public static func makeCrossReferencedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "CrossReferencedEvent"])
      }

      public static func makeDemilestonedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "DemilestonedEvent"])
      }

      public static func makeDisconnectedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "DisconnectedEvent"])
      }

      public static func makeIssueComment() -> Node {
        return Node(unsafeResultMap: ["__typename": "IssueComment"])
      }

      public static func makeLabeledEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "LabeledEvent"])
      }

      public static func makeLockedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "LockedEvent"])
      }

      public static func makeMarkedAsDuplicateEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "MarkedAsDuplicateEvent"])
      }

      public static func makeMentionedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "MentionedEvent"])
      }

      public static func makeMilestonedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "MilestonedEvent"])
      }

      public static func makeMovedColumnsInProjectEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "MovedColumnsInProjectEvent"])
      }

      public static func makeParentIssueAddedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "ParentIssueAddedEvent"])
      }

      public static func makeParentIssueRemovedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "ParentIssueRemovedEvent"])
      }

      public static func makePinnedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "PinnedEvent"])
      }

      public static func makeReferencedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "ReferencedEvent"])
      }

      public static func makeRemovedFromProjectEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "RemovedFromProjectEvent"])
      }

      public static func makeRenamedTitleEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "RenamedTitleEvent"])
      }

      public static func makeReopenedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "ReopenedEvent"])
      }

      public static func makeSubIssueAddedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "SubIssueAddedEvent"])
      }

      public static func makeSubIssueRemovedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "SubIssueRemovedEvent"])
      }

      public static func makeSubscribedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "SubscribedEvent"])
      }

      public static func makeTransferredEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "TransferredEvent"])
      }

      public static func makeUnassignedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "UnassignedEvent"])
      }

      public static func makeUnlabeledEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "UnlabeledEvent"])
      }

      public static func makeUnlockedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "UnlockedEvent"])
      }

      public static func makeUnmarkedAsDuplicateEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "UnmarkedAsDuplicateEvent"])
      }

      public static func makeUnpinnedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "UnpinnedEvent"])
      }

      public static func makeUnsubscribedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "UnsubscribedEvent"])
      }

      public static func makeUserBlockedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "UserBlockedEvent"])
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
