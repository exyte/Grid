import SwiftUI
import ExyteGrid

struct PixelTestExample: View {
    @Environment(\.pixelLength) var pixelLength: CGFloat

    let rowHeight: CGFloat = 50

    var body: some View {
        VStack(spacing: 0) {
            Group {
                Text("HStack with 1 pixel borders:")

                HStack(spacing: 0) {
                    ColorView(.orange, cornerRadius: 0, debugSize: true).border(.black, width: pixelLength)
                    ColorView(.orange, cornerRadius: 0, debugSize: true).border(.black, width: 0)
                    ColorView(.orange, cornerRadius: 0, debugSize: true).border(.black, width: pixelLength)
                    ColorView(.orange, cornerRadius: 0, debugSize: true).border(.black, width: 0)
                }.frame(maxHeight: rowHeight)

                HStack(spacing: 0) {
                    ColorView(.orange, cornerRadius: 0, debugSize: true).border(.black, width: 0)
                    ColorView(.orange, cornerRadius: 0, debugSize: true).border(.black, width: pixelLength)
                    ColorView(.orange, cornerRadius: 0, debugSize: true).border(.black, width: 0)
                    ColorView(.orange, cornerRadius: 0, debugSize: true).border(.black, width: pixelLength)
                }.frame(maxHeight: rowHeight)

                Text("Grid with 1 pixel borders:")

                Grid(tracks: 4, spacing: 0) {
                    ColorView(.orange, cornerRadius: 0, debugSize: true).border(.black, width: pixelLength)
                    ColorView(.orange, cornerRadius: 0, debugSize: true).border(.black, width: 0)
                    ColorView(.orange, cornerRadius: 0, debugSize: true).border(.black, width: pixelLength)
                    ColorView(.orange, cornerRadius: 0, debugSize: true).border(.black, width: 0)
                }.frame(maxHeight: rowHeight)

                Grid(tracks: 4, spacing: 0) {
                    ColorView(.orange, cornerRadius: 0, debugSize: true).border(.black, width: 0)
                    ColorView(.orange, cornerRadius: 0, debugSize: true).border(.black, width: pixelLength)
                    ColorView(.orange, cornerRadius: 0, debugSize: true).border(.black, width: 0)
                    ColorView(.orange, cornerRadius: 0, debugSize: true).border(.black, width: pixelLength)
                }.frame(maxHeight: rowHeight)
            }

            Group {
                Text("HStack with 1 point borders:")

                HStack(spacing: 0) {
                    ColorView(.orange, cornerRadius: 0, debugSize: true).border(.black, width: 1)
                    ColorView(.orange, cornerRadius: 0, debugSize: true).border(.black, width: 0)
                    ColorView(.orange, cornerRadius: 0, debugSize: true).border(.black, width: 1)
                    ColorView(.orange, cornerRadius: 0, debugSize: true).border(.black, width: 0)
                }.frame(maxHeight: rowHeight)

                HStack(spacing: 0) {
                    ColorView(.orange, cornerRadius: 0, debugSize: true).border(.black, width: 0)
                    ColorView(.orange, cornerRadius: 0, debugSize: true).border(.black, width: 1)
                    ColorView(.orange, cornerRadius: 0, debugSize: true).border(.black, width: 0)
                    ColorView(.orange, cornerRadius: 0, debugSize: true).border(.black, width: 1)
                }.frame(maxHeight: rowHeight)

                Text("Grid with 1 point borders:")

                Grid(tracks: 4, spacing: 0) {
                    ColorView(.orange, cornerRadius: 0, debugSize: true).border(.black, width: 1)
                    ColorView(.orange, cornerRadius: 0, debugSize: true).border(.black, width: 0)
                    ColorView(.orange, cornerRadius: 0, debugSize: true).border(.black, width: 1)
                    ColorView(.orange, cornerRadius: 0, debugSize: true).border(.black, width: 0)
                }.frame(maxHeight: rowHeight)

                Grid(tracks: 4, spacing: 0) {
                    ColorView(.orange, cornerRadius: 0, debugSize: true).border(.black, width: 0)
                    ColorView(.orange, cornerRadius: 0, debugSize: true).border(.black, width: 1)
                    ColorView(.orange, cornerRadius: 0, debugSize: true).border(.black, width: 0)
                    ColorView(.orange, cornerRadius: 0, debugSize: true).border(.black, width: 1)
                }.frame(maxHeight: rowHeight)
            }

            Group {
                Text("Grid with spans and 1 pixel borders:")

                Grid(tracks: 4, spacing: 0) {
                    ColorView(.orange, cornerRadius: 0, debugSize: true).border(.black, width: pixelLength)
                        .gridSpan(column: 2)
                    ColorView(.orange, cornerRadius: 0, debugSize: true).border(.black, width: pixelLength)
                    ColorView(.orange, cornerRadius: 0, debugSize: true).border(.black, width: pixelLength)
                        .gridSpan(row: 2)
                    ColorView(.orange, cornerRadius: 0, debugSize: true).border(.black, width: pixelLength)
                    ColorView(.orange, cornerRadius: 0, debugSize: true).border(.black, width: pixelLength)
                    ColorView(.orange, cornerRadius: 0, debugSize: true).border(.black, width: pixelLength)
                    ColorView(.orange, cornerRadius: 0, debugSize: true).border(.black, width: pixelLength)
                }.frame(maxHeight: 100)
            }

            Group {
                Text("Grid with spans:")

                Grid(tracks: 4, spacing: 0) {
                    ColorView(.orange, cornerRadius: 0, debugSize: true)
                        .gridSpan(column: 2)
                    ColorView(.orange, cornerRadius: 0, debugSize: true)
                    ColorView(.orange, cornerRadius: 0, debugSize: true)
                        .gridSpan(row: 2)
                    ColorView(.orange, cornerRadius: 0, debugSize: true)
                    ColorView(.orange, cornerRadius: 0, debugSize: true)
                    ColorView(.orange, cornerRadius: 0, debugSize: true)
                    ColorView(.orange, cornerRadius: 0, debugSize: true)
                }.frame(maxHeight: 100)
            }

            Spacer()
        }
    }
}

struct PixelTestExample_Previews: PreviewProvider {
    static var previews: some View {
        PixelTestExample()
    }
}
