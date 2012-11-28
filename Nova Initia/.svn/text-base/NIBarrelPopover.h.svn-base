//
//  NIBarrelPopover.h
//  Nova Initia iPhone
//
//  Created by svp on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NIBarrelPopover : UIViewController{
    IBOutlet UIScrollView *scrollView;
    
}

@property (nonatomic, retain) IBOutlet UITextField *sg;
@property (nonatomic, retain) IBOutlet UITextField *traps;
@property (nonatomic, retain) IBOutlet UITextField *barrels;
@property (nonatomic, retain) IBOutlet UITextField *spiders;
@property (nonatomic, retain) IBOutlet UITextField *shields;
@property (nonatomic, retain) IBOutlet UITextField *doorways;
@property (nonatomic, retain) IBOutlet UITextField *signposts;
@property (nonatomic, retain) IBOutlet UITextField *message;
@property (nonatomic, retain) IBOutlet UITextField *label;

- (BOOL)checkBarrelCapacity;

- (NSString *)urlEncode:(NSString *)url;

- (void)alertResponse:(NSString *)title:(NSString *)_message:(NSString *)image;

- (void)processResponse:(NSString *)response;

- (void)showProcessDialog:(NSString *)tool;

@end
