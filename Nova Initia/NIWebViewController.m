//
//  NIWebViewController.m
//  Nova Initia iPhone
//
//  Created by svp on 4/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NIWebViewController.h"
#import "NOVA_INITIA.h"
#import "NIBarrelPopover.h"
#import "User.h"
#import "SBJson.h"

@implementation NIWebViewController{
    UIActionSheet *toolSheet;
    UIAlertView *process;
    BOOL *gotTools;
}

@synthesize webView;
@synthesize urlBar;
@synthesize backButton;
@synthesize forwardButton;
@synthesize refreshButton;
@synthesize placeToolButton;

- (void)injectJavascript:(NSString *)resource{

    NSString *jsPath = [[NSBundle mainBundle] pathForResource:resource ofType:@"js"];
    NSString *js = [NSString stringWithContentsOfFile:jsPath encoding:NSUTF8StringEncoding error:NULL];
    
    [self.webView stringByEvaluatingJavaScriptFromString:js];

}

- (IBAction)placeToolButtonPressed:(id)sender{
    
    NSString *shieldStatus = @"OFF";
    if([User getInstance].isShielded == 1)shieldStatus = @"ON";
    
    NSString *btnTraps = [NSString stringWithFormat:@"Place Trap (%d)",[User getInstance].numTraps];
    NSString *btnBarrels = [NSString stringWithFormat:@"Place Barrel (%d)",[User getInstance].numBarrels];
    NSString *btnSignposts = [NSString stringWithFormat:@"Place Signpost (%d)",[User getInstance].numSignposts];
    NSString *btnDoorways = [NSString stringWithFormat:@"Place Doorway (%d)",[User getInstance].numDoorways];
    NSString *btnSpiders = [NSString stringWithFormat:@"Place Spider (%d)",[User getInstance].numSpiders];
    NSString *btnShields = [NSString stringWithFormat:@"Shield is %@ (%d)",shieldStatus,[User getInstance].numShields];
    
    toolSheet = [[UIActionSheet alloc]
                                     initWithTitle:@"Place a Tool"
                                     delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
                                otherButtonTitles:btnTraps, btnBarrels, btnSignposts, btnDoorways, btnSpiders, btnShields, nil];
    
    [toolSheet showInView:[self.view window]];

}

-(void)goToNextView:(NSString *)segue{
    [super performSegueWithIdentifier:segue sender:self];
}

+ (void)updateUser{
    NSString *updateRequest = [NSString stringWithFormat:@"http://data.nova-initia.com/rf/remog/user/%@.json",[User getInstance].userId];
    
    NSString *updateResponse = [[NOVA_INITIA getInstance] sendRequest:@"GET":updateRequest:NULL];
    
//    NSLog(@"updateResponse = %@",updateResponse);
    
    [[User getInstance] buildUser:updateResponse];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch(buttonIndex){
        case 0:{
            if([User getInstance].numTraps > 0){
                [self showProcessDialog:@"Placing Trap..."];
                [toolSheet dismissWithClickedButtonIndex:toolSheet.cancelButtonIndex animated:YES];
            NSString *url = webView.request.URL.absoluteString;
            NSString *req = [NSString stringWithFormat:@"NIurlToHash('%@',true);", url];
            NSString *urlDomainHash = [webView stringByEvaluatingJavaScriptFromString:req];
            NSLog(@"urlDomainHash = %@",urlDomainHash);
            NSArray *ud = [urlDomainHash componentsSeparatedByString: @","];
            NSString *urlHash = [ud objectAtIndex: 0];
            NSLog(@"urlHash = %@",urlHash);
            NSString *domainHash = [ud objectAtIndex: 1];
            NSLog(@"domainHash = %@",domainHash);
            NSString *trapId = @"0";
            NSString *lastKey = [[User getInstance] lastKey];
            NSLog(@"lastKey = %@",lastKey);
            
            NSString *requestString = [NSString stringWithFormat:@"http://data.nova-initia.com/rf/remog/page/%@/%@/%@.json",urlHash,domainHash,trapId];
            
            
            NSLog(@"requestString = %@", requestString);
            
            NSString *response = [[NOVA_INITIA getInstance] sendRequest2:@"POST":requestString:NULL:NO];
            
            NSLog(@"response = %@",response);
            
            [self processResponse:response:0];
            
            break;
            }
            else{
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"Error"
                                          message:@"Not enough Traps in inventory." delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                [alertView show];
                break;
            }
        }
        case 1:{
            NSString *url = webView.request.URL.absoluteString;
            [NOVA_INITIA getInstance].curUrl = [self NIurlEncode:webView.request.URL.absoluteString];
            NSString *req = [NSString stringWithFormat:@"NIurlToHash('%@',true);", url];
            NSString *urlDomainHash = [webView stringByEvaluatingJavaScriptFromString:req];
            NSLog(@"urlDomainHash = %@",urlDomainHash);
            NSArray *ud = [urlDomainHash componentsSeparatedByString: @","];
            [NOVA_INITIA getInstance].urlHash = [ud objectAtIndex: 0];
            [NOVA_INITIA getInstance].domainHash = [ud objectAtIndex: 1];
            [self goToNextView:@"barrelPopover"];
            break;
        }
        case 2:{
//            [self showTestAlert:@"SIGNPOST"];
            
            NSString *url = webView.request.URL.absoluteString;
            [NOVA_INITIA getInstance].curUrl = [self NIurlEncode:webView.request.URL.absoluteString];
            NSString *req = [NSString stringWithFormat:@"NIurlToHash('%@',true);", url];
            NSString *urlDomainHash = [webView stringByEvaluatingJavaScriptFromString:req];
            NSLog(@"urlDomainHash = %@",urlDomainHash);
            NSArray *ud = [urlDomainHash componentsSeparatedByString: @","];
            [NOVA_INITIA getInstance].urlHash = [ud objectAtIndex: 0];
            [NOVA_INITIA getInstance].domainHash = [ud objectAtIndex: 1];
            [self goToNextView:@"signpostPopover"];
            break;
        }
        case 3:{
            NSString *url = webView.request.URL.absoluteString;
            [NOVA_INITIA getInstance].curUrl = [self NIurlEncode:webView.request.URL.absoluteString];
            NSString *req = [NSString stringWithFormat:@"NIurlToHash('%@',true);", url];
            NSString *urlDomainHash = [webView stringByEvaluatingJavaScriptFromString:req];
            NSLog(@"urlDomainHash = %@",urlDomainHash);
            NSArray *ud = [urlDomainHash componentsSeparatedByString: @","];
            [NOVA_INITIA getInstance].urlHash = [ud objectAtIndex: 0];
            [NOVA_INITIA getInstance].domainHash = [ud objectAtIndex: 1];
            [self goToNextView:@"doorwayPopover"];
            break;
        }
        case 4:{
            
            if([User getInstance].numSpiders > 0){
                [self showProcessDialog:@"Placing Spider..."];
                [toolSheet dismissWithClickedButtonIndex:toolSheet.cancelButtonIndex animated:YES];
                    NSString *url = webView.request.URL.absoluteString;
                NSString *req = [NSString stringWithFormat:@"NIurlToHash('%@',true);", url];
                NSString *urlDomainHash = [webView stringByEvaluatingJavaScriptFromString:req];
                NSLog(@"urlDomainHash = %@",urlDomainHash);
                NSArray *ud = [urlDomainHash componentsSeparatedByString: @","];
                NSString *urlHash = [ud objectAtIndex: 0];
                NSLog(@"urlHash = %@",urlHash);
                NSString *domainHash = [ud objectAtIndex: 1];
                NSLog(@"domainHash = %@",domainHash);
                NSString *spiderId = @"2";
                NSString *lastKey = [[User getInstance] lastKey];
                NSLog(@"lastKey = %@",lastKey);

                NSString *requestString = [NSString stringWithFormat:@"http://data.nova-initia.com/rf/remog/page/%@/%@/%@.json",urlHash,domainHash,spiderId];
                NSLog(@"requestString = %@", requestString);
                NSString *response = [[NOVA_INITIA getInstance] sendRequest2:@"POST":requestString:NULL:NO];
                NSLog(@"response = %@",response);
            
                [self processResponse:response:2];
 
                break;
            }
            else{
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"Error"
                                          message:@"Not enough Spiders in inventory." delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                [alertView show];
                break;
            }
        }
        case 5:{
            if([User getInstance].numShields > 0){
                [self showProcessDialog:@"Toggling Shield..."];
                [toolSheet dismissWithClickedButtonIndex:toolSheet.cancelButtonIndex animated:YES];
                NSString *requestString = @"http://data.nova-initia.com/rf/remog/user/shield.json";
                NSString *response = [[NOVA_INITIA getInstance] sendRequest2:@"POST":requestString:NULL:NO];
                NSLog(@"response = %@",response);
                
                [self alertResponse:@"Nova Initia":@"Shield toggled":@"shield.png"];
                [NIWebViewController updateUser];
                
                [[User getInstance] buildUser:response];
                
                break;
            }
            
            else{
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"Error"
                                          message:@"Not enough Shields in inventory." delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                [alertView show];
                break;
            }
            
            
        }
        default: break;
            
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

- (void)processResponse:(NSString *)response:(int)toolId{
    
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSDictionary *jsonData = [jsonParser objectWithString:response];
    NSArray *allKeys = [jsonData allKeys];
    NSLog(@"allKeys = %@",allKeys);
    
    switch(toolId){
        case 0:{
            if([allKeys containsObject:@"pageSet"]){
                [self alertResponse:@"Nova Initia":@"Trap set on page":@"trapSet.png"];
            }
            
            if([allKeys containsObject:@"error"]){
                NSString *error = [jsonData objectForKey:@"error"];
                [self alertResponse:@"Nova Initia":error:@"trapFailed.png"]; 
            }
            if([allKeys containsObject:@"result"]){
                NSString *result = [jsonData objectForKey:@"result"];
                NSString *uname = [jsonData objectForKey:@"username"];
                NSString *message = [NSString stringWithFormat:@"%@ username: %@",result,uname];
                [self alertResponse:@"Nova Initia":message:@"spiderTriggered.png"];
            }
            if([allKeys containsObject:@"fail"]){
                [self alertResponse:@"Nova Initia":@"Trap Failed":@"trapFailed.png"]; 
            }
            
            break;
        }
        case 2:{
            if([allKeys containsObject:@"pageSet"]){
                [self alertResponse:@"Nova Initia":@"Spider placed on page":@"spiderSet.png"];
            }
                
            if([allKeys containsObject:@"error"]){
                NSString *error = [jsonData objectForKey:@"error"];
                [self alertResponse:@"Nova Initia":error:@"spiderFailed.png"]; 
            }
            if([allKeys containsObject:@"result"]){
                NSString *result = [jsonData objectForKey:@"result"];
                NSString *uname = [jsonData objectForKey:@"username"];
                NSString *message = [NSString stringWithFormat:@"%@ username: %@",result,uname];
                [self alertResponse:@"Nova Initia":message:@"spiderTriggered.png"];
            }
            if([allKeys containsObject:@"fail"]){
                [self alertResponse:@"Nova Initia":@"Spider Failed":@"spiderFailed.png"]; 
            }
            
            break;
        }
            
        default: break;
            
    }
    
    [NIWebViewController updateUser];
    
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

-(NSString *)NIurlEncode:(NSString *)str{
    NSString *jsString = [NSString stringWithFormat:@"NIurlEncode('%@');", str];
    return [webView stringByEvaluatingJavaScriptFromString:jsString];
}

-(void)place_signpost:(NSString *)title:(NSString *)comment:(BOOL)nsfw{
//    NSString *theNSFW = @"0";
//    if(nsfw)theNSFW = @"1";
//    
//    NSString *url = [self niurlencode:webView.request.URL.absoluteString];
//    NSString *theTitle = [self niurlencode:title];
//    NSString *theComment = [self niurlencode:comment];
//    
//    NSString *theParams = [NSString stringWithFormat:(@"Url=%@&Title=%@&Comment=%@&NSFW=%@",url,theTitle,theComment,theNSFW)];
//    
//    NSString *requestString = [NSString stringWithFormat:(@"http://data.nova-initia.com/rf/remog/page/%@/
}

-(IBAction)launch:(id)sender{
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    NSString *homePage = [[[NOVA_INITIA getInstance] prefs] valueForKey:@"homePage"];
    NSURL *homeUrl = [NSURL URLWithString:homePage];
    if(homeUrl != NULL && (!homeUrl.scheme)){
        NSString *modifiedURLString = [NSString stringWithFormat:@"http://%@", homePage];
        homeUrl = [NSURL URLWithString:modifiedURLString];
    }
    if(homePage == NULL){
        homePage = @"http://www.nova-initia.com/";
        homeUrl = [NSURL URLWithString:homePage];
    }
//    NSLog(homePage);
//    NSURL *url = [NSURL URLWithString:homePage];
    NSURLRequest *request = [NSURLRequest requestWithURL:homeUrl];
    [self.webView loadRequest:request];
    [self updateButtons];
}

-(IBAction)loadUrl:(NSString *)theUrl{
    NSURL *url = [NSURL URLWithString:theUrl];
    if(!url.scheme){
        NSString *modifiedURLString = [NSString stringWithFormat:@"http://%@", theUrl];
        url = [NSURL URLWithString:modifiedURLString];
    }
//    else{
//        NSString *modURLString = [urlString stringByReplacingOccurrencesOfString:@" "withString:@"+"];
//        NSString *gString = @"http://www.google.com/search?q=";
//        NSString *uString = [gString stringByAppendingString:modURLString];
//        url = [NSURL URLWithString:uString];
//    }
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self loadUrl:urlBar.text];
    [urlBar resignFirstResponder];
    return YES;
}


-(void)viewDidAppear:(BOOL)animated{
    if([NOVA_INITIA getInstance].tradepost){
        [NOVA_INITIA getInstance].tradepost = NO;
        [self loadUrl:[NSString stringWithFormat:@"http://www.nova-initia.com/remog/trade?LASTKEY=%@",[User getInstance].lastKey]];
    }
    if([NOVA_INITIA getInstance].readMessages){
        [NOVA_INITIA getInstance].readMessages = NO;
        [self loadUrl:[NSString stringWithFormat:@"http://www.nova-initia.com/remog/mail?LASTKEY=%@",[User getInstance].lastKey]];
    }
    if([NOVA_INITIA getInstance].doorway){
        [NOVA_INITIA getInstance].doorway = NO;
        [self loadUrl:[NOVA_INITIA getInstance].doorwayUrl];
    }
}

- (void)viewDidLoad{
    gotTools = NO;
    urlBar.delegate = self;
    [self launch:self];
	// Do any additional setup after loading the view, typically from a nib.
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

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [self updateAddress:request];
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    gotTools = NO;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self updateButtons];
}
- (void)webViewDidFinishLoad:(UIWebView *)_webView{
    if(webView.loading)
        return;

    [self injectJavascript:@"nifunctions"];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSString *req = [NSString stringWithFormat:@"NIurlToHash('%@',true);", webView.request.URL.absoluteString];
    NSString *urlDomainHash = [webView stringByEvaluatingJavaScriptFromString:req];
//    NSLog(@"urlDomainHash = %@",urlDomainHash);
    NSArray *ud = [urlDomainHash componentsSeparatedByString: @","];
    NSString *urlHash = [ud objectAtIndex: 0];
//    NSLog(@"urlHash = %@",urlHash);
    NSString *domainHash = [ud objectAtIndex: 1];
    
    NSString *requestString = [NSString stringWithFormat:@"http://data.nova-initia.com/rf/remog/page/%@/%@.json?LastKey=%@", urlHash, domainHash, [User getInstance].lastKey];
    
        NSString *response = [[NOVA_INITIA getInstance] sendRequest2:@"GET" :requestString :NULL:NO];
        NSLog(@"response = %@",response);
        [self processToolsOnPage:response];

    
    NSURLRequest *request = [_webView request];
    [self updateAddress:request];
    [self updateButtons];
}

- (void)processToolsOnPage:(NSString *)jsonString{
//    if(!gotTools){
    
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSDictionary *jsonData = [jsonParser objectWithString:jsonString];
    
        NSArray* pageSet = [jsonData objectForKey:@"pageSet"];
        id trap = [pageSet objectAtIndex:0];
        
        if ([trap JSONRepresentation].length > 3){
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Nova Initia" message:@"You triggered a trap!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(220, 10, 40, 40)];
            
            NSString *path = [[NSString alloc] initWithString:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"trapTriggered.png"]];
            UIImage *bkgImg = [[UIImage alloc] initWithContentsOfFile:path];
            [imageView setImage:bkgImg];
            
            [alert addSubview:imageView];

            [alert show];
        
        }
    
//    id doorways = [pageSet objectAtIndex:4];
//    if([doorways JSONRepresentation].length > 3){
//        NSLog(@"DOORWAY(S) on page");
//        id doorway1 = [doorways objectAtIndex:0];
//        NSLog(@"Doorway = %@",doorway1);
//        [NOVA_INITIA getInstance].doorwayId = [doorway1 objectForKey:@"ID"];
//        [NOVA_INITIA getInstance].doorwayUserId = [doorway1 objectForKey:@"USERID"];
//        id toolData = [doorway1 objectForKey:@"toolData"];
//        [NOVA_INITIA getInstance].doorwayHint = [toolData objectForKey:@"Hint"];
//        NSLog(@"doorway id = %@",[NOVA_INITIA getInstance].doorwayId);
//        NSLog(@"doorway hint = %@",[NOVA_INITIA getInstance].doorwayHint);
//    }
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self informError:error];
    [self updateButtons];
}

- (void)updateButtons
{
    self.forwardButton.enabled = self.webView.canGoForward;
    self.backButton.enabled = self.webView.canGoBack;
}

- (void)updateAddress:(NSURLRequest *)request
{
    NSURL *url = [request mainDocumentURL];
    NSString *urlString = [url absoluteString];
    self.urlBar.text = urlString;
}

- (void)informError:(NSError *)error
{
    NSString *localizedDescription = [error localizedDescription];
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:localizedDescription delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    [alertView show];
}


@end
