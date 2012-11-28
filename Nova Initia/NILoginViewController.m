//
//  NILoginViewController.m
//  Nova Initia iPhone
//
//  Created by svp on 4/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NILoginViewController.h"
#import "NOVA_INITIA.h"
#import "User.h"
#import "LoginModel.h"

@interface NILoginViewController(){
    NOVA_INITIA *NI;
    UIAlertView *loginBox;
    NSMutableData *receivedData;
}@end

@implementation NILoginViewController

@synthesize uname;
@synthesize pwd;
@synthesize rememberMe;
@synthesize loginButton;

- (void)storeUser{
    [[[NOVA_INITIA getInstance] prefs] setBool:YES forKey:@"remembered?"];
    [[[NOVA_INITIA getInstance] prefs] setValue:self.uname.text forKey:@"username"];
    [[[NOVA_INITIA getInstance] prefs] setValue:self.pwd.text forKey:@"password"];
    [[[NOVA_INITIA getInstance] prefs] synchronize];
}

- (void)removeUser{
    [[[NOVA_INITIA getInstance] prefs] removeObjectForKey:@"remembered?"];
    [[[NOVA_INITIA getInstance] prefs] removeObjectForKey:@"username"];
    [[[NOVA_INITIA getInstance] prefs] removeObjectForKey:@"password"];
    [[[NOVA_INITIA getInstance] prefs] synchronize];
}

- (void) handleLogin:(NSString *)jsonString{
    [loginBox dismissWithClickedButtonIndex:0 animated:YES];
    if(jsonString.length > 23){
        NSLog(@"LOGIN SUCCESSFULL");
        if([rememberMe isOn]){
            [self storeUser];
            
        }
        if(![rememberMe isOn]){
            [self removeUser];
        }
        [[User getInstance] buildUser:jsonString];
        [self goToNextView];
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Login Failed"
                                  message:@"Please re-enter and try again" delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];

        NSLog(@"LOGIN FAILED");
//        NSLog(jsonString);
    }
}

- (IBAction)loginPressed:(UIButton *)sender{
    if(uname.text.length > 0 && pwd.text.length > 0){
        loginBox = [[UIAlertView alloc] initWithTitle:@"\nLogging in" 
                                             message:@"Please Wait..." delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
        [loginBox show];
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
        indicator.center = CGPointMake(loginBox.bounds.size.width / 2, loginBox.bounds.size.height - 50);
        [indicator startAnimating];
        [loginBox addSubview:indicator];
    
        NSString *jsonString = [[NOVA_INITIA getInstance] login:self.uname.text:self.pwd.text];
        [self handleLogin:jsonString];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self loginPressed:loginButton];
    [uname resignFirstResponder];
    [pwd resignFirstResponder];
    return YES;
}


-(void)goToNextView{
    [super performSegueWithIdentifier:@"loginSuccess"sender:self];
}

-(IBAction)textFieldReturn:(id)sender{
    [uname resignFirstResponder];
    [pwd resignFirstResponder];
} 

-(IBAction)backgroundTouched:(id)sender{
    [uname resignFirstResponder];
    [pwd resignFirstResponder];
}

- (void)viewDidLoad{
//    NSLog(@"VIEW DID LOAD");
    uname.delegate = self;
    pwd.delegate = self;
    if([[[NOVA_INITIA getInstance] prefs]  boolForKey:@"remembered?"] == YES){
        uname.text = [[[NOVA_INITIA getInstance] prefs]  valueForKey:@"username"];
        pwd.text = [[[NOVA_INITIA getInstance] prefs]  valueForKey:@"password"];
    }
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
@end
