//
//  CLProgressFPD.h
//  CLProgressFPD
//
//  Created by ClaudeLi on 2017/11/22.
//  Copyright © 2017年 ClaudeLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLProgressFPD : UIView

/**
 HUD background color default blackColor.alpha:0.6;
 */
@property (nonatomic, strong) UIColor *hudColor;

/**
 HUD layer corner radius, default 6.0f
 */
@property (nonatomic, assign) CGFloat hudRadius;

/**
 default [UIFont boldSystemFontOfSize:16]
 */
@property (nonatomic, strong) UIFont  *textFont;

/**
 default [UIColor whiteColor]
 */
@property (nonatomic, strong) UIColor *textColor;

- (instancetype)init;
- (instancetype)initWithSuperView:(UIView *)view;

// default delay:1.5f, canTouch:YES
- (void)showText:(NSString *)text;
- (void)showText:(NSString *)text canTouch:(BOOL)canTouch;
- (void)showText:(NSString *)text delay:(NSTimeInterval)delay;
- (void)showText:(NSString *)text delay:(NSTimeInterval)delay canTouch:(BOOL)canTouch;

- (void)showProgress:(BOOL)canTouch;
// default canTouch:NO
- (void)showProgressWithText:(NSString *)text;
- (void)showProgressWithText:(NSString *)text canTouch:(BOOL)canTouch;

// hide
- (void)hideProgress;

@end
