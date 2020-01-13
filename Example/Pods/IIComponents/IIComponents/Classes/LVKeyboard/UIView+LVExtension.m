//
//  UIView+LVExtension.m
//  黑马微博2期
//
//  Created by apple on 14-10-7.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "UIView+LVExtension.h"

@implementation UIView (LVExtension)

- (void)setLvkb_x:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setLvkb_y:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)lvkb_x
{
    return self.frame.origin.x;
}

- (CGFloat)lvkb_y
{
    return self.frame.origin.y;
}

- (void)setLvkb_centerX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)lvkb_centerX
{
    return self.center.x;
}

- (void)setLvkb_centerY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)lvkb_centerY
{
    return self.center.y;
}

- (void)setLvkb_width:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setLvkb_height:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)lvkb_height
{
    return 216;
}

- (CGFloat)lvkb_width
{
    return self.frame.size.width;
}

- (void)setLvkb_size:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)lvkb_size
{
    return self.frame.size;
}

- (void)setLvkb_origin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)lvkb_origin
{
    return self.frame.origin;
}
@end
