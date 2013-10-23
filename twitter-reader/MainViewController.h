//
//  MainViewController.h
//  twitter-reader
//
//  Created by Batuhan Erdogan on 23.10.2013.
//  Copyright (c) 2013 Batuhan Erdogan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import <QuartzCore/QuartzCore.h>

@interface MainViewController : UITableViewController{

    IBOutlet UITextView *lastTweetTextView;
}
@property (nonatomic, retain) NSString *username;

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *tweets;
@property (nonatomic, retain) NSString *following;
@property (nonatomic, retain) NSString *followers;
@property (nonatomic, retain) NSString *profileImageURL;
@property (nonatomic, retain) NSString *bannerImageURL;

@end
