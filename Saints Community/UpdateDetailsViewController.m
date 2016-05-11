//
//  UpdateDetailsViewController.m
//  Saints Community
//
//  Created by Kehinde Shittu on 23/12/2015.
//  Copyright © 2015 Kehesjay. All rights reserved.
//

#import "UpdateDetailsViewController.h"
#import "Utils.h"
#import <CoreData/CoreData.h>
#import <SDWebImage/UIImageView+WebCache.h>


@interface UpdateDetailsViewController (){
       CGFloat pageWidth;
}
@end

@implementation UpdateDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSInteger index = [Utils sharedInstance].selectedIndex;
    NSManagedObject *info =  [Utils sharedInstance].fetchedUpdates[index];
    self.headerLabel.text = [info valueForKey:@"title"];
    self.descriptionLabel.editable = YES;
    self.descriptionLabel.text = [info valueForKey:@"entity_description"];
    self.descriptionLabel.editable = NO;
    self.dateLabel.text = [info valueForKey:@"updated_date"];
}

-(void)viewDidAppear:(BOOL)animated{
    self.scrollView.delegate = self;
    self.scrollView.contentSize =  CGSizeMake(self.scrollView.frame.size.width * [Utils sharedInstance].fetchedUpdates.count,
                                              self.scrollView.frame.size.height);
    
    pageWidth = self.scrollView.contentSize.width / [Utils sharedInstance].fetchedUpdates.count;
    for (NSInteger i = 0; i < [Utils sharedInstance].fetchedUpdates.count; i++)
    {
        NSManagedObject *info =  [Utils sharedInstance].fetchedUpdates[i];
        CGRect frame;
        frame.origin.x = self.scrollView.frame.size.width * i;
        frame.size = self.scrollView.frame.size;

        
        UIImageView * updateImage = [[UIImageView alloc] initWithFrame:frame];
        [updateImage sd_setImageWithURL:[NSURL URLWithString:[info valueForKey:@"image_url"]]
                       placeholderImage:[UIImage imageNamed:@"news.png"]];
        
        [self.scrollView addSubview:updateImage];
    }
    [self scrollTo:[Utils sharedInstance].selectedIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger pageIndex = round(self.scrollView.contentOffset.x / pageWidth);
    [self scrollTo:pageIndex];
}

-(void)scrollTo:(NSInteger)index{
    
     self.descriptionLabel.editable = YES;
    CGRect frame = self.scrollView.frame;
    frame.origin.x = pageWidth * index;
    frame.origin.y = 0;
    
    NSManagedObject *info =  [Utils sharedInstance].fetchedUpdates[index];
    self.headerLabel.text = [info valueForKey:@"title"];
    [self.scrollView scrollRectToVisible:frame animated:YES];
    self.descriptionLabel.text = [info valueForKey:@"entity_description"];
    self.descriptionLabel.editable = NO;
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
