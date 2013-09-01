//
//  SecondViewController.m
//  BarChat
//
//  Created by Filipe Magalhães on 01/09/13.
//  Copyright (c) 2013 Filipe Magalhães. All rights reserved.
//


#import "SecondViewController.h"

@interface SecondViewController()
@end

@implementation SecondViewController
@synthesize accountStore = _accountStore;

- (BOOL)userHasAccessToTwitter
{
    return [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    _accountStore = [[ACAccountStore alloc] init];
    
    [self getTweetsOfSkol];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) getTweetsOfSkol{
    if ([SLComposeViewController isAvailableForServiceType: SLServiceTypeTwitter]){
        NSLog(@"can send");
    }
    
    NSLog(@"0");
    if ([self userHasAccessToTwitter]) {
        NSLog(@"1");
        //  Step 1:  Obtain access to the user's Twitter accounts
        NSLog(@"ˆ%@", self.accountStore);
        
        ACAccountType *twitterAccountType = [self.accountStore
                                             accountTypeWithAccountTypeIdentifier:
                                             ACAccountTypeIdentifierTwitter];
        NSLog(@"%@", self.accountStore);
        [self.accountStore
         requestAccessToAccountsWithType:twitterAccountType
         options:NULL
         completion:^(BOOL granted, NSError *error) {
             NSLog(@"2");

             if (granted) {
                 NSLog(@"2 if");

                 NSURL *url = [NSURL URLWithString: @"https://api.twitter.com/1.1/search/tweets.json"];
                 NSMutableDictionary *params = [NSMutableDictionary dictionary];
                 [params setObject:@"skol%20cerveja" forKey:@"q"];
                 
                 SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                requestMethod:SLRequestMethodGET
                                                          URL:url
                                                   parameters:params];
                 
                 [request performRequestWithHandler:^(NSData *responseData,
                                             NSHTTPURLResponse *urlResponse,
                                             NSError *error) {
                     NSLog(@"3");

                     if (responseData) {
                         NSLog(@"3 if");
                         NSString *res_string = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
                         NSLog(@"%@", res_string);
                         if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
                             NSLog(@"4 if");

                             NSError *jsonError;
                             NSDictionary *skolTweets =
                             [NSJSONSerialization
                              JSONObjectWithData:responseData
                              options:NSJSONReadingAllowFragments error:&jsonError];
                    
                            for(NSDictionary *tweet in skolTweets){
                                NSLog(@"%@", tweet );
                            }
                    
                            if (skolTweets) {
                                NSLog(@"5 if");

                                NSLog(@"Timeline Response: %@\n", skolTweets);
                            }
                            else {
                                NSLog(@"5 else");

                                // Our JSON deserialization went awry
                                NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                            }
                         }
                         else {
                             NSLog(@"4 else");

                            // The server did not respond successfully... were we rate-limited?
                            NSLog(@"The response status code is %d", urlResponse.statusCode);
                         }
                     } else {
                         NSLog(@"3 else");

                     }
                 }];
             }
             else {
                 NSLog(@"2 else");
             }
         }];
    }
}
@end
