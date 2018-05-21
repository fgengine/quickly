//
//  Quickly
//

import Quickly

class DisclosureShape : QShapeModel {

    init(color: UIColor) {
        super.init(size: CGSize(width: 8, height: 24))
        self.strokeColor = color
        self.lineWidth = 1
        self.lineCap = .round
        self.lineJoin = .round
    }

    override func make() -> UIBezierPath? {
        let size2 = CGSize(width: self.size.width / 2, height: self.size.height / 2)

        let path = UIBezierPath()
        path.move(to: CGPoint(x: -size2.width, y: -size2.height))
        path.addLine(to: CGPoint(x: size2.width, y: 0))
        path.addLine(to: CGPoint(x: -size2.width, y: size2.height))
        return path
    }

}
