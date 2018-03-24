//
//  Quickly
//

import Quickly

class DisclosureShape : QShapeModel {

    public init(color: UIColor) {
        super.init(size: CGSize(width: 8, height: 24))
        self.strokeColor = color
        self.lineWidth = 1
        self.lineCap = .round
        self.lineJoin = .round
    }

    override func prepare(_ bounds: CGRect) -> UIBezierPath? {
        let path: UIBezierPath = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: self.size.width, y: self.size.height / 2))
        path.addLine(to: CGPoint(x: 0, y: self.size.height))
        path.apply(CGAffineTransform(
            translationX: ((bounds.width - self.size.width) / 2),
            y: ((bounds.height - self.size.height) / 2)
        ))
        return path
    }

}
