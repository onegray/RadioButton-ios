//
//  ViewController.h
//  RadioButtonSample
//
//  Created by Sergey on 9/22/13.
//
//

#import <UIKit/UIKit.h>

@class RadioButton;

@interface ViewController : UIViewController


@property (nonatomic, strong) IBOutlet RadioButton* radioButton;
@property (nonatomic, strong) IBOutlet UILabel* statusLabel;
-(IBAction)onRadioBtn:(id)sender;


@property (nonatomic, strong) IBOutlet RadioButton* maleButton;
-(IBAction)onInvertBtn:(id)sender;


-(IBAction)onCreateMoreButtons:(id)sender;

@end
