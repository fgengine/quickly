//
//  Quickly
//

import UIKit

extension QPhotosViewController {
    
    public class ThumbnailItemStyle {

        public var selectedAlpha: CGFloat
        public var selectedBorderWidth: CGFloat
        public var selectedBorderColor: UIColor?
        public var unselectedAlpha: CGFloat
        public var unselectedBorderWidth: CGFloat
        public var unselectedBorderColor: UIColor?
        
        public init(
            selectedAlpha: CGFloat = 1,
            selectedBorderWidth: CGFloat = 1,
            selectedBorderColor: UIColor? = nil,
            unselectedAlpha: CGFloat = 0.8,
            unselectedBorderWidth: CGFloat = 1,
            unselectedBorderColor: UIColor? = nil
        ) {
            self.selectedAlpha = selectedAlpha
            self.selectedBorderWidth = selectedBorderWidth
            self.selectedBorderColor = selectedBorderColor
            self.unselectedAlpha = unselectedAlpha
            self.unselectedBorderWidth = unselectedBorderWidth
            self.unselectedBorderColor = unselectedBorderColor
        }

    }
    
}
