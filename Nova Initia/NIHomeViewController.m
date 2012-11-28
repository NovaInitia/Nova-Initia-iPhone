//
//  NIHomeViewController.m
//  Nova Initia iPhone
//
//  Created by svp on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NIHomeViewController.h"
#import "User.h"
#import "NOVA_INITIA.h"
#import "NIWebViewController.h"

@implementation NIHomeViewController

@synthesize welcomeLabel, shieldsLabel, signpostsLabel, trapsLabel, doorwaysLabel, spidersLabel, barrelsLabel, sgLabel, classNameLabel, expLabel, avatarImageView;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidAppear:(BOOL)animated{
    self.welcomeLabel.text = [NSString stringWithFormat:@"Welcome, %@", [[User getInstance] userName]];
    self.shieldsLabel.text = [NSString stringWithFormat:@"Shields x%@", [NSString stringWithFormat:@"%d",[[User getInstance] numShields]]];
    self.signpostsLabel.text = [NSString stringWithFormat:@"Signposts x%@", [NSString stringWithFormat:@"%d",[[User getInstance] numSignposts]]];
    self.trapsLabel.text = [NSString stringWithFormat:@"Traps x%@", [NSString stringWithFormat:@"%d",[[User getInstance] numTraps]]];
    self.doorwaysLabel.text = [NSString stringWithFormat:@"Doorways x%@", [NSString stringWithFormat:@"%d",[[User getInstance] numDoorways]]];
    self.spidersLabel.text = [NSString stringWithFormat:@"Spiders x%@", [NSString stringWithFormat:@"%d",[[User getInstance] numSpiders]]];
    self.barrelsLabel.text = [NSString stringWithFormat:@"Barrels x%@", [NSString stringWithFormat:@"%d",[[User getInstance] numBarrels]]];
    self.sgLabel.text = [NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%d",[[User getInstance] sg]]];
    self.classNameLabel.text = [NSString stringWithFormat:@"Level %d %@",[User getInstance].level,[User getInstance].className];
    self.expLabel.text = [NSString stringWithFormat:@"exp %d",[User getInstance].exp];

}

- (void)viewDidLoad{
    
    NSURL *url = [NSURL URLWithString:[User getInstance].avatarUrl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    if(data != NULL){
        UIImage *img = [[UIImage alloc] initWithData:data];
        [avatarImageView setImage:img];
    }
}
- (IBAction)tradepostPressed:(UIButton *)sender{
    [NOVA_INITIA getInstance].tradepost = YES;
    [self.tabBarController setSelectedIndex:1];
    
}
- (IBAction)messagesPressed:(id)sender{
    UIActionSheet *messageSheet = [[UIActionSheet alloc]
                 initWithTitle:@"Messages"
                 delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
                 otherButtonTitles:@"Send Message",@"Read Messages", nil];
    
    [messageSheet showInView:[self.view window]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch(buttonIndex){
        case 0:{
            [self goToNextView:@"sendMessage"];
            break;
        }
        case 1:{
            [NOVA_INITIA getInstance].readMessages = YES;
            [self.tabBarController setSelectedIndex:1];
            break;
        }
        default: break;
    }
}

- (IBAction)logoutPressed:(UIButton *)sender{
    [[User getInstance] destructUser];
    [self goToNextView:@"logout"];
}

- (void) goToNextView:(NSString *)segue{
    [super performSegueWithIdentifier:segue sender:self];
}

- (void)viewDidUnload{
    NSLog(@"Home view UNLOADED");
    [super viewDidUnload];
    self.welcomeLabel.text = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
