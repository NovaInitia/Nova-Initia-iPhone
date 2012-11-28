//
//  User.h
//  Nova Initia iPhone
//
//  Created by svp on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, retain) NSMutableArray *inventory;

@property int numTraps, numBarrels, numSpiders, numShields, numDoorways, numSignposts, sg, isShielded, niClass, giverId, guardianId, guideId, refugeeId, level, exp;

@property (nonatomic, retain) NSString *userName, *lastKey, *userId, *className, *avatarUrl;

+ (User *) getInstance;

- (void) buildUser:(NSString *)jsonString;

- (void) destructUser;

@end
