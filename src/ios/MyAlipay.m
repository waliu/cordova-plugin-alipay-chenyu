/********* MyAlipay.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import <AlipaySDK/AlipaySDK.h>

//#import "APAuthInfo.h"
//#import "APOrderInfo.h"
//#import "APRSASigner.h"

@interface MyAlipay : CDVPlugin {
  // Member variables go here.
}

@property(nonatomic,strong)NSString *appId;

@property(nonatomic,strong)NSString *currentCallbackId;

- (void)coolMethod:(CDVInvokedUrlCommand*)command;
@end

@implementation MyAlipay

-(void)pluginInitialize
{
    self.appId = [[self.commandDelegate settings] objectForKey:@"app_id"];
}

- (void)coolMethod:(CDVInvokedUrlCommand*)command
{
    NSString* echo = [command.arguments objectAtIndex:0];
    self.currentCallbackId = command.callbackId;
    if ([self.appId length] == 0)
    {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"支付APP_ID设置错误"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        return;
    }
        if (echo != nil) {
            //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
            NSMutableString * schema = [NSMutableString string];
            [schema appendFormat:@"ALI%@", self.appId];

            NSString *orderString = echo;
            //            NSLog(@"orderString = %@",orderString);
            // NOTE: 调用支付结果开始支付
            [[AlipaySDK defaultService] payOrder:orderString fromScheme:schema callback:^(NSDictionary *resultDic) {
                NSLog(@"resErro:%@",resultDic);
                CDVPluginResult* pluginResult1 = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:resultDic];
                [self.commandDelegate sendPluginResult:pluginResult1 callbackId:command.callbackId];
            }];
    } else {
        CDVPluginResult* pluginResult = nil;
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}
- (void)handleOpenURL:(NSNotification *)notification
{
    NSURL* url = [notification object];

    if ([url.scheme rangeOfString:self.appId].length > 0)
    {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [self successWithCallbackID:self.currentCallbackId messageAsDictionary:resultDic];
        }];
    }
}


- (void)successWithCallbackID:(NSString *)callbackID messageAsDictionary:(NSDictionary *)message
{
    NSLog(@"message = %@",message);
    CDVPluginResult *commandResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:message];
    [self.commandDelegate sendPluginResult:commandResult callbackId:callbackID];
}
@end

