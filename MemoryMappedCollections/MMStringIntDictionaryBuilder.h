//
//  MMStringIntDictionaryBuilder.h
//  MemoryMappedCollections
//
//  Created by Viacheslav Volodko on 3/2/19.
//  Copyright © 2019 killobatt. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMStringIntDictionaryBuilder : NSObject

- (instancetype)initWithDictionary:(NSDictionary<NSString *, NSNumber *> *)dictionary NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;
- (NSData *)serialize;

@end

NS_ASSUME_NONNULL_END
