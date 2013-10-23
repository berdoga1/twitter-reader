//
//  MainViewController.m
//  twitter-reader
//
//  Created by Batuhan Erdogan on 23.10.2013.
//  Copyright (c) 2013 Batuhan Erdogan. All rights reserved.
//

#import "MainViewController.h"
#import "ProfileCell.h"
#import "InfoCell.h"
#import "TweetCell.h"
#import <QuartzCore/QuartzCore.h>

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize username        = _username;
@synthesize name            = _name;
@synthesize tweets          = _tweets;
@synthesize following       = _following;
@synthesize followers       = _followers;
@synthesize profileImageURL = _profileImageURL;
@synthesize bannerImageURL  = _bannerImageURL;




- (void) getInfo
{
    
    // Request access to the Twitter accounts
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error){
        if (granted) {
            NSArray *accounts = [accountStore accountsWithAccountType:accountType];
            // Check if the users has setup at least one Twitter account
            if (accounts.count > 0)
            {
                ACAccount *twitterAccount = [accounts objectAtIndex:0];
                // Creating a request to get the info about a user on Twitter
                SLRequest *twitterInfoRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/users/show.json"] parameters:[NSDictionary dictionaryWithObject:twitterAccount.username forKey:@"screen_name"]];
                [twitterInfoRequest setAccount:twitterAccount];
                // Making the request
                [twitterInfoRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // Check if we reached the reate limit
                        if ([urlResponse statusCode] == 429) {
                            NSLog(@"Rate limit reached");
                            return;
                        }
                        // Check if there was an error
                        if (error) {
                            NSLog(@"Error: %@", error.localizedDescription);
                            return;
                        }
                        // Check if there is some response data
                        if (responseData) {
                            NSError *error = nil;
                            NSArray *TWData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
                            // Filter the preferred data
                            NSString *screen_name = [(NSDictionary *)TWData objectForKey:@"screen_name"];
                            NSString *name = [(NSDictionary *)TWData objectForKey:@"name"];
                            int followers = [[(NSDictionary *)TWData objectForKey:@"followers_count"] integerValue];
                            int following = [[(NSDictionary *)TWData objectForKey:@"friends_count"] integerValue];
                            int tweets = [[(NSDictionary *)TWData objectForKey:@"statuses_count"] integerValue];
                            self.profileImageURL = [(NSDictionary *)TWData objectForKey:@"profile_image_url_https"];
                            self.bannerImageURL =[(NSDictionary *)TWData objectForKey:@"profile_banner_url"];
                            // Update the interface with the loaded data
                            self.name = name;
                            self.username = [NSString stringWithFormat:@"@%@",screen_name];
                            self.tweets = [NSString stringWithFormat:@"%i", tweets];
                            self.following = [NSString stringWithFormat:@"%i", following];
                            self.followers = [NSString stringWithFormat:@"%i", followers];
                            NSString *lastTweet = [[(NSDictionary *)TWData objectForKey:@"status"] objectForKey:@"text"];
                            lastTweetTextView.text= lastTweet;

                            

                            [self.tableView reloadData];
                        }
                    });
                }];
                
                
                
             // Profile Page timeline json request
                
//                twitterInfoRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/user_timeline.json"] parameters:[NSDictionary dictionaryWithObject:@"200" forKey:@"count"]];
//                [twitterInfoRequest setAccount:twitterAccount];
//                // Making the request
//                [twitterInfoRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        // Check if we reached the reate limit
//                        if ([urlResponse statusCode] == 429) {
//                            NSLog(@"Rate limit reached");
//                            return;
//                        }
//                        // Check if there was an error
//                        if (error) {
//                            NSLog(@"Error: %@", error.localizedDescription);
//                            return;
//                        }
//                        // Check if there is some response data
//                        if (responseData) {
//                            NSString *myString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
//                            NSLog(@"%@", myString );
//                        }
//                    });
//                }];
                
                
                // Home timeline json request
                
//                twitterInfoRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/home_timeline.json"] parameters:[NSDictionary dictionaryWithObject:@"200" forKey:@"count"]];
//                [twitterInfoRequest setAccount:twitterAccount];
//                // Making the request
//                [twitterInfoRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        // Check if we reached the reate limit
//                        if ([urlResponse statusCode] == 429) {
//                            NSLog(@"Rate limit reached");
//                            return;
//                        }
//                        // Check if there was an error
//                        if (error) {
//                            NSLog(@"Error: %@", error.localizedDescription);
//                            return;
//                        }
//                        // Check if there is some response data
//                        if (responseData) {
//                            NSString *myString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
//                            NSLog(@"%@", myString );
//                        }
//                    });
//                }];
                

                
                
            }
        } else {
            NSLog(@"No access granted");
        }
    }];
}


#pragma default methods

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tweets = @"0";
    self.following = @"0";
    self.followers = @"0";
    self.username = @"@username";
    self.name = @"Name";
}

-(void)viewDidAppear:(BOOL)animated{
    [self getInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return 1;
    }
    else if(section == 1){
        return 1;
    }
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section == 0){
        static NSString *CellIdentifier = @"profileCell";
        ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.nameLabel.text = self.name;
        cell.nameLabel.textColor = [UIColor whiteColor];
        
        cell.usernameLabel.text = self.username;
        cell.usernameLabel.textColor = [UIColor whiteColor];

        
        // Get the profile image in the original resolution
        
        if (self.profileImageURL) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

                self.profileImageURL = [self.profileImageURL stringByReplacingOccurrencesOfString:@"_normal" withString:@""];

                NSURL *url = [NSURL URLWithString:self.profileImageURL];
                NSData *data = [NSData dataWithContentsOfURL:url];
                dispatch_async(dispatch_get_main_queue(), ^{

                    [cell.profileImageView.layer setBorderWidth:4.0f];
                    [cell.profileImageView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
                    [cell.profileImageView.layer setShadowRadius:3.0];
                    [cell.profileImageView.layer setShadowOpacity:0.5];
                    [cell.profileImageView.layer setShadowOffset:CGSizeMake(1.0, 0.0)];
                    [cell.profileImageView.layer setShadowColor:[[UIColor blackColor] CGColor]];
                    
                    cell.profileImageView.image = [UIImage imageWithData:data];
                });
            });

        }
        
        // Get the banner image, if the user has one
        if (self.bannerImageURL) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

                NSString *bannerURLString = [NSString stringWithFormat:@"%@/mobile_retina", self.bannerImageURL];
              
                NSURL *url = [NSURL URLWithString:bannerURLString];
                NSData *data = [NSData dataWithContentsOfURL:url];
                dispatch_async(dispatch_get_main_queue(), ^{

                    cell.bannerImageView.image = [UIImage imageWithData:data];
                });
            });
        }
        
        
        // Configure the cell...
        
        return cell;
    }
    else if(indexPath.section == 1){
        static NSString *CellIdentifier = @"infoCell";
        InfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        cell.tweetsLabel.text = self.tweets;
        cell.followingLabel.text = self.following;
        cell.followersLabel.text = self.followers;
        
        return cell;
    }
    else{
        static NSString *CellIdentifier = @"tweetCell";
        TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        
        return cell;

    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 160;
    }
    else if(indexPath.section == 1){
        return 44;
    }
    return 110;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
