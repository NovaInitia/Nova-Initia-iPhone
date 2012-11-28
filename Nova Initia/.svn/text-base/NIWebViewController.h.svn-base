//
//  NIWebViewController.h
//  Nova Initia iPhone
//
//  Created by svp on 4/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIBarrelPopover.h"

@interface NIWebViewController : UIViewController<UIWebViewDelegate, UIActionSheetDelegate, UITextFieldDelegate> {
    
    IBOutlet UIWebView *webView;
    IBOutlet UITextField *urlBar;
    IBOutlet UIBarButtonItem *placeToolButton;
    UIBarButtonItem *back;
    UIBarButtonItem *forward;
    UIBarButtonItem *refresh;

}

@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) UITextField *urlBar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* backButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* forwardButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* refreshButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* placeToolButton;

+ (NIWebViewController *) getInstance;

- (void)injectJavascript:(NSString *)resource;
- (IBAction)launch:(id)sender;
- (IBAction)loadUrl:(id)sender;
+ (void)updateUser;
- (void)updateButtons;
- (void)updateAddress:(NSURLRequest *)request;
- (void)informError:(NSError *)error;
- (void)showTestAlert:(NSString *)toolType;
- (void)goToNextView:(NSString *)segue;
- (NSString *)NIurlEncode:(NSString *)str;
- (void)place_signpost:(NSString *)title;
- (void)processToolsOnPage:(NSString *)jsonString;

- (void)showProcessDialog:(NSString *)tool;

- (void)processResponse:(NSString *)response:(int)toolId;

- (void)alertResponse:(NSString *)title:(NSString *)message:(NSString *)image;

//    [webView stringByEvaluatingJavaScriptFromString:
//     @"var script = document.createElement('script');"  
//     "script.type = 'text/javascript';"  
//     "script.text = \"function urlEncode(str){"
//     "var hexStr = function (dec) {"
//     "return '%' + (dec < 16 ? '0' : '') + dec.toString(16).toUpperCase();"
//     "};"
//     "var ret = '',"
//     "unreserved = /[\w.-]/;"
//     "str = (str+'').toString();"
//     "for (var i = 0, dl = str.length; i < dl; i++) {"
//     "var ch = str.charAt(i);"
//     "if (unreserved.test(ch)) {"
//     "ret += ch;"
//     "}"
//     "else {"
//     "var code = str.charCodeAt(i);"
//     "if (0xD800 <= code && code <= 0xDBFF) {"
//     "ret += ((code - 0xD800) * 0x400) + (str.charCodeAt(i+1) - 0xDC00) + 0x10000;"
//     "i++;"
//     "}"
//     "else if (code === 32) {"
//     "ret += '+';"
//     "}"
//     "else if (code < 128) {"
//     "ret += hexStr(code);"
//     "}"
//     "else if (code >= 128 && code < 2048) {"
//     "ret += hexStr((code >> 6) | 0xC0);"
//     "ret += hexStr((code & 0x3F) | 0x80);"
//     "}"
//     "else if (code >= 2048) {"
//     "ret += hexStr((code >> 12) | 0xE0);"
//     "ret += hexStr(((code >> 6) & 0x3F) | 0x80);"
//     "ret += hexStr((code & 0x3F) | 0x80);"
//     "}"
//     "}"
//     "}"
//     "return ret;"
//     "}\";"
//     
//     "function base32md5(data){"
//     "var hex = ni.MD5(data);"
//     "if (hex.length != 32)"
//     "return(false);"
//     "var b32 = '';"
//     "for(var i = 0; i < 7; i++){"
//     "var b32tmp = parseInt(hex.substr(0,5),16).toString(32);"
//     "while(b32tmp.length < (i==6?2:4))"
//     "b32tmp = '0'+b32tmp;"
//     "b32 += b32tmp;"
//     "hex = hex.substr(5);"
//     "}"
//     "return(b32);"
//     "}"
//     
//     "function MD5(str){"
//     "var utf = Utf8Encode(str);"
//     "var bytes = convertToByteArray(utf);"
//     "var hash = Crypto.MD5(bytes, { asString: true });"
//     "alert(hash);"
//     "function toHexString(charCode){"
//     "return ('0' + charCode.toString(16)).slice(-2);"
//     "}"
//     "var s = '';"
//     "for(i in hash){"
//     "s += toHexString(hash.charCodeAt(i));"
//     "}"
//     "s = s.substr(0,32);"
//     "return s;"
//     "}"
//     

//     "function urlToHash(url,doHash){"
//     "url = /^[a-z]+:\/\/([a-z0-9][-a-z0-9]+(\.[a-z0-9][-a-z0-9]+)+)[^_]($|\/|\?)?[^#]*/.exec(url);"
//     "if (!url)"
//     "return(false);"
//     "var domain = url[1];"
//     "url = url[0];"
//     "if(doHash)"
//     "return({'domain':ni.base32md5(domain),'url':ni.base32md5(url)});"
//     "else"
//     "return(url);"
//     "}"
//     
//     "document.getElementsByTagName('head')[0].appendChild(script);"];

@end
