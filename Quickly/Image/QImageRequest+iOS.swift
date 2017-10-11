//
//  Quickly
//

#if os(iOS)

    public class QImageRequest: QApiRequest {

        public init(url: URL) {
            super.init(method: "GET")
            self.url = url
        }

    }

#endif
