//
//  Quickly
//

#if os(iOS)

    open class QBackgroundColorCollectionCell< ItemType: QBackgroundColorCollectionItem >: QCollectionCell< ItemType > {

        open override func set(item: ItemType) {
            super.set(item: item)
            self.apply(item: item)
        }

        open override func update(item: ItemType) {
            super.update(item: item)
            self.apply(item: item)
        }

        private func apply(item: QBackgroundColorCollectionItem) {
            if let backgroundColor: UIColor = item.backgroundColor {
                self.backgroundColor = backgroundColor
            }
            if let selectedBackgroundColor: UIColor = item.selectedBackgroundColor {
                let view: UIView = UIView(frame: self.bounds)
                view.backgroundColor = selectedBackgroundColor
                self.selectedBackgroundView = view
            } else {
                self.selectedBackgroundView = nil
            }
        }

    }

#endif
