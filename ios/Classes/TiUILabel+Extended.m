/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2015 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#define USE_TI_UILABEL
#define USE_TI_UIATTRIBUTEDSTRING
#import "TiUILabel+Extended.h"


@implementation TiUILabel (Extended)


- (CGSize)sizeForFont:(CGFloat)suggestedWidth
{
  NSAttributedString *value = [label attributedText];
  CGSize maxSize = CGSizeMake(suggestedWidth <= 0 ? 480 : suggestedWidth, 10000);
  CGSize shadowOffset = [label shadowOffset];
  requiresLayout = YES;
  if ((suggestedWidth > 0) && [[label text] hasSuffix:@" "]) {
    // (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(UILineBreakMode)lineBreakMode method truncates
    // the string having trailing spaces when given size parameter width is equal to the expected return width, so we adjust it here.
    maxSize.width += 0.00001;
  }
  CGSize returnVal = [value size];
  CGSize size = CGSizeMake(ceilf(returnVal.width), ceilf(returnVal.height));
  if (shadowOffset.width > 0) {
    // if we have a shadow and auto, we need to adjust to prevent
    // font from clipping
    size.width += shadowOffset.width + 10;
  }

  return size;
}

- (CGFloat)contentWidthForWidth:(CGFloat)suggestedWidth
{
  CGFloat sizeThatFitsResult = [[self label] sizeThatFits:CGSizeMake(suggestedWidth, 0)].width;
  CGFloat fontMeasurementResult = [self sizeForFont:suggestedWidth].width;

  return (MAX(sizeThatFitsResult, fontMeasurementResult));
}



- (CGFloat)contentHeightForWidth:(CGFloat)width
{
  return [[self label] sizeThatFits:CGSizeMake(width, 0)].height;
}

- (CGSize)sizeWithMyFontToSize:(UIFont *)fontToUse withString:(NSString *)string constrainedToSize:(CGSize)size {
    
    NSAttributedString *attributedText =
        [[NSAttributedString alloc]
            initWithString:string
            attributes:@
            {
                NSFontAttributeName: fontToUse
            }];
    CGRect rect = [attributedText boundingRectWithSize:CGSizeMake(size.width, 0)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize newSize = rect.size;
    
    return newSize;
}

- (CGSize)sizeWithMyFont:(UIFont *)fontToUse withString:(NSString *)word
{
    NSDictionary* attribs = @{NSFontAttributeName:fontToUse};
    return ( [word sizeWithAttributes:attribs] );
}




-(CGFloat)fontSizeWithFont:(UIFont *)font withString:(NSString *)string constrainedToSize:(CGSize)size minimumFontSize:(CGFloat)minimumFontSize {
    CGFloat height;
    CGFloat fontSize = [font pointSize];
    
    CGSize newSize = [self sizeWithMyFontToSize:font withString:string constrainedToSize:CGSizeMake(size.width,CGFLOAT_MAX)];
    height = newSize.height;
    UIFont *newFont = font;
    
    //Reduce font size while too large, break if no height (empty string)
    while (height > size.height && height != 0 && fontSize > minimumFontSize) {
        fontSize--;
      //  newFont = [UIFont fontWithName:font.fontName size:fontSize];
        newFont = [UIFont systemFontOfSize:fontSize];
        
        height = [self sizeWithMyFontToSize:newFont withString:string constrainedToSize:CGSizeMake(size.width,CGFLOAT_MAX)].height;
    };
    
    // Loop through words in string and resize to fit
    for (NSString *word in [string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]) {
        CGFloat width = [self sizeWithMyFont:newFont withString:word].width;
        while (width > size.width && width != 0 && fontSize > minimumFontSize) {
            fontSize--;
            newFont = [UIFont systemFontOfSize:fontSize];
            width = [self sizeWithMyFont:newFont withString:word].width;
        }
    }
    return fontSize;
}

- (CGRect)padLabel
{
    if (label.adjustsFontSizeToFitWidth == YES){

            CGSize actualLabelSize;
            actualLabelSize = [label.text boundingRectWithSize:CGSizeMake(initialLabelFrame.size.width, 0)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:@{NSFontAttributeName:[UIFont fontWithName:label.font.fontName size:label.font.pointSize]}
                                                  context:nil].size;
            
            
            if (initialLabelFrame.size.width > 0 && [[self.proxy valueForUndefinedKey:@"width"] isEqual:@"FILL"]){
                
                CGFloat adjustedFontSize = [self fontSizeWithFont:self.label.font withString:self.label.text constrainedToSize:initialLabelFrame.size minimumFontSize:minFontSize];
                   self.label.font = [self.label.font fontWithSize:adjustedFontSize];
            }
            CGRect labelRect = CGRectMake(label.frame.origin.x, label.frame.origin.y, actualLabelSize.width,actualLabelSize.height);
            if ([[self.proxy valueForUndefinedKey:@"width"] isEqual:@"FILL"]){
                labelRect.size.width = initialLabelFrame.size.width;
            }
            else {
                if (initialLabelFrame.size.width < actualLabelSize.width) {
                      labelRect.size.width = initialLabelFrame.size.width;
                }
            }
            if ([[self proxy] valueForUndefinedKey:@"maxLines"]){
                CGFloat maxLines = [TiUtils floatValue:[[self proxy] valueForKey:@"maxLines"]];
                if ([[self.proxy valueForUndefinedKey:@"height"] isEqual:@"SIZE"]){
                    labelRect.size.height = initialLabelFrame.size.height;
                }
            }
            else {
                if (initialLabelFrame.size.height < actualLabelSize.height) {
                    labelRect.size.height = initialLabelFrame.size.height;
                }

            }

           [label setFrame:CGRectIntegral(labelRect)];
    }
    else {
        
      CGSize actualLabelSize;
      actualLabelSize = [label sizeThatFits:CGSizeMake(initialLabelFrame.size.width, 0)];
        
      UIControlContentVerticalAlignment alignment = verticalAlign;
      if (alignment == UIControlContentVerticalAlignmentFill) {
        //IOS7 layout issue fix with attributed string.
        if (actualLabelSize.height < initialLabelFrame.size.height) {
          alignment = UIControlContentVerticalAlignmentCenter;
        } else {
          alignment = UIControlContentVerticalAlignmentTop;
        }
      }
      if (alignment != UIControlContentVerticalAlignmentFill && ([label numberOfLines] != 1)) {
        CGFloat originX = 0;
        switch (label.textAlignment) {
        case NSTextAlignmentRight:
          originX = (initialLabelFrame.size.width - actualLabelSize.width);
          break;
        case NSTextAlignmentCenter:
          originX = (initialLabelFrame.size.width - actualLabelSize.width) / 2.0;
          break;
        default:
          break;
        }

        if (originX < 0) {
          originX = 0;
        }
        CGRect labelRect = CGRectMake(originX, 0, actualLabelSize.width, actualLabelSize.height);
          
        switch (alignment) {
            case UIControlContentVerticalAlignmentBottom:

              labelRect.origin.y = initialLabelFrame.size.height - actualLabelSize.height;
              break;
                
            case UIControlContentVerticalAlignmentCenter:
              labelRect.origin.y = (initialLabelFrame.size.height - actualLabelSize.height) / 2;
                if (labelRect.origin.y < 0) {
                    labelRect.size.height = (initialLabelFrame.size.height - labelRect.origin.y);
                }
              break;
                
            default:

              if (initialLabelFrame.size.height < actualLabelSize.height) {

                      if([TiUtils boolValue:[self.proxy valueForKey:@"calcRealSize"] def:NO] == YES) {
                          if ([self.proxy valueForUndefinedKey:@"ellipsize"]) {
                              if (![[TiUtils stringValue:[self.proxy valueForKey:@"ellipsize"]] isEqualToString:@"true"]) {
                                  labelRect.size.height = actualLabelSize.height;
                              }
                              else {
                                  labelRect.size.height = initialLabelFrame.size.height;
                              }
                          }
                          else {
                              labelRect.size.height = initialLabelFrame.size.height;
                          }
                      }
                      else {
                          labelRect.size.height = initialLabelFrame.size.height;
                      }
              }
                
              break;
        }
        [label setFrame:CGRectIntegral(labelRect)];
     
      } else {
        [label setFrame:initialLabelFrame];
      }

      if ([self backgroundImageLayer] != nil && !CGRectIsEmpty(initialLabelFrame)) {
        [self updateBackgroundImageFrameWithPadding];
      }
    }
    return label.frame;
}


#ifndef TI_USE_AUTOLAYOUT
// FIXME: This isn't quite true.  But the brilliant soluton wasn't so brilliant, because it screwed with layout in unpredictable ways.
//	Sadly, there was a brilliant solution for fixing the blurring here, but it turns out there's a
//	quicker fix: Make sure the label itself has an even height and width. Everything else is irrelevant.
- (void)setCenter:(CGPoint)newCenter
{
  [super setCenter:CGPointMake(floorf(newCenter.x), floorf(newCenter.y))];
}
#endif

- (void)frameSizeChanged:(CGRect)frame bounds:(CGRect)bounds
{
    CGRect tempSize = bounds;
    CGRect tempFrame = frame;
    
    #ifndef TI_USE_AUTOLAYOUT
        
     initialLabelFrame = bounds;
    [self padLabel];

    if (!CGRectIsEmpty(bounds)) {
        CGFloat diff = tempSize.size.width - label.frame.size.width;
        
        if([TiUtils boolValue:[self.proxy valueForKey:@"calcRealSize"] def:NO] == YES) {
            TiViewProxy *parent = [(TiViewProxy *)self.proxy parent];
            tempSize.size.width = label.frame.size.width;
            tempSize.size.height = label.frame.size.height;
            tempFrame.size.width = label.frame.size.width;
            tempFrame.size.height = label.frame.size.height;
            
            CGFloat leftSpacing = 0;
            CGFloat rightSpacing = 0;
            CGFloat topSpacing = 0;
            CGFloat bottomSpacing = 0;

            [(TiViewProxy *)[self proxy] layoutProperties]->width = TiDimensionDip(tempSize.size.width);
            [(TiViewProxy *)[self proxy] layoutProperties]->height = TiDimensionDip(tempSize.size.height);

            id widthValue = [parent valueForKey:@"width"];
            id heightValue = [parent valueForKey:@"height"];

            TiDimension width = [TiUtils dimensionValue:widthValue];
            TiDimension height = [TiUtils dimensionValue:heightValue];
            if ([parent valueForKey:@"top"]) {
                id topValue = [parent valueForKey:@"top"];
                TiDimension top = [TiUtils dimensionValue:topValue];

                if (TiDimensionIsDip(top)) {
                    topSpacing = top.value;
                }
            }

            if ([parent valueForKey:@"bottom"]) {
                id bottomValue = [parent valueForKey:@"bottom"];
                TiDimension bottom = [TiUtils dimensionValue:bottomValue];

                if (TiDimensionIsDip(bottom)) {
                    bottomSpacing = bottom.value;
                }
            }


            if ([parent valueForKey:@"left"]) {
                id leftValue = [parent valueForKey:@"left"];
                TiDimension left = [TiUtils dimensionValue:leftValue];

                if (TiDimensionIsDip(left)) {
                    leftSpacing = left.value;
                }
            }

            if ([parent valueForKey:@"right"]) {
                id rightValue = [parent valueForKey:@"right"];
                TiDimension right = [TiUtils dimensionValue:rightValue];

                if (TiDimensionIsDip(right)) {
                    rightSpacing = right.value;
                }
            }

            [super frameSizeChanged:tempFrame bounds:tempSize];
            [TiUtils setView:label positionRect:tempSize];
            [parent refreshView:nil];

        }
        else {
            [super frameSizeChanged:tempFrame bounds:tempSize];
            [TiUtils setView:label positionRect:tempSize];
        }
    }
    else {
        [super frameSizeChanged:tempFrame bounds:tempSize];
        [TiUtils setView:label positionRect:tempSize];
    }
    #else
        [super frameSizeChanged:frame bounds:bounds];
        [TiUtils setView:label positionRect:tempSize];
    #endif
    
}

- (UILabel *)label
{
  if (label == nil) {
      label = [[UILabel alloc] initWithFrame:CGRectZero];
      label.numberOfLines = 0;

      id backgroundColor = [self.proxy valueForUndefinedKey:@"backgroundColor"];
      UIColor * backgroundColorValue = nil;

      if (backgroundColor != nil) {
          backgroundColorValue = [[TiUtils colorValue:backgroundColor] _color];
      }

      if (backgroundColorValue != nil) {
        label.backgroundColor = backgroundColorValue;
        label.opaque = YES;
        label.layer.masksToBounds = YES;
        self.opaque = YES;
        self.layer.masksToBounds = YES;
      }
      else {
        label.backgroundColor = [UIColor clearColor];
        label.opaque = YES;
        label.layer.masksToBounds = YES;
        self.opaque = YES;
        self.layer.masksToBounds = YES;
      }
      label.clipsToBounds = YES;
      self.clipsToBounds = YES;

      minFontSize = 0;
      CGFloat maxLines = 0;

      if ([[self proxy] valueForUndefinedKey:@"minimumFontSize"]){
          minFontSize = [TiUtils floatValue:[[self proxy] valueForKey:@"minimumFontSize"]];
      }
     
      
      if (minFontSize < 4) { // Beholden to 'most minimum' font size
        [label setAdjustsFontSizeToFitWidth:NO];
        [label setMinimumScaleFactor:0.0];
          if ([[self proxy] valueForUndefinedKey:@"maxLines"]){
              maxLines = [TiUtils floatValue:[[self proxy] valueForKey:@"maxLines"]];
          }
        [label setNumberOfLines:maxLines];
      }
      else {
        CGFloat ratio = minFontSize / label.font.pointSize;
          if ([[self proxy] valueForUndefinedKey:@"maxLines"]){
           maxLines = [TiUtils floatValue:[[self proxy] valueForKey:@"maxLines"]];
           [label setNumberOfLines:maxLines];
           [label setMinimumScaleFactor:ratio];
           [label setLineBreakMode:NSLineBreakByWordWrapping];
           [label sizeToFit];
        }
        else {
            [label setNumberOfLines:floor((minFontSize*0.5)/2)];
            [label setMinimumScaleFactor:0.75];
            [label setLineBreakMode:NSLineBreakByTruncatingTail];
        }
        [label setAdjustsFontSizeToFitWidth:YES];
      }

      [self addSubview:label];
  }

  return label;
}

- (BOOL)proxyHasGestureListeners
{
  return [super proxyHasGestureListeners] || [(TiViewProxy *)[self proxy] _hasListeners:@"link" checkParent:NO];
}

- (void)ensureGestureListeners
{
  if ([(TiViewProxy *)[self proxy] _hasListeners:@"link" checkParent:NO]) {
    [[self gestureRecognizerForEvent:@"singletap"] setEnabled:YES];
  }
  [super ensureGestureListeners];
}

- (void)handleListenerRemovedWithEvent:(NSString *)event
{
  ENSURE_UI_THREAD_1_ARG(event);
  // unfortunately on a remove, we have to check all of them
  // since we might be removing one but we still have others
  if ([event isEqualToString:@"link"] || [event isEqualToString:@"singletap"]) {
    BOOL enableListener = [self.proxy _hasListeners:@"singletap"] || [(TiViewProxy *)[self proxy] _hasListeners:@"link" checkParent:NO];
    [[self gestureRecognizerForEvent:@"singletap"] setEnabled:enableListener];
  } else {
    [super handleListenerRemovedWithEvent:event];
  }
}

// Code taken from https://github.com/AliSoftware/OHAttributedStringAdditions

- (NSTextContainer *)currentTextContainer
{
  NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:self.label.bounds.size];
  textContainer.lineFragmentPadding = 0;
  textContainer.maximumNumberOfLines = (NSUInteger)self.label.numberOfLines;
  textContainer.lineBreakMode = self.label.lineBreakMode;
  return textContainer;
}

- (NSUInteger)characterIndexAtPoint:(NSMutableAttributedString *)theString atPoint:(CGPoint)point
{
  NSTextContainer *textContainer = self.currentTextContainer;
  NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:theString];

  NSLayoutManager *layoutManager = [NSLayoutManager new];
  [textStorage addLayoutManager:layoutManager];
  [layoutManager addTextContainer:textContainer];

  // UILabel centers its text vertically, so adjust the point coordinates accordingly
  NSRange glyphRange = [layoutManager glyphRangeForTextContainer:textContainer];
  CGRect wholeTextRect = [layoutManager boundingRectForGlyphRange:glyphRange
                                                  inTextContainer:textContainer];
  point.y -= (CGRectGetHeight(self.bounds) - CGRectGetHeight(wholeTextRect)) / 2;

  // Bail early if point outside the whole text bounding rect
  if (!CGRectContainsPoint(wholeTextRect, point)) {
    return NSNotFound;
  }

  // ask the layoutManager which glyph is under this tapped point
  NSUInteger glyphIdx = [layoutManager glyphIndexForPoint:point
                                          inTextContainer:textContainer
                           fractionOfDistanceThroughGlyph:NULL];

  // as explained in Apple's documentation the previous method returns the nearest glyph
  // if no glyph was present at that point. So if we want to ensure the point actually
  // lies on that glyph, we should check that explicitly
  CGRect glyphRect = [layoutManager boundingRectForGlyphRange:NSMakeRange(glyphIdx, 1)
                                              inTextContainer:textContainer];
  if (CGRectContainsPoint(glyphRect, point)) {
    NSUInteger index = [layoutManager characterIndexForGlyphAtIndex:glyphIdx];
    return index;
  } else {
    return NSNotFound;
  }
}

- (BOOL)checkLinkAttributeForString:(NSMutableAttributedString *)theString atPoint:(CGPoint)p
{
  NSUInteger idx = [self characterIndexAtPoint:theString atPoint:p];

  if (idx == NSNotFound) {
    return NO;
  }

  NSRange theRange = NSMakeRange(0, 0);
  NSString *url = nil;
#ifdef USE_TI_UIATTRIBUTEDSTRING
  TiUIAttributedStringProxy *tempString = [[self proxy] valueForKey:@"attributedString"];
  url = [tempString getLink:idx];
#endif

  if (url == nil || url.length == 0) {
    return NO;
  }

  NSDictionary *eventDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                              url, @"url",
                                          [NSArray arrayWithObjects:NUMUINTEGER(theRange.location), NUMUINTEGER(theRange.length), nil], @"range",
                                          nil];
  [[self proxy] fireEvent:@"link" withObject:eventDict propagate:NO reportSuccess:NO errorCode:0 message:nil];
  return YES;
}

- (void)recognizedTap:(UITapGestureRecognizer *)recognizer
{
  BOOL testLink = (label != nil) && ([(TiViewProxy *)[self proxy] _hasListeners:@"link" checkParent:NO]);
  CGPoint tapPoint = [recognizer locationInView:self];
  NSDictionary *event = [TiUtils pointToDictionary:tapPoint];

  if ([recognizer numberOfTouchesRequired] == 2) {
    [self.proxy fireEvent:@"twofingertap" withObject:event];
  } else if ([recognizer numberOfTapsRequired] == 2) {
    //Because double-tap suppresses touchStart and double-click, we must do this:
    if ([self.proxy _hasListeners:@"touchstart"]) {
      [self.proxy fireEvent:@"touchstart" withObject:event propagate:YES];
    }
    if ([self.proxy _hasListeners:@"dblclick"]) {
      [self.proxy fireEvent:@"dblclick" withObject:event propagate:YES];
    }
    [self.proxy fireEvent:@"doubletap" withObject:event];
  } else {
    [self.proxy fireEvent:@"singletap" withObject:event];
    if (testLink) {
      NSMutableAttributedString *optimizedAttributedText = [label.attributedText mutableCopy];
      if (optimizedAttributedText != nil) {
        // use label's font and lineBreakMode properties in case the attributedText does not contain such attributes
        [label.attributedText enumerateAttributesInRange:NSMakeRange(0, [label.attributedText length])
                                                 options:0
                                              usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
                                                if (!attrs[(NSString *)kCTFontAttributeName]) {
                                                  [optimizedAttributedText addAttribute:(NSString *)kCTFontAttributeName value:label.font range:range];
                                                }
                                                if (!attrs[(NSString *)kCTParagraphStyleAttributeName]) {
                                                  NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                                                  [paragraphStyle setLineBreakMode:label.lineBreakMode];
                                                  [optimizedAttributedText addAttribute:(NSString *)kCTParagraphStyleAttributeName value:paragraphStyle range:range];
                                                }
                                              }];

        // modify kCTLineBreakByTruncatingTail lineBreakMode to kCTLineBreakByWordWrapping
        [optimizedAttributedText enumerateAttribute:(NSString *)kCTParagraphStyleAttributeName
                                            inRange:NSMakeRange(0, [optimizedAttributedText length])
                                            options:0
                                         usingBlock:^(id value, NSRange range, BOOL *stop) {
                                           NSMutableParagraphStyle *paragraphStyle = [value mutableCopy];
                                           if ([paragraphStyle lineBreakMode] == NSLineBreakByTruncatingTail) {
                                             [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
                                           }
                                           [optimizedAttributedText removeAttribute:(NSString *)kCTParagraphStyleAttributeName range:range];
                                           [optimizedAttributedText addAttribute:(NSString *)kCTParagraphStyleAttributeName value:paragraphStyle range:range];
                                         }];
        [self checkLinkAttributeForString:optimizedAttributedText atPoint:tapPoint];
      }
    }
  }
}

- (id)accessibilityElement
{
  return [self label];
}

- (void)setHighlighted:(BOOL)newValue
{
  [[self label] setHighlighted:newValue];
}

- (void)didMoveToSuperview
{
  /*
	 *	Because of how we re-use the same cells in both a tableview and its
	 *	search table, there is the chance that the label is transported between
	 *	the two views before a selected search row is deselected. In other
	 *	words, make sure we're not highlighted when changing superviews.
	 */
  [self setHighlighted:NO];
  [super didMoveToSuperview];
}

- (void)didMoveToWindow
{
  /*
     * See above
     */
  [self setHighlighted:NO];
  [super didMoveToWindow];
}

- (BOOL)isHighlighted
{
  return [[self label] isHighlighted];
}

#pragma mark Public APIs

- (void)setVerticalAlign_:(id)value
{
  verticalAlign = [self verticalAlignFromValue:value];
  if (verticalAlign < UIControlContentVerticalAlignmentCenter || verticalAlign > UIControlContentVerticalAlignmentBottom) {
    verticalAlign = UIControlContentVerticalAlignmentFill;
  }
  if (label != nil) {
    [self padLabel];
  }
}

- (void)setMaxLines_:(id)value
{
  ENSURE_TYPE(value, NSNumber);
  [[self label] setNumberOfLines:[TiUtils floatValue:value]];
  [self padLabel];
  [(TiViewProxy *)[self proxy] contentsWillChange];
}

- (void)setText_:(id)text
{
  [[self label] setText:[TiUtils stringValue:text]];
  [self padLabel];
  [(TiViewProxy *)[self proxy] contentsWillChange];
}

- (void)setColor_:(id)color
{
  UIColor *newColor = [[TiUtils colorValue:color] _color];
  [[self label] setTextColor:(newColor != nil) ? newColor : [UIColor darkTextColor]];
}

- (void)setEllipsize_:(id)value
{
  ENSURE_SINGLE_ARG(value, NSNumber);
  if ([[TiUtils stringValue:value] isEqualToString:@"true"]) {
    [[self label] setLineBreakMode:NSLineBreakByTruncatingTail];
    return;
  }
  [[self label] setLineBreakMode:[TiUtils intValue:value]];
}

- (void)setHighlightedColor_:(id)color
{
  UIColor *newColor = [[TiUtils colorValue:color] _color];
  [[self label] setHighlightedTextColor:(newColor != nil) ? newColor : [UIColor lightTextColor]];
}

- (void)setFont_:(id)font
{
  [[self label] setFont:[[TiUtils fontValue:font] font]];
  if (minFontSize > 4) {
    CGFloat ratio = minFontSize / label.font.pointSize;
    [label setMinimumScaleFactor:ratio];
  }
  [self padLabel];
  [(TiViewProxy *)[self proxy] contentsWillChange];
}

- (void)setMinimumFontSize_:(id)size
{
  minFontSize = [TiUtils floatValue:size];
  if (minFontSize < 4) { // Beholden to 'most minimum' font size
    [[self label] setAdjustsFontSizeToFitWidth:NO];
    [label setMinimumScaleFactor:0.0];
    [label setNumberOfLines:0];
  } else {
    [[self label] setNumberOfLines:1];
    [label setAdjustsFontSizeToFitWidth:YES];
    CGFloat ratio = minFontSize / label.font.pointSize;
    [label setMinimumScaleFactor:ratio];
    [label setBaselineAdjustment:UIBaselineAdjustmentNone];
  }
}

- (void)updateBackgroundImageFrameWithPadding
{
  CGRect backgroundFrame = CGRectMake(self.bounds.origin.x - padding.origin.x,
      self.bounds.origin.y - padding.origin.y,
      self.bounds.size.width + padding.origin.x + padding.size.width,
      self.bounds.size.height + padding.origin.y + padding.size.height);
  [self backgroundImageLayer].frame = backgroundFrame;
}

- (void)setAttributedString_:(id)arg
{
    
#ifdef USE_TI_UIATTRIBUTEDSTRING
  ENSURE_SINGLE_ARG(arg, TiUIAttributedStringProxy);
  [[self proxy] replaceValue:arg forKey:@"attributedString" notification:NO];
  [[self label] setAttributedText:[arg attributedString]];
  
    id backgroundColor = [self.proxy valueForUndefinedKey:@"backgroundColor"];
    UIColor * backgroundColorValue = nil;
    if (backgroundColor != nil) {
        UIColor * backgroundColorValue = [[TiUtils colorValue:backgroundColor] _color];
    }
    if (backgroundColorValue != nil) {
        [self label].backgroundColor = backgroundColorValue;
        self.backgroundColor = backgroundColorValue;
        super.backgroundColor = backgroundColorValue;
    }
    self.opaque = YES;

    [self label].opaque = YES;
    super.opaque = YES;
   
  [self padLabel];
  [(TiViewProxy *)[self proxy] contentsWillChange];
  
#endif
}
-(void)setBackgroundColor_:(id)color
{
    if ([color isKindOfClass:[UIColor class]])
    {
        [self label].backgroundColor = color;
        super.backgroundColor = color;
        [self label].opaque = YES;
        super.opaque = YES;
    }
    else
    {
        //TiColor *ticolor = [TiUtils colorValue:color];
        UIColor * aColor =[[TiUtils colorValue:color] _color];

        [self label].backgroundColor = aColor;
        super.backgroundColor = aColor;

        [self label].opaque = YES;
        super.opaque = YES;
    }
}

- (void)setBackgroundPaddingLeft_:(id)left
{
  padding.origin.x = [TiUtils floatValue:left];
  [self updateBackgroundImageFrameWithPadding];
}

- (void)setBackgroundPaddingRight_:(id)right
{
  padding.size.width = [TiUtils floatValue:right];
  [self updateBackgroundImageFrameWithPadding];
}

- (void)setBackgroundPaddingTop_:(id)top
{
  padding.origin.y = [TiUtils floatValue:top];
  [self updateBackgroundImageFrameWithPadding];
}

- (void)setBackgroundPaddingBottom_:(id)bottom
{
  padding.size.height = [TiUtils floatValue:bottom];
  [self updateBackgroundImageFrameWithPadding];
}

- (void)setTextAlign_:(id)alignment
{
  [[self label] setTextAlignment:[TiUtils textAlignmentValue:alignment]];
  [self padLabel];
}

- (void)setShadowColor_:(id)color
{
  if (color == nil) {
    [[self label] setShadowColor:nil];
  } else {
    color = [TiUtils colorValue:color];
    [[self label] setShadowColor:[color _color]];
  }
}

- (void)setShadowOffset_:(id)value
{
  CGPoint p = [TiUtils pointValue:value];
  CGSize size = { p.x, p.y };
  [[self label] setShadowOffset:size];
}

- (UIControlContentVerticalAlignment)verticalAlignFromValue:(id)value
{
  if ([value isKindOfClass:[NSNumber class]]) {
    return [TiUtils intValue:value def:UIControlContentVerticalAlignmentFill];
  } else if ([value isKindOfClass:[NSString class]]) {
    if ([value isEqualToString:@"top"]) {
      return UIControlContentVerticalAlignmentTop;
    } else if ([value isEqualToString:@"bottom"]) {
      return UIControlContentVerticalAlignmentBottom;
    } else if ([value isEqualToString:@"center"]) {
      return UIControlContentVerticalAlignmentCenter;
    }
  }

  return UIControlContentVerticalAlignmentFill;
}

@end
