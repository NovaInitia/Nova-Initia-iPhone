//
//  NIRegisterViewController.m
//  Nova Initia iPhone
//
//  Created by svp on 4/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NIRegisterViewController.h"

@implementation NIRegisterViewController

@synthesize webView;

- (IBAction)buttonPressed:(id)sender{
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    NSURL *url = [NSURL URLWithString:@"http://www.nova-initia.com/remog/login"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
//    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
