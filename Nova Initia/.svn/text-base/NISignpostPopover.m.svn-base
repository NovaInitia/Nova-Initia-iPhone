//
//  NISignpostPopover.m
//  Nova Initia iPhone
//
//  Created by svp on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NISignpostPopover.h"
#import "NOVA_INITIA.h"
#import "NIWebViewController.h"
#import "User.h"
#import "SBJson.h"

@implementation NISignpostPopover{
    UIAlertView *process;
}

@synthesize title, comment, nsfw;


- (IBAction)cancelPressed:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)alertResponse:(NSString *)title:(NSString *)message:(NSString *)image{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(220, 10, 40, 40)];
    
    NSString *path = [[NSString alloc] initWithString:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:image]];
    UIImage *bkgImg = [[UIImage alloc] initWithContentsOfFile:path];
    [imageView setImage:bkgImg];
    
    [alert addSubview:imageView];
    
    [process dismissWithClickedButtonIndex:0 animated:YES];
    [alert show];
}

- (void)processResponse:(NSString *)response{
    
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSDictionary *jsonData = [jsonParser objectWithString:response];
    
    NSArray *allKeys = [jsonData allKeys];
    
    NSLog(@"allKeys = %@",allKeys);
    
    if([allKeys containsObject:@"pageSet"]){
        [self alertResponse:@"Nova Initia":@"Signpost placed on page":@"signpostSet.png"];
    }
    
    if([allKeys containsObject:@"error"]){
        NSString *error = [jsonData objectForKey:@"error"];
        [self alertResponse:@"Nova Initia":error:@"signpostFailed.png"]; 
    }
    
    if([allKeys containsObject:@"result"]){
        NSString *result = [jsonData objectForKey:@"result"];
        NSString *uname = [jsonData objectForKey:@"username"];
        NSString *message = [NSString stringWithFormat:@"%@ by: %@",result,uname];
        [self alertResponse:@"Nova Initia":message:@"signpostBlocked.png"];
    }
    
    if([allKeys containsObject:@"fail"]){
        [self alertResponse:@"Nova Initia":@"Signpost Failed":@"signpostFailed.png"]; 
    }
    
    [NIWebViewController updateUser];
    
}

- (IBAction)deployPressed:(id)sender{
    
    if([User getInstance].numSignposts > 0){
        
        [self showProcessDialog:@"Placing Signpost..."];
    
        NSString *curUrl = [NOVA_INITIA getInstance].curUrl;
        NSString *urlHash = [NOVA_INITIA getInstance].urlHash;
        NSString *domainHash = [NOVA_INITIA getInstance].domainHash;
    
        NSString *signpostTitle = [title.text stringByReplacingOccurrencesOfString:@" "withString:@"+"];
        NSString *signpostComment = [comment.text stringByReplacingOccurrencesOfString:@" "withString:@"+"];
        NSString *signpostNSFW = @"false";
        if([nsfw isOn]) signpostNSFW = @"true";
        NSString *signpostId = @"5";
    
        NSString *theParams = [NSString stringWithFormat:@"Url=%@&Title=%@&Comment=%@&NSFW=%@",curUrl,signpostTitle,signpostComment,signpostNSFW];
    
        NSLog(@"theParams = %@", theParams);
    
        NSString *requestString = [NSString stringWithFormat:@"http://data.nova-initia.com/rf/remog/page/%@/%@/%@.json",urlHash,domainHash,signpostId];
    
        NSLog(@"requestString = %@", requestString);
    
        NSString *response = [[NOVA_INITIA getInstance] sendRequest2:@"POST":requestString:theParams:NO];
    
        NSLog(@"response = %@",response);
    
        [self processResponse:response];
    
        [NIWebViewController updateUser];
    
        [self dismissModalViewControllerAnimated:YES];
    }
    
    else{
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:@"Not enough Signposts in inventory." delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
    
}

-(void)showProcessDialog:(NSString *)tool{
    process = [[UIAlertView alloc] initWithTitle:tool 
                                         message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [process show];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    indicator.center = CGPointMake(process.bounds.size.width / 2, process.bounds.size.height - 50);
    [indicator startAnimating];
    [process addSubview:indicator];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad{
    [nsfw setOn:NO];
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(320,500)];
    [scrollView setBounces:NO];
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
