//
//  Quickly
//

#if os(iOS)

    public struct QLabelStyleSheet : IQStyleSheet {

        public var text: IQText
        public var contentAlignment: QLabel.ContentAlignment = .left
        public var padding: CGFloat = 0
        public var numberOfLines: Int = 0
        public var lineBreakMode: NSLineBreakMode = .byWordWrapping

        public init(text: IQText) {
            self.text = text
            self.contentAlignment = .left
            self.padding = 0
            self.numberOfLines = 0
            self.lineBreakMode = .byWordWrapping
        }

        public func apply(target: QLabel) {
            target.text = self.text
            target.contentAlignment = self.contentAlignment
            target.padding = self.padding
            target.numberOfLines = self.numberOfLines
            target.lineBreakMode = self.lineBreakMode
        }

    }

#endif
