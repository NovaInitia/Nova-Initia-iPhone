//
//  NIDoorwayPopover.m
//  Nova Initia iPhone
//
//  Created by svp on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NIDoorwayPopover.h"
#import "NOVA_INITIA.h"
#import "NIWebViewController.h"
#import "User.h"
#import "SBJson.h"

@implementation NIDoorwayPopover{
    UIAlertView *process;
}

@synthesize url, hint, comment, chain, nsfw;

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
        [self alertResponse:@"Nova Initia":@"Doorway placed on page":@"doorwaySet.png"];
    }
    
    if([allKeys containsObject:@"error"]){
        NSString *error = [jsonData objectForKey:@"error"];
       [self alertResponse:@"Nova Initia":error:@"doorwayFailed.png"]; 
    }
    
    if([allKeys containsObject:@"fail"]){
        [self alertResponse:@"Nova Initia":@"Doorway Failed":@"doorwayFailed.png"]; 
    }
    
    [NIWebViewController updateUser];
    
}

- (IBAction)deployPressed:(id)sender{
    if([User getInstance].numDoorways > 0){
        
        [self showProcessDialog:@"Placing Doorway..."];
    
        NSString *curUrl = [NOVA_INITIA getInstance].curUrl;
        NSString *urlHash = [NOVA_INITIA getInstance].urlHash;
        NSString *domainHash = [NOVA_INITIA getInstance].domainHash;
    
        NSString *doorwayUrl = url.text;
        NSString *doorwayHint = hint.text;
        NSString *doorwayComment = comment.text;
        NSString *doorwayNSFW = @"false";
        if([nsfw isOn]) doorwayNSFW = @"true";
    
        NSString *curUrlEncoded = [self urlEncode:curUrl];
        NSString *doorwayUrlEncoded = [self urlEncode:doorwayUrl];
        NSString *doorwayHintEncoded = [self urlEncode:doorwayHint];
        NSString *doorwayCommentEncoded = [self urlEncode:doorwayComment];
    
        NSString *doorwayId = @"4";
    
        NSString *theParams = [NSString stringWithFormat:@"Url=%@&Hint=%@&Comment=%@&Home=%@&NSFW=%@",doorwayUrlEncoded,doorwayHintEncoded,doorwayCommentEncoded,curUrlEncoded,doorwayNSFW];
    
        NSString *requestString = [NSString stringWithFormat:@"http://data.nova-initia.com/rf/remog/page/%@/%@/%@.json",urlHash,domainHash,doorwayId];
    
    
        NSLog(@"requestString = %@", requestString);
    
        NSLog(@"theParams = %@",theParams);
        
        NSURL *dUrl = [NSURL URLWithString:doorwayUrl];
        if(!dUrl.scheme){
            NSString *modifiedURLString = [NSString stringWithFormat:@"http://%@", doorwayUrl];
            dUrl = [NSURL URLWithString:modifiedURLString];
            doorwayUrl = dUrl.absoluteString;
        }

        if([self validateUrl:doorwayUrl]){
        
            NSString *response = [[NOVA_INITIA getInstance] sendRequest2:@"POST":requestString:theParams:NO];
    
            NSLog(@"response = %@",response);
            
            [self processResponse:response];
    
            [self dismissModalViewControllerAnimated:YES];
        }
        else{
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Error"
                                      message:@"Invalid URL entered." delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [process dismissWithClickedButtonIndex:0 animated:YES];
            [alertView show];
        }
        
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:@"Not enough Doorways in inventory." delegate:nil
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

- (BOOL)validateUrl:(NSString *)candidate{
    NSString *urlRegEx =
    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx]; 
    return [urlTest evaluateWithObject:candidate];
}


-(NSString *)urlEncode:(NSString *)url{
    NSString *escapedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                           NULL,
                                                                                           (__bridge CFStringRef)url,
                                                                                           NULL,
                                                                                           (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                           kCFStringEncodingUTF8);
    
    NSLog(@"escapedString: %@",escapedString);
    
    return escapedString;
}


- (void)viewDidLoad{
    [chain setOn:NO];
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
