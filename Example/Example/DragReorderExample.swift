import SwiftUI
import ExyteGrid

struct DragReorderItem: Identifiable, Equatable {
    var id: UUID = .init()
    var color: Color
    var columns: Int
    var rows: Int
    var height: CGFloat = 80
}

struct DragRelocateDelegate: DropDelegate {
    var item: DragReorderItem
    @Binding var list: [DragReorderItem]
    @Binding var current: DragReorderItem?

    func dropEntered(info: DropInfo) {
        guard let current, item != current,
              let from = list.firstIndex(of: current),
              let to = list.firstIndex(of: item) else { return }
        list.move(fromOffsets: IndexSet(integer: from), toOffset: to > from ? to + 1 : to)
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        DropProposal(operation: .move)
    }

    func performDrop(info: DropInfo) -> Bool {
        current = nil
        return true
    }
}

struct DragReorderExample: View {
    @State var gridPacking = GridPacking.sparse
    @State var items: [DragReorderItem] = {
        let specs: [(columns: Int, rows: Int, height: CGFloat)] = [
            (2, 1, 80), (2, 1, 80), (2, 2, 160), (2, 1, 80), (2, 2, 160),
            (2, 1, 80), (2, 1, 80), (4, 2, 160), (2, 1, 80), (2, 1, 80),
            (2, 1, 80), (2, 1, 80), (2, 1, 80),
        ]
        return specs.enumerated().map { i, spec in
            DragReorderItem(
                color: Palette.colors[i % Palette.colors.count],
                columns: spec.columns,
                rows: spec.rows,
                height: spec.height
            )
        }
    }()
    @State private var draggingItem: DragReorderItem?

    private var packingPicker: some View {
        Picker("Packing", selection: $gridPacking) {
            ForEach([GridPacking.sparse, GridPacking.dense], id: \.self) {
                Text($0 == .sparse ? "SPARSE" : "DENSE")
                    .tag($0)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }

    var body: some View {
        VStack {
            packingPicker

            if #available(iOS 16.0, *) {
                Grid(tracks: 4, spacing: 0) {
                    ForEach(items) { item in
                        item.color
                            .overlay {
                                Text(item.id.uuidString)
                                    .font(.caption2)
                            }
                            .border(Color.red, width: 2)
                            .gridItemAlignment(.top)
                            .gridSpan(column: item.columns, row: item.rows)
                            .frame(height: item.height)
                            .onDrag {
                                withAnimation { draggingItem = item }
                                return NSItemProvider(object: "\(item.id)" as NSString)
                            }
                            .onDrop(
                                of: [.text],
                                delegate: DragRelocateDelegate(item: item, list: $items, current: $draggingItem)
                            )
                    }
                }
                .gridPacking(gridPacking)
                .gridAnimation(.default)
                .gridContentMode(.scroll)
                .gridCommonItemsAlignment(.top)
                .gridContentAlignment(.top)
            }
        }
    }
}

struct DragReorderExample_Previews: PreviewProvider {
    static var previews: some View {
        DragReorderExample()
    }
}
