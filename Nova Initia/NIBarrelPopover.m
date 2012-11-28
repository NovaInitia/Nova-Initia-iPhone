//
//  NIBarrelPopover.m
//  Nova Initia iPhone
//
//  Created by svp on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NIBarrelPopover.h"
#import "NOVA_INITIA.h"
#import "SBJson.h"
#import "NIWebViewController.h"
#import "User.h"

@implementation NIBarrelPopover{
    UIAlertView *process;
}

@synthesize sg, traps, barrels, spiders, shields, doorways, signposts, message, label;

- (IBAction)cancelPressed:(id)sender{
    [self dismissModalViewControllerAnimated:YES];

}

- (void)alertResponse:(NSString *)title:(NSString *)_message:(NSString *)image{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:_message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
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
        [self alertResponse:@"Nova Initia":@"Barrel stashed on page":@"barrelSet.png"];
    }
    
    if([allKeys containsObject:@"error"]){
        NSString *error = [jsonData objectForKey:@"error"];
        [self alertResponse:@"Nova Initia":error:@"barrelFailed.png"]; 
    }
    
    if([allKeys containsObject:@"fail"]){
        [self alertResponse:@"Nova Initia":@"Barrel Failed":@"barrelFailed.png"]; 
    }
    
    [NIWebViewController updateUser];
    
}

- (IBAction)deployPressed:(id)sender{
    
    if([User getInstance].numBarrels > 0){
        
        [self showProcessDialog:@"Placing Barrel..."];
        
        if(sg.text.length == 0)sg.text = @"0";
        if(traps.text.length == 0)traps.text = @"0";
        if(barrels.text.length == 0)barrels.text = @"0";
        if(spiders.text.length == 0)spiders.text = @"0";
        if(shields.text.length == 0)shields.text = @"0";
        if(doorways.text.length == 0)doorways.text = @"0";
        if(signposts.text.length == 0)signposts.text = @"0";
        
        if([self checkBarrelCapacity]){
    
            NSString *urlHash = [NOVA_INITIA getInstance].urlHash;
            NSString *domainHash = [NOVA_INITIA getInstance].domainHash;
            NSString *barrelId = @"1";
    
            NSString *barrelCommentEncoded = [self urlEncode:message.text];

            NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    sg.text, @"Sg", signposts.text, @"Tool5", doorways.text, @"Tool4",shields.text, @"Tool3", spiders.text, @"Tool2", barrels.text, @"Tool1", traps.text, @"Tool0", barrelCommentEncoded, @"Comment",nil];
    
            NSString *theParams = [jsonDictionary JSONRepresentation];
            NSLog(@"requestJson %@", theParams);
    
            NSString *requestString = [NSString stringWithFormat:@"http://data.nova-initia.com/rf/remog/page/%@/%@/%@.json",urlHash,domainHash,barrelId];
    
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
                                      message:@"Please ensure that you are not trying to stash an empty barrel or exceed your barrel contents limit." delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [process dismissWithClickedButtonIndex:0 animated:YES];
            [alertView show];
            
        }
    }
    
    else{
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:@"Not enough Barrels in inventory." delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [process dismissWithClickedButtonIndex:0 animated:YES];
        [alertView show];
    }
    
}

- (BOOL)checkBarrelCapacity{
    int _sg = sg.text.intValue;
    int _traps = traps.text.intValue;
    int _barrels = barrels.text.intValue;
    int _spiders = spiders.text.intValue;
    int _shields = shields.text.intValue;
    int _doorways = doorways.text.intValue;
    int _signposts = signposts.text.intValue;
    
    int limit = 10;
    if([User getInstance].niClass == 1)limit = 100;
    
    if((_sg+_traps+_barrels+_spiders+_shields+_doorways+_signposts) == 0){
        return NO;
    }
    
    if((_sg+_traps+_barrels+_spiders+_shields+_doorways+_signposts) > limit){
        return NO;
    }
    
    if((_sg > [User getInstance].sg) || (_traps > [User getInstance].numTraps) || (_barrels > [User getInstance].numBarrels) || (_spiders > [User getInstance].numSpiders) || (_shields > [User getInstance].numShields) || (_doorways > [User getInstance].numDoorways) || (_signposts > [User getInstance].numSignposts)){
       return NO; 
    }
    
    else return YES;
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

- (void)viewDidAppear:(BOOL)animated{
    if([User getInstance].niClass != 1){
        [sg setEnabled:NO];
        sg.alpha = 0.5;
        
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad{
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(320,700)];
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
