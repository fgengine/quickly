//
//  Quickly
//

@import Foundation;
@import UIKit;

extern NSErrorDomain _Nonnull QJsonImplErrorDomain;

typedef NS_ENUM(NSInteger, QJsonImplErrorCode) {
    QJsonImplErrorCodeNotFound,
    QJsonImplErrorCodeConvert
};

@interface QJsonImpl : NSObject

@property(nonatomic, nullable, readonly, strong) id root;

- (nonnull instancetype)init NS_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithRoot:(nullable id)root NS_SWIFT_NAME(init(root:)) NS_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithData:(nonnull NSData*)data NS_SWIFT_NAME(init(data:));
- (nullable instancetype)initWithString:(nonnull NSString*)string NS_SWIFT_NAME(init(string:));
- (nullable instancetype)initWithString:(nonnull NSString*)string encoding:(NSStringEncoding)encoding NS_SWIFT_NAME(init(string:encoding:));

- (nullable NSData*)saveAsData NS_SWIFT_NAME(saveAsData());
- (nullable NSString*)saveAsString NS_SWIFT_NAME(saveAsString());
- (nullable NSString*)saveAsStringEncoding:(NSStringEncoding)encoding NS_SWIFT_NAME(saveAsString(encoding:));

- (BOOL)isDictionary NS_SWIFT_NAME(isDictionary());
- (void)setDictionary:(nonnull NSDictionary*)dictionary NS_SWIFT_NAME(set(value:));
- (nullable NSDictionary*)dictionary NS_SWIFT_NAME(dictionary());

- (BOOL)isArray NS_SWIFT_NAME(isArray());
- (void)setArray:(nonnull NSArray*)array NS_SWIFT_NAME(set(value:));
- (nullable NSArray*)array NS_SWIFT_NAME(array());

- (void)clean NS_SWIFT_NAME(clean());

- (BOOL)setObject:(nullable id)object forPath:(nonnull NSString*)path NS_SWIFT_NAME(set(object:forPath:));
- (BOOL)setDictionary:(nullable NSDictionary*)dictionary forPath:(nonnull NSString*)path NS_SWIFT_NAME(set(dictionary:forPath:));
- (BOOL)setArray:(nullable NSArray*)array forPath:(nonnull NSString*)path NS_SWIFT_NAME(set(array:forPath:));
- (BOOL)setBoolean:(BOOL)value forPath:(nonnull NSString*)path NS_SWIFT_NAME(set(boolean:forPath:));
- (BOOL)setNumber:(nullable NSNumber*)number forPath:(nonnull NSString*)path NS_SWIFT_NAME(set(number:forPath:));
- (BOOL)setDecimalNumber:(nullable NSDecimalNumber*)decimalNumber forPath:(nonnull NSString*)path NS_SWIFT_NAME(set(decimalNumber:forPath:));
- (BOOL)setString:(nullable NSString*)string forPath:(nonnull NSString*)path NS_SWIFT_NAME(set(string:forPath:));
- (BOOL)setUrl:(nullable NSURL*)url forPath:(nonnull NSString*)path NS_SWIFT_NAME(set(url:forPath:));
- (BOOL)setDate:(nullable NSDate*)date forPath:(nonnull NSString*)path NS_SWIFT_NAME(set(date:forPath:));
- (BOOL)setDate:(nullable NSDate*)date format:(nonnull NSString*)format forPath:(nonnull NSString*)path NS_SWIFT_NAME(set(date:format:forPath:));
- (BOOL)setColor:(nullable UIColor*)color forPath:(nonnull NSString*)path NS_SWIFT_NAME(set(color:forPath:));

- (nullable id)objectAtPath:(nonnull NSString*)path error:(NSError* _Nullable __autoreleasing * _Nullable)error NS_SWIFT_NAME(object(at:));
- (nullable NSDictionary*)dictionaryAtPath:(nonnull NSString*)path error:(NSError* _Nullable __autoreleasing * _Nullable)error NS_SWIFT_NAME(dictionary(at:));
- (nullable NSArray*)arrayAtPath:(nonnull NSString*)path error:(NSError* _Nullable __autoreleasing * _Nullable)error NS_SWIFT_NAME(array(at:));
- (nullable NSNumber*)numberAtPath:(nonnull NSString*)path error:(NSError* _Nullable __autoreleasing * _Nullable)error NS_SWIFT_NAME(number(at:));
- (nullable NSDecimalNumber*)decimalNumberAtPath:(nonnull NSString*)path error:(NSError* _Nullable __autoreleasing * _Nullable)error NS_SWIFT_NAME(decimalNumber(at:));
- (nullable NSString*)stringAtPath:(nonnull NSString*)path error:(NSError* _Nullable __autoreleasing * _Nullable)error NS_SWIFT_NAME(string(at:));
- (nullable NSURL*)urlAtPath:(nonnull NSString*)path error:(NSError* _Nullable __autoreleasing * _Nullable)error NS_SWIFT_NAME(url(at:));
- (nullable NSDate*)dateAtPath:(nonnull NSString*)path error:(NSError* _Nullable __autoreleasing * _Nullable)error NS_SWIFT_NAME(date(at:));
- (nullable NSDate*)dateAtPath:(nonnull NSString*)path formats:(nonnull NSArray< NSString* >*)formats error:(NSError* _Nullable __autoreleasing * _Nullable)error NS_SWIFT_NAME(date(at:formats:));
- (nullable UIColor*)colorAtPath:(nonnull NSString*)path error:(NSError* _Nullable __autoreleasing * _Nullable)error NS_SWIFT_NAME(color(at:));

+ (nullable id)objectFromBoolean:(BOOL)value NS_SWIFT_NAME(objectFrom(boolean:));
+ (nullable id)objectFromNumber:(nullable NSNumber*)number NS_SWIFT_NAME(objectFrom(number:));
+ (nullable id)objectFromDecimalNumber:(nullable NSDecimalNumber*)decimalNumber NS_SWIFT_NAME(objectFrom(decimalNumber:));
+ (nullable id)objectFromString:(nullable NSString*)string NS_SWIFT_NAME(objectFrom(string:));
+ (nullable id)objectFromUrl:(nullable NSURL*)url NS_SWIFT_NAME(objectFrom(url:));
+ (nullable id)objectFromDate:(nullable NSDate*)date NS_SWIFT_NAME(objectFrom(date:));
+ (nullable id)objectFromDate:(nullable NSDate*)date format:(nonnull NSString*)format NS_SWIFT_NAME(objectFrom(date:format:));
+ (nullable id)objectFromColor:(nullable UIColor*)color NS_SWIFT_NAME(objectFrom(color:));

+ (nullable NSNumber*)numberFromObject:(nullable id)object error:(NSError* _Nullable __autoreleasing * _Nullable)error NS_SWIFT_NAME(toNumber(from:));
+ (nullable NSDecimalNumber*)decimalNumberFromObject:(nullable id)object error:(NSError* _Nullable __autoreleasing * _Nullable)error NS_SWIFT_NAME(toDecimalNumber(from:));
+ (nullable NSString*)stringFromObject:(nullable id)object error:(NSError* _Nullable __autoreleasing * _Nullable)error NS_SWIFT_NAME(toString(from:));
+ (nullable NSURL*)urlFromObject:(nullable id)object error:(NSError* _Nullable __autoreleasing * _Nullable)error NS_SWIFT_NAME(toUrl(from:));
+ (nullable NSDate*)dateFromObject:(nullable id)object error:(NSError* _Nullable __autoreleasing * _Nullable)error NS_SWIFT_NAME(toDate(from:));
+ (nullable NSDate*)dateFromObject:(nullable id)object formats:(nonnull NSArray< NSString* >*)formats error:(NSError* _Nullable __autoreleasing * _Nullable)error NS_SWIFT_NAME(toDate(from:formats:));
+ (nullable UIColor*)colorFromObject:(nullable id)object error:(NSError* _Nullable __autoreleasing * _Nullable)error NS_SWIFT_NAME(toColor(from:));

@end
