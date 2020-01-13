//
//  NSArray+Random.m
//  iOS Custom Keyboards
//
//  Created by 郭翰林 on 16/6/15.
//  Copyright © 2016年 Kulpreet Chilana. All rights reserved.
//

#import "NSArray+Random.h"

@implementation NSArray (Random)

- (NSArray *)randomizedArray {
    NSMutableArray *results = [NSMutableArray arrayWithArray:self];
    NSUInteger i = [results count];
    while(--i > 0) {
        int j = arc4random() % (i+1);
        [results exchangeObjectAtIndex:i withObjectAtIndex:j];
    }
    return [NSArray arrayWithArray:results];
}

@end
