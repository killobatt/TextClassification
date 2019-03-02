//
//  NSString+CPP.m
//  MemoryMappedCollections
//
//  Created by Viacheslav Volodko on 3/2/19.
//  Copyright © 2019 killobatt. All rights reserved.
//

#import "NSString+CPP.h"

@implementation NSString (CPP)

- (nullable const char *)utf8cString {
    return [self cStringUsingEncoding:NSUTF8StringEncoding];
}

@end
