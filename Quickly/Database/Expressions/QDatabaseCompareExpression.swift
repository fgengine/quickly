//
//  Quickly
//

public extension QDatabase {
    
    struct CompareExpression : IQDatabaseExpressable {
        
        public enum Operator {
            case equal
            case notEqual
            case more
            case moreOrEqual
            case less
            case lessOrEqual
        }
        
        public let column: QDatabase.Column
        public let `operator`: Operator
        public let expression: IQDatabaseExpressable
        
        public init(
            _ column: QDatabase.Column,
            _ `operator`: Operator,
            _ expression: IQDatabaseExpressable
        ) {
            self.column = column
            self.operator = `operator`
            self.expression = expression
        }
        
        public init(
            _ column: QDatabase.Column,
            _ `operator`: Operator,
            _ value: IQDatabaseInputValue
        ) {
            self.init(column, `operator`, LiteralExpression(value))
        }
        
        public func inputValues() -> [IQDatabaseInputValue] {
            return self.expression.inputValues()
        }
        
        public func queryExpression() -> String {
            return self.column.name + " " + self.operator.queryString() + " " + self.expression.queryExpression()
        }
        
    }

}

// MARK: Internal • QDatabase.CompareExpression.Operator

internal extension QDatabase.CompareExpression.Operator {
    
    func queryString() -> String {
        switch self {
        case .equal: return "=="
        case .notEqual: return "<>"
        case .more: return ">"
        case .moreOrEqual: return ">="
        case .less: return "<"
        case .lessOrEqual: return "<="
        }
    }
    
}
