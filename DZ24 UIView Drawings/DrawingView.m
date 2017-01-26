//
//  DrawingView.m
//  DZ24 UIView Drawings
//
//  Created by Vasilii on 25.01.17.
//  Copyright © 2017 Vasilii Burenkov. All rights reserved.
//

#import "DrawingView.h"

@interface DrawingView()

@property (strong, nonatomic) NSMutableArray *rects;

@end

@implementation DrawingView

-(UIColor*) randomColor {
    CGFloat red = (CGFloat)arc4random_uniform(256)/255;
    CGFloat blue = (CGFloat)arc4random_uniform(256)/255;
    CGFloat green = (CGFloat)arc4random_uniform(256)/255;
    return [UIColor colorWithRed:red green:green blue:blue alpha:0.8];
}

// the method defines free location for the rectangle

-(BOOL) placeForRectIsFree:(CGRect) newRect andRects:(NSMutableArray*) rects {
    BOOL placeForRectIsFree = YES;
    
    for (int i = 0; i < rects.count; i++) {
        CGRect rect = CGRectFromString([rects objectAtIndex:i]);
        if (CGRectIntersectsRect(rect, newRect)) {//пересeкаются
            placeForRectIsFree = NO;
        }
    }
    return placeForRectIsFree;
}

//the metod create the rectangle for stars
-(CGRect) createRandomRectForStar:(CGRect) rect {
    CGFloat size = MIN(CGRectGetWidth(rect), CGRectGetHeight(rect) / 5);
    
    CGFloat pointX = arc4random_uniform((UInt32)CGRectGetMaxX(rect) - size);
    CGFloat pointY = arc4random_uniform((UInt32)CGRectGetMaxY(rect) - size);
    CGRect rectStar = CGRectMake(pointX, pointY, size, size);
    
    //origin прямоугольника будет генерироваться пока не появится в незанятом месте
    while (![self  placeForRectIsFree:rectStar andRects:self.rects]) {
        CGFloat pointX = arc4random_uniform((UInt32)CGRectGetMaxX(rect) - size);
        CGFloat pointY = arc4random_uniform((UInt32)CGRectGetMaxY(rect) - size);
        rectStar = CGRectMake(pointX, pointY, size, size);
    }
    
    [self.rects addObject:NSStringFromCGRect(rectStar)];
    return rectStar;
}

-(void) createSrarInRect:(CGRect) rect {
    CGRect rectStar = [self createRandomRectForStar:rect];
    
    CGFloat radiusStar = rectStar.size.width / 2;
    CGFloat centerStarX = CGRectGetMidX(rectStar);
    CGFloat centerStarY = CGRectGetMidY(rectStar);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPoint vertexStar;// вершина звезды
    CGFloat angle = (4 * M_PI)/5; //угол делим полный круг на 5 частей
    
    CGContextSetLineWidth(context, 1.0); // Line Width
    CGContextSetStrokeColorWithColor(context, [self randomColor].CGColor);// цвет обводки
    CGContextSetFillColorWithColor (context, [self randomColor].CGColor);//цвет заполнения
    
    //drawing star
    CGContextMoveToPoint(context, centerStarX, centerStarY - radiusStar);
    for (int i = 0; i < 6; i++) {
        vertexStar.x = radiusStar * sin(i * angle);
        vertexStar.y = radiusStar * cos(i * angle);
        
        CGContextAddLineToPoint(context, centerStarX - vertexStar.x, centerStarY - vertexStar.y);
    }
    CGContextFillPath(context);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
 
    self.rects = [[NSMutableArray alloc] init];
    for (int i = 0; i < 5 ; i++) {
        [self createSrarInRect: rect];
    }
     
}



@end
