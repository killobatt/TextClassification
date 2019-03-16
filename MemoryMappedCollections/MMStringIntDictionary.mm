//
//  MMStringIntDictionary.m
//  MemoryMappedCollections
//
//  Created by Viacheslav Volodko on 3/2/19.
//  Copyright © 2019 killobatt. All rights reserved.
//

#import "MMStringIntDictionary.h"
#import "schema_generated.h"

@interface MMStringIntDictionary ()
@property (nonatomic, strong, nonnull) NSData *dataBuffer;
@property (nonatomic, unsafe_unretained) const flatcollections::StringIntDictionary *dict;
@end

@implementation MMStringIntDictionary

- (instancetype)initWithFileURL:(NSURL *)fileURL error:(NSError *__autoreleasing *)error {
    NSData *data = [NSData dataWithContentsOfURL:fileURL options:NSDataReadingMappedAlways error:error];
    if (nil == data) {
        return nil;
    }
    return [self initWithData:data];
}

- (instancetype)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        self.dataBuffer = data;
        self.dict = flatcollections::GetStringIntDictionary(data.bytes);
    }
    return self;
}

- (int64_t)int64ForKey:(NSString *)key {
    @autoreleasepool {
        auto entries = self.dict->entries();
        auto entry = entries->LookupByKey(key.UTF8String);
        if (NULL != entry) {
            return entry->value();
        }
        return NSNotFound;
    }
}

- (NSArray<NSString *> *)allKeys {
    auto entries = self.dict->entries();
    NSMutableArray *allKeys = @[].mutableCopy;
    for (int i = 0; i < entries->Length(); ++i) {
        auto entry = entries->Get(i);
        NSString *key = [NSString stringWithUTF8String:entry->key()->c_str()];
        [allKeys addObject:key];
    }
    return allKeys.copy;
}

@end
