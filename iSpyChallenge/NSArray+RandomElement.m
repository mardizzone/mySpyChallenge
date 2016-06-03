//
//  NSArray+RandomElement.m
//  iSpyChallenge
//
//  Created by Bennett Smith on 6/2/16.
//  Copyright © 2016 Blue Owl. All rights reserved.
//

#import "NSArray+RandomElement.h"

@implementation NSArray (RandomElement)

- (nullable id)randomObject {
    id randomObject = [self count] ? self[arc4random_uniform((u_int32_t)[self count])] : nil;
    return randomObject;
}

@end
