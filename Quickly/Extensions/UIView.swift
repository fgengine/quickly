//
//  Quickly
//

extension UIView {
    
    public func setContentHuggingPriority(horizontal: UILayoutPriority, vertical: UILayoutPriority) {
        self.setContentHuggingPriority(horizontal, for: .horizontal)
        self.setContentHuggingPriority(vertical, for: .vertical)
    }
    
    public func setContentCompressionResistancePriority(horizontal: UILayoutPriority, vertical: UILayoutPriority) {
        self.setContentCompressionResistancePriority(horizontal, for: .horizontal)
        self.setContentCompressionResistancePriority(vertical, for: .vertical)
    }
    
}
