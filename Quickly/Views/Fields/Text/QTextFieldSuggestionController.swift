//
//  Quickly
//

public class QTextFieldSuggestionController : QCollectionController, IQTextFieldSuggestionController {
    
    public var onSelectSuggestion: SelectSuggestionClosure?
    
    private lazy var _section: QCollectionSection = {
        let section = QCollectionSection(items: [])
        section.insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        section.minimumInteritemSpacing = 6
        return section
    }()
    
    public init() {
        super.init(cells: [
            Cell.self
        ])
    }
    
    open override func configure() {
        super.configure()
        self.sections = [ self._section ]
    }
    
    public func set(variants: [String]) {
        self._section.setItems(variants.compactMap({
            return Item(text: $0)
        }))
    }
    
}

extension QTextFieldSuggestionController {
    
    @objc
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.item(indexPath: indexPath)
        if let item = item as? Item {
            self.onSelectSuggestion?(self, item.text)
        }
        self.deselect(item: item, animated: true)
    }
    
}
