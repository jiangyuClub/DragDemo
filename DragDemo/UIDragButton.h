//
//  UIDragButton.h
//  DragDemo
//
//  Created by jiangyu on 15/10/19.
//  Copyright © 2015年 YANGReal. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UIDragButton;

typedef NS_ENUM(NSInteger, SudokuBtnType) {
    SudokuBtnType_1=0,
    SudokuBtnType_2,
};


#define DragBtnTagPlus   88

//拖拽回调协议
@protocol UIDragButtonDelegate <NSObject>
@optional
- (void)dragButtonDragBeginWithDragBtn:(UIDragButton *)dragBtn; //开始拖拽
- (void)dragButtonDragingWithDragBtn:(UIDragButton *)dragBtn offsetPoint:(CGPoint)offsetPoint; //正在拖拽
- (void)dragButtonDragEndWithDragBtn:(UIDragButton *)dragBtn;   //拖拽完成
- (void)dragButtonClickWithDragBtn:(UIDragButton *)dragBtn;     //点击操作
@end


@interface UIDragButton : UIButton

@property (nonatomic, assign) id<UIDragButtonDelegate> delegate;
@property (nonatomic, assign) SudokuBtnType btnType;       //九宫格按钮类型
@property (nonatomic, assign) NSMutableArray *itemsArray;  //button集合，一定要assin因为只是保持引用

- (instancetype)initWithFrame:(CGRect)frame sudokuBtnType:(SudokuBtnType)type;

@end

