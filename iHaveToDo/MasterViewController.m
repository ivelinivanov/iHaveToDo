//
//  MasterViewController.m
//  iHaveToDo
//
//  Created by Ivelin Ivanov on 8/29/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import "MasterViewController.h"

@interface MasterViewController ()
{
    
}
@end

@implementation MasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.reminders = [[NSMutableArray alloc] init];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
                                        init];
    refreshControl.tintColor = [UIColor blackColor];
    [refreshControl addTarget:self action:@selector(refreshReminders) forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl = refreshControl;
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = self.reminders.count;

    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    [self refreshReminders];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshReminders)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self refreshReminders];
    
}

-(void)refreshReminders
{
    UIApplication *app = [UIApplication sharedApplication];
    
    [self.reminders removeAllObjects];
    
    self.reminders = [NSMutableArray arrayWithArray:[app scheduledLocalNotifications]];
    
    [self.tableView reloadData];
    
    [self setTitleRemindersCount];
    [self setBadgesCount];
    
    [self.refreshControl endRefreshing];
}

- (void)insertNewObject:(id)sender
{
    [self performSegueWithIdentifier:@"createReminder" sender:self];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.reminders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    UILocalNotification *notification = self.reminders[indexPath.row];
    cell.textLabel.text = notification.alertBody;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"hh:mm dd/MMM/yyyy";
    
    switch (notification.repeatInterval)
    {
        case NSDayCalendarUnit:
            cell.detailTextLabel.text = [NSString stringWithFormat:@"Every day since: %@", [formatter stringFromDate:notification.fireDate]];
            break;
        case NSMonthCalendarUnit:
            cell.detailTextLabel.text = [NSString stringWithFormat:@"Every month since: %@", [formatter stringFromDate:notification.fireDate]];
            break;
        case NSWeekCalendarUnit:
            cell.detailTextLabel.text = [NSString stringWithFormat:@"Every week since: %@", [formatter stringFromDate:notification.fireDate]];
            break;
        case NSYearCalendarUnit:
            cell.detailTextLabel.text = [NSString stringWithFormat:@"Every year since: %@", [formatter stringFromDate:notification.fireDate]];
            break;
        default:
            cell.detailTextLabel.text = [NSString stringWithFormat:@"Single %@", [formatter stringFromDate:notification.fireDate]];
            break;
    }
        
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [[UIApplication sharedApplication] cancelLocalNotification:self.reminders[indexPath.row]];
        [self.reminders removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [self setBadgesCount];
        [self setTitleRemindersCount];
    }
}

-(void)setBadgesCount
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = self.reminders.count;
}

-(void)setTitleRemindersCount
{
    self.navigationItem.title = [NSString stringWithFormat:@"Reminders (%d)", self.reminders.count];
}

@end
