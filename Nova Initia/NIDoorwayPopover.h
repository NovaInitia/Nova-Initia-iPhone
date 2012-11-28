//
//  NIDoorwayPopover.h
//  Nova Initia iPhone
//
//  Created by svp on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NIDoorwayPopover : UIViewController{
    IBOutlet UIScrollView *scrollView;
}

@property (nonatomic, retain) IBOutlet UITextField *url;
@property (nonatomic, retain) IBOutlet UITextField *hint;
@property (nonatomic, retain) IBOutlet UITextField *comment;
@property (nonatomic, retain) IBOutlet UISwitch *chain;
@property (nonatomic, retain) IBOutlet UISwitch *nsfw;

-(NSString *)urlEncode:(NSString *)url;

-(void)showProcessDialog:(NSString *)tool;

- (BOOL)validateUrl:(NSString *)candidate;

- (void)processResponse:(NSString *)response;

- (void)alertResponse:(NSString *)message:(NSString *)image;


@end
