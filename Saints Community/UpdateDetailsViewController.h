//
//  UpdateDetailsViewController.h
//  Saints Community
//
//  Created by Kehinde Shittu on 23/12/2015.
//  Copyright © 2015 Kehesjay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateDetailsViewController : UIViewController <UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic) IBOutlet UITextView *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
- (IBAction)cancel:(id)sender;

@end
