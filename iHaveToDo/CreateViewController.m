//
//  CreateViewController.m
//  iHaveToDo
//
//  Created by Ivelin Ivanov on 8/29/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import "CreateViewController.h"

@interface CreateViewController ()
{
    NSString *soundName;
}

@end

@implementation CreateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.reminderName.delegate = self;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"Ache" forKey:@"selectedSound"];
    [defaults synchronize];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(addButtonPressed:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
     
    self.navigationItem.title = @"New Reminder";
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    soundName = [[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSound"];
    self.selectedSoundLabel.text = soundName;
}

- (BOOL)checkForValidData
{
    if ([self.reminderName.text isEqualToString:@""])
    {
        return NO;
    }
    else if ([self.datePicker.date timeIntervalSinceNow] < 0)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

#pragma mark - IBAction methods

- (IBAction)addButtonPressed:(id)sender
{
    if ([self checkForValidData])
    {
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = self.datePicker.date;
        
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        
        localNotification.alertBody = self.reminderName.text;
        localNotification.alertAction = @"Snooze";
        localNotification.hasAction = YES;
        
        localNotification.soundName = [NSString stringWithFormat:@"%@.caf", soundName];
        
        NSLog(@"%d", [self.segmentPicker selectedSegmentIndex]);
        
        switch ([self.segmentPicker selectedSegmentIndex])
        {
            case 0:
                localNotification.repeatInterval = 0;
                break;
            case 1:
                localNotification.repeatInterval = NSDayCalendarUnit;
                break;
            case 2:
                localNotification.repeatInterval = NSWeekCalendarUnit;
                break;
            case 3:
                localNotification.repeatInterval = NSMonthCalendarUnit;
                break;
            case 4:
                localNotification.repeatInterval = NSYearCalendarUnit;
                break;
            default:
                break;
        }
        
        localNotification.repeatCalendar = [NSCalendar currentCalendar];
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!" message:@"The reminder you've entered is not correct!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
}

#pragma mark - TextField keyboard methods

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self performSelector:@selector(addButtonPressed:) withObject:self];
    return YES;
}

@end
