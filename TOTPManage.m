#import "TOTPManage.h"
#import "TOTPGenerator.h"
#import "MF_Base32Additions.h"

@implementation TOTPManage

+ (TOTPManage *)getInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}


#pragma mark -
#pragma mark ---- TOTP ---
- (NSString *)getPINTOTP:(NSString *)timestampServer secret:(NSString *)secretStr
{
    // T0TP
    NSString *secret = secretStr;
    //NSData *secretData =  [NSData dataWithBase32String:secret];;
    NSData *secretData = [self convertHexStrToData:secret];
    
    
    NSInteger digits = 8;
    NSInteger period = 30;
    NSTimeInterval timestamp = [timestampServer intValue];
    
    TOTPGenerator *generator = [[TOTPGenerator alloc] initWithSecret:secretData algorithm:kOTPGeneratorSHA256Algorithm digits:digits period:period];
    
    NSString *pin = [generator generateOTPForDate:[NSDate dateWithTimeIntervalSince1970:timestamp]];
    
    return pin;
}

//十六进制转换为NSData
- (NSData *)convertHexStrToData:(NSString *)str
{
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    
    NSLog(@"hexdata: %@", hexData);
    return hexData;
}

@end
