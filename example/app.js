/**
 * ti.labelextension - Comprehensive Example App
 *
 * Demonstrates all features of the high-performance UILabel extension:
 * - Basic labels with various properties
 * - calcRealSize for dynamic sizing
 * - Attributed strings with link detection
 * - Performance in ListView/ScrollView
 * - Shadow effects, minimumFontSize, ellipsize
 * - Background colors and images
 */

var win = Ti.UI.createWindow({
    title: 'ti.labelextension Demo',
    backgroundColor: '#f5f5f5'
});

var currentView = 0;
var views = [];

// ============================================================
// VIEW 1: Basic Label Properties
// ============================================================
function createBasicLabelsView() {
    var scrollView = Ti.UI.createScrollView({
        backgroundColor: '#f5f5f5',
        contentWidth: Ti.UI.FILL,
        contentHeight: Ti.UI.SIZE
    });

    var container = Ti.UI.createView({
        layout: 'vertical',
        backgroundColor: '#f5f5f5',
        top: 10,
        bottom: 10,
        left: 10,
        right: 10
    });

    // Section header
    var header = Ti.UI.createLabel({
        text: 'Basic Labels',
        font: { fontSize: 28, fontWeight: 'bold' },
        color: '#333',
        textAlign: Ti.UI.TEXT_ALIGNMENT_CENTER,
        top: 10,
        width: Ti.UI.FILL
    });
    container.add(header);

    // Simple text label
    var simple = Ti.UI.createLabel({
        text: 'Simple Label',
        font: { fontSize: 18 },
        color: '#666',
        top: 10,
        width: Ti.UI.FILL
    });
    container.add(simple);

    // Bold text
    var bold = Ti.UI.createLabel({
        text: 'Bold Text (fontSize: 32)',
        font: { fontSize: 32, fontWeight: 'bold' },
        color: '#2c3e50',
        top: 15
    });
    container.add(bold);

    // Colored text
    var colored = Ti.UI.createLabel({
        text: 'Colored Text (red)',
        font: { fontSize: 20 },
        color: '#e74c3c',
        top: 15
    });
    container.add(colored);

    // Center aligned
    var centered = Ti.UI.createLabel({
        text: 'Centered Text',
        font: { fontSize: 18 },
        color: '#333',
        textAlign: Ti.UI.TEXT_ALIGNMENT_CENTER,
        top: 15,
        width: Ti.UI.FILL,
        height: 40,
        backgroundColor: '#ecf0f1'
    });
    container.add(centered);

    // Right aligned
    var rightAligned = Ti.UI.createLabel({
        text: 'Right Aligned',
        font: { fontSize: 18 },
        color: '#333',
        textAlign: Ti.UI.TEXT_ALIGNMENT_RIGHT,
        top: 15,
        width: Ti.UI.FILL,
        height: 40,
        backgroundColor: '#ecf0f1'
    });
    container.add(rightAligned);

    // Label with shadow
    var shadowLabel = Ti.UI.createLabel({
        text: 'Shadow Effect',
        font: { fontSize: 24, fontWeight: 'bold' },
        color: '#fff',
        shadowColor: '#000',
        shadowOffset: { x: 2, y: 2 },
        top: 15,
        height: 50,
        backgroundColor: '#3498db'
    });
    container.add(shadowLabel);

    // Vertical alignment examples
    var sectionHeader = Ti.UI.createLabel({
        text: 'Vertical Alignment',
        font: { fontSize: 20, fontWeight: 'bold' },
        color: '#333',
        top: 20
    });
    container.add(sectionHeader);

    var topAlign = Ti.UI.createLabel({
        text: 'Vertical Align: TOP',
        font: { fontSize: 14 },
        color: '#333',
        verticalAlign: 'top',
        top: 5,
        width: Ti.UI.FILL,
        height: 60,
        backgroundColor: '#fff3cd'
    });
    container.add(topAlign);

    var centerAlign = Ti.UI.createLabel({
        text: 'Vertical Align: CENTER',
        font: { fontSize: 14 },
        color: '#333',
        verticalAlign: 'center',
        top: 5,
        width: Ti.UI.FILL,
        height: 60,
        backgroundColor: '#d4edda'
    });
    container.add(centerAlign);

    var bottomAlign = Ti.UI.createLabel({
        text: 'Vertical Align: BOTTOM',
        font: { fontSize: 14 },
        color: '#333',
        verticalAlign: 'bottom',
        top: 5,
        width: Ti.UI.FILL,
        height: 60,
        backgroundColor: '#cce5ff'
    });
    container.add(bottomAlign);

    scrollView.add(container);
    return scrollView;
}

// ============================================================
// VIEW 2: calcRealSize Demonstration
// ============================================================
function createCalcRealSizeView() {
    var scrollView = Ti.UI.createScrollView({
        backgroundColor: '#f5f5f5',
        contentWidth: Ti.UI.FILL,
        contentHeight: Ti.UI.SIZE
    });

    var container = Ti.UI.createView({
        layout: 'vertical',
        backgroundColor: '#f5f5f5',
        top: 10,
        bottom: 10,
        left: 10,
        right: 10
    });

    var header = Ti.UI.createLabel({
        text: 'calcRealSize Demo',
        font: { fontSize: 28, fontWeight: 'bold' },
        color: '#333',
        textAlign: Ti.UI.TEXT_ALIGNMENT_CENTER,
        top: 10,
        width: Ti.UI.FILL
    });
    container.add(header);

    var description = Ti.UI.createLabel({
        text: 'calcRealSize renders the label to its actual text size instead of the container frame',
        font: { fontSize: 14 },
        color: '#666',
        textAlign: Ti.UI.TEXT_ALIGNMENT_CENTER,
        top: 10,
        width: Ti.UI.FILL
    });
    container.add(description);

    // Without calcRealSize (false) - takes parent container width
    var withoutRealSize = Ti.UI.createLabel({
        text: 'Short',
        font: { fontSize: 24 },
        color: '#333',
        calcRealSize: false,
        top: 20,
        width: 200,
        height: 40,
        backgroundColor: '#ffcccc',
        borderColor: '#ff6666',
        borderWidth: 1
    });
    container.add(withoutRealSize);

    // With calcRealSize (true) - shrinks to text size
    var withRealSize = Ti.UI.createLabel({
        text: 'Short',
        font: { fontSize: 24 },
        color: '#333',
        calcRealSize: true,
        top: 10,
        width: Ti.UI.SIZE,
        height: Ti.UI.SIZE,
        backgroundColor: '#ccffcc',
        borderColor: '#66cc66',
        borderWidth: 1
    });
    container.add(withRealSize);

    // Longer text
    var longText = Ti.UI.createLabel({
        text: 'This is longer text',
        font: { fontSize: 24 },
        color: '#333',
        calcRealSize: true,
        top: 10,
        width: Ti.UI.SIZE,
        height: Ti.UI.SIZE,
        backgroundColor: '#ccffcc',
        borderColor: '#66cc66',
        borderWidth: 1
    });
    container.add(longText);

    var note = Ti.UI.createLabel({
        text: 'Note: calcRealSize works best with width: Ti.UI.SIZE and height: Ti.UI.SIZE',
        font: { fontSize: 12, fontStyle: 'italic' },
        color: '#999',
        top: 20,
        width: Ti.UI.FILL
    });
    container.add(note);

    scrollView.add(container);
    return scrollView;
}

// ============================================================
// VIEW 3: Attributed String with Link Detection
// ============================================================
function createAttributedStringView() {
    var scrollView = Ti.UI.createScrollView({
        backgroundColor: '#f5f5f5',
        contentWidth: Ti.UI.FILL,
        contentHeight: Ti.UI.SIZE
    });

    var container = Ti.UI.createView({
        layout: 'vertical',
        backgroundColor: '#f5f5f5',
        top: 10,
        bottom: 10,
        left: 10,
        right: 10
    });

    var header = Ti.UI.createLabel({
        text: 'AttributedString + Links',
        font: { fontSize: 28, fontWeight: 'bold' },
        color: '#333',
        textAlign: Ti.UI.TEXT_ALIGNMENT_CENTER,
        top: 10,
        width: Ti.UI.FILL
    });
    container.add(header);

    // Simple attributed string with color
    var coloredText = Ti.UI.createLabel({
        text: 'Red text, blue text, and bold',
        font: { fontSize: 18 },
        color: '#333',
        top: 20,
        width: Ti.UI.FILL
    });
    container.add(coloredText);

    // Attributed string with link
    var linkLabel = Ti.UI.createLabel({
        attributedString: {
            text: 'Tap here to visit Titanium',
            attributes: [{
                type: Ti.UI.ATTRIBUTE_LINK,
                value: 'https://appcelerator.com',
                range: [0, 31]
            }]
        },
        font: { fontSize: 18 },
        top: 20,
        width: Ti.UI.FILL,
        height: 40
    });

    linkLabel.addEventListener('link', function(e) {
        Ti.API.info('Link tapped: ' + e.url);
        Ti.API.info('Range: [' + e.range[0] + ', ' + e.range[1] + ']');
        alert('Link tapped: ' + e.url);
    });

    container.add(linkLabel);

    // Rich attributed string
    var richLabel = Ti.UI.createLabel({
        attributedString: {
            text: 'Bold and Colored Text',
            attributes: [
                {
                    type: Ti.UI.ATTRIBUTE_FONT,
                    value: { fontSize: 24, fontWeight: 'bold' },
                    range: [0, 4]  // "Bold"
                },
                {
                    type: Ti.UI.ATTRIBUTE_FOREGROUND_COLOR,
                    value: '#e74c3c',
                    range: [9, 7]  // "Colored"
                }
            ]
        },
        font: { fontSize: 18 },
        top: 20,
        width: Ti.UI.FILL,
        height: 50
    });
    container.add(richLabel);

    var note = Ti.UI.createLabel({
        text: 'Link events fire with { url, range } when tapped',
        font: { fontSize: 12, fontStyle: 'italic' },
        color: '#999',
        top: 15,
        width: Ti.UI.FILL
    });
    container.add(note);

    scrollView.add(container);
    return scrollView;
}

// ============================================================
// VIEW 4: minimumFontSize & Ellipsize
// ============================================================
function createFontSizeView() {
    var scrollView = Ti.UI.createScrollView({
        backgroundColor: '#f5f5f5',
        contentWidth: Ti.UI.FILL,
        contentHeight: Ti.UI.SIZE
    });

    var container = Ti.UI.createView({
        layout: 'vertical',
        backgroundColor: '#f5f5f5',
        top: 10,
        bottom: 10,
        left: 10,
        right: 10
    });

    var header = Ti.UI.createLabel({
        text: 'minimumFontSize & Ellipsize',
        font: { fontSize: 28, fontWeight: 'bold' },
        color: '#333',
        textAlign: Ti.UI.TEXT_ALIGNMENT_CENTER,
        top: 10,
        width: Ti.UI.FILL
    });
    container.add(header);

    // Normal font size
    var normal = Ti.UI.createLabel({
        text: 'Normal (fontSize: 24)',
        font: { fontSize: 24 },
        color: '#333',
        top: 20,
        width: 150,
        height: 40
    });
    container.add(normal);

    // Auto-shrinking label
    var shrinking = Ti.UI.createLabel({
        text: 'This text will shrink to fit',
        font: { fontSize: 28 },
        minimumFontSize: 12,
        top: 15,
        width: 150,
        height: 40
    });
    container.add(shrinking);

    // Ellipsize example
    var ellipsizeLabel = Ti.UI.createLabel({
        text: 'This text will be truncated with ellipsis',
        font: { fontSize: 18 },
        ellipsize: 'true',
        top: 15,
        width: 200,
        height: 30
    });
    container.add(ellipsizeLabel);

    var info = Ti.UI.createLabel({
        text: 'minimumFontSize < 4: disables auto-shrinking\n' +
              'minimumFontSize >= 4: enables adjustsFontSizeToFitWidth\n' +
              'ellipsize: "true" enables NSLineBreakByTruncatingTail',
        font: { fontSize: 12 },
        color: '#666',
        top: 20,
        width: Ti.UI.FILL,
        lineHeight: 18
    });
    container.add(info);

    scrollView.add(container);
    return scrollView;
}

// ============================================================
// VIEW 5: Performance Test (ListView with 1000 items)
// ============================================================
function createPerformanceView() {
    var container = Ti.UI.createView({
        layout: 'vertical',
        backgroundColor: '#f5f5f5'
    });

    var header = Ti.UI.createLabel({
        text: 'Performance Test',
        font: { fontSize: 28, fontWeight: 'bold' },
        color: '#333',
        textAlign: Ti.UI.TEXT_ALIGNMENT_CENTER,
        top: 10,
        height: 50,
        width: Ti.UI.FILL
    });
    container.add(header);

    var subtitle = Ti.UI.createLabel({
        text: '1000 items in ListView (scroll to test)',
        font: { fontSize: 14 },
        color: '#666',
        textAlign: Ti.UI.TEXT_ALIGNMENT_CENTER,
        top: 0,
        height: 30,
        width: Ti.UI.FILL
    });
    container.add(subtitle);

    // Create ListView with 1000 items
    var listView = Ti.UI.createListView({
        top: 35,
        bottom: 0,
        left: 0,
        right: 0,
        templates: {
            '.item': {
                childTemplates: [
                    {
                        id: 'title',
                        type: Ti.UI.LIST_ITEM_TEMPLATE_LABEL,
                        verticalAlign: Ti.UI.VERTICAL_CENTER,
                        left: 15,
                        right: 15,
                        height: 50
                    }
                ]
            }
        }
    });

    var items = [];
    for (var i = 0; i < 1000; i++) {
        items.push({
            type: '.item',
            properties: {
                titleText: 'Item ' + (i + 1) + ' - ti.labelextension optimized label',
                titleFont: { fontSize: 16 },
                titleColor: '#333',
                titleVerticalAlign: Ti.UI.VERTICAL_CENTER
            }
        });
    }

    var section = Ti.UI.createListSection({
        items: items
    });

    listView.appendSection(section);
    container.add(listView);

    return container;
}

// ============================================================
// VIEW 6: Shadow Effects
// ============================================================
function createShadowView() {
    var scrollView = Ti.UI.createScrollView({
        backgroundColor: '#f5f5f5',
        contentWidth: Ti.UI.FILL,
        contentHeight: Ti.UI.SIZE
    });

    var container = Ti.UI.createView({
        layout: 'vertical',
        backgroundColor: '#f5f5f5',
        top: 10,
        bottom: 10,
        left: 10,
        right: 10
    });

    var header = Ti.UI.createLabel({
        text: 'Shadow Effects',
        font: { fontSize: 28, fontWeight: 'bold' },
        color: '#333',
        textAlign: Ti.UI.TEXT_ALIGNMENT_CENTER,
        top: 10,
        width: Ti.UI.FILL
    });
    container.add(header);

    // Subtle shadow
    var subtleShadow = Ti.UI.createLabel({
        text: 'Subtle Shadow',
        font: { fontSize: 20, fontWeight: 'bold' },
        color: '#333',
        shadowColor: 'rgba(0,0,0,0.3)',
        shadowOffset: { x: 1, y: 1 },
        top: 20,
        height: 50,
        width: Ti.UI.FILL,
        backgroundColor: '#ffffff'
    });
    container.add(subtleShadow);

    // Strong shadow
    var strongShadow = Ti.UI.createLabel({
        text: 'Strong Shadow (x:3, y:3)',
        font: { fontSize: 20, fontWeight: 'bold' },
        color: '#fff',
        shadowColor: '#000',
        shadowOffset: { x: 3, y: 3 },
        top: 15,
        height: 50,
        width: Ti.UI.FILL,
        backgroundColor: '#9b59b6'
    });
    container.add(strongShadow);

    // Offset shadow
    var offsetShadow = Ti.UI.createLabel({
        text: 'Offset Shadow (x:5, y:5)',
        font: { fontSize: 20, fontWeight: 'bold' },
        color: '#fff',
        shadowColor: '#333',
        shadowOffset: { x: 5, y: 5 },
        top: 15,
        height: 60,
        width: Ti.UI.FILL,
        backgroundColor: '#e67e22'
    });
    container.add(offsetShadow);

    scrollView.add(container);
    return scrollView;
}

// ============================================================
// Build Views
// ============================================================
views.push(createBasicLabelsView());
views.push(createCalcRealSizeView());
views.push(createAttributedStringView());
views.push(createFontSizeView());
views.push(createPerformanceView());
views.push(createShadowView());

var viewTitles = [
    'Basic Labels',
    'calcRealSize',
    'AttributedString',
    'minFontSize & Ellipsize',
    'Performance (1000 items)',
    'Shadow Effects'
];

// ============================================================
// Navigation Toolbar
// ============================================================
var toolbar = Ti.UI.createView({
    backgroundColor: '#2c3e50',
    top: 0,
    left: 0,
    right: 0,
    height: 50
});

var prevButton = Ti.UI.createButton({
    title: '< Prev',
    font: { fontSize: 16 },
    color: '#fff',
    left: 10,
    top: 8,
    width: 70,
    height: 34
});

var nextButton = Ti.UI.createButton({
    title: 'Next >',
    font: { fontSize: 16 },
    color: '#fff',
    right: 10,
    top: 8,
    width: 70,
    height: 34
});

var titleLabel = Ti.UI.createLabel({
    text: viewTitles[0],
    font: { fontSize: 18, fontWeight: 'bold' },
    color: '#fff',
    textAlign: Ti.UI.TEXT_ALIGNMENT_CENTER,
    top: 10,
    width: Ti.UI.SIZE,
    height: 30
});

toolbar.add(prevButton);
toolbar.add(nextButton);
toolbar.add(titleLabel);
win.add(toolbar);

// ============================================================
// View Navigation
// ============================================================
function showView(index) {
    // Remove old views
    for (var i = 0; i < views.length; i++) {
        if (i !== index) {
            win.remove(views[i]);
        }
    }

    var view = views[index];
    view.top = 50;
    view.left = 0;
    view.right = 0;
    view.bottom = 0;
    win.add(view);

    titleLabel.text = viewTitles[index];

    // Enable/disable buttons
    prevButton.enabled = index > 0;
    nextButton.enabled = index < views.length - 1;
}

prevButton.addEventListener('click', function() {
    if (currentView > 0) {
        currentView--;
        showView(currentView);
    }
});

nextButton.addEventListener('click', function() {
    if (currentView < views.length - 1) {
        currentView++;
        showView(currentView);
    }
});

// Show first view
showView(0);

// Open window
win.open();
