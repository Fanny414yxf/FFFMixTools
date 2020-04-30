//
//  CXMetaNSData.m
//  SDKMixTools
//
//  Created by chr on 2020/4/3.
//  Copyright © 2020 chr. All rights reserved.
//

#import "CXMetaNSData.h"

#define MODEL_NSDATA_1 @"\
    if ({OCINPUT1} && [{OCINPUT1} length]>0) {\n\
        NSMutableString *{OCPARAM3} = [[NSMutableString alloc] initWithCapacity:[{OCINPUT1} length]];\n\
        [{OCINPUT1} enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {\n\
            unsigned char *dataBytes = (unsigned char*)bytes;\n\
            for (NSInteger i = 0; i < 1; i++) {\n\
                NSString *{OCPARAM2} = [NSString stringWithFormat:@\"%x\", (dataBytes[i]) & 0xff];\n\
                if ([{OCPARAM2} length] == 2) {\n\
                    [{OCPARAM3} appendString:{OCPARAM2}];\n\
                } else {\n\
                    [{OCPARAM3} appendFormat:@\"0%@\", {OCPARAM2}];\n\
                }\n\
            }\n\
        }];\n\
    }\n"
#define MODEL_NSDATA_2 @"\
    const unsigned char *{OCPARAM2} = (const unsigned char *)[{OCINPUT1} bytes];\n\
    if ({OCPARAM2})\n\
    { \n\
        NSMutableString *{OCPARAM3} = [NSMutableString stringWithCapacity:([{OCINPUT1} length] * 2)];\n\
        \n\
        for (int i = 0; i < 1; ++i)\n\
        {\n\
            [{OCPARAM3} appendFormat:@\"%02x\", (unsigned int){OCPARAM2}[i]];\n\
        }\n\
        [NSString stringWithString:{OCPARAM3}];\n\
    }\n"
#define MODEL_NSDATA_3 @"\
    NSData *{OCPARAM1} = [[{OCINPUT1} base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed] dataUsingEncoding:NSUTF8StringEncoding];\n\
    [{OCPARAM1} base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];\n"
#define MODEL_NSDATA_4 @"\
    NSData *{OCPARAM1} = [[NSData alloc]initWithBase64EncodedString:@\"{OCPARAM1}\" options:NSDataBase64DecodingIgnoreUnknownCharacters];\n\
    [[NSString alloc]initWithData:{OCPARAM1} encoding:NSUTF8StringEncoding];\n"

@implementation CXMetaNSData

static CXMetaNSData *_instance;
+ (CXMetaNSData *)sharedInstance {
    if (_instance == nil) {
        _instance = [[CXMetaNSData alloc] init];
    }
    return _instance;
}


- (CGFloat)methodBodyMacrosCount {
    return 4;
}

- (NSArray <NSString *>*)marosArr {
    return @[
        MODEL_NSDATA_1,
        MODEL_NSDATA_2,
        MODEL_NSDATA_3,
        MODEL_NSDATA_4
    ];
}
@end
