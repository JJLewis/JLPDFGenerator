//
//  JLPDFGenerator.h
//
//
//  Created by Lewis, Jordan on 5/05/14.
//  Copyright (c) 2014 JordanLewis. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kSizeA4Portrait CGSizeMake(595, 842)
#define kSizeA4Landscape CGSizeMake(842, 595)

#define kSizeA5Portrait CGSizeMake(1748, 2480)
#define kSizeA5Landscape CGSizeMake(2480, 1748)

#define NSVerticalAlignmentTop 0
#define NSVerticalAlignmentMiddle 1
#define NSVerticalAlignmentBottom 2

@interface JLPDFGenerator : NSObject {
    CGSize pageSize;
}

/**
 *  Begin the PDF Document
 *
 *  @param name The Document Name to saved as.
 *  @param size The size in pixels of the document. Presets are available.
 */
-(void)setupPDFDocumentNamed:(NSString*)name withSize:(CGSize)size;
/**
 *  Begin the first page of the document
 */
-(void)beginPDFPage;
/**
 *  Add a page to the PDF
 */
-(void)addPageToPDF;

/**
 *  Add Text to PDF
 *
 *  @param text          This is the text to be added to the PDF.
 *  @param frame         The bounding box for which the text should be placed in.
 *  @param fontSize      The font size.
 *  @param color         The text color.
 *  @param textAlignment The text alignment.
 *
 *  @return Returns the bounding box for the text.
 */
-(CGRect)addText:(NSString*)text withFrame:(CGRect)frame withFont:(UIFont *)font withColor:(UIColor *)color textAlignment:(NSTextAlignment)textAlignment verticalAlignment:(int)vertAlignment;

-(CGRect)addTextOLD:(NSString*)text withFrame:(CGRect)frame withFont:(UIFont *)font withColor:(UIColor *)color textAlignment:(NSTextAlignment)textAlignment;

-(CGRect)addLineFromPoint:(CGPoint)startPoint toEndPoint:(CGPoint)endPoint withColor:(UIColor *)color andWidth:(float)width;

-(CGRect)addImage:(UIImage*)image inRect:(CGRect)rect;

-(CGRect)addPath:(CGPathRef)path withStrokeWidth:(float)strokeWidth withFillColor:(UIColor *)fillColor andStrokeColor:(UIColor *)strokeColor atPoint:(CGPoint)location;

-(CGRect)addCircleWithRadius:(float)radius withFillColor:(UIColor *)fillColor andStrokeColor:(UIColor *)strokeColor strokeWithWidth:(float)strokeWidth atCentre:(CGPoint)centre;

-(CGRect)addRect:(CGRect)rect withFillColor:(UIColor *)fillColor andStrokeColor:(UIColor *)strokeColor strokeWithWidth:(float)strokeWidth;

/**
 *  Finish and save the pdf. Write to the doc dir.
 */
-(void)finishPDF;

@end
