//
//  Quickly
//

#import "QApiImpl.h"

#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonDigest.h>

static NSString* QApiImplSHA256(NSData* data) {
    NSString* base64 = [data base64EncodedStringWithOptions:(NSDataBase64EncodingOptions)0];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    const char* string = base64.UTF8String;
    CC_SHA256(string, (CC_LONG)strlen(string), result);
    return [[NSString  stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X", result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7], result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15], result[16], result[17], result[18], result[19], result[20], result[21], result[22], result[23], result[24], result[25], result[26], result[27], result[28], result[29], result[30], result[31]] lowercaseString];
}

@implementation QApiImplAuthenticationChallenge

@synthesize disposition = _disposition;
@synthesize credential = _credential;

- (instancetype)initWithLocalCertificateUrls:(NSArray< NSURL* >*)localCertificateUrls
                    allowInvalidCertificates:(BOOL)allowInvalidCertificates
                                   challenge:(NSURLAuthenticationChallenge*)challenge {
    self = [super init];
    if(self != nil) {
        if(localCertificateUrls.count > 0) {
            for (NSURL* localCertificateUrl in localCertificateUrls) {
                [self __setupLocalCertificateUrl:localCertificateUrl
                        allowInvalidCertificates:allowInvalidCertificates
                                       challenge:challenge];
                if(_disposition != NSURLSessionAuthChallengeCancelAuthenticationChallenge) {
                    break;
                }
            }
        } else {
            [self __setupLocalCertificateUrl:nil
                    allowInvalidCertificates:allowInvalidCertificates
                                   challenge:challenge];
        }
    }
    return self;
}

- (void)__setupLocalCertificateUrl:(NSURL*)localCertificateUrl
          allowInvalidCertificates:(BOOL)allowInvalidCertificates
                         challenge:(NSURLAuthenticationChallenge*)challenge {
    SecTrustRef serverTrust = challenge.protectionSpace.serverTrust;
    if(localCertificateUrl != nil) {
        SecCertificateRef localCertificate = NULL;
        SecTrustResultType serverTrustResult = kSecTrustResultOtherError;
        NSData* data = [NSData dataWithContentsOfURL:localCertificateUrl];
        if(data != nil) {
            CFDataRef cfData = (__bridge_retained CFDataRef)data;
            localCertificate = SecCertificateCreateWithData(NULL, cfData);
            if(localCertificate != NULL) {
                CFArrayRef cfCertArray = CFArrayCreate(NULL, (void*)&localCertificate, 1, NULL);
                if(cfCertArray != NULL) {
                    SecTrustSetAnchorCertificates(serverTrust, cfCertArray);
                    SecTrustEvaluate(serverTrust, &serverTrustResult);
                    if(serverTrustResult == kSecTrustResultRecoverableTrustFailure) {
                        CFDataRef cfErrorData = SecTrustCopyExceptions(serverTrust);
                        SecTrustSetExceptions(serverTrust, cfErrorData);
                        SecTrustEvaluate(serverTrust, &serverTrustResult);
                        CFRelease(cfErrorData);
                    }
                    CFRelease(cfCertArray);
                }
            }
            CFRelease(cfData);
        }
        if((serverTrustResult == kSecTrustResultUnspecified) || (serverTrustResult == kSecTrustResultProceed)) {
            SecCertificateRef serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0);
            if(serverCertificate != NULL) {
                NSString* serverHash = nil;
                NSData* serverCertificateData = (__bridge_transfer NSData*)SecCertificateCopyData(serverCertificate);
                if(serverCertificateData != nil) {
                    serverHash = QApiImplSHA256(serverCertificateData);
                }
                NSString* localHash = nil;
                NSData* localCertificateData = (__bridge_transfer NSData*)SecCertificateCopyData(localCertificate);
                if(localCertificateData != nil) {
                    localHash = QApiImplSHA256(localCertificateData);
                }
                if((localHash != nil) && ([serverHash isEqualToString:localHash] == YES)) {
                    _disposition = NSURLSessionAuthChallengeUseCredential;
                    _credential = [NSURLCredential credentialForTrust:serverTrust];
                } else {
                    _disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
                    _credential = nil;
                }
            } else {
                _disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
                _credential = nil;
            }
        } else {
            _disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
            _credential = nil;
        }
        if(localCertificate != NULL) {
            CFRelease(localCertificate);
        }
    } else if(allowInvalidCertificates == NO) {
        _disposition = NSURLSessionAuthChallengeUseCredential;
        _credential = [NSURLCredential credentialForTrust:serverTrust];
    } else {
        _disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        _credential = nil;
    }
}

@end
