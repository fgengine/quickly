//
//  Quickly
//

import UIKit

open class QSeparatorTableRow : QBackgroundColorTableRow {

    public var edgeInsets: UIEdgeInsets
    public var color: UIColor

    public init(color: UIColor, backgroundColor: UIColor? = nil, edgeInsets: UIEdgeInsets = UIEdgeInsets.zero) {
        self.edgeInsets = edgeInsets
        self.color = color
        super.init(backgroundColor: backgroundColor)
        self.canSelect = false
    }

}

open class QSeparatorTableCell< RowType: QSeparatorTableRow > : QBackgroundColorTableCell< RowType > {

    private var lineView: QView!

    private var _edgeInsets: UIEdgeInsets?

    private var _constraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self._constraints) }
        didSet { self.contentView.addConstraints(self._constraints) }
    }

    open override class func height(row: RowType, spec: IQContainerSpec) -> CGFloat {
        return row.edgeInsets.top + (1 / UIScreen.main.scale) + row.edgeInsets.bottom
    }

    open override func setup() {
        super.setup()

        self.lineView = QView(frame: self.contentView.bounds)
        self.lineView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.lineView)
    }

    open override func prepare(row: RowType, spec: IQContainerSpec, animated: Bool) {
        super.prepare(row: row, spec: spec, animated: animated)
        
        if self._edgeInsets != row.edgeInsets {
            self._edgeInsets = row.edgeInsets
            self._constraints = [
                self.lineView.topLayout == self.contentView.topLayout.offset(row.edgeInsets.top),
                self.lineView.leadingLayout == self.contentView.leadingLayout.offset(row.edgeInsets.left),
                self.lineView.trailingLayout == self.contentView.trailingLayout.offset(-row.edgeInsets.right),
                self.lineView.bottomLayout == self.contentView.bottomLayout.offset(-row.edgeInsets.bottom)
            ]
        }
        self.lineView.backgroundColor = row.color
    }

}
