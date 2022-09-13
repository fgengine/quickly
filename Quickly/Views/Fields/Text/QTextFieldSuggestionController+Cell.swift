//
//  Quickly
//

import UIKit

extension QTextFieldSuggestionController {
    
    class Composable : QTitleComposable {
        
        init(
            text: String,
            font: UIFont,
            color: UIColor
        ) {
            super.init(
                edgeInsets: UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12),
                titleStyle: QLabelStyleSheet(
                    text: QText(
                        text: text,
                        font: font,
                        color: color
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
        
        init(
            text: String,
            font: UIFont,
            color: UIColor
        ) {
            self.text = text
            super.init(
                composable: Composable(text: text, font: font, color: color),
                backgroundColor: UIColor.white,
                selectedBackgroundColor: UIColor.lightGray
            )
        }
        
    }

    class Cell : QCompositionCollectionCell< Composition > {
    }

}
