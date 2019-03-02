//
//  MMStringIntDictionary.h
//  MemoryMappedCollections
//
//  Created by Viacheslav Volodko on 3/2/19.
//  Copyright © 2019 killobatt. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMStringIntDictionary : NSObject

- (nullable instancetype)initWithFileURL:(NSURL *)fileURL error:(NSError *__autoreleasing *)error;
- (instancetype)initWithData:(NSData *)data NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

- (int64_t)int64ForKey:(NSString *)key;

@property (nonatomic, readonly, copy) NSArray<NSString *> *allKeys;

@end

NS_ASSUME_NONNULL_END
