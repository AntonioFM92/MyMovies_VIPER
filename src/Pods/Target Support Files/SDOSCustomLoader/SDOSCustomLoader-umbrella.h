#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "SDOSLoaderConstants.h"
#import "SDOSLoaderProgress.h"
#import "UIColorSDOSLoaderHelper.h"
#import "UIViewSDOSLoaderHelper.h"
#import "SDOSLoaderCircularProgressLayer.h"
#import "SDOSLoaderLinearProgressLayer.h"
#import "SDOSLoaderProgressLayer.h"

FOUNDATION_EXPORT double SDOSCustomLoaderVersionNumber;
FOUNDATION_EXPORT const unsigned char SDOSCustomLoaderVersionString[];

