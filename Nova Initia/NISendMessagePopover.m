//
//  NISendMessagePopover.m
//  Nova Initia
//
//  Created by svp on 5/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NISendMessagePopover.h"
#import "SBJson.h"
#import "NOVA_INITIA.h"
#import "User.h"

@implementation NISendMessagePopover{
    UIAlertView *process;
}

@synthesize to, subject, message;

- (IBAction)cancelPressed:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)sendPressed:(id)sender{
//    process = [[UIAlertView alloc] initWithTitle:@"Sending Message..." 
//                                         message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
//    [process show];
//    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//    
//    indicator.center = CGPointMake(process.bounds.size.width / 2, process.bounds.size.height - 50);
//    [indicator startAnimating];
//    [process addSubview:indicator];
    
    NSString *toId = to.text;
    NSString *mailSubject = subject.text;
    NSString *contents = message.text;
    
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:toId,@"ToID",mailSubject,@"Subject",contents,@"Contents",nil];
    
    NSString *theParams = [jsonDictionary JSONRepresentation];
    NSLog(@"requestJson %@", theParams);
    
    NSString *requestString = @"http://data.nova-initia.com/rf/remog/mail.json";
    
    NSString *response = [[NOVA_INITIA getInstance] sendRequest2:@"POST":requestString:theParams:NO];
    
    NSLog(@"response = %@",response);
    
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

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
