//
//  UIView+AVFields.h
//  paas
//
//  Created by Summer on 13-3-28.
//  Copyright (c) 2013年 AVOS. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat const kTextFieldHeight;
extern CGFloat const kTextFieldWidth;
extern CGFloat const kSmallPadding;
extern CGFloat const kSmallPaddingX;
extern CGFloat const kBigPadding;
extern CGFloat const kLogoHeight;

extern CGFloat const kCornerRadius;

@interface UIView (AVFields)

- (UITextField *)defaultStyleField;
- (UIButton *)defaultStyleButton;
- (UIView *)defaultLogo;

- (UIButton *)defaultDismissButton;
- (UIButton *)defaultSignUpButton;

-(void)makeShadowForView:(UIView *)view withCornerRadius:(float)radius;

@end
