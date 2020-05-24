<img src="https://github.com/exyte/Grid/blob/master/Assets/header.png">

<p><h1 align="left">Grid</h1></p>

<p><h4>A Grid view inspired by CSS Grid and written with SwiftUI</h4></p>

___

<p> We are a development agency building
  <a href="https://clutch.co/profile/exyte#review-731233?utm_medium=referral&utm_source=github.com&utm_campaign=phenomenal_to_clutch">phenomenal</a> apps.</p>

</br>

<a href="https://exyte.com/contacts"><img src="https://i.imgur.com/vGjsQPt.png" width="134" height="34"></a> <a href="https://twitter.com/exyteHQ"><img src="https://i.imgur.com/DngwSn1.png" width="165" height="34"></a>

</br></br>

[![Twitter](https://img.shields.io/badge/Twitter-@exyteHQ-blue.svg?style=flat)](http://twitter.com/exyteHQ)
[![Version](https://img.shields.io/cocoapods/v/ExyteGrid.svg?style=flat)](https://cocoapods.org/pods/ExyteGrid)
[![License](https://img.shields.io/cocoapods/l/ExyteGrid.svg?style=flat)](https://cocoapods.org/pods/ExyteGrid)
[![Platform](https://img.shields.io/cocoapods/p/ExyteGrid.svg?style=flat)](https://cocoapods.org/pods/ExyteGrid)

## Features
- **Track sizes:**
  -  Flexible *.fr(...)*
  -  Constant *.pt(...)*
  - Content fitting *.fit*
- **Spanning grid items:**
  - by rows
  - by columns
- **Automatic items positioning**
- **Explicit items positions specifying:**
  - start row
  - start column
  - both
- **Flow direction:**
  - by rows
  - by columns
- **Packing mode:**
  - sparse
  - dense
- **Content mode:**
  - Fit to a container
  - Scrollable content
- Vertical and horizontal spacing
- ForEach support
- Content updates can be animated

 
## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## How to use
### 1. Initialization
You can instantiate grid by different ways:
1. Just specify tracks and your views inside ViewBuilder closure:
```swift
Grid(tracks: 3) {
		ColorView(.blue)
		ColorView(.purple)
		ColorView(.red)
		ColorView(.cyan)
		ColorView(.green)
		ColorView(.orange)
}
```
2. Use Range:
```swift
Grid(0..<6, tracks: 3) { _ in
		ColorView(.random)
}
```
3. Use Identifiable enitites:
```swift
Grid(colorModels, tracks: 3) {
		ColorView($0)
}
```
4. Use explicitly defined ID:
```swift
Grid(colorModels, id: \.self, tracks: 3) {
		ColorView($0)
}
```

### 2. Containers
##### ForEach
Inside ViewBuilder you also can use regular ForEach statement:
```swift
Grid(tracks: 4) {
    ColorView(.red)
    ColorView(.purple)
    
    ForEach(0..<4) { _ in
        ColorView(.black)
    }

    ColorView(.orange)
    ColorView(.green)
}
```
##### GridGroup
Number of views in ViewBuilder closure is limited to 10. It's impossible to obtain content views from regular SwiftUI `Group` view. To exceed that limit you could use `GridGroup`. Every view in GridGroup is placed as a separate grid item. Unlike the `Group` view any modifications of `GridView` are not applied to the descendant views. So it's just an enumerable container.

*All nested containers are processed recursively.*

### 3. Track sizes
There are 3 types of track sizes that you could mix with each other:
##### Fixed-sized track: 
`.pt(N)` where N - points count. 
```swift
Grid(tracks: [.pt(50), .pt(200), .pt(100)]) {
    ColorView(.blue)
    ColorView(.purple)
    ColorView(.red)
    ColorView(.cyan)
    ColorView(.green)
    ColorView(.orange)
}
```
##### Content-based size: *.fit*
Defines the track size as a maximum of the content sizes of every item in track
```swift
Grid(0..<6, tracks: [.fit, .fit, .fit]) {
    ColorView(.random)
        .frame(maxWidth: 50 + 15 * CGFloat($0))
}
```

##### Flexible sized track: `.fr(N)`
Fr is a fractional unit and `.fr(1)` is for 1 part of the unassigned space in the grid. Flexible-sized tracks are computed at the very end after all non-flexible sized tracks (`.pt` and `.fit`). So the available space for them to distribute is the difference of the total size available and the sum of non-flexible track sizes.
```swift
Grid(tracks: [.pt(100), .fr(1), .fr(2.5)]) {
    ColorView(.blue)
    ColorView(.purple)
    ColorView(.red)
    ColorView(.cyan)
    ColorView(.green)
    ColorView(.orange)
}
```

Also you could specify just an Int literal as a track size. It's equal to repeating `.fr(1)` track sizes:
```swift
Grid(tracks: 3) { ... }
```
is equal to:
```swift
Grid(tracks: [.fr(1), .fr(1), .fr(1)]) { ... }
```

### 4. Grid cell background and overlay.
When using non-flexible track sizes it's possible the extra space to be allocated than a grid item is able to take up. To fill that space you could use `.gridCellBackground(...)` and `gridCellOverlay(...)` modifiers.

### 5. Spans
Every grid item may span across the provided number of grid tracks. You can achieve it using `.gridSpan(column: row:)` modifier. The default span is 1.
```swift
Grid(tracks: [.fr(1), .pt(150), .fr(2)]) {
    ColorView(.blue)
        .gridSpan(column: 2)
    ColorView(.purple)
        .gridSpan(row: 2)
    ColorView(.red)
    ColorView(.cyan)
    ColorView(.green)
        .gridSpan(column: 2, row: 3)
    ColorView(.orange)
    ColorView(.magenta)
        .gridSpan(row: 2)
}
```

More complex example:


```swift
Grid(tracks: [.fr(1), .fit, .fit], spacing: 10) {
    TextBox(text: self.placeholderText, color: .red)
    
    TextBox(text: String(self.placeholderText.prefix(30)), color: .orange)
        .frame(maxWidth: 70)
    
    TextBox(text: String(self.placeholderText.prefix(120)), color: .green)
        .frame(maxWidth: 100)
        .gridSpan(column: 1, row: 2)
    
    TextBox(text: String(self.placeholderText.prefix(160)), color: .magenta)
        .gridSpan(column: 2, row: 1)
    
    TextBox(text: String(self.placeholderText.prefix(190)), color: .cyan)
        .gridSpan(column: 3, row: 1)
}

struct TextBox: View {
    let text: String
    let color: UIColor
    
    var body: some View {
        Text(self.text)
            .foregroundColor(.black)
            .fontWeight(.medium)
            .padding(5)
            .gridCellBackground { _ in
                self.background
            }
    }
    
    var borderColor: Color {
        return Color(self.color.darker())
    }
    
    var background: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(ColorView(self.color))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(self.borderColor, lineWidth: 5)
        )
    }
}
```

### 6. Starts
For every grid item you can set explicit start position by specifying a column, a row or both.
Firstly, the grid items with both column and row start positions are placed. 
Secondly, the auto-placing algorhitm tries to place items with either column or row start position specified. If there are any conflicts - such items are placed automatically and you see warning in the console.
And at the very end grid items with no explicit start position are placed.
Item's start position is defined using `.gridStart(column: row:)`  modifier


### 7. Flow
Grid has 2 types of tracks. The first one is where you specify [track sizes](#track-sizes) - the fixed one. Fixed means that a count of tracks is known. The second one and orthogonal to the fixed - is growing tracks type - where your content grows. Grid flow defines the direction of items placement:
 -  **Columns**
 Default. The number of columns is fixed and [defined as track sizes](#track-sizes). Grid items are placed moving firstly between columns and switching to the next row after the last column. Rows count is growing.
 
 -  **Rows**
The number of rows is fixed and [defined as track sizes](#track-sizes). Grid items are placed moving firstly between rows  and switching to the next columns after the last row. Columns count is growing.

*Grid flow could be specified in a grid constuctor as well as using  `.gridFlow(...)` modifier. The first option has more priority.*

### 8. Content mode
There are 2 kinds of content modes:

##### Fill
In this mode grid view tries to fill the entire space provided by the parent view by its content. So it's better to have at least one flexible-sized track and grid items within this track that are able to fill the provided space. Grid tracks that orthogonal to the grid flow direction (growing) are implicitly assumed to have `.fr(1)` size.

##### Scroll
In this mode the inner grid content is able to scroll to the [growing direction](#flow). Grid tracks that orthogonal to the grid flow direction (growing) are implicitly assumed to have `.fit` size.

*Grid content mode could be specified in a grid constuctor as well as using  `.gridContentMode(...)` modifier. The first option has more priority.*

### 9. Packing
Auto-placing algorithm could stick to the one of two strategies:
##### Sparse 
Default. The placement algorithm only ever moves “forward” in the grid when placing items, never backtracking to fill holes. This ensures that all of the auto-placed items appear “in order”, even if this leaves holes that could have been filled by later items.

##### Dense 
Attempts to fill in holes earlier in the grid if smaller items come up later. This may cause items to appear out-of-order, when doing so would fill in holes left by larger items.

*Grid packing could be specified in a grid constuctor as well as using  `.gridPacking(...)` modifier. The first option has more priority.*

### 10. Spacing
There are several ways to define horizontal and vertical spacing between tracks:
- Using Int literal which means equal spacing in all directions:
```swift
Grid(tracks: 4, spacing: 5) { ... } 
```
- Using explicit init
```swift
Grid(tracks: 4, spacing: GridSpacing(horizontal: 10, vertical: 5)) { ... } 
```
- Using array literal:
```swift
Grid(tracks: 4, spacing: [10, 5]) { ... } 
```
## Installation

Grid is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ExyteGrid'
```

## Requirements

* iOS 13+
* Xcode 11+ 


## Roadmap:

- [ ] add GridIdentified-like item to track the same View in animations 
- [ ] add regions or settings for GridGroup to specify position
- [ ] dual dimension track sizes (grid-template-rows, grid-template-columns).
- [ ] grid-auto-rows, grid-auto-columns
- [ ] grid min/ideal sizes
- [ ] improve dense placement algorithm
- [ ] support if clauses
- [ ] ? landscape/portrait layout
- [ ] ? calculate layout in background thread
- [x] add GridGroup
- [x] grid item explicit row and/or column position
- [x] different spacing for rows and columns
- [x] intrinsic sized tracks (fit-content)
- [x] forEach support
- [x] dense/sparse placement algorithm
- [x] add horizontal axis
- [x] init via Identifiable models
- [x] scrollable content


## License

Grid is available under the MIT license. See the LICENSE file for more info.

