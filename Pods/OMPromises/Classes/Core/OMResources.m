//
// OMResources.m
// OMPromises
//
// Copyright (C) 2013,2014 Oliver Mader
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "OMResources.h"

#import "OMPromise.h"

#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
static NSString *const kBundleName = @"OMPromises-Resources-iOS";
#else
static NSString *const kBundleName = @"OMPromises-Resources-OSX";
#endif

NSBundle *OMResourcesBundle() {
    static NSBundle *resources = nil;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        NSBundle *bundle = [NSBundle bundleForClass:OMPromise.class];
        NSString *path = [bundle pathForResource:kBundleName ofType:@"bundle"];
        resources = [NSBundle bundleWithPath:path];
    });
    
    return resources;
}

NSBundle *OMLocalizedStrings() {
    NSBundle *resources = OMResourcesBundle();
    
    for (NSString *locale in [NSLocale preferredLanguages]) {
        NSString *path = [resources pathForResource:locale ofType:@"lproj"];
        if (path) {
            return [NSBundle bundleWithPath:path];
        }
    }
    
    return nil;
}

NSString *OMLocalizedString(NSString *key, ...) {
    NSString *format = [OMLocalizedStrings() localizedStringForKey:key value:@"" table:nil];
    
    va_list args;
    va_start(args, key);
    NSString *value = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    
    return value;
}
