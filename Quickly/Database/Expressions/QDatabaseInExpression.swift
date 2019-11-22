//
//  Quickly
//

// MARK: Public • QDatabase.InExpression

public extension QDatabase {
    
    struct InExpression : IQDatabaseExpressable {
        
        public let column: QDatabase.Column
        public let values: [IQDatabaseInputValue]
        
        public init(
            _ column: QDatabase.Column,
            _ values: [IQDatabaseInputValue]
        ) {
            self.column = column
            self.values = values
        }
        
        public func inputValues() -> [IQDatabaseInputValue] {
            return self.values
        }
        
        public func queryExpression() -> String {
            let values = self.values.compactMap({ _ in return "?" })
            return self.column.name + " IN (" +  values.joined(separator: ", ") + ")"
        }
        
    }
    
    struct NotInExpression : IQDatabaseExpressable {
        
        public let column: QDatabase.Column
        public let values: [IQDatabaseInputValue]
        
        public init(
            _ column: QDatabase.Column,
            _ values: [IQDatabaseInputValue]
        ) {
            self.column = column
            self.values = values
        }
        
        public func inputValues() -> [IQDatabaseInputValue] {
            return self.values
        }
        
        public func queryExpression() -> String {
            let values = self.values.compactMap({ _ in return "?" })
            return self.column.name + " NOT IN (" +  values.joined(separator: ", ") + ")"
        }
        
    }
    
}
