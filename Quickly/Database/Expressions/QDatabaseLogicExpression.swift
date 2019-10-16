//
//  Quickly
//

public extension QDatabase {
    
    struct LogicExpression : IQDatabaseExpressable {
        
        public enum Operator {
            case and
            case or
        }
        
        public let `operator`: Operator
        public let expressions: [IQDatabaseExpressable]
        
        public init(
            _ `operator`: Operator,
            _ expressions: [IQDatabaseExpressable]
        ) {
            self.operator = `operator`
            self.expressions = expressions
        }
        
        public func inputValues() -> [IQDatabaseInputValue] {
            var bindables: [IQDatabaseInputValue] = []
            self.expressions.forEach({ bindables.append(contentsOf: $0.inputValues()) })
            return bindables
        }
        
        public func queryExpression() -> String {
            let expressions = self.expressions.compactMap({ return "(" + $0.queryExpression() + ")" })
            if expressions.count > 0 {
                return expressions.joined(separator: " " + self.operator.queryString() + " ")
            }
            return ""
        }
        
    }
    
}

// MARK: Internal • QDatabase.LogicExpression.Operator

internal extension QDatabase.LogicExpression.Operator {
    
    func queryString() -> String {
        switch self {
        case .and: return "AND"
        case .or: return "OR"
        }
    }
    
}
