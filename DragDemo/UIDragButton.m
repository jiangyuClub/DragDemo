//
//  UIDragButton.m
//  DragDemo
//
//  Created by jiangyu on 15/10/19.
//  Copyright © 2015年 YANGReal. All rights reserved.
//

#import "UIDragButton.h"
#import "UIImage+Base.h"

#define Duration 0.25

#define DragBtnNormalImg [UIImage imageFromColor:[UIColor colorWithRed:0.646 green:0.593 blue:0.781 alpha:1.000] withframe:self.frame]
#define DragBtnHighlightedImg [UIImage imageFromColor:[UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1] withframe:self.frame]

@interface UIDragButton ()

@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint originPoint;

@end

@implementation UIDragButton

- (instancetype)initWithFrame:(CGRect)frame sudokuBtnType:(SudokuBtnType)type {
    self = [super initWithFrame:frame];
    if (self) {
        self.tag = type + DragBtnTagPlus;  //九宫格类型作为按钮tag
        self.btnType = type;
        self.clipsToBounds = NO;
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setBackgroundImage:DragBtnNormalImg forState:UIControlStateNormal];
        [self setBackgroundImage:DragBtnHighlightedImg forState:UIControlStateHighlighted];
        
        [self setUpWithType:type];

        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(buttonLongPressed:)];
        [self addGestureRecognizer:longGesture];
        
        [self addTarget:self action:@selector(doDragButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

#pragma mark 根据类型填写标题和图片
- (void)setUpWithType:(SudokuBtnType)btnType {
    switch (btnType) {
        case SudokuBtnType_1: {
            [self setTitle:@"我是普京" forState:UIControlStateNormal];
            [self setImage:[UIImage imageNamed:@"zc_icon_red"] forState:UIControlStateNormal];
        }
            break;
        case SudokuBtnType_2: {
            [self setTitle:@"我是IS" forState:UIControlStateNormal];
            [self setImage:[UIImage imageNamed:@"zc_icon_red"] forState:UIControlStateNormal];
        }
            break;
        
        default:
            break;
    }
}

#pragma mark 设置按钮标题和图片的偏移
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGRect imageRect = CGRectMake((width - self.imageView.image.size.width)/2,
                                  (height - self.imageView.image.size.height - self.titleLabel.font.pointSize - 10)/2,
                                  self.imageView.image.size.width,
                                  self.imageView.image.size.height);
    self.imageView.frame = imageRect;
    
    CGFloat labelHeight = self.titleLabel.font.pointSize + 2;
    CGRect labelRect = CGRectMake(0, imageRect.origin.y + imageRect.size.height,
                                  width, labelHeight);
    self.titleLabel.frame = labelRect;
}

#pragma mark- 长按处理
- (void)buttonLongPressed:(UILongPressGestureRecognizer *)sender {
    UIDragButton *currentBtn = (UIDragButton *)sender.view;
    __block NSInteger currentIndex = [self currentIndexOfPoint:currentBtn.center];
    
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        self.startPoint = [sender locationInView:sender.view];
        self.originPoint = currentBtn.center;
        [UIView animateWithDuration:Duration animations:^{
            currentBtn.transform = CGAffineTransformMakeScale(1.1, 1.1);
            [[currentBtn superview] bringSubviewToFront:currentBtn];
        }];
        [self setBackgroundImage:DragBtnHighlightedImg forState:UIControlStateNormal];
        if (self.delegate && [self.delegate respondsToSelector:@selector(dragButtonDragBeginWithDragBtn:)]) {
            [self.delegate dragButtonDragBeginWithDragBtn:currentBtn];
        }
    }
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
        CGPoint newPoint = [sender locationInView:sender.view];
        CGFloat deltaX = newPoint.x-self.startPoint.x;
        CGFloat deltaY = newPoint.y-self.startPoint.y;
        currentBtn.center = CGPointMake(currentBtn.center.x+deltaX,currentBtn.center.y+deltaY);
        
        NSInteger index = [self indexOfPoint:currentBtn.center withButton:currentBtn];
        if (index >= 0) {
            [UIView animateWithDuration:Duration animations:^{
                CGPoint tempPoint = self.originPoint;
                CGPoint nextPoint = self.originPoint;
                if (index > currentIndex) {
                    for (NSInteger i = currentIndex; i < index; i ++) {
                        UIButton *button = _itemsArray[i + 1];
                        nextPoint = button.center;
                        if (i == currentIndex) {
                            button.center = self.originPoint;
                        } else {
                            button.center = tempPoint;
                        }
                        tempPoint = nextPoint;
                        self.originPoint = nextPoint;
                        [self.itemsArray exchangeObjectAtIndex:i withObjectAtIndex:i + 1];
                    }
                } else if (index < currentIndex) {
                    for (NSInteger i = currentIndex; i > index; i--) {
                        UIButton *button = _itemsArray[i - 1];
                        nextPoint = button.center;
                        if (i == currentIndex) {
                            button.center = self.originPoint;
                        } else {
                            button.center = tempPoint;
                        }
                        tempPoint = nextPoint;
                        self.originPoint = nextPoint;
                        [self.itemsArray exchangeObjectAtIndex:i withObjectAtIndex:i - 1];
                    }
                }
            }];
        }
        currentIndex = [self currentIndexOfPoint:currentBtn.center];
        if (self.delegate && [self.delegate respondsToSelector:@selector(dragButtonDragingWithDragBtn:offsetPoint:)]) {
            [self.delegate dragButtonDragingWithDragBtn:currentBtn offsetPoint:CGPointMake(deltaX, deltaY)];
        }
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        [UIView animateWithDuration:Duration animations:^{
            currentBtn.transform = CGAffineTransformIdentity;
            currentBtn.center = self.originPoint;
        }];
        [self setBackgroundImage:DragBtnNormalImg forState:UIControlStateNormal];
        if (self.delegate && [self.delegate respondsToSelector:@selector(dragButtonDragEndWithDragBtn:)]) {
            [self.delegate dragButtonDragEndWithDragBtn:currentBtn];
        }
    }
}

#pragma mark 获取当前按钮非自己的index
- (NSInteger)indexOfPoint:(CGPoint)point withButton:(UIButton *)btn
{
    for (NSInteger i = 0;i<_itemsArray.count;i++)
    {
        UIButton *button = _itemsArray[i];
        if (button != btn)
        {
            if (CGRectContainsPoint(button.frame, point))
            {
                return i;
            }
        }
    }
    return -1;
}

#pragma mark 获取当前按钮index
- (NSInteger)currentIndexOfPoint:(CGPoint)point
{
    for (NSInteger i = 0;i<_itemsArray.count;i++)
    {
        UIButton *button = _itemsArray[i];
        if (CGRectContainsPoint(button.frame, point))
        {
            return i;
        }
    }
    return -1;
}

#pragma mark- 按钮点击事件
- (void)doDragButtonAction:(UIDragButton *)dragBtn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(dragButtonClickWithDragBtn:)]) {
        [self.delegate dragButtonClickWithDragBtn:dragBtn];
    }
}

@end
