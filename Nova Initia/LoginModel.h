//
//  LoginModel.h
//  Nova Initia iPhone
//
//  Created by svp on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginModel : NSObject

@property (nonatomic , retain) NSString *key;

- (NSString *) login:(NSString *)username:(NSString *)password;

- (NSString *)sha2:(NSString *)input;

- (NSString *)hashPwd:(NSString *)password:(NSString *)key;

@end
