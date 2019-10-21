//
//  Quickly
//

// MARK: Public • QDatabase.LikeExpression

public extension QDatabase {

    struct LikeExpression : IQDatabaseExpressable {
        
        public let column: QDatabase.Column
        public let value: String
        
        public init(
            _ column: QDatabase.Column,
            _ value: String
            ) {
            self.column = column
            self.value = value
        }
        
        public func inputValues() -> [IQDatabaseInputValue] {
            return []
        }
        
        public func queryExpression() -> String {
            return self.column.name + " LIKE '" + value + "'"
        }
        
    }
    
}
