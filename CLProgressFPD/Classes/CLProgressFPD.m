//
//  CLProgressFPD.m
//  CLProgressFPD
//
//  Created by ClaudeLi on 2017/11/22.
//  Copyright © 2017年 ClaudeLi. All rights reserved.
//

#import "CLProgressFPD.h"

#define CLHUDTitleDefaultFont   [UIFont boldSystemFontOfSize:16]

CGFloat whiteSpace = 10.0f;
@interface CLProgressFPD (){
    NSTimer *_timer;
}

@property (nonatomic, strong) UIView  *hudView;
@property (nonatomic, strong) UILabel *hudLabel;
@property (nonatomic, strong) UIActivityIndicatorView *hudIndicatorView;
@property (nonatomic, assign) CGFloat mainWidth;

@end

@implementation CLProgressFPD

- (instancetype)init{
    self = [super init];
    if (self) {
        self.alpha = 0;
    }
    return self;
}

- (instancetype)initWithSuperView:(UIView *)view{
    self = [self init];
    if (self) {
        [view addSubview:self];        
    }
    return self;
}

- (UIView *)hudView{
    if (!_hudView) {
        _hudView = [UIView new];
        _hudView.backgroundColor = _hudColor?:[[UIColor blackColor] colorWithAlphaComponent:0.6];
        _hudView.layer.masksToBounds = YES;
        _hudView.layer.cornerRadius = _hudRadius?:6.0f;
        _hudView.alpha = 0;
        [self addSubview:_hudView];
    }
    return _hudView;
}

- (UIActivityIndicatorView *)hudIndicatorView{
    if (!_hudIndicatorView) {
        _hudIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _hudIndicatorView.frame = CGRectMake(0, 0, 30, 30);
        [self.hudView addSubview:_hudIndicatorView];
    }
    return _hudIndicatorView;
}

- (UILabel *)hudLabel{
    if (!_hudLabel) {
        _hudLabel = [UILabel new];
        _hudLabel.textAlignment = NSTextAlignmentCenter;
        _hudLabel.font = _textFont?:CLHUDTitleDefaultFont;
        _hudLabel.textColor = _textColor?:[UIColor whiteColor];
        _hudLabel.adjustsFontSizeToFitWidth = YES;
        [self.hudView addSubview:_hudLabel];
    }
    return _hudLabel;
}

- (CGFloat)mainWidth{
    if (!_mainWidth) {
        _mainWidth = (MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) - 40);
    }
    return _mainWidth;
}

- (void)setHudColor:(UIColor *)hudColor{
    _hudColor = hudColor;
    if (_hudView) {
        _hudView.backgroundColor = _hudColor;
    }
}

- (void)setHudRadius:(CGFloat)hudRadius{
    _hudRadius = hudRadius;
    if (_hudView) {
        _hudView.layer.cornerRadius = _hudRadius;
    }
}

- (void)setTextFont:(UIFont *)textFont{
    _textFont = textFont;
    if (_hudLabel) {
        _hudLabel.font = _textFont;
    }
}

- (void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    if (_hudLabel) {
        _hudLabel.textColor = _textColor;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.center = self.superview.center;
    self.hudView.center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
}

- (void)showText:(NSString *)text{
    [self showText:text delay:1.5f];
}

- (void)showText:(NSString *)text canTouch:(BOOL)canTouch{
    [self showText:text delay:1.5f canTouch:canTouch];
}

- (void)showText:(NSString *)text delay:(NSTimeInterval)delay{
    [self showText:text delay:delay canTouch:YES];
}

- (void)showText:(NSString *)text delay:(NSTimeInterval)delay canTouch:(BOOL)canTouch{
    if ([[NSThread currentThread] isMainThread]) {
        [self _showText:text delay:delay canTouch:canTouch];
    }else{
        __weak __typeof(&*self)weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf _showText:text delay:delay canTouch:canTouch];
        });
    }
}

- (void)_showText:(NSString *)text delay:(NSTimeInterval)delay canTouch:(BOOL)canTouch{
    if (!text.length) {
        return;
    }
    _hudIndicatorView.hidden = YES;
    delay = delay?:1.0;
    CGSize  size = [text sizeWithAttributes:@{NSFontAttributeName:_textFont?:CLHUDTitleDefaultFont}];
    CGFloat width = MIN(size.width, self.mainWidth);
    if (canTouch) {
        self.bounds = CGRectMake(0, 0, width + whiteSpace*2, 60);
        self.hudView.bounds = self.bounds;
    }else{
        self.bounds = self.superview.bounds;
        self.hudView.bounds = CGRectMake(0, 0, width + whiteSpace*2, 60);
    }
    self.center = self.superview.center;
    self.hudLabel.frame = CGRectMake(whiteSpace, 0, width, self.hudView.frame.size.height);
    self.hudLabel.text = text;
    self.hudLabel.hidden = NO;
    [self show];
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer timerWithTimeInterval:delay target:self selector:@selector(hideProgress) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}


- (void)showProgress:(BOOL)canTouch{
    if ([[NSThread currentThread] isMainThread]) {
        [self _showProgress:canTouch];
    }else{
        __weak __typeof(&*self)weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf _showProgress:canTouch];
        });
    }
}

- (void)_showProgress:(BOOL)canTouch{
    _hudLabel.hidden = YES;
    if (canTouch) {
        self.bounds = CGRectMake(0, 0, 68, 68);
        self.hudView.bounds = self.bounds;
    }else{
        self.bounds = self.superview.bounds;
        self.hudView.bounds = CGRectMake(0, 0, 68, 68);
    }
    self.center = self.superview.center;
    self.hudIndicatorView.center = CGPointMake(self.hudView.bounds.size.width/2.0, self.hudView.bounds.size.height/2.0);
    [self.hudIndicatorView startAnimating];
    [self show];
}

- (void)showProgressWithText:(NSString *)text{
    [self showProgressWithText:text canTouch:NO];
}

- (void)showProgressWithText:(NSString *)text canTouch:(BOOL)canTouch{
    if ([[NSThread currentThread] isMainThread]) {
        [self _showProgressWithText:text canTouch:canTouch];
    }else{
        __weak __typeof(&*self)weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf _showProgressWithText:text canTouch:canTouch];
        });
    }
}

- (void)_showProgressWithText:(NSString *)text canTouch:(BOOL)canTouch{
    if (!text.length) {
        return;
    }
    CGSize  size = [text sizeWithAttributes:@{NSFontAttributeName:_textFont?:CLHUDTitleDefaultFont}];
    CGFloat width = MIN(size.width, self.mainWidth);
    if (canTouch) {
        self.bounds = CGRectMake(0, 0, width + whiteSpace*2, 88);
        self.hudView.bounds = self.bounds;
    }else{
        self.bounds = self.superview.bounds;
        self.hudView.bounds = CGRectMake(0, 0, width + whiteSpace*2, 88);
    }
    self.center = self.superview.center;
    self.hudIndicatorView.center = CGPointMake(self.hudView.bounds.size.width/2.0, 30);
    [self.hudIndicatorView startAnimating];
    self.hudLabel.frame = CGRectMake(whiteSpace, 60, width, size.height);
    self.hudLabel.text = text;
    self.hudLabel.hidden = NO;
    [self show];
}

- (void)hideProgress{
    if ([[NSThread currentThread] isMainThread]) {
        [self _hideProgress];
    }else{
        __weak __typeof(&*self)weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf _hideProgress];
        });
    }
}

- (void)_hideProgress{
    __weak __typeof(&*self)weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.alpha = 0;
        weakSelf.hudView.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf finished];
    }];
}

- (void)finished{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    self.hidden = YES;
    _hudView.hidden = YES;
    [_hudIndicatorView stopAnimating];
}

- (void)show{
    [self.superview bringSubviewToFront:self];
    self.hidden = NO;
    self.hudView.hidden = NO;
    __weak __typeof(&*self)weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.alpha = 1;
        weakSelf.hudView.alpha = 1;
    }];
}

@end
