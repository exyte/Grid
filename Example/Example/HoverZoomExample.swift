import SwiftUI
import ExyteGrid

private struct CellFramesKey: PreferenceKey {
  static var defaultValue: [Int: CGRect] = [:]

  static func reduce(value: inout [Int: CGRect], nextValue: () -> [Int: CGRect]) {
    value.merge(nextValue()) { $1 }
  }
}

struct HoverZoomExample: View {
  private let colors: [GridColor] = [
    GridColor(hue: 0.60, saturation: 0.40, brightness: 0.78, alpha: 1),
    GridColor(hue: 0.35, saturation: 0.40, brightness: 0.75, alpha: 1),
    GridColor(hue: 0.07, saturation: 0.45, brightness: 0.90, alpha: 1),
    GridColor(hue: 0.95, saturation: 0.40, brightness: 0.85, alpha: 1),
    GridColor(hue: 0.75, saturation: 0.38, brightness: 0.80, alpha: 1),
    GridColor(hue: 0.50, saturation: 0.40, brightness: 0.76, alpha: 1),
  ]
  private let columnCount = 4
  private let itemCount = 16

  @State private var cellFrames: [Int: CGRect] = [:]
  @State private var hoveredIndex: Int? = nil

  var body: some View {
    Grid(tracks: columnCount, spacing: 8) {
      ForEach(0..<itemCount, id: \.self) { index in
        ColorView(colors[index % colors.count])
          .frame(minHeight: 80)
          .background(
            GeometryReader { geo in
              Color.clear.preference(
                key: CellFramesKey.self,
                value: [index: geo.frame(in: .named("grid"))]
              )
            }
          )
      }
    }
    .padding(8)
    .coordinateSpace(name: "grid")
    .overlay(alignment: .topLeading) {
      if let idx = hoveredIndex, let frame = cellFrames[idx] {
        ColorView(colors[idx % colors.count])
          .frame(width: frame.width, height: frame.height)
          .scaleEffect(1.3)
          .position(x: frame.midX, y: frame.midY)
          .allowsHitTesting(false)
          .transition(.scale(scale: 1 / 1.3).combined(with: .opacity))
          .id(idx)
      }
    }
    .onPreferenceChange(CellFramesKey.self) { cellFrames = $0 }
    .gesture(
      DragGesture(minimumDistance: 0, coordinateSpace: .named("grid"))
        .onChanged { value in
          withAnimation(.spring(response: 0.3, dampingFraction: 0.65)) {
            hoveredIndex = cellFrames.first { $0.value.contains(value.location) }?.key
          }
        }
        .onEnded { _ in
          withAnimation(.spring(response: 0.3, dampingFraction: 0.65)) {
            hoveredIndex = nil
          }
        }
    )
  }
}

struct HoverZoomExample_Previews: PreviewProvider {
  static var previews: some View {
    HoverZoomExample()
  }
}
