//
//  SDOSLoaderProgress.h
//
//  Copyright © 2018 SDOS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SDOSLoaderProgressStyle) { Circular, Linear };

typedef NS_ENUM(NSUInteger, SDOSLoaderProgressType) {
  Indeterminate,
  Determinate,
  //  Buffer,
  //  QueryIndeterminateAndDeterminate
};

@interface SDOSLoaderProgress : UIView

- (_Nonnull instancetype)initWithFrame:(CGRect)frame type:(enum SDOSLoaderProgressType)progressType;

@property(strong, nonatomic) UIColor *progressColor;
@property(strong, nonatomic) UIColor *trackColor;
@property(nonatomic) enum SDOSLoaderProgressType progressType;
@property(nonatomic) enum SDOSLoaderProgressStyle progressStyle;
@property(nonatomic) CGFloat circularProgressDiameter;

@property(nonatomic) int type;
@property(nonatomic) int style;
@property(nonatomic) float trackWidth;

@property(nonatomic) float progress;
@property(nonatomic) BOOL enableTrackColor;

- (void) startAnimation;
- (void) stopAnimation;
@end
