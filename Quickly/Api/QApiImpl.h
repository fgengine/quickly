//
//  Quickly
//

@import Foundation;

@interface QApiImplAuthenticationChallenge : NSObject

@property(nonatomic, readonly) NSURLSessionAuthChallengeDisposition disposition;
@property(nonatomic, nullable, readonly) NSURLCredential* credential;

- (nonnull instancetype)initWithLocalCertificateUrl:(nullable NSURL*)localCertificateUrl
                           allowInvalidCertificates:(BOOL)allowInvalidCertificates
                                          challenge:(nonnull NSURLAuthenticationChallenge*)challenge;

@end
