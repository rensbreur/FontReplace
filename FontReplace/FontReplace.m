//
//  FontReplace.m
//  FontReplace
//
//  Created by Rens Breur on 27/03/2017.
//  Copyright © 2017 Rens Breur. All rights reserved.
//

#import "FontReplace.h"
#import "mach_override.h"

#define kNSCTFontUIUsageAttribute @"NSCTFontUIUsageAttribute"

typedef CTFontRef (*CTProc)();
CTProc CTFontCreateWithFontDescriptorOriginal;

@implementation FontReplace

NSDictionary *replaceFonts;

+ (void)load {
    // Load font dictionary
    replaceFonts = [NSDictionary dictionaryWithContentsOfFile:@"/Library/Preferences/FontReplace.settings.plist"];
    
    // Override CTFontCreateWithFontDescriptor
    mach_override_ptr((void*)&CTFontCreateWithFontDescriptor,
                      (void*)&CTFontCreateWithFontDescriptorOverride,
                      (void**)&CTFontCreateWithFontDescriptorOriginal);
}

CTFontRef CTFontCreateWithFontDescriptorOverride(CTFontDescriptorRef  _Nonnull descriptor, CGFloat size, const CGAffineTransform * _Nullable matrix) {
    // Read descriptor
    CFDictionaryRef dictionary = CTFontDescriptorCopyAttributes(descriptor);
    
    NSString *fontName = CFDictionaryGetValue(dictionary, (__bridge CFStringRef)NSFontNameAttribute);
    NSString *replaceFontName = replaceFonts[fontName];
    
    if (replaceFontName) {
        // Update descriptor
        NSMutableDictionary *mutableDictionary = [(__bridge NSDictionary *)dictionary mutableCopy];
        [mutableDictionary removeObjectForKey:kNSCTFontUIUsageAttribute];
        [mutableDictionary setValue:replaceFontName forKey:NSFontNameAttribute];
        
        descriptor = CTFontDescriptorCreateWithAttributes((__bridge CFDictionaryRef)mutableDictionary);
    }
    
    return CTFontCreateWithFontDescriptorOriginal(descriptor, size, matrix);
}

@end
