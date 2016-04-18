//
//  EventDetailsViewController.m
//  Saints Community
//
//  Created by Kehinde Shittu on 23/12/2015.
//  Copyright © 2015 Kehesjay. All rights reserved.
//

#import "EventDetailsViewController.h"
#import "Utils.h"
#import <CoreData/CoreData.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface EventDetailsViewController (){
    CGFloat pageWidth;
}
@end

@implementation EventDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSInteger index = [Utils sharedInstance].selectedIndex;
    NSManagedObject *info =  [Utils sharedInstance].fetchedEvents[index];
    self.headerLabel.text = [info valueForKey:@"title"];
    self.descriptionLabel.text = [info valueForKey:@"entity_description"];
    self.dateLabel.text = [info valueForKey:@"updated_date"];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    self.scrollView.delegate = self;
    self.scrollView.contentSize =  CGSizeMake(self.scrollView.frame.size.width * [Utils sharedInstance].fetchedEvents.count,
                                              self.scrollView.frame.size.height);
    
    pageWidth = self.scrollView.contentSize.width / [Utils sharedInstance].fetchedEvents.count;
    for (NSInteger i = 0; i < [Utils sharedInstance].fetchedEvents.count; i++)
    {
        NSManagedObject *info =  [Utils sharedInstance].fetchedEvents[i];
        CGRect frame;
        frame.origin.x = self.scrollView.frame.size.width * i;
        frame.size = self.scrollView.frame.size;
        
        
        UIImageView * eventImage = [[UIImageView alloc] initWithFrame:frame];
        [eventImage sd_setImageWithURL:[NSURL URLWithString:[info valueForKey:@"image_url"]]
                      placeholderImage:[UIImage imageNamed:@"upcoming.png"]];
        
        [self.scrollView addSubview:eventImage];
    }
    [self scrollTo:[Utils sharedInstance].selectedIndex];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger pageIndex = round(self.scrollView.contentOffset.x / pageWidth);
    [self scrollTo:pageIndex];
}

-(void)scrollTo:(NSInteger)index{
    CGRect frame = self.scrollView.frame;
    frame.origin.x = pageWidth * index;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    
    NSManagedObject *info =  [Utils sharedInstance].fetchedEvents[index];
    self.headerLabel.text = [info valueForKey:@"title"];
    self.descriptionLabel.text = [info valueForKey:@"entity_description"];
    self.dateLabel.text = [info valueForKey:@"updated_date"];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
