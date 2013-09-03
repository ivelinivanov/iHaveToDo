//
//  CreateViewController.h
//  iHaveToDo
//
//  Created by Ivelin Ivanov on 8/29/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *reminderName;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentPicker;
@property (weak, nonatomic) IBOutlet UILabel *selectedSoundLabel;


@end
