//
//  Quickly
//

@import Foundation;

@interface QImplAuthenticationChallenge : NSObject

@property(nonatomic, readonly) NSURLSessionAuthChallengeDisposition disposition;
@property(nonatomic, nullable, readonly) NSURLCredential* credential;

- (nonnull instancetype)initWithLocalCertificateUrls:(nonnull NSArray< NSURL* >*)localCertificateUrls
                            allowInvalidCertificates:(BOOL)allowInvalidCertificates
                                           challenge:(nonnull NSURLAuthenticationChallenge*)challenge;

@end
