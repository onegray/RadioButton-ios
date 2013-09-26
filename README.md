# Radio Button for iOS
Pretty simple class that extends standard UIButton functionality.
Default and selected states can be configured for every button. 

![Demo](https://raw.github.com/onegray/RadioButton-ios/data/demo.gif)

#### Super easy to use
It does not need any central manager. Just link the buttons right in Interface Builder:

![Demo](https://raw.github.com/onegray/RadioButton-ios/data/linking.gif)


Alternatively group the buttons using single line of code:

	radio1.groupButtons = @[radio1, radio2, radio3];


Select any button, and all other button in the same group become deselected automatically:

	radio2.selected = YES; // radio1 and radio3 become deselected


Any button from the group knows which one is selected:

	RadioButton* r1 = radio1.selectedButton;
	RadioButton* r2 = radio2.selectedButton;
	RadioButton* r3 = radio3.selectedButton;
	NSAssert (r1==r2 && r2==r3, @"Must be equal");

And a helpful method to select button by tag:

	[radio1 setSelectedWithTag:kTagRadio3];


#### Resources
[sample.zip](https://github.com/onegray/RadioButton-ios/archive/sample.zip) - Sample app  
[radio-res-ios.zip](https://raw.github.com/onegray/RadioButton-ios/data/radio-res-ios.zip) - Radio Button images used in the sample  

#### License
RadioButton is available under the MIT license - fork, modify and use however you want.
