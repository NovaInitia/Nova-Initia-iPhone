//
//  LoginModel.m
//  Nova Initia iPhone
//
//  Created by svp on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginModel.h"
#import "CommonCrypto/CommonDigest.h"
#import "NOVA_INITIA.h"

@interface LoginModel(){
    NOVA_INITIA *NI;
}
@end

@implementation LoginModel

@synthesize key = _key;

// get user's last key
- (void)getLastKey:(NSString *)username{
    
    NSString *params = [NSString stringWithFormat:@"login=1&uname=%@" , username];
    NSString *uLastKey = [[NOVA_INITIA getInstance] sendRequest:@"POST":@"http://data.nova-initia.com/getKey.php":params];
    if(uLastKey)
        self.key = uLastKey;
    
}

- (NSString *)login:(NSString *)username:(NSString *)password{
    
    [self getLastKey:username];
    
    NSString *hashedPwd = [self hashPwd:password:self.key];

    NSString *params = [NSString stringWithFormat:@"login=1&pwd=%@&uname=%@&LastKey=%@", hashedPwd, username, self.key];
    
    return [[NOVA_INITIA getInstance] sendRequest:@"POST":@"http://data.nova-initia.com/login2.php":params];
}

/** 
 
 * NI Hashing Funcions
 
 */

//SHA256 Hashing Function
- (NSString *)sha2:(NSString *)input {
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    
    CC_SHA256(data.bytes, data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output; 
}

//Double Hashing for password
- (NSString *)hashPwd:(NSString *)password:(NSString *)lastkey{
    NSString *hashedPwd = [self sha2:password];
    hashedPwd = [hashedPwd stringByAppendingString:lastkey];
    hashedPwd = [self sha2:hashedPwd];
    return hashedPwd;
}

@end
