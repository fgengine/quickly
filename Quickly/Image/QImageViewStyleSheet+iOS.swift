//
//  Quickly
//

#if os(iOS)

    public struct QImageViewStyleSheet : IQStyleSheet {

        public var verticalAlignment: QImageViewVerticalAlignment
        public var horizontalAlignment: QImageViewHorizontalAlignment
        public var roundCorners: Bool
        public var source: QImageSource
        public var filter: IQImageLoaderFilter?
        public var loader: QImageLoader?

        public init(source: QImageSource) {
            self.verticalAlignment = .center
            self.horizontalAlignment = .center
            self.roundCorners = false
            self.source = source
        }

        public func apply(target: QImageView) {
            target.verticalAlignment = self.verticalAlignment
            target.horizontalAlignment = self.horizontalAlignment
            target.roundCorners = self.roundCorners
            target.source = self.source
            target.filter = self.filter
            target.loader = self.loader
        }

    }

#endif
