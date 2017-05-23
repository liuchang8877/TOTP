# TOTP是什么?
- TOTP（Time-Based One-Time Password基于时间的一次性密码）

# 适用范围
- 用于iOS端进行根据时间的一次性加密数据行为
- 根据服务端要求，更改不通的加密算法，周期时间，返回加密信息长度

# 基本功能
- 根据所协议定的周期时间，算法要求，返回加密字段长度不同，进行根据时间的一次性对数据的加密，返回加密后字段

# 怎么使用
```c
#import "TOTPManage.h"
NSString *serverutc = @"服务器时间";
NSString *seed32 = @"服务器下发秘钥seed";
//获取加密信息
NSString *resultCode = [TOTPManage getInstance] getPINTOTP:serverutc secret:seed32];
```

# 注意事项
- 加密算法用的是 HMAC-SHA256，可以切换其他加密算法，根据服务端要求
- 服务端要求步长 30s ，可以更改 period来更换周期，范围0~300秒
- 服务端要求返回定长8位 ，可以更改period来更改返回字段长度， 最小6位，最大8位支持

```c
#pragma mark -
#pragma mark ---- TOTP ---
- (NSString *)getPINTOTP:(NSString *)timestampServer secret:(NSString *)secretStr
{
// T0TP
NSString *secret = secretStr;
//NSData *secretData = [NSData dataWithBase32String:secret];;
NSData *secretData = [self convertHexStrToData:secret];

NSInteger digits = 8;
NSInteger period = 30;
//NSTimeInterval timestamp = [timestampServer intValue];
//NSString *const kOTPGeneratorSHA1Algorithm = @"SHA1";
//加密算法用的是 HMAC-SHA256，可以切换其他加密算法，根据服务端要求
//NSString *const kOTPGeneratorSHA256Algorithm = @"SHA256";
//NSString *const kOTPGeneratorSHA512Algorithm = @"SHA512";
//NSString *const kOTPGeneratorSHAMD5Algorithm = @"MD5";

TOTPGenerator *generator = [[TOTPGenerator alloc] initWithSecret:secretData algorithm:kOTPGeneratorSHA256Algorithm digits:digits period:period];

NSString *pin = [generator generateOTPForDate:[NSDate dateWithTimeIntervalSince1970:timestamp]];

return pin;
}
```
