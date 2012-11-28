//
//  NISettingsViewController.m
//  Nova Initia iPhone
//
//  Created by svp on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NISettingsViewController.h"
#import "NOVA_INITIA.h"

@implementation NISettingsViewController{
    NOVA_INITIA *NI;
}

@synthesize homePage;

- (IBAction)savePressed:(id)sender{
    [[[NOVA_INITIA getInstance] prefs] setValue:self.homePage.text forKey:@"homePage"];
    [[[NOVA_INITIA getInstance] prefs] synchronize];
    [self.tabBarController setSelectedIndex:0];
    
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad{
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(320,500)];
    self.homePage.text = [[[NOVA_INITIA getInstance] prefs] valueForKey:@"homePage"];
    [super viewDidLoad];
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
