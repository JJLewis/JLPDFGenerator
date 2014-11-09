//
//  JLPDFGenerator.m
//
//
//  Created by Lewis, Jordan on 5/05/14.
//  Copyright (c) 2014 JordanLewis. All rights reserved.
//

#import "JLPDFGenerator.h"

@implementation JLPDFGenerator

#define kPadding 20

-(void)setupPDFDocumentNamed:(NSString *)name withSize:(CGSize)size {
    
    pageSize = size;
    
    NSString *newPDFName = [NSString stringWithFormat:@"%@.pdf", name];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *pdfPath = [documentsDirectory stringByAppendingPathComponent:newPDFName];
    
    UIGraphicsBeginPDFContextToFile(pdfPath, CGRectZero, nil);
}

-(void)beginPDFPage {
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
}

-(void)addPageToPDF {
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
}

-(CGRect)addText:(NSString*)text withFrame:(CGRect)frame withFont:(UIFont *)font withColor:(UIColor *)color textAlignment:(NSTextAlignment)textAlignment verticalAlignment:(int)vertAlignment {
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
    [paragraphStyle setAlignment:textAlignment];
    
    CGSize stringSize = [text boundingRectWithSize:frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle} context:nil].size;
    
    float textWidth = frame.size.width;
    
    if (textWidth < stringSize.width)
        textWidth = stringSize.width;
    if (textWidth > pageSize.width)
        textWidth = pageSize.width - frame.origin.x;
    
    float height = stringSize.height;
    
    if (vertAlignment == NSVerticalAlignmentTop) {
        height = frame.origin.y;
    }
    if (vertAlignment == NSVerticalAlignmentMiddle) {
        height = frame.origin.y + ((frame.size.height - stringSize.height)/2);
    }
    if (vertAlignment == NSVerticalAlignmentBottom) {
        height = frame.origin.y + (stringSize.height/2);
    }
    
    CGRect renderingRect = CGRectMake(frame.origin.x, height, textWidth, stringSize.height);
    
    [text drawInRect:renderingRect withAttributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle, NSForegroundColorAttributeName:color}];
    
    return renderingRect;
}

-(CGRect)addTextOLD:(NSString*)text withFrame:(CGRect)frame withFont:(UIFont *)font withColor:(UIColor *)color textAlignment:(NSTextAlignment)textAlignment{
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(currentContext, color.CGColor);
    
    CGSize stringSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(pageSize.width - 2*20-2*20, pageSize.height - 2*20 - 2*20) lineBreakMode:UILineBreakModeWordWrap];
    
    float textWidth = frame.size.width;
    
    if (textWidth < stringSize.width)
        textWidth = stringSize.width;
    if (textWidth > pageSize.width)
        textWidth = pageSize.width - frame.origin.x;
    
    float height = frame.origin.y + ((frame.size.height - stringSize.height)/2);
    
    CGRect renderingRect = CGRectMake(frame.origin.x, height, textWidth, stringSize.height);
    
    [text drawInRect:renderingRect withFont:font lineBreakMode:UILineBreakModeWordWrap alignment:textAlignment];
    
    frame = CGRectMake(frame.origin.x, frame.origin.y, textWidth, stringSize.height);
    
    return frame;
}

-(CGRect)addLineFromPoint:(CGPoint)startPoint toEndPoint:(CGPoint)endPoint withColor:(UIColor *)color andWidth:(float)width {
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(currentContext, color.CGColor);
    
    // this is the thickness of the line
    CGContextSetLineWidth(currentContext, width);

    CGContextBeginPath(currentContext);
    CGContextMoveToPoint(currentContext, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(currentContext, endPoint.x, endPoint.y);
    
    CGContextClosePath(currentContext);
    CGContextDrawPath(currentContext, kCGPathFillStroke);
    
    CGSize rectSize = CGSizeMake(endPoint.x-startPoint.x, endPoint.y-startPoint.y);
    CGRect rect = CGRectMake(startPoint.x, startPoint.y, rectSize.width, rectSize.width);

    return rect;
}

-(CGRect)addImage:(UIImage*)image inRect:(CGRect)rect {
    
    [image drawInRect:rect];
    
    return rect;
}

-(CGRect)addPath:(CGPathRef)path withStrokeWidth:(float)strokeWidth withFillColor:(UIColor *)fillColor andStrokeColor:(UIColor *)strokeColor atPoint:(CGPoint)location {
    
    if (strokeColor == nil) {
        strokeColor = [UIColor clearColor];
    }
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(currentContext, fillColor.CGColor);
    CGContextSetStrokeColorWithColor(currentContext, strokeColor.CGColor);
    
    CGContextBeginPath(currentContext);
    
    // Set stroke width
    CGContextSetLineWidth(currentContext, strokeWidth);
    
    // Move path to location
    CGContextTranslateCTM(currentContext, location.x, location.y);
    
    // Draw the path
    CGContextAddPath(currentContext, path);
    
    CGContextClosePath(currentContext);
    CGContextDrawPath(currentContext, kCGPathFillStroke);
    
    // CGRect of Path (Bounding Box)
    CGRect pathRect;
    pathRect = CGPathGetBoundingBox(path);
    pathRect.origin.x = location.x;
    pathRect.origin.y = location.y;
    
    return pathRect;
}

-(CGRect)addCircleWithRadius:(float)radius withFillColor:(UIColor *)fillColor andStrokeColor:(UIColor *)strokeColor strokeWithWidth:(float)strokeWidth atCentre:(CGPoint)centre {
    
    if (strokeColor == nil) {
        strokeColor = [UIColor clearColor];
    }
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(currentContext, fillColor.CGColor);
    CGContextSetStrokeColorWithColor(currentContext, strokeColor.CGColor);
    
    CGContextBeginPath(currentContext);
    
    // Set stroke width
    CGContextSetLineWidth(currentContext, strokeWidth);
    
    CGContextAddArc(currentContext, centre.x - radius, centre.y - radius, radius, 0, M_PI*2, 0);
    
    CGContextClosePath(currentContext);
    CGContextDrawPath(currentContext, kCGPathFillStroke);
    
    return CGRectMake(centre.x - radius, centre.y - radius, radius*2, radius*2);
}

-(CGRect)addRect:(CGRect)rect withFillColor:(UIColor *)fillColor andStrokeColor:(UIColor *)strokeColor strokeWithWidth:(float)strokeWidth {
    
    if (strokeColor == nil) {
        strokeColor = [UIColor clearColor];
    }
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(currentContext, strokeColor.CGColor);
    CGContextSetFillColorWithColor(currentContext, fillColor.CGColor);
    
    CGContextSetLineWidth(currentContext, strokeWidth);
    
    CGContextBeginPath(currentContext);
    
    CGContextAddRect(currentContext, rect);
    
    CGContextClosePath(currentContext);
    CGContextDrawPath(currentContext, kCGPathFillStroke);
    
    return rect;
}

-(void)finishPDF {
    UIGraphicsEndPDFContext();
}

@end