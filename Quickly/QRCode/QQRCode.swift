//
//  Quickly
//

public struct QQRCode {
    
    public enum ErrorCorrection : String {
        case low = "L"
        case medium = "M"
        case quartile = "Q"
        case high = "H"
    }
    
    public let data: Data
    public let errorCorrection: ErrorCorrection
    
    public init(
        data: Data,
        errorCorrection: ErrorCorrection = .low
    ) {
        self.data = data
        self.errorCorrection = errorCorrection
    }
    
    public func generate(
        color: UIColor = UIColor.white,
        backgroundColor: UIColor = UIColor.black,
        size: CGSize = CGSize(width: 200, height: 200)
    ) -> UIImage? {
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else {
            return nil
        }
        qrFilter.setDefaults()
        qrFilter.setValue(self.data, forKey: "inputMessage")
        qrFilter.setValue(self.errorCorrection.rawValue, forKey: "inputCorrectionLevel")
        guard let colorFilter = CIFilter(name: "CIFalseColor") else {
            return nil
        }
        colorFilter.setDefaults()
        colorFilter.setValue(qrFilter.outputImage, forKey: "inputImage")
        colorFilter.setValue(CIColor(cgColor: color.cgColor), forKey: "inputColor0")
        colorFilter.setValue(CIColor(cgColor: backgroundColor.cgColor), forKey: "inputColor1")
        guard let ciImage = colorFilter.outputImage else {
            return nil
        }
        let ciImageSize = ciImage.extent.size
        let widthRatio = size.width / ciImageSize.width
        let heightRatio = size.height / ciImageSize.height
        return ciImage.nonInterpolatedImage(withScale: CGPoint(x: widthRatio, y: heightRatio))
    }
    
}
