//
//  NISignpostPopover.h
//  Nova Initia iPhone
//
//  Created by svp on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NISignpostPopover : UIViewController{

    IBOutlet UIScrollView *scrollView;
}

@property (nonatomic, retain) IBOutlet UITextField *title;
@property (nonatomic, retain) IBOutlet UITextField *comment;
@property (nonatomic, retain) IBOutlet UISwitch *nsfw;

- (void)alertResponse:(NSString *)title:(NSString *)message:(NSString *)image;

- (void)processResponse:(NSString *)response;

-(void)showProcessDialog:(NSString *)tool;



@end
