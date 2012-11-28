//
//  NILoginViewController.h
//  Nova Initia iPhone
//
//  Created by svp on 4/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NILoginViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, retain) IBOutlet UITextField *uname;
@property (nonatomic, retain) IBOutlet UITextField *pwd;

@property (nonatomic, retain) IBOutlet UIButton *loginButton;

@property (nonatomic, retain) IBOutlet UISwitch *rememberMe;

- (IBAction)loginPressed:(UIButton *)sender;

- (IBAction)textFieldReturn:(id)sender;

- (IBAction)backgroundTouched:(id)sender;

- (BOOL)textFieldShouldReturn:(UITextField *)textField;

-(void)goToNextView;

- (void) handleLogin:(NSString *)jsonString;

@end
