//
//  MMStringIntDictionaryBuilder.m
//  MemoryMappedCollections
//
//  Created by Viacheslav Volodko on 3/2/19.
//  Copyright © 2019 killobatt. All rights reserved.
//

#import "MMStringIntDictionaryBuilder.h"
#import "schema_generated.h"

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
    flatbuffers::FlatBufferBuilder builder(1024 * 1024 * 10);
    std::vector<flatbuffers::Offset<flatcollections::StringIntDictionaryEntry>> entries;
    for (NSString *key in self.dictionary.allKeys) {
        int64_t value = (int64_t)[self.dictionary objectForKey:key].integerValue;
        auto entry = flatcollections::CreateStringIntDictionaryEntryDirect(builder, key.UTF8String, value);
        entries.push_back(entry);
    }

    auto vector = builder.CreateVectorOfSortedTables(&entries);
    auto dictionary = flatcollections::CreateStringIntDictionary(builder, vector);

    builder.Finish(dictionary);

    NSData *data = [NSData dataWithBytes:builder.GetBufferPointer() length:builder.GetSize()];
    return data;
}

@end
