//
//  UpdatesViewController.h
//  Saints Community
//
//  Created by Kehinde Shittu on 31/10/2015.
//  Copyright © 2015 Kehesjay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdatesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@end
