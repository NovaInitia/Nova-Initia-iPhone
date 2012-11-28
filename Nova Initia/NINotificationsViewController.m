//
//  NINotificationsViewController.m
//  Nova Initia
//
//  Created by svp on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NINotificationsViewController.h"
#import "NOVA_INITIA.h"
#import "SBJson.h"

@implementation NINotificationsViewController

@synthesize doorwayLabel, hintLabel, doorwayButton;

- (IBAction)openPressed:(id)sender{
    [self.tabBarController setSelectedIndex:1];
}

- (void)viewDidAppear:(BOOL)animated{

    doorwayLabel.text = @"teambobtest's Doorway";
    hintLabel.text = @"mmmmm...Coffee....";
    
    [NOVA_INITIA getInstance].doorway = YES;
    [NOVA_INITIA getInstance].doorwayUrl = @"http://www.raoscoffee.com/";
    
    
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad{
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
