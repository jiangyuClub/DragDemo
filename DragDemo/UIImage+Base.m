//
//  UIImage+Base.m
//  iqianjin
//
//  Created by jiangyu on 15/7/17.
//  Copyright (c) 2015年 iqianjin. All rights reserved.
//

#import "UIImage+Base.h"

@implementation UIImage (Base)

+ (UIImage *)imageFromColor:(UIColor *)color withframe:(CGRect)frame {
    CGRect rect = CGRectMake(0, 0, frame.size.width, frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
