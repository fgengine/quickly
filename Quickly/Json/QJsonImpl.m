//
//  Quickly
//


#import "QJsonImpl.h"

NSErrorDomain QJsonImplErrorDomain = @"QJsonImplErrorDomain";

NSString* QJsonImplErrorPathKey = @"QJsonImplErrorPathKey";

static NSString* QJsonImplPathSeparator = @".";
static NSString* QJsonImplPathIndexPattern = @"^\\[\\d+\\]$";

@interface QJsonImpl () {
    NSRegularExpression* _indexRegexp;
}

@end

@implementation QJsonImpl

@synthesize basePath = _basePath;
@synthesize root = _root;

- (instancetype)initWithBasePath:(NSString*)basePath {
    self = [super init];
    if(self != nil) {
        _basePath = basePath;
    }
    return self;
}

- (instancetype)initWithBasePath:(NSString*)basePath root:(id)root {
    self = [super init];
    if(self != nil) {
        _basePath = basePath;
        _root = root;
    }
    return self;
}

- (instancetype)initWithBasePath:(NSString*)basePath data:(NSData*)data {
    id root = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingOptions)0 error:nil];
    if(root == nil) {
        return nil;
    }
    return [self initWithBasePath:basePath root:root];
}

- (instancetype)initWithBasePath:(NSString*)basePath string:(NSString*)string {
    return [self initWithBasePath:basePath string:string encoding:NSUTF8StringEncoding];
}

- (instancetype)initWithBasePath:(NSString*)basePath string:(NSString*)string encoding:(NSStringEncoding)encoding {
    NSData* data = [string dataUsingEncoding:encoding];
    if(data == nil) {
        return nil;
    }
    return [self initWithBasePath:basePath data:data];
}

- (NSData*)saveAsData {
    if(_root != nil) {
        return [NSJSONSerialization dataWithJSONObject:_root options:(NSJSONWritingOptions)0 error:nil];
    }
    return nil;
}

- (NSString*)saveAsString {
    return [self saveAsStringEncoding:NSUTF8StringEncoding];
}

- (NSString*)saveAsStringEncoding:(NSStringEncoding)encoding {
    NSData* data = [self saveAsData];
    if(data != nil) {
        return [[NSString alloc] initWithData:data encoding:encoding];
    }
    return nil;
}

- (void)clean {
    _root = nil;
}

- (BOOL)isDictionary {
    return [_root isKindOfClass:NSDictionary.class];
}

- (void)setDictionary:(NSDictionary*)dictionary {
    _root = dictionary;
}

- (NSDictionary*)dictionary {
    if([_root isKindOfClass:NSDictionary.class] == YES) {
        return _root;
    }
    return nil;
}

- (BOOL)isArray {
    return (([_root isKindOfClass:NSArray.class] == YES) || ([_root isKindOfClass:NSOrderedSet.class] == YES));
}

- (void)setArray:(NSArray*)array {
    _root = array;
}

- (NSArray*)array {
    if(([_root isKindOfClass:NSArray.class] == YES) || ([_root isKindOfClass:NSOrderedSet.class] == YES)) {
        return _root;
    }
    return nil;
}

- (BOOL)setObject:(id)object forPath:(NSString*)path {
    BOOL successful = NO;
    if(path.length > 0) {
        if([path containsString:QJsonImplPathSeparator] == YES) {
            NSArray< NSString* >* paths = [self _paths:path];
            if(paths != nil) {
                [self _setPaths:paths index:0 object:object successful:&successful];
            }
        } else {
            [self _setPaths:@[path] index:0 object:object successful:&successful];
        }
    } else {
        _root = object;
    }
    return successful;
}

- (BOOL)setDictionary:(NSDictionary*)dictionary forPath:(NSString*)path {
    return [self setObject:dictionary forPath:path];
}

- (BOOL)setArray:(NSArray*)array forPath:(NSString*)path {
    return [self setObject:array forPath:path];
}

- (BOOL)setBoolean:(BOOL)value forPath:(NSString*)path {
    return [self setObject:[QJsonImpl objectFromBoolean:value] forPath:path];
}

- (BOOL)setNumber:(NSNumber*)number forPath:(NSString*)path {
    return [self setObject:[QJsonImpl objectFromNumber:number] forPath:path];
}

- (BOOL)setDecimalNumber:(NSDecimalNumber*)decimalNumber forPath:(NSString*)path {
    return [self setObject:[QJsonImpl objectFromDecimalNumber:decimalNumber] forPath:path];
}

- (BOOL)setString:(NSString*)string forPath:(NSString*)path {
    return [self setObject:[QJsonImpl objectFromString:string] forPath:path];
}

- (BOOL)setUrl:(NSURL*)url forPath:(NSString*)path {
    return [self setObject:[QJsonImpl objectFromUrl:url] forPath:path];
}

- (BOOL)setDate:(NSDate*)date forPath:(NSString*)path {
    return [self setObject:[QJsonImpl objectFromDate:date] forPath:path];
}

- (BOOL)setDate:(NSDate*)date format:(NSString*)format forPath:(NSString*)path {
    return [self setObject:[QJsonImpl objectFromDate:date format:format] forPath:path];
}

- (BOOL)setColor:(QJsonColor*)color forPath:(NSString*)path {
    return [self setObject:[QJsonImpl objectFromColor:color] forPath:path];
}

- (id)objectAtPath:(NSString*)path error:(NSError* __autoreleasing *)error {
    id result = nil;
    if(path.length > 0) {
        if([path containsString:QJsonImplPathSeparator] == YES) {
            NSArray< NSString* >* paths = [self _paths:path];
            if(paths != nil) {
                result = [self _get:_root paths:paths index:0];
            }
        } else {
            result = [self _get:_root paths:@[path] index:0];
        }
    } else {
        result = _root;
    }
    if((result == nil) && (error != nil)) {
        *error = [QJsonImpl notFoundError:[QJsonImpl preparePath:_basePath path:path]];
    }
    return result;
}

- (NSDictionary*)dictionaryAtPath:(NSString*)path error:(NSError* __autoreleasing *)error {
    id object = [self objectAtPath:path error:error];
    if(object == nil) {
        return nil;
    }
    if([object isKindOfClass:NSDictionary.class] == YES) {
        return object;
    }
    if(error != nil) {
        *error = [QJsonImpl convertError:[QJsonImpl preparePath:_basePath path:path]];
    }
    return nil;
}

- (NSArray*)arrayAtPath:(NSString*)path error:(NSError* __autoreleasing *)error {
    id object = [self objectAtPath:path error:error];
    if(object == nil) {
        return nil;
    }
    if(([object isKindOfClass:NSArray.class] == YES) || ([object isKindOfClass:NSOrderedSet.class] == YES)) {
        return object;
    }
    if(error != nil) {
        *error = [QJsonImpl convertError:[QJsonImpl preparePath:_basePath path:path]];
    }
    return nil;
}

- (NSNumber*)numberAtPath:(NSString*)path error:(NSError* __autoreleasing *)error {
    id object = [self objectAtPath:path error:error];
    if(object == nil) {
        return nil;
    }
    return [QJsonImpl numberFromObject:object forPath:path error:error];
}

- (NSDecimalNumber*)decimalNumberAtPath:(NSString*)path error:(NSError* __autoreleasing *)error {
    id object = [self objectAtPath:path error:error];
    if(object == nil) {
        return nil;
    }
    return [QJsonImpl decimalNumberFromObject:object forPath:path error:error];
}

- (NSString*)stringAtPath:(NSString*)path error:(NSError* __autoreleasing *)error {
    id object = [self objectAtPath:path error:error];
    if(object == nil) {
        return nil;
    }
    return [QJsonImpl stringFromObject:object forPath:path error:error];
}

- (NSURL*)urlAtPath:(NSString*)path error:(NSError* __autoreleasing *)error {
    id object = [self objectAtPath:path error:error];
    if(object == nil) {
        return nil;
    }
    return [QJsonImpl urlFromObject:object forPath:path error:error];
}

- (NSDate*)dateAtPath:(NSString*)path error:(NSError* __autoreleasing *)error {
    id object = [self objectAtPath:path error:error];
    if(object == nil) {
        return nil;
    }
    return [QJsonImpl dateFromObject:object forPath:path error:error];
}

- (NSDate*)dateAtPath:(NSString*)path formats:(NSArray< NSString* >*)formats error:(NSError* __autoreleasing *)error {
    id object = [self objectAtPath:path error:error];
    if(object == nil) {
        return nil;
    }
    return [QJsonImpl dateFromObject:object forPath:path formats:formats error:error];
}

- (QJsonColor*)colorAtPath:(NSString*)path error:(NSError* __autoreleasing *)error {
    id object = [self objectAtPath:path error:error];
    if(object == nil) {
        return nil;
    }
    return [QJsonImpl colorFromObject:object forPath:path error:error];
}

+ (id)objectFromBoolean:(BOOL)value {
    return @(value);
}

+ (id)objectFromNumber:(NSNumber*)number {
    if(number == nil) {
        return nil;
    }
    return number;
}

+ (id)objectFromDecimalNumber:(NSDecimalNumber*)decimalNumber {
    if(decimalNumber == nil) {
        return nil;
    }
    return decimalNumber;
}

+ (id)objectFromString:(NSString*)string {
    if(string == nil) {
        return nil;
    }
    return string;
}

+ (id)objectFromUrl:(NSURL*)url {
    if(url == nil) {
        return nil;
    }
    return url.absoluteString;
}

+ (id)objectFromDate:(NSDate*)date {
    if(date == nil) {
        return nil;
    }
    return @(date.timeIntervalSince1970);
}

+ (id)objectFromDate:(NSDate*)date format:(NSString*)format {
    if(date == nil) {
        return nil;
    }
    if(format == nil) {
        return @(date.timeIntervalSince1970);
    }
    NSDateFormatter* formatter = [NSDateFormatter new];
    formatter.locale = NSLocale.currentLocale;
    formatter.dateFormat = format;
    return [formatter stringFromDate:date];
}

+ (id)objectFromColor:(QJsonColor*)color {
    if(color == nil) {
        return nil;
    }
    return QJsonImplStringFromColor(color);
}

+ (NSNumber*)numberFromObject:(id)object forPath:(NSString*)path error:(NSError* __autoreleasing *)error {
    NSNumber* number = nil;
    if([object isKindOfClass:NSNumber.class] == YES) {
        number = object;
    } else if([object isKindOfClass:NSString.class] == YES) {
        number = QJsonImplNumberFromString((NSString*)object);
        if(number == nil) {
            number = QJsonImplBoolFromString((NSString*)object);
        }
    }
    if((number == nil) && (error != nil)) {
        *error = [self convertError:path];
    }
    return number;
}

+ (NSDecimalNumber*)decimalNumberFromObject:(id)object forPath:(NSString*)path error:(NSError* __autoreleasing *)error {
    NSDecimalNumber* decimalNumber = nil;
    if([object isKindOfClass:NSNumber.class] == YES) {
        decimalNumber = [NSDecimalNumber decimalNumberWithString:[object stringValue]];
    } else if([object isKindOfClass:NSDecimalNumber.class] == YES) {
        decimalNumber = QJsonImplDecimalNumberFromString((NSString*)object);
    } else if([object isKindOfClass:NSString.class] == YES) {
        decimalNumber = QJsonImplDecimalNumberFromString((NSString*)object);
    }
    if((decimalNumber == nil) && (error != nil)) {
        *error = [self convertError:path];
    }
    return decimalNumber;
}

+ (NSString*)stringFromObject:(id)object forPath:(NSString*)path error:(NSError* __autoreleasing *)error {
    NSString* string = nil;
    if([object isKindOfClass:NSString.class] == YES) {
        string = object;
    } else if([object isKindOfClass:NSNumber.class] == YES) {
        string = [object stringValue];
    }
    if((string == nil) && (error != nil)) {
        *error = [self convertError:path];
    }
    return string;
}

+ (NSURL*)urlFromObject:(id)object forPath:(NSString*)path error:(NSError* __autoreleasing *)error {
    NSURL* url = nil;
    if([object isKindOfClass:NSString.class] == YES) {
        url = [NSURL URLWithString:object];
    }
    if((url == nil) && (error != nil)) {
        *error = [self convertError:path];
    }
    return url;
}

+ (NSDate*)dateFromObject:(id)object forPath:(NSString*)path error:(NSError* __autoreleasing *)error {
    NSDate* date = nil;
    if([object isKindOfClass:NSNumber.class] == YES) {
        date = [NSDate dateWithTimeIntervalSince1970:[object unsignedLongValue]];
    } else if([object isKindOfClass:NSString.class] == YES) {
        NSNumber* number = QJsonImplNumberFromString(object);
        if(number != nil) {
            date = [NSDate dateWithTimeIntervalSince1970:[number unsignedLongValue]];
        }
    }
    if((date == nil) && (error != nil)) {
        *error = [self convertError:path];
    }
    return date;
}

+ (NSDate*)dateFromObject:(id)object forPath:(NSString*)path formats:(NSArray< NSString* > *)formats error:(NSError* __autoreleasing *)error {
    NSDate* date = nil;
    if([object isKindOfClass:NSString.class] == YES) {
        NSDateFormatter* dateFormatter = [NSDateFormatter new];
        for(NSString* format in formats) {
            dateFormatter.dateFormat = format;
            NSDate* varDate = [dateFormatter dateFromString:object];
            if(varDate != nil) {
                date = varDate;
                break;
            }
        }
        if(date == nil) {
            NSNumber* number = QJsonImplNumberFromString(object);
            if(number != nil) {
                date = [NSDate dateWithTimeIntervalSince1970:[number unsignedLongValue]];
            }
        }
    } else if([object isKindOfClass:NSNumber.class] == YES) {
        date = [NSDate dateWithTimeIntervalSince1970:[object unsignedLongValue]];
    }
    if((date == nil) && (error != nil)) {
        *error = [self convertError:path];
    }
    return date;
}

+ (QJsonColor*)colorFromObject:(id)object forPath:(NSString*)path error:(NSError* __autoreleasing *)error {
    QJsonColor* color = nil;
    if([object isKindOfClass:NSString.class] == YES) {
        color = QJsonImplColorFromString(object);
    }
    if((color == nil) && (error != nil)) {
        *error = [self convertError:path];
    }
    return color;
}

+ (NSError*)notFoundError:(NSString*)path {
    return [self _error:QJsonImplErrorCodeNotFound path:path];
}

+ (NSError*)convertError:(NSString*)path {
    return [self _error:QJsonImplErrorCodeConvert path:path];
}

+ (NSString*)preparePath:(NSString*)path {
    return path;
}

+ (NSString*)preparePath:(NSString*)path index:(NSInteger)index {
    return [NSString stringWithFormat:@"%@[%d]", path, (int)index];
}

+ (NSString*)preparePath:(NSString*)path key:(id)key {
    return [NSString stringWithFormat:@"%@.%@", path, key];
}

+ (NSString*)preparePath:(NSString*)basePath path:(NSString*)path {
    if(basePath.length > 0) {
        return [NSString stringWithFormat:@"%@.%@", basePath, path];
    }
    return path;
}

+ (NSString*)preparePath:(NSString*)basePath path:(NSString*)path index:(NSInteger)index {
    if(basePath.length > 0) {
        return [NSString stringWithFormat:@"%@.%@[%d]", basePath, path, (int)index];
    }
    return [NSString stringWithFormat:@"%@[%d]", path, (int)index];
}

+ (NSString*)preparePath:(NSString*)basePath path:(NSString*)path key:(id)key {
    if(basePath.length > 0) {
        return [NSString stringWithFormat:@"%@.%@.%@", basePath, path, key];
    }
    return [NSString stringWithFormat:@"%@.%@", path, key];
}

- (NSArray*)_paths:(NSString*)path {
    NSArray< NSString* >* subPaths = [path componentsSeparatedByString:QJsonImplPathSeparator];
    NSMutableArray* result = [NSMutableArray arrayWithCapacity:subPaths.count];
    for(NSString* subPath in subPaths) {
        NSNumber* asIndex = nil;
        if([self _path:subPath index:&asIndex] == YES) {
            [result addObject:asIndex];
        } else {
            [result addObject:subPath];
        }
    }
    return result;
}

- (BOOL)_path:(NSString*)path index:(NSNumber* __autoreleasing *)index {
    BOOL result = NO;
    if(_indexRegexp == nil) {
        _indexRegexp = [NSRegularExpression regularExpressionWithPattern:QJsonImplPathIndexPattern options:NSRegularExpressionAnchorsMatchLines error:nil];
    }
    NSUInteger pathLength = path.length;
    NSRange range = [_indexRegexp rangeOfFirstMatchInString:path options:(NSMatchingOptions)0 range:NSMakeRange(0, pathLength)];
    if((range.location != NSNotFound) && (range.length > 0)) {
        NSNumber* number = nil;
        if(range.length > 0) {
            NSString* string = [path substringWithRange:NSMakeRange(1, pathLength - 2)];
            number = QJsonImplNumberFromString(string);
        }
        if(number != nil) {
            *index = number;
        }
        result = YES;
    }
    return result;
}

- (void)_setPaths:(NSArray*)paths index:(NSUInteger)index object:(id)object successful:(BOOL*)successful {
    if(_root == nil) {
        id path = paths[index];
        if([path isKindOfClass:NSNumber.class] == YES) {
            _root = [NSMutableArray array];
        } else {
            _root = [NSMutableDictionary dictionary];
        }
    }
    id mutating = [self _set:_root paths:paths index:index object:object successful:successful];
    if(mutating != nil) {
        _root = mutating;
    }
}

- (id)_set:(id)json paths:(NSArray*)paths index:(NSUInteger)index object:(id)object successful:(BOOL*)successful {
    BOOL isDictionary = [json isKindOfClass:NSDictionary.class];
    BOOL isArray = (isDictionary == NO) ? ([json isKindOfClass:NSArray.class] == YES) : NO;
    BOOL isOrderedSet = (isArray == NO) ? ([json isKindOfClass:NSOrderedSet.class] == YES) : NO;
    BOOL isCollection = ((isArray == YES) || (isOrderedSet == YES));
    BOOL isLastPath = (index == paths.count - 1);
    id path = paths[index];
    id mutating = nil;
    if(isLastPath == YES) {
        if(isDictionary == YES) {
            if([json isKindOfClass:NSMutableDictionary.class] == NO) {
                mutating = [NSMutableDictionary dictionaryWithDictionary:json];
                json = mutating;
            }
            if(object != nil) {
                [json setObject:object forKey:path];
            } else {
                id exist = [json objectForKey:path];
                if(exist != nil) {
                    [json removeObjectForKey:path];
                }
            }
            *successful = YES;
        } else if(isCollection == YES) {
            if((isArray == YES) && ([json isKindOfClass:NSMutableArray.class] == NO)) {
                mutating = [NSMutableArray arrayWithArray:json];
                json = mutating;
            } else if((isOrderedSet == YES) && ([json isKindOfClass:NSMutableOrderedSet.class] == NO)) {
                mutating = [NSMutableOrderedSet orderedSetWithOrderedSet:json];
                json = mutating;
            }
            NSUInteger arrayCount = [json count];
            NSUInteger pathAsIndex = [path unsignedIntegerValue];
            if(object != nil) {
                if(pathAsIndex < arrayCount) {
                    [json setObject:object atIndex:pathAsIndex];
                } else {
                    NSUInteger fc = pathAsIndex - arrayCount;
                    for(NSUInteger fi = 0; fi < fc; fi++) {
                        [json addObject:[NSNull null]];
                    }
                }
            } else {
                if(pathAsIndex < arrayCount) {
                    [json removeObjectAtIndex:pathAsIndex];
                }
            }
            *successful = YES;
        }
    } else {
        id exist = nil;
        NSUInteger pathAsIndex = NSNotFound;
        if(isDictionary == YES) {
            exist = [json objectForKey:path];
            if(exist == nil) {
                id nextPath = paths[index + 1];
                if([nextPath isKindOfClass:NSNumber.class] == YES) {
                    exist = [NSMutableArray array];
                } else {
                    exist = [NSMutableDictionary dictionary];
                }
                if([json isKindOfClass:NSMutableDictionary.class] == NO) {
                    mutating = [NSMutableDictionary dictionaryWithDictionary:json];
                    json = mutating;
                }
                [json setValue:exist forKey:path];
            }
        } else if(isCollection == YES) {
            if([path isKindOfClass:NSNumber.class] == YES) {
                if((isArray == YES) && ([json isKindOfClass:NSMutableArray.class] == NO)) {
                    mutating = [NSMutableArray arrayWithArray:json];
                    json = mutating;
                } else if((isOrderedSet == YES) && ([json isKindOfClass:NSMutableOrderedSet.class] == NO)) {
                    mutating = [NSMutableOrderedSet orderedSetWithOrderedSet:json];
                    json = mutating;
                }
                NSUInteger arrayCount = [json count];
                pathAsIndex = [path unsignedIntegerValue];
                if(pathAsIndex < arrayCount) {
                    exist = [json objectAtIndex:pathAsIndex];
                    if([exist isKindOfClass:NSNull.class] == YES) {
                        id nextPath = paths[index + 1];
                        if([nextPath isKindOfClass:NSNumber.class] == YES) {
                            exist = [NSMutableArray array];
                        } else {
                            exist = [NSMutableDictionary dictionary];
                        }
                        [json setObject:exist atIndex:pathAsIndex];
                    }
                } else {
                    id nextPath = paths[index + 1];
                    if([nextPath isKindOfClass:NSNumber.class] == YES) {
                        exist = [NSMutableArray array];
                    } else {
                        exist = [NSMutableDictionary dictionary];
                    }
                    NSUInteger fc = pathAsIndex - arrayCount;
                    for(NSUInteger fi = 0; fi < fc; fi++) {
                        [json addObject:[NSNull null]];
                    }
                    [json addObject:exist];
                }
            }
        }
        if(exist != nil) {
            id nextMutating = [self _set:exist paths:paths index:index + 1 object:object successful:successful];
            if(nextMutating != nil) {
                if(isDictionary == YES) {
                    if([json isKindOfClass:NSMutableDictionary.class] == NO) {
                        mutating = [NSMutableDictionary dictionaryWithDictionary:json];
                        json = mutating;
                    }
                    [json setValue:nextMutating forKey:path];
                } else if(isCollection == YES) {
                    if(pathAsIndex != NSNotFound) {
                        if((isArray == YES) && ([json isKindOfClass:NSMutableArray.class] == NO)) {
                            mutating = [NSMutableArray arrayWithArray:json];
                            json = mutating;
                        } else if((isOrderedSet == YES) && ([json isKindOfClass:NSMutableOrderedSet.class] == NO)) {
                            mutating = [NSMutableOrderedSet orderedSetWithOrderedSet:json];
                            json = mutating;
                        }
                        [json setObject:nextMutating atIndex:pathAsIndex];
                    } else {
                        [NSException raise:@"Invalid json" format:@"Please check build code"];
                    }
                }
            }
        }
    }
    return mutating;
}

- (id)_get:(id)json paths:(NSArray*)paths index:(NSUInteger)index {
    id result = nil;
    BOOL isLastPath = (index == paths.count - 1);
    id path = paths[index];
    if([json isKindOfClass:NSDictionary.class] == YES) {
        result = [json objectForKey:path];
        if((result != nil) && (isLastPath == NO)) {
            result = [self _get:result paths:paths index:index + 1];
        }
    } else if(([json isKindOfClass:NSArray.class] == YES) || ([json isKindOfClass:NSOrderedSet.class] == YES)) {
        if([path isKindOfClass:NSNumber.class] == YES) {
            NSUInteger pathAsIndex = [path unsignedIntegerValue];
            result = [json objectAtIndex:pathAsIndex];
            if((result != nil) && (isLastPath == NO)) {
                result = [self _get:result paths:paths index:index + 1];
            }
        }
    }
    return result;
}

+ (NSError*)_error:(QJsonImplErrorCode)code path:(NSString*)path {
    NSDictionary* userInfo = @{
        QJsonImplErrorPathKey: path
    };
    return [NSError errorWithDomain:QJsonImplErrorDomain code:code userInfo:userInfo];
}

@end

NSNumber* QJsonImplBoolFromString(NSString* string) {
    NSString* lowercased = [string lowercaseString];
    if(([lowercased isEqualToString:@"true"] == YES) ||
       ([lowercased isEqualToString:@"yes"] == YES) ||
       ([lowercased isEqualToString:@"on"] == YES) ||
       ([string isEqualToString:@"1"] == YES)) {
        return @YES;
    }
    if(([lowercased isEqualToString:@"false"] == YES) ||
       ([lowercased isEqualToString:@"no"] == YES) ||
       ([lowercased isEqualToString:@"off"] == YES) ||
       ([string isEqualToString:@"0"] == YES)) {
        return @NO;
    }
    return nil;
}

NSNumber* QJsonImplNumberFromString(NSString* string) {
    NSNumberFormatter* formatter = [NSNumberFormatter new];
    formatter.locale = NSLocale.currentLocale;
    formatter.formatterBehavior = NSNumberFormatterBehavior10_4;
    formatter.numberStyle = NSNumberFormatterNoStyle;

    NSNumber* number = [formatter numberFromString:string];
    if(number == nil) {
        if([formatter.decimalSeparator isEqualToString:@"."]) {
            formatter.decimalSeparator = @",";
        } else {
            formatter.decimalSeparator = @".";
        }
        number = [formatter numberFromString:string];
    }
    return number;
}

NSDecimalNumber* QJsonImplDecimalNumberFromString(NSString* string) {
    NSNumberFormatter* formatter = [NSNumberFormatter new];
    formatter.locale = NSLocale.currentLocale;
    formatter.formatterBehavior = NSNumberFormatterBehavior10_4;
    formatter.numberStyle = NSNumberFormatterNoStyle;

    NSDecimalNumber* decimalNumber = (NSDecimalNumber*)[formatter numberFromString:string];
    if(decimalNumber == nil) {
        if([formatter.decimalSeparator isEqualToString:@"."]) {
            formatter.decimalSeparator = @",";
        } else {
            formatter.decimalSeparator = @".";
        }
        decimalNumber = (NSDecimalNumber*)[formatter numberFromString:string];
    }
    return decimalNumber;
}

NSString* QJsonImplStringFromColor(QJsonColor* color) {
    CGFloat r, g, b, a;
    [color getRed:&r green:&g blue:&b alpha:&a];
    return [NSString stringWithFormat:@"#%02X%02X%02X%02X", (int)(255 * r), (int)(255 * g), (int)(255 * b), (int)(255 * a)];
}

BOOL QJsonImplColorComponentsFromString(NSString* string, CGFloat* r, CGFloat* g, CGFloat* b, CGFloat* a) {
    static NSCharacterSet* characterSet = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        characterSet = NSCharacterSet.alphanumericCharacterSet.invertedSet;
    });
    NSString* colorString = [string stringByTrimmingCharactersInSet:characterSet];
    unsigned hex = 0;
    [[NSScanner scannerWithString:colorString] scanHexInt:&hex];
    switch (colorString.length) {
        case 2:
            *r = *g = *b = (CGFloat)((UInt8)(hex & 0xFF)) / (CGFloat)(255.0);
            *a = 1;
            return YES;
        case 3:
            *r = (CGFloat)((UInt8)((hex >> 8) * 17)) / (CGFloat)(255.0);
            *g = (CGFloat)((UInt8)(((hex >> 4) & 0xF) * 17)) / (CGFloat)(255.0);
            *b = (CGFloat)((UInt8)((hex & 0xF) * 17)) / (CGFloat)(255.0);
            *a = 1;
            return YES;
        case 6:
            *r = (CGFloat)((UInt8)(hex >> 16)) / (CGFloat)(255.0);
            *g = (CGFloat)((UInt8)((hex >> 8) & 0xFF)) / (CGFloat)(255.0);
            *b = (CGFloat)((UInt8)(hex & 0xFF)) / (CGFloat)(255.0);
            *a = 1;
            return YES;
        case 8:
            *r = (CGFloat)((UInt8)((hex >> 24) & 0xFF)) / (CGFloat)(255.0);
            *g = (CGFloat)((UInt8)((hex >> 16) & 0xFF)) / (CGFloat)(255.0);
            *b = (CGFloat)((UInt8)((hex >> 8) & 0xFF)) / (CGFloat)(255.0);
            *a = (CGFloat)((UInt8)(hex & 0xFF)) / (CGFloat)(255.0);
            return YES;
        default:
            return NO;
    }
}

QJsonColor* QJsonImplColorFromString(NSString* string) {
    CGFloat r = 1, g = 1, b = 1, a = 1;
    if(QJsonImplColorComponentsFromString(string, &r, &g, &b, &a) == NO) {
        return nil;
    }
    return [QJsonColor colorWithRed:r
                              green:g
                               blue:b
                              alpha:a];
}
