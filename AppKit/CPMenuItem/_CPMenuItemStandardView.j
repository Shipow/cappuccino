/*
 * _CPMenuItemStandardView.j
 * AppKit
 *
 * Created by Francisco Tolmasky.
 * Copyright 2009, 280 North, Inc.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
 */

@import "CPControl.j"
@import "CPImageView.j"
@import "_CPImageAndTextView.j"

@implementation _CPMenuItemStandardView : CPView
{
    CPMenuItem              _menuItem @accessors(property=menuItem);

    CPFont                  _font;
    CPColor                 _textColor;
    CPColor                 _textShadowColor;

    CGSize                  _minSize @accessors(readonly, property=minSize);
    BOOL                    _isDirty;

    CPImageView             _stateView;
    _CPImageAndTextView     _imageAndTextView;
    _CPImageAndTextView     _keyEquivalentView;
    CPView                  _submenuIndicatorView;
}

+ (CPString)defaultThemeClass
{
    return "menu-item-standard-view";
}

+ (id)themeAttributes
{
    return [CPDictionary dictionaryWithObjects:[[CPNull null], [CPNull null], [CPNull null], [CPNull null], [CPNull null], [CPNull null], [CPNull null], [CPNull null], [CPNull null], 3.0, 17.0, 14.0, 17.0, 4.0, 30.0]
                                       forKeys:[    @"submenu-indicator-color",
                                                    @"menu-item-selection-color",
                                                    @"menu-item-text-shadow-color",
                                                    @"menu-item-default-off-state-image",
                                                    @"menu-item-default-off-state-highlighted-image",
                                                    @"menu-item-default-on-state-image",
                                                    @"menu-item-default-on-state-highlighted-image",
                                                    @"menu-item-default-mixed-state-image",
                                                    @"menu-item-default-mixed-state-highlighted-image",
                                                    @"left-margin",
                                                    @"right-margin",
                                                    @"state-column-width",
                                                    @"indentation-width",
                                                    @"vertical-margin",
                                                    @"right-columns-margin"]];
}

+ (id)view
{
    return [[self alloc] init];
}

+ (float)_standardLeftMargin
{
    return [[CPTheme defaultTheme] valueForAttributeWithName:@"left-margin" forClass:[self class]] + [[CPTheme defaultTheme] valueForAttributeWithName:@"state-column-width" forClass:[self class]];
}

- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];

    if (self)
    {
        _stateView = [[CPImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0)];

        [_stateView setImageScaling:CPImageScaleNone];

        [self addSubview:_stateView];

        _imageAndTextView = [[_CPImageAndTextView alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0)];

        [_imageAndTextView setImagePosition:CPImageLeft];
        [_imageAndTextView setTextShadowOffset:CGSizeMake(0.0, 1.0)];

        [self addSubview:_imageAndTextView];

        _keyEquivalentView = [[_CPImageAndTextView alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0)];

        [_keyEquivalentView setImagePosition:CPNoImage];
        [_keyEquivalentView setTextShadowOffset:CGSizeMake(0.0, 1.0)];
        [_keyEquivalentView setAutoresizingMask:CPViewMinXMargin];

        [self addSubview:_keyEquivalentView];

        _submenuIndicatorView = [[_CPMenuItemSubmenuIndicatorView alloc] initWithFrame:CGRectMake(0.0, 0.0, 8.0, 10.0)];

        [_submenuIndicatorView setColor:[self valueForThemeAttribute:@"submenu-indicator-color"]];
        [_submenuIndicatorView setAutoresizingMask:CPViewMinXMargin];

        [self addSubview:_submenuIndicatorView];

        [self setAutoresizingMask:CPViewWidthSizable];
    }

    return self;
}

- (CPColor)textColor
{
    if (![_menuItem isEnabled])
        return [CPColor lightGrayColor];

    return _textColor || [CPColor colorWithCalibratedRed:70.0 / 255.0 green:69.0 / 255.0 blue:69.0 / 255.0 alpha:1.0];
}

- (CPColor)textShadowColor
{
    if (![_menuItem isEnabled])
        return nil;

    return _textShadowColor || [CPColor colorWithWhite:1.0 alpha:0.8];
}

- (void)setFont:(CPFont)aFont
{
    _font = aFont;
}

- (void)update
{
    var x = [self valueForThemeAttribute:@"left-margin"] + [_menuItem indentationLevel] * [self valueForThemeAttribute:@"indentation-width"],
        height = 0.0,
        hasStateColumn = [[_menuItem menu] showsStateColumn];

    if (hasStateColumn)
    {
        [_stateView setHidden:NO];
        //[_stateView setImage:_CPMenuItemDefaultStateImages[[_menuItem state]] || nil];

        switch ([_menuItem state])
        {
            case CPOnState:
                [_stateView setImage:[self valueForThemeAttribute:@"menu-item-default-on-state-image"]];
                break;

            case CPOffState:
                [_stateView setImage:[self valueForThemeAttribute:@"menu-item-default-off-state-image"]];
                break;

            case CPMixedState:
                [_stateView setImage:[self valueForThemeAttribute:@"menu-item-default-mixed-state-image"]];
                break;

            default:
                break;
        }

        x += [self valueForThemeAttribute:@"state-column-width"];
    }
    else
        [_stateView setHidden:YES];

    [_imageAndTextView setFont:[_menuItem font] || _font];
    [_imageAndTextView setVerticalAlignment:CPCenterVerticalTextAlignment];
    [_imageAndTextView setImage:[_menuItem image]];
    [_imageAndTextView setText:[_menuItem title]];
    [_imageAndTextView setTextColor:[self textColor]];
    [_imageAndTextView setTextShadowColor:[self textShadowColor]];
    [_imageAndTextView setTextShadowOffset:CGSizeMake(0.0, 1.0)];
    [_imageAndTextView sizeToFit];

    var imageAndTextViewFrame = [_imageAndTextView frame];

    imageAndTextViewFrame.origin.x = x;
    x += CGRectGetWidth(imageAndTextViewFrame);
    height = MAX(height, CGRectGetHeight(imageAndTextViewFrame));

    var hasKeyEquivalent = !![_menuItem keyEquivalent],
        hasSubmenu = [_menuItem hasSubmenu];

    if (hasKeyEquivalent || hasSubmenu)
        x += [self valueForThemeAttribute:@"right-columns-margin"];

    if (hasKeyEquivalent)
    {
        [_keyEquivalentView setFont:[_menuItem font] || _font];
        [_keyEquivalentView setVerticalAlignment:CPCenterVerticalTextAlignment];
        [_keyEquivalentView setImage:[_menuItem image]];
        [_keyEquivalentView setText:[_menuItem keyEquivalentStringRepresentation]];
        [_keyEquivalentView setTextColor:[self textColor]];
        [_keyEquivalentView setTextShadowColor:[self textShadowColor]];
        [_keyEquivalentView setTextShadowOffset:CGSizeMake(0, 1)];
        [_keyEquivalentView setFrameOrigin:CGPointMake(x, [self valueForThemeAttribute:@"vertical-margin"])];
        [_keyEquivalentView sizeToFit];

        var keyEquivalentViewFrame = [_keyEquivalentView frame];

        keyEquivalentViewFrame.origin.x = x;
        x += CGRectGetWidth(keyEquivalentViewFrame);
        height = MAX(height, CGRectGetHeight(keyEquivalentViewFrame));

        if (hasSubmenu)
            x += [self valueForThemeAttribute:@"right-columns-margin"];
    }
    else
        [_keyEquivalentView setHidden:YES];

    if (hasSubmenu)
    {
        [_submenuIndicatorView setHidden:NO];

        var submenuViewFrame = [_submenuIndicatorView frame];

        submenuViewFrame.origin.x = x;

        x += CGRectGetWidth(submenuViewFrame);
        height = MAX(height, CGRectGetHeight(submenuViewFrame));
    }
    else
        [_submenuIndicatorView setHidden:YES];

    height += 2.0 * [self valueForThemeAttribute:@"vertical-margin"];

    imageAndTextViewFrame.origin.y = FLOOR((height - CGRectGetHeight(imageAndTextViewFrame)) / 2.0);
    [_imageAndTextView setFrame:imageAndTextViewFrame];

    if (hasStateColumn)
        [_stateView setFrameSize:CGSizeMake([self valueForThemeAttribute:@"state-column-width"], height)];

    if (hasKeyEquivalent)
    {
        keyEquivalentViewFrame.origin.y = FLOOR((height - CGRectGetHeight(keyEquivalentViewFrame)) / 2.0);
        [_keyEquivalentView setFrame:keyEquivalentViewFrame];
    }

    if (hasSubmenu)
    {
        submenuViewFrame.origin.y = FLOOR((height - CGRectGetHeight(submenuViewFrame)) / 2.0);
        [_submenuIndicatorView setFrame:submenuViewFrame];
    }

    _minSize = CGSizeMake(x + [self valueForThemeAttribute:@"right-margin"], height);

    [self setAutoresizesSubviews:NO];
    [self setFrameSize:_minSize];
    [self setAutoresizesSubviews:YES];
}

- (void)highlight:(BOOL)shouldHighlight
{
    // FIXME: This should probably be even throw.
    if (![_menuItem isEnabled])
        return;

    if (shouldHighlight)
    {
        [self setBackgroundColor:[self valueForThemeAttribute:@"menu-item-selection-color"]];

        [_imageAndTextView setImage:[_menuItem alternateImage] || [_menuItem image]];
        [_imageAndTextView setTextColor:[CPColor whiteColor]];
        [_keyEquivalentView setTextColor:[CPColor whiteColor]];
        [_submenuIndicatorView setColor:[CPColor whiteColor]];

        [_imageAndTextView setTextShadowColor:[self valueForThemeAttribute:@"menu-item-text-shadow-color"]];
        [_keyEquivalentView setTextShadowColor:[self valueForThemeAttribute:@"menu-item-text-shadow-color"]];
    }
    else
    {
        [self setBackgroundColor:nil];

        [_imageAndTextView setImage:[_menuItem image]];
        [_imageAndTextView setTextColor:[self textColor]];
        [_keyEquivalentView setTextColor:[self textColor]];
        [_submenuIndicatorView setColor:[self valueForThemeAttribute:@"submenu-indicator-color"]];

        [_imageAndTextView setTextShadowColor:[self textShadowColor]];
        [_keyEquivalentView setTextShadowColor:[self textShadowColor]];
    }

    if ([[_menuItem menu] showsStateColumn])
    {
        if (shouldHighlight)
        {
            switch ([_menuItem state])
            {
                case CPOnState:
                    [_stateView setImage:[self valueForThemeAttribute:@"menu-item-default-on-state-highlighted-image"]];
                    break;

                case CPOffState:
                    [_stateView setImage:[self valueForThemeAttribute:@"menu-item-default-off-state-highlighted-image"]];
                    break;

                case CPMixedState:
                    [_stateView setImage:[self valueForThemeAttribute:@"menu-item-default-mixed-state-highlighted-image"]];
                    break;

                default:
                    break;
            }
        }
        else
        {
            switch ([_menuItem state])
            {
                case CPOnState:
                    [_stateView setImage:[self valueForThemeAttribute:@"menu-item-default-on-state-image"]];
                    break;

                case CPOffState:
                    [_stateView setImage:[self valueForThemeAttribute:@"menu-item-default-off-state-image"]];
                    break;

                case CPMixedState:
                    [_stateView setImage:[self valueForThemeAttribute:@"menu-item-default-mixed-state-image"]];
                    break;

                default:
                    break;
            }
        }
    }
}

@end

@implementation _CPMenuItemSubmenuIndicatorView : CPView
{
    CPColor _color;
}

- (void)setColor:(CPColor)aColor
{
    if (_color === aColor)
        return;

    _color = aColor;

    [self setNeedsDisplay:YES];
}

- (void)drawRect:(CGRect)aRect
{
    var context = [[CPGraphicsContext currentContext] graphicsPort],
        bounds = [self bounds];

    CGContextBeginPath(context);

    CGContextMoveToPoint(context, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
    CGContextAddLineToPoint(context, CGRectGetMaxX(bounds), CGRectGetMidY(bounds));
    CGContextAddLineToPoint(context, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));

    CGContextClosePath(context);

    CGContextSetFillColor(context, _color);
    CGContextFillPath(context);
}

@end
