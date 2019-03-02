//
//  NSString+CPP.h
//  MemoryMappedCollections
//
//  Created by Viacheslav Volodko on 3/2/19.
//  Copyright © 2019 killobatt. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (CPP)

@property (nonatomic, readonly, nullable) const char *utf8cString;

@end

NS_ASSUME_NONNULL_END
