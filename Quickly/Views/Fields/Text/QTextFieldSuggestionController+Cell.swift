//
//  Quickly
//

extension QTextFieldSuggestionController {
    
    class Composable : QTitleComposable {
        
        init(text: String) {
            super.init(
                edgeInsets: UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12),
                titleStyle: QLabelStyleSheet(
                    text: QText(
                        text: text,
                        font: UIFont.boldSystemFont(ofSize: UIFont.buttonFontSize),
                        color: UIColor.systemBlue
                    )
                )
            )
        }
        
    }

    class Composition : QTitleComposition< Composable > {
        
        override class func size(composable: Composable, spec: IQContainerSpec) -> CGSize {
            let availableHeight = spec.containerSize.height - (composable.edgeInsets.top + composable.edgeInsets.bottom)
            let textSize = composable.titleStyle.size(height: availableHeight)
            return CGSize(
                width: composable.edgeInsets.left + textSize.width + composable.edgeInsets.right,
                height: spec.containerSize.height
            )
        }
        
    }

    class Item : QCompositionCollectionItem< Composable > {
        
        let text: String
        
        init(text: String) {
            self.text = text
            super.init(
                composable: Composable(text: text),
                backgroundColor: UIColor.white,
                selectedBackgroundColor: UIColor.lightGray
            )
        }
        
    }

    class Cell : QCompositionCollectionCell< Composition > {
    }

}
