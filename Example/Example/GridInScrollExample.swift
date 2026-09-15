import SwiftUI
import ExyteGrid

struct GridInScrollExample: View {

  private var colors: [Color] = [
    .red, .orange, .yellow, .green, .blue, .purple,
    .pink, .teal, .indigo, .mint, .cyan, .brown
  ]

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 24) {
        section(title: "3 Columns") {
          Grid(tracks: 3, spacing: 6) {
            ForEach(0..<6) { i in
              colors[i]
                .frame(height: 60)
                .cornerRadius(8)
                .overlay(Text("\(i + 1)").foregroundColor(.white).bold())
            }
          }
        }

        section(title: "Spanning") {
          Grid(tracks: 4, spacing: 6) {
            ForEach(0..<8) { i in
              colors[i + 4]
                .frame(height: 60)
                .cornerRadius(8)
                .overlay(Text("\(i + 1)").foregroundColor(.white).bold())
                .gridSpan(column: i == 0 ? 2 : 1)
            }
          }
        }

        section(title: "Dense Packing") {
          Grid(tracks: 5, spacing: 6) {
            ForEach(0..<10) { i in
              colors[i % colors.count]
                .frame(height: 50)
                .cornerRadius(8)
                .gridSpan(column: [1, 2, 1, 1, 3, 1, 2, 1, 1, 1][i])
            }
          }
          .gridPacking(.dense)
        }
      }
      .padding()
    }
  }

  private func section<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(title)
        .font(.headline)

      content()
    }
  }
}

struct GridInScrollExample_Previews: PreviewProvider {
  static var previews: some View {
    GridInScrollExample()
  }
}
