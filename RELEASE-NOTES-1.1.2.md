# Release Notes — ti.labelextension v1.1.2

**Date:** 2026-01-07
**Platform:** iOS (iPhone, iPad, Mac Catalyst)
**Min SDK:** 13.2.0
**Architectures:** arm64, x86_64

---

## Overview

Version 1.1.2 brings significant performance improvements, bug fixes, and full SDK parity to the high-performance UILabel extension for Titanium iOS. This release fixes a critical measurement cache bug, optimizes TextKit object reuse, adds support for dictionary-based AttributedString input (SDK 14+), and includes comprehensive documentation.

---

## What's New

### 🚀 Performance Optimizations

#### TextKit Stack Recycling
The NSLayoutManager, NSTextContainer, and NSTextStorage objects are now **reused** instead of being reallocated on every frame change or tap event. This significantly reduces memory allocations, especially in scrolling scenarios (ListView, TableView, ScrollView).

**Before:** Every frame change → new NSLayoutManager + new NSTextContainer
**After:** Existing objects are updated in-place; allocation only on first use

#### Optimized Attributed String Hit-Testing
The `recognizedTap` method no longer creates an unnecessary `mutableCopy` for empty labels. This saves allocation overhead on labels without attributed text.

#### Measurement Cache with Proper CGSize Storage
The measurement cache now correctly stores the full `CGSize` (width **and** height) via `NSValue`. This fixes a bug where only the width was cached, resulting in a height of `0` on cache hits.

---

## Bug Fixes

| Issue | Fix |
|-------|-----|
| **Measurement cache lost height value** | Changed from `NSNumber` (width only) to `NSValue` (full CGSize) — height is now correctly preserved on cache hits |
| **Duplicate cache initialization** | Removed redundant `measurementCache` allocation in `-[label]`; lazy initialization in getter is sufficient |
| **needsParentRefresh flag never reset** | Flag is now reset to `NO` after parent refresh completes — prevents stale state in subsequent layout passes |

---

## API Changes

### AttributedString: Dictionary Input Support (SDK 14+)

The `attributedString` property now accepts a plain dictionary in addition to `Ti.UI.AttributedString` objects, matching the latest Titanium SDK behavior:

```javascript
// Both now work:
Ti.UI.createLabel({
    attributedString: {
        text: 'Hello World',
        attributes: [{
            type: Ti.UI.ATTRIBUTE_FOREGROUND_COLOR,
            value: '#e74c3c',
            range: [0, 5]
        }]
    }
});

Ti.UI.createLabel({
    attributedString: Ti.UI.createAttributedString({
        text: 'Hello World',
        attributes: [{
            type: Ti.UI.ATTRIBUTE_FOREGROUND_COLOR,
            value: '#e74c3c',
            range: [0, 5]
        }]
    })
});
```

---

## Module-Specific Properties

| Property | Type | Description |
|----------|------|-------------|
| `calcRealSize` | `BOOL` | Render the label to its actual text size (default: `false`) |

> All standard `Ti.UI.Label` properties are supported. See the [README](README.md) for a complete reference.

---

## Caching Strategy

| Cache | Type | Capacity | Invalidated On |
|-------|------|----------|----------------|
| **Measurement** | `NSCache<NSString*, NSValue*>` | 100 entries | `text` or `font` change |
| **TextKit Stack** | NSLayoutManager, NSTextContainer, NSTextStorage | Per label | Frame change, text change |
| **Frame** | `CGRect` | Per label | Frame comparison via `CGRectEqualToRect` |
| **Text Hash** | `NSNumber` | Per label | Text content change |

---

## Architecture

This module uses **Objective-C categories** to extend the Titanium SDK's `TiUILabel` and `TiUILabelProxy` classes:

- **Drop-in replacement** — no JavaScript code changes required
- **Full API compatibility** — every standard label property works
- **Safe upgrade path** — category adapts to SDK changes automatically

### Key Techniques

1. **Opaque rendering** — `opaque = YES` + `masksToBounds = YES` eliminates GPU blended layers
2. **Center rounding** — `setCenter` floors to even integers, preventing sub-pixel blur
3. **Single-pass attribute optimization** — font and paragraphStyle merged in one enumeration pass
4. **TextKit recycling** — layout objects reused across taps instead of reallocating

---

## Performance Comparison

| Feature | Titanium SDK | ti.labelextension |
|---------|-------------|-------------------|
| Blended layers | Yes | **No** (opaque rendering) |
| Measurement caching | None | **NSCache** (100 entries) |
| TextKit allocation | New per tap | **Cached & recycled** |
| `calcRealSize` | No | **Yes** |
| minimumFontSize search | Linear O(n) | **Binary search O(log n)** |
| AttributedString from dict | SDK 14+ | **Yes** (fromProperties) |

---

## Upgrade Notes

### From v1.1.1

- **Breaking changes:** None
- **API additions:** Dictionary input for `attributedString` (backward compatible)
- **Behavior changes:** Measurement cache now correctly preserves height values (may affect edge cases where width-only caching masked layout issues)

### Migration

Simply update the module version in `tiapp.xml`:

```xml
<modules>
    <module version="1.1.2">ti.labelextension</module>
</modules>
```

No code changes required in your app.

---

## Changelog

### v1.1.2 (2026-01-07)
- 🐛 Fix measurement cache: store CGSize via NSValue instead of NSNumber (height was lost)
- 🚀 Recycle TextKit stack (NSLayoutManager, NSTextContainer) instead of reallocating
- 🚀 Optimize recognizedTap: skip empty label mutableCopy
- ✨ Add `fromProperties` for AttributedString (SDK parity, allows dict input)
- 🐛 Reset needsParentRefresh flag after parent refresh completes
- 🗑️ Remove duplicate measurementCache initialization
- 📝 Comprehensive README with all properties, examples, and architecture

### v1.1.1 (2025)
- 🚀 Binary search for minimumFontSize (O(log n) instead of O(n))
- 🚀 Single-pass enumerateAttributes optimization
- 🧹 Clean label initialization (no blended layers from the start)

### v1.1.0 (2022)
- ✨ Initial release with blended layer elimination
- ✨ calcRealSize property
- ✨ Measurement caching with NSCache

---

## Known Issues

None at this time.

---

## Credits

**Author:** Marc Bender
**License:** Apache Public License 2.0
**Repository:** [github.com/mbender74/ti.labelextension-ios](https://github.com/mbender74/ti.labelextension-ios)

---

## Support

For issues, questions, or contributions, please open an issue on the GitHub repository.
