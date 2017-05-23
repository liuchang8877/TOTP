#import <Foundation/Foundation.h>



@interface TOTPManage : NSObject

//初始化
+ (TOTPManage *)getInstance;


/**
 调用TOTP加密

 @param timestampServer 服务端时间戳
 @param secretStr 秘钥
 @return 加密后数据
 */
- (NSString *)getPINTOTP:(NSString *)timestampServer secret:(NSString *)secretStr;

@end
