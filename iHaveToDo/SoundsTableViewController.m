//
//  SoundsTableViewController.m
//  iHaveToDo
//
//  Created by Ivelin Ivanov on 8/30/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import "SoundsTableViewController.h"
#import <AudioToolbox/AudioToolbox.h>


@interface SoundsTableViewController ()
{
    NSArray *soundNames;
}


@end

@implementation SoundsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Sounds";

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    soundNames = @[@"Ache", @"Angry Laser", @"Arp", @"Arrogant", @"Attention Seeker", @"Chafing", @"Decided", @"Happy Jump", @"Pizzicato"];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return soundNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = soundNames[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:soundNames[indexPath.row] forKey:@"selectedSound"];
    [defaults synchronize];
    
    NSString *songName = [soundNames[indexPath.row] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSURL *soundURL = [[NSBundle mainBundle] URLForResource:songName withExtension:@"caf"];
    
    SystemSoundID sound;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL, &sound);
    
    AudioServicesPlaySystemSound(sound);
}


@end
