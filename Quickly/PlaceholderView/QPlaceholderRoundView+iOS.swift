//
//  Quickly
//

#if os(iOS)

    open class QPlaceholderRoundView : QRoundView, IQPlaceholderView {

        public init(color: QPlatformColor) {
            super.init(frame: CGRect.zero)

            self.backgroundColor = color
        }

        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

    }

#endif
