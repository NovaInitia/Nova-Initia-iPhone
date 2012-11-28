//
//  NIRegisterViewController.h
//  Nova Initia iPhone
//
//  Created by svp on 4/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NIRegisterViewController : UIViewController<UIWebViewDelegate> {
    IBOutlet UIWebView *webView;
}

@property (nonatomic, retain) UIWebView *webView;

@end
