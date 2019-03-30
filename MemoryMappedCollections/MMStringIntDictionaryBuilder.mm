//
//  MMStringIntDictionaryBuilder.m
//  MemoryMappedCollections
//
//  Created by Viacheslav Volodko on 3/2/19.
//  Copyright © 2019 killobatt. All rights reserved.
//

#import "MMStringIntDictionaryBuilder.h"
#import "schema_generated.h"

using namespace flatbuffers;
using namespace flatcollections;

@interface MMStringIntDictionaryBuilder ()
@property (nonatomic, copy) NSDictionary<NSString *, NSNumber *> *dictionary;
@end

@implementation MMStringIntDictionaryBuilder

- (instancetype)initWithDictionary:(NSDictionary<NSString *, NSNumber *> *)dictionary {
    self = [super init];
    if (self) {
        self.dictionary = dictionary;
    }
    return self;
}

- (NSData *)serialize {
    // 1. Alloc 10MB buffer on stack
    FlatBufferBuilder builder(1024 * 1024 * 10);

    // 2. Iterate NSDictionary keys and values, converting them into flatcollections::StringIntDictionaryEntry structs
    std::vector<Offset<StringIntDictionaryEntry>> entries;
    for (NSString *key in self.dictionary.allKeys) {
        int64_t value = (int64_t)[self.dictionary objectForKey:key].integerValue;
        auto entry = CreateStringIntDictionaryEntryDirect(builder,
                                                          key.UTF8String,
                                                          value);
        entries.push_back(entry);
    }

    // 3. Create flatcollections::StringIntDictionary
    auto vector = builder.CreateVectorOfSortedTables(&entries);
    auto dictionary = CreateStringIntDictionary(builder, vector);

    // 4. Return flatbuffer as NSData
    builder.Finish(dictionary);
    NSData *data = [NSData dataWithBytes:builder.GetBufferPointer()
                                  length:builder.GetSize()];
    return data;
}

@end
