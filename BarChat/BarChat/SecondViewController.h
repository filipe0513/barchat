//
//  SecondViewController.h
//  BarChat
//
//  Created by Filipe Magalhães on 01/09/13.
//  Copyright (c) 2013 Filipe Magalhães. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import <Twitter/Twitter.h>

@interface SecondViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableOfTweets;
@property (nonatomic) ACAccountStore *accountStore;
@end
