//
//  NOVA_INITIA.h
//  Nova Initia iPhone
//
//  Created by svp on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NOVA_INITIA : NSObject

@property (nonatomic, retain) NSUserDefaults *prefs;
//@property (nonatomic, retain) NSString *niurlencodejs;

@property (nonatomic, retain) NSString *curUrl, *urlHash, *domainHash;

@property (nonatomic, retain) NSString *doorwayId, *doorwayHint, *doorwayUserId, *doorwayUrl;

@property BOOL *tradepost, *readMessages, *doorway;

+ (NOVA_INITIA *) getInstance;

- (NSString *) login:(NSString *)username:(NSString *)password;

- (NSString *)sendRequest:(NSString *)method:(NSString *)url:(NSString *)params;

- (NSString *)sendRequest2:(NSString *)method:(NSString *)url:(NSString *)params:(BOOL)noHeader;

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;

- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

@end
