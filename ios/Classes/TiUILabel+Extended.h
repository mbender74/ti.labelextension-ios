/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2014 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#define USE_TI_UILABEL
#define USE_TI_UIATTRIBUTEDSTRING

#import "TiUILabelProxy+Extended.h"

#import <CoreText/CoreText.h>
#import <TitaniumKit/TiUtils.h>
#import <TitaniumKit/UIImage+Resize.h>
#import <TitaniumKit/TiUIView.h>

@interface TiUILabel (Extended)

// Performance caches (backing ivars declared in implementation)
@property (nonatomic, strong) NSCache<NSString *, NSNumber *> *measurementCache;
@property (nonatomic, strong) NSLayoutManager *cachedLayoutManager;
@property (nonatomic, strong) NSTextContainer *cachedTextContainer;
@property (nonatomic, strong) NSTextStorage *cachedTextStorage;
@property (nonatomic, assign) CGRect cachedLabelFrame;
@property (nonatomic, strong) NSNumber *cachedTextHash;
@property (nonatomic, assign) BOOL needsParentRefresh;

@end

// Extension to declare backing ivars
@interface TiUILabel ()
@end
