//
//  User.m
//  Nova Initia iPhone
//
//  Created by svp on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "User.h"
#import "SBJSON/SBJson.h"
#import "ToolType.h"

@interface User(){
    
}
@end

@implementation User

@synthesize inventory;


@synthesize numTraps, numBarrels, numSpiders, numShields, numDoorways, numSignposts, sg, isShielded, niClass, giverId, guardianId, guideId, refugeeId, level, exp;
@synthesize userName, lastKey, userId, className, avatarUrl;

- (int)giverID{return 1;}
- (int)guardianID{return 2;}
- (int)guideID{return 3;}
- (int)refugeeID{return 0;}

-(NSString *)className{
    switch(niClass){
        case 0:{
            return @"Refugee";
            break;
        }
        case 1:{
            return @"Giver";
            break;
        }
        case 2:{
            return @"Guardian";
            break;
        }
        case 3:{
            return @"Guide";
            break;
        }
        default:{
            return @"";
            break;
        }
    }
}

-(NSMutableArray *)inventory{
    if(!inventory)
        inventory = [[NSMutableArray alloc] init];
    return inventory;
}

static User *instance;

+ (User *) getInstance{
    @synchronized(self){
        if(instance == nil)
            instance = [[User alloc] init];
    }
    
    return(instance);
}

- (void) buildUser:(NSString *)jsonString{
    
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSDictionary *jsonData = [jsonParser objectWithString:jsonString];

    id user = [jsonData objectForKey:@"user"];
    
//    NSLog(@"%@",user);
    
//    self.inventory[ToolType.TRAP] = [user objectForKey:@"Tool0"];
//    [self.inventory insertObject:[user objectForKey:@"Tool0"]atIndex:0];
    self.userName = (NSString *)[user objectForKey:@"UserName"];
    self.lastKey = (NSString *)[user objectForKey:@"LastKey"];
    self.userId =  (NSString *)[user objectForKey:@"ID"];
    
    self.numTraps = [(NSString *)[user objectForKey:@"Tool0"] intValue];
    self.numBarrels = [(NSString *)[user objectForKey:@"Tool1"] intValue];
    self.numSpiders = [(NSString *)[user objectForKey:@"Tool2"] intValue];
    self.numShields = [(NSString *)[user objectForKey:@"Tool3"] intValue];
    self.numDoorways = [(NSString *)[user objectForKey:@"Tool4"] intValue];
    self.numSignposts = [(NSString *)[user objectForKey:@"Tool5"] intValue];
    
    self.sg = [(NSString *)[user objectForKey:@"Sg"] intValue];
    self.isShielded = [(NSString *)[user objectForKey:@"isShielded"] intValue];
    
    self.niClass = [(NSString *)[user objectForKey:@"Class"] intValue];
    self.level = [(NSString *)[user objectForKey:[NSString stringWithFormat:@"LevelClass%d",niClass]] intValue];
    self.exp = [(NSString *)[user objectForKey:[NSString stringWithFormat:@"Experience%d",niClass]] intValue];
    
    self.avatarUrl =  (NSString *)[user objectForKey:@"AvatarUrl"];
    
    NSLog(@"exp = %d",exp);
    
//    NSLog(@"Traps = %@", self.numTraps);
//    NSLog(@"Barrels = %@", self.numBarrels);
//    NSLog(@"Spiders = %@", self.numSpiders);
//    NSLog(@"Shields = %@", self.numShields);
//    NSLog(@"Doorways = %@", self.numDoorways);
//    NSLog(@"Signposts = %@", self.numSignposts);
    
}

- (void) destructUser{
    self.userName = nil;
    
    self.numTraps = 0;
    self.numBarrels = 0;
    self.numSpiders = 0;
    self.numShields = 0;
    self.numDoorways = 0;
    self.numSignposts = 0;
    
    instance = nil;
}

@end
