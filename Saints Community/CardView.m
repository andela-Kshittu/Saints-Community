//
//  CardView.m
//  Saints Community
//
//  Created by Kehinde Shittu on 23/12/2015.
//  Copyright © 2015 Kehesjay. All rights reserved.
//

#import "CardView.h"

@implementation CardView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)layoutSubviews{
    
    CGFloat radius = 2.0;
    self.layer.cornerRadius = radius;
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:radius];
    
    self.layer.masksToBounds = false;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 3);
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowPath = shadowPath.CGPath;
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end
