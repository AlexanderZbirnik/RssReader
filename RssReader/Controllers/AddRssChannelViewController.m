//
//  AddRssChannelViewController.m
//  RssReader
//
//  Created by Alex Zbirnik on 04.03.17.
//  Copyright © 2017 com.alexzbirnik. All rights reserved.
//

#import "AddRssChannelViewController.h"
#import "FramedTextField.h"
#import "RoundedButton.h"
#import "CoreDataManager.h"

@interface AddRssChannelViewController ()

@property (weak, nonatomic) IBOutlet FramedTextField *titleTextField;
@property (weak, nonatomic) IBOutlet FramedTextField *urlTextField;
@property (weak, nonatomic) IBOutlet RoundedButton *saveButton;

@end

@implementation AddRssChannelViewController

#pragma mark - UIViewController life cycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNotification];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private methods

- (void) textValidationInTextField: (FramedTextField *) textField {
    
    if (textField.text.length) {
        
        [textField setNormalState];
        
    } else {
        
        [textField setWarningState];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.tag == 0) {
        
        [self.urlTextField becomeFirstResponder];
        
    } else {
        
        [textField resignFirstResponder];
    }
    
    return YES;
}

#pragma mark - Actions

- (IBAction)saveButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    
    BOOL titleExist = self.titleTextField.text.length;
    BOOL urlExist = self.urlTextField.text.length;
    
    if (titleExist && urlExist) {
        
        [[CoreDataManager sharedManager] addChannelWithTitle:self.titleTextField.text
                                                      andUrl:self.urlTextField.text
                                              successHandler:^{
                                                  
                                                  [self.delegate addRssChannelViewController:self
                                                                          newRssChannelAdded:self.titleTextField.text];
                                                  
                                                  [self dismissViewControllerAnimated:YES completion:nil];
                                                  
                                              } andFailureHandler:^(NSError *error) {
                                                  
                                                  NSLog(@"error: %@", error);
                                              }];
    } else {
        
        if (!titleExist) {
            
            [self.titleTextField setWarningState];
        }
        
        if (!urlExist) {
            
            [self.urlTextField setWarningState];
        }
    }
}

#pragma mark - Notification

- (void) addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldTextDidEndEditingNotification:)
                                                 name:UITextFieldTextDidEndEditingNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldTextDidChangeNotification:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
}

- (void) textFieldTextDidEndEditingNotification: (NSNotification *) notification {
    
    [self textValidationInTextField:notification.object];
}

- (void) textFieldTextDidChangeNotification: (NSNotification *) notification {
    
    [self textValidationInTextField:notification.object];
}

@end
