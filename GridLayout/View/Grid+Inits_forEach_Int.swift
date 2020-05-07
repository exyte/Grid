// GENERATED

// swiftlint:disable large_tuple line_length file_length

import SwiftUI

extension Grid {
    public init<T: View>(tracks: [TrackSize], spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(ForEach<Range<Int>, Int, T>)> {
        self.trackSizes = tracks
        self.tracksCount = self.trackSizes.count
        self.spacing = spacing
        self.items =
            content().value.data.map { GridItem(AnyView(content().value.content($0)), id: AnyHashable(($0 + 10))) }
    }

    public init<C0: View, T: View>(tracks: [TrackSize], spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(ForEach<Range<Int>, Int, T>, C0)> {
        self.trackSizes = tracks
        self.tracksCount = self.trackSizes.count
        self.spacing = spacing
        self.items =
            content().value.0.data.map { GridItem(AnyView(content().value.0.content($0)), id: AnyHashable(($0 + 10))) }
            + [GridItem(AnyView(content().value.1), id: AnyHashable(1))]
    }

    public init<C0: View, T: View>(tracks: [TrackSize], spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(C0, ForEach<Range<Int>, Int, T>)> {
        self.trackSizes = tracks
        self.tracksCount = self.trackSizes.count
        self.spacing = spacing
        self.items =
            [GridItem(AnyView(content().value.0), id: AnyHashable(0))]
            + content().value.1.data.map { GridItem(AnyView(content().value.1.content($0)), id: AnyHashable(($0 + 10))) }
    }

    public init<C0: View, C1: View, T: View>(tracks: [TrackSize], spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(ForEach<Range<Int>, Int, T>, C0, C1)> {
        self.trackSizes = tracks
        self.tracksCount = self.trackSizes.count
        self.spacing = spacing
        self.items =
            content().value.0.data.map { GridItem(AnyView(content().value.0.content($0)), id: AnyHashable(($0 + 10))) }
            + [GridItem(AnyView(content().value.1), id: AnyHashable(1)),
            GridItem(AnyView(content().value.2), id: AnyHashable(2))]
    }

    public init<C0: View, C1: View, T: View>(tracks: [TrackSize], spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(C0, ForEach<Range<Int>, Int, T>, C1)> {
        self.trackSizes = tracks
        self.tracksCount = self.trackSizes.count
        self.spacing = spacing
        self.items =
            [GridItem(AnyView(content().value.0), id: AnyHashable(0))]
            + content().value.1.data.map { GridItem(AnyView(content().value.1.content($0)), id: AnyHashable(($0 + 10))) }
            + [GridItem(AnyView(content().value.2), id: AnyHashable(2))]
    }

    public init<C0: View, C1: View, T: View>(tracks: [TrackSize], spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(C0, C1, ForEach<Range<Int>, Int, T>)> {
        self.trackSizes = tracks
        self.tracksCount = self.trackSizes.count
        self.spacing = spacing
        self.items =
            [GridItem(AnyView(content().value.0), id: AnyHashable(0)),
            GridItem(AnyView(content().value.1), id: AnyHashable(1))]
            + content().value.2.data.map { GridItem(AnyView(content().value.2.content($0)), id: AnyHashable(($0 + 10))) }
    }

    public init<C0: View, C1: View, C2: View, T: View>(tracks: [TrackSize], spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(ForEach<Range<Int>, Int, T>, C0, C1, C2)> {
        self.trackSizes = tracks
        self.tracksCount = self.trackSizes.count
        self.spacing = spacing
        self.items =
            content().value.0.data.map { GridItem(AnyView(content().value.0.content($0)), id: AnyHashable(($0 + 10))) }
            + [GridItem(AnyView(content().value.1), id: AnyHashable(1)),
            GridItem(AnyView(content().value.2), id: AnyHashable(2)),
            GridItem(AnyView(content().value.3), id: AnyHashable(3))]
    }

    public init<C0: View, C1: View, C2: View, T: View>(tracks: [TrackSize], spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(C0, ForEach<Range<Int>, Int, T>, C1, C2)> {
        self.trackSizes = tracks
        self.tracksCount = self.trackSizes.count
        self.spacing = spacing
        self.items =
            [GridItem(AnyView(content().value.0), id: AnyHashable(0))]
            + content().value.1.data.map { GridItem(AnyView(content().value.1.content($0)), id: AnyHashable(($0 + 10))) }
            + [GridItem(AnyView(content().value.2), id: AnyHashable(2)),
            GridItem(AnyView(content().value.3), id: AnyHashable(3))]
    }

    public init<C0: View, C1: View, C2: View, T: View>(tracks: [TrackSize], spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(C0, C1, ForEach<Range<Int>, Int, T>, C2)> {
        self.trackSizes = tracks
        self.tracksCount = self.trackSizes.count
        self.spacing = spacing
        self.items =
            [GridItem(AnyView(content().value.0), id: AnyHashable(0)),
            GridItem(AnyView(content().value.1), id: AnyHashable(1))]
            + content().value.2.data.map { GridItem(AnyView(content().value.2.content($0)), id: AnyHashable(($0 + 10))) }
            + [GridItem(AnyView(content().value.3), id: AnyHashable(3))]
    }

    public init<C0: View, C1: View, C2: View, T: View>(tracks: [TrackSize], spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(C0, C1, C2, ForEach<Range<Int>, Int, T>)> {
        self.trackSizes = tracks
        self.tracksCount = self.trackSizes.count
        self.spacing = spacing
        self.items =
            [GridItem(AnyView(content().value.0), id: AnyHashable(0)),
            GridItem(AnyView(content().value.1), id: AnyHashable(1)),
            GridItem(AnyView(content().value.2), id: AnyHashable(2))]
            + content().value.3.data.map { GridItem(AnyView(content().value.3.content($0)), id: AnyHashable(($0 + 10))) }
    }

    public init<C0: View, C1: View, C2: View, C3: View, T: View>(tracks: [TrackSize], spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(ForEach<Range<Int>, Int, T>, C0, C1, C2, C3)> {
        self.trackSizes = tracks
        self.tracksCount = self.trackSizes.count
        self.spacing = spacing
        self.items =
            content().value.0.data.map { GridItem(AnyView(content().value.0.content($0)), id: AnyHashable(($0 + 10))) }
            + [GridItem(AnyView(content().value.1), id: AnyHashable(1)),
            GridItem(AnyView(content().value.2), id: AnyHashable(2)),
            GridItem(AnyView(content().value.3), id: AnyHashable(3)),
            GridItem(AnyView(content().value.4), id: AnyHashable(4))]
    }

    public init<C0: View, C1: View, C2: View, C3: View, T: View>(tracks: [TrackSize], spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(C0, ForEach<Range<Int>, Int, T>, C1, C2, C3)> {
        self.trackSizes = tracks
        self.tracksCount = self.trackSizes.count
        self.spacing = spacing
        self.items =
            [GridItem(AnyView(content().value.0), id: AnyHashable(0))]
            + content().value.1.data.map { GridItem(AnyView(content().value.1.content($0)), id: AnyHashable(($0 + 10))) }
            + [GridItem(AnyView(content().value.2), id: AnyHashable(2)),
            GridItem(AnyView(content().value.3), id: AnyHashable(3)),
            GridItem(AnyView(content().value.4), id: AnyHashable(4))]
    }

    public init<C0: View, C1: View, C2: View, C3: View, T: View>(tracks: [TrackSize], spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(C0, C1, ForEach<Range<Int>, Int, T>, C2, C3)> {
        self.trackSizes = tracks
        self.tracksCount = self.trackSizes.count
        self.spacing = spacing
        self.items =
            [GridItem(AnyView(content().value.0), id: AnyHashable(0)),
            GridItem(AnyView(content().value.1), id: AnyHashable(1))]
            + content().value.2.data.map { GridItem(AnyView(content().value.2.content($0)), id: AnyHashable(($0 + 10))) }
            + [GridItem(AnyView(content().value.3), id: AnyHashable(3)),
            GridItem(AnyView(content().value.4), id: AnyHashable(4))]
    }

    public init<C0: View, C1: View, C2: View, C3: View, T: View>(tracks: [TrackSize], spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(C0, C1, C2, ForEach<Range<Int>, Int, T>, C3)> {
        self.trackSizes = tracks
        self.tracksCount = self.trackSizes.count
        self.spacing = spacing
        self.items =
            [GridItem(AnyView(content().value.0), id: AnyHashable(0)),
            GridItem(AnyView(content().value.1), id: AnyHashable(1)),
            GridItem(AnyView(content().value.2), id: AnyHashable(2))]
            + content().value.3.data.map { GridItem(AnyView(content().value.3.content($0)), id: AnyHashable(($0 + 10))) }
            + [GridItem(AnyView(content().value.4), id: AnyHashable(4))]
    }

    public init<C0: View, C1: View, C2: View, C3: View, T: View>(tracks: [TrackSize], spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(C0, C1, C2, C3, ForEach<Range<Int>, Int, T>)> {
        self.trackSizes = tracks
        self.tracksCount = self.trackSizes.count
        self.spacing = spacing
        self.items =
            [GridItem(AnyView(content().value.0), id: AnyHashable(0)),
            GridItem(AnyView(content().value.1), id: AnyHashable(1)),
            GridItem(AnyView(content().value.2), id: AnyHashable(2)),
            GridItem(AnyView(content().value.3), id: AnyHashable(3))]
            + content().value.4.data.map { GridItem(AnyView(content().value.4.content($0)), id: AnyHashable(($0 + 10))) }
    }

    public init<C0: View, C1: View, C2: View, C3: View, C4: View, T: View>(tracks: [TrackSize], spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(ForEach<Range<Int>, Int, T>, C0, C1, C2, C3, C4)> {
        self.trackSizes = tracks
        self.tracksCount = self.trackSizes.count
        self.spacing = spacing
        self.items =
            content().value.0.data.map { GridItem(AnyView(content().value.0.content($0)), id: AnyHashable(($0 + 10))) }
            + [GridItem(AnyView(content().value.1), id: AnyHashable(1)),
            GridItem(AnyView(content().value.2), id: AnyHashable(2)),
            GridItem(AnyView(content().value.3), id: AnyHashable(3)),
            GridItem(AnyView(content().value.4), id: AnyHashable(4)),
            GridItem(AnyView(content().value.5), id: AnyHashable(5))]
    }

    public init<C0: View, C1: View, C2: View, C3: View, C4: View, T: View>(tracks: [TrackSize], spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(C0, ForEach<Range<Int>, Int, T>, C1, C2, C3, C4)> {
        self.trackSizes = tracks
        self.tracksCount = self.trackSizes.count
        self.spacing = spacing
        self.items =
            [GridItem(AnyView(content().value.0), id: AnyHashable(0))]
            + content().value.1.data.map { GridItem(AnyView(content().value.1.content($0)), id: AnyHashable(($0 + 10))) }
            + [GridItem(AnyView(content().value.2), id: AnyHashable(2)),
            GridItem(AnyView(content().value.3), id: AnyHashable(3)),
            GridItem(AnyView(content().value.4), id: AnyHashable(4)),
            GridItem(AnyView(content().value.5), id: AnyHashable(5))]
    }

    public init<C0: View, C1: View, C2: View, C3: View, C4: View, T: View>(tracks: [TrackSize], spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(C0, C1, ForEach<Range<Int>, Int, T>, C2, C3, C4)> {
        self.trackSizes = tracks
        self.tracksCount = self.trackSizes.count
        self.spacing = spacing
        self.items =
            [GridItem(AnyView(content().value.0), id: AnyHashable(0)),
            GridItem(AnyView(content().value.1), id: AnyHashable(1))]
            + content().value.2.data.map { GridItem(AnyView(content().value.2.content($0)), id: AnyHashable(($0 + 10))) }
            + [GridItem(AnyView(content().value.3), id: AnyHashable(3)),
            GridItem(AnyView(content().value.4), id: AnyHashable(4)),
            GridItem(AnyView(content().value.5), id: AnyHashable(5))]
    }

    public init<C0: View, C1: View, C2: View, C3: View, C4: View, T: View>(tracks: [TrackSize], spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(C0, C1, C2, ForEach<Range<Int>, Int, T>, C3, C4)> {
        self.trackSizes = tracks
        self.tracksCount = self.trackSizes.count
        self.spacing = spacing
        self.items =
            [GridItem(AnyView(content().value.0), id: AnyHashable(0)),
            GridItem(AnyView(content().value.1), id: AnyHashable(1)),
            GridItem(AnyView(content().value.2), id: AnyHashable(2))]
            + content().value.3.data.map { GridItem(AnyView(content().value.3.content($0)), id: AnyHashable(($0 + 10))) }
            + [GridItem(AnyView(content().value.4), id: AnyHashable(4)),
            GridItem(AnyView(content().value.5), id: AnyHashable(5))]
    }

    public init<C0: View, C1: View, C2: View, C3: View, C4: View, T: View>(tracks: [TrackSize], spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(C0, C1, C2, C3, ForEach<Range<Int>, Int, T>, C4)> {
        self.trackSizes = tracks
        self.tracksCount = self.trackSizes.count
        self.spacing = spacing
        self.items =
            [GridItem(AnyView(content().value.0), id: AnyHashable(0)),
            GridItem(AnyView(content().value.1), id: AnyHashable(1)),
            GridItem(AnyView(content().value.2), id: AnyHashable(2)),
            GridItem(AnyView(content().value.3), id: AnyHashable(3))]
            + content().value.4.data.map { GridItem(AnyView(content().value.4.content($0)), id: AnyHashable(($0 + 10))) }
            + [GridItem(AnyView(content().value.5), id: AnyHashable(5))]
    }

    public init<C0: View, C1: View, C2: View, C3: View, C4: View, T: View>(tracks: [TrackSize], spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(C0, C1, C2, C3, C4, ForEach<Range<Int>, Int, T>)> {
        self.trackSizes = tracks
        self.tracksCount = self.trackSizes.count
        self.spacing = spacing
        self.items =
            [GridItem(AnyView(content().value.0), id: AnyHashable(0)),
            GridItem(AnyView(content().value.1), id: AnyHashable(1)),
            GridItem(AnyView(content().value.2), id: AnyHashable(2)),
            GridItem(AnyView(content().value.3), id: AnyHashable(3)),
            GridItem(AnyView(content().value.4), id: AnyHashable(4))]
            + content().value.5.data.map { GridItem(AnyView(content().value.5.content($0)), id: AnyHashable(($0 + 10))) }
    }

    public init<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, T: View>(tracks: [TrackSize], spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(ForEach<Range<Int>, Int, T>, C0, C1, C2, C3, C4, C5)> {
        self.trackSizes = tracks
        self.tracksCount = self.trackSizes.count
        self.spacing = spacing
        self.items =
            content().value.0.data.map { GridItem(AnyView(content().value.0.content($0)), id: AnyHashable(($0 + 10))) }
            + [GridItem(AnyView(content().value.1), id: AnyHashable(1)),
            GridItem(AnyView(content().value.2), id: AnyHashable(2)),
            GridItem(AnyView(content().value.3), id: AnyHashable(3)),
            GridItem(AnyView(content().value.4), id: AnyHashable(4)),
            GridItem(AnyView(content().value.5), id: AnyHashable(5)),
            GridItem(AnyView(content().value.6), id: AnyHashable(6))]
    }

    public init<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, T: View>(tracks: [TrackSize], spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(C0, ForEach<Range<Int>, Int, T>, C1, C2, C3, C4, C5)> {
        self.trackSizes = tracks
        self.tracksCount = self.trackSizes.count
        self.spacing = spacing
        self.items =
            [GridItem(AnyView(content().value.0), id: AnyHashable(0))]
            + content().value.1.data.map { GridItem(AnyView(content().value.1.content($0)), id: AnyHashable(($0 + 10))) }
            + [GridItem(AnyView(content().value.2), id: AnyHashable(2)),
            GridItem(AnyView(content().value.3), id: AnyHashable(3)),
            GridItem(AnyView(content().value.4), id: AnyHashable(4)),
            GridItem(AnyView(content().value.5), id: AnyHashable(5)),
            GridItem(AnyView(content().value.6), id: AnyHashable(6))]
    }

    public init<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, T: View>(tracks: [TrackSize], spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(C0, C1, ForEach<Range<Int>, Int, T>, C2, C3, C4, C5)> {
        self.trackSizes = tracks
        self.tracksCount = self.trackSizes.count
        self.spacing = spacing
        self.items =
            [GridItem(AnyView(content().value.0), id: AnyHashable(0)),
            GridItem(AnyView(content().value.1), id: AnyHashable(1))]
            + content().value.2.data.map { GridItem(AnyView(content().value.2.content($0)), id: AnyHashable(($0 + 10))) }
            + [GridItem(AnyView(content().value.3), id: AnyHashable(3)),
            GridItem(AnyView(content().value.4), id: AnyHashable(4)),
            GridItem(AnyView(content().value.5), id: AnyHashable(5)),
            GridItem(AnyView(content().value.6), id: AnyHashable(6))]
    }

    public init<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, T: View>(tracks: [TrackSize], spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(C0, C1, C2, ForEach<Range<Int>, Int, T>, C3, C4, C5)> {
        self.trackSizes = tracks
        self.tracksCount = self.trackSizes.count
        self.spacing = spacing
        self.items =
            [GridItem(AnyView(content().value.0), id: AnyHashable(0)),
            GridItem(AnyView(content().value.1), id: AnyHashable(1)),
            GridItem(AnyView(content().value.2), id: AnyHashable(2))]
            + content().value.3.data.map { GridItem(AnyView(content().value.3.content($0)), id: AnyHashable(($0 + 10))) }
            + [GridItem(AnyView(content().value.4), id: AnyHashable(4)),
            GridItem(AnyView(content().value.5), id: AnyHashable(5)),
            GridItem(AnyView(content().value.6), id: AnyHashable(6))]
    }

    public init<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, T: View>(tracks: [TrackSize], spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(C0, C1, C2, C3, ForEach<Range<Int>, Int, T>, C4, C5)> {
        self.trackSizes = tracks
        self.tracksCount = self.trackSizes.count
        self.spacing = spacing
        self.items =
            [GridItem(AnyView(content().value.0), id: AnyHashable(0)),
            GridItem(AnyView(content().value.1), id: AnyHashable(1)),
            GridItem(AnyView(content().value.2), id: AnyHashable(2)),
            GridItem(AnyView(content().value.3), id: AnyHashable(3))]
            + content().value.4.data.map { GridItem(AnyView(content().value.4.content($0)), id: AnyHashable(($0 + 10))) }
            + [GridItem(AnyView(content().value.5), id: AnyHashable(5)),
            GridItem(AnyView(content().value.6), id: AnyHashable(6))]
    }

    public init<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, T: View>(tracks: [TrackSize], spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(C0, C1, C2, C3, C4, ForEach<Range<Int>, Int, T>, C5)> {
        self.trackSizes = tracks
        self.tracksCount = self.trackSizes.count
        self.spacing = spacing
        self.items =
            [GridItem(AnyView(content().value.0), id: AnyHashable(0)),
            GridItem(AnyView(content().value.1), id: AnyHashable(1)),
            GridItem(AnyView(content().value.2), id: AnyHashable(2)),
            GridItem(AnyView(content().value.3), id: AnyHashable(3)),
            GridItem(AnyView(content().value.4), id: AnyHashable(4))]
            + content().value.5.data.map { GridItem(AnyView(content().value.5.content($0)), id: AnyHashable(($0 + 10))) }
            + [GridItem(AnyView(content().value.6), id: AnyHashable(6))]
    }

    public init<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, T: View>(tracks: [TrackSize], spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(C0, C1, C2, C3, C4, C5, ForEach<Range<Int>, Int, T>)> {
        self.trackSizes = tracks
        self.tracksCount = self.trackSizes.count
        self.spacing = spacing
        self.items =
            [GridItem(AnyView(content().value.0), id: AnyHashable(0)),
            GridItem(AnyView(content().value.1), id: AnyHashable(1)),
            GridItem(AnyView(content().value.2), id: AnyHashable(2)),
            GridItem(AnyView(content().value.3), id: AnyHashable(3)),
            GridItem(AnyView(content().value.4), id: AnyHashable(4)),
            GridItem(AnyView(content().value.5), id: AnyHashable(5))]
            + content().value.6.data.map { GridItem(AnyView(content().value.6.content($0)), id: AnyHashable(($0 + 10))) }
    }

    public init<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, T: View>(tracks: [TrackSize], spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(ForEach<Range<Int>, Int, T>, C0, C1, C2, C3, C4, C5, C6)> {
        self.trackSizes = tracks
        self.tracksCount = self.trackSizes.count
        self.spacing = spacing
        self.items =
            content().value.0.data.map { GridItem(AnyView(content().value.0.content($0)), id: AnyHashable(($0 + 10))) }
            + [GridItem(AnyView(content().value.1), id: AnyHashable(1)),
            GridItem(AnyView(content().value.2), id: AnyHashable(2)),
            GridItem(AnyView(content().value.3), id: AnyHashable(3)),
            GridItem(AnyView(content().value.4), id: AnyHashable(4)),
            GridItem(AnyView(content().value.5), id: AnyHashable(5)),
            GridItem(AnyView(content().value.6), id: AnyHashable(6)),
            GridItem(AnyView(content().value.7), id: AnyHashable(7))]
    }

    public init<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, T: View>(tracks: [TrackSize], spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(C0, ForEach<Range<Int>, Int, T>, C1, C2, C3, C4, C5, C6)> {
        self.trackSizes = tracks
        self.tracksCount = self.trackSizes.count
        self.spacing = spacing
        self.items =
            [GridItem(AnyView(content().value.0), id: AnyHashable(0))]
            + content().value.1.data.map { GridItem(AnyView(content().value.1.content($0)), id: AnyHashable(($0 + 10))) }
            + [GridItem(AnyView(content().value.2), id: AnyHashable(2)),
            GridItem(AnyView(content().value.3), id: AnyHashable(3)),
            GridItem(AnyView(content().value.4), id: AnyHashable(4)),
            GridItem(AnyView(content().value.5), id: AnyHashable(5)),
            GridItem(AnyView(content().value.6), id: AnyHashable(6)),
            GridItem(AnyView(content().value.7), id: AnyHashable(7))]
    }

    public init<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, T: View>(tracks: [TrackSize], spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(C0, C1, ForEach<Range<Int>, Int, T>, C2, C3, C4, C5, C6)> {
        self.trackSizes = tracks
        self.tracksCount = self.trackSizes.count
        self.spacing = spacing
        self.items =
            [GridItem(AnyView(content().value.0), id: AnyHashable(0)),
            GridItem(AnyView(content().value.1), id: AnyHashable(1))]
            + content().value.2.data.map { GridItem(AnyView(content().value.2.content($0)), id: AnyHashable(($0 + 10))) }
            + [GridItem(AnyView(content().value.3), id: AnyHashable(3)),
            GridItem(AnyView(content().value.4), id: AnyHashable(4)),
            GridItem(AnyView(content().value.5), id: AnyHashable(5)),
            GridItem(AnyView(content().value.6), id: AnyHashable(6)),
            GridItem(AnyView(content().value.7), id: AnyHashable(7))]
    }

    public init<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, T: View>(tracks: [TrackSize], spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(C0, C1, C2, ForEach<Range<Int>, Int, T>, C3, C4, C5, C6)> {
        self.trackSizes = tracks
        self.tracksCount = self.trackSizes.count
        self.spacing = spacing
        self.items =
            [GridItem(AnyView(content().value.0), id: AnyHashable(0)),
            GridItem(AnyView(content().value.1), id: AnyHashable(1)),
            GridItem(AnyView(content().value.2), id: AnyHashable(2))]
            + content().value.3.data.map { GridItem(AnyView(content().value.3.content($0)), id: AnyHashable(($0 + 10))) }
            + [GridItem(AnyView(content().value.4), id: AnyHashable(4)),
            GridItem(AnyView(content().value.5), id: AnyHashable(5)),
            GridItem(AnyView(content().value.6), id: AnyHashable(6)),
            GridItem(AnyView(content().value.7), id: AnyHashable(7))]
    }

    public init<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, T: View>(tracks: [TrackSize], spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(C0, C1, C2, C3, ForEach<Range<Int>, Int, T>, C4, C5, C6)> {
        self.trackSizes = tracks
        self.tracksCount = self.trackSizes.count
        self.spacing = spacing
        self.items =
            [GridItem(AnyView(content().value.0), id: AnyHashable(0)),
            GridItem(AnyView(content().value.1), id: AnyHashable(1)),
            GridItem(AnyView(content().value.2), id: AnyHashable(2)),
            GridItem(AnyView(content().value.3), id: AnyHashable(3))]
            + content().value.4.data.map { GridItem(AnyView(content().value.4.content($0)), id: AnyHashable(($0 + 10))) }
            + [GridItem(AnyView(content().value.5), id: AnyHashable(5)),
            GridItem(AnyView(content().value.6), id: AnyHashable(6)),
            GridItem(AnyView(content().value.7), id: AnyHashable(7))]
    }

    public init<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, T: View>(tracks: [TrackSize], spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(C0, C1, C2, C3, C4, ForEach<Range<Int>, Int, T>, C5, C6)> {
        self.trackSizes = tracks
        self.tracksCount = self.trackSizes.count
        self.spacing = spacing
        self.items =
            [GridItem(AnyView(content().value.0), id: AnyHashable(0)),
            GridItem(AnyView(content().value.1), id: AnyHashable(1)),
            GridItem(AnyView(content().value.2), id: AnyHashable(2)),
            GridItem(AnyView(content().value.3), id: AnyHashable(3)),
            GridItem(AnyView(content().value.4), id: AnyHashable(4))]
            + content().value.5.data.map { GridItem(AnyView(content().value.5.content($0)), id: AnyHashable(($0 + 10))) }
            + [GridItem(AnyView(content().value.6), id: AnyHashable(6)),
            GridItem(AnyView(content().value.7), id: AnyHashable(7))]
    }

    public init<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, T: View>(tracks: [TrackSize], spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(C0, C1, C2, C3, C4, C5, ForEach<Range<Int>, Int, T>, C6)> {
        self.trackSizes = tracks
        self.tracksCount = self.trackSizes.count
        self.spacing = spacing
        self.items =
            [GridItem(AnyView(content().value.0), id: AnyHashable(0)),
            GridItem(AnyView(content().value.1), id: AnyHashable(1)),
            GridItem(AnyView(content().value.2), id: AnyHashable(2)),
            GridItem(AnyView(content().value.3), id: AnyHashable(3)),
            GridItem(AnyView(content().value.4), id: AnyHashable(4)),
            GridItem(AnyView(content().value.5), id: AnyHashable(5))]
            + content().value.6.data.map { GridItem(AnyView(content().value.6.content($0)), id: AnyHashable(($0 + 10))) }
            + [GridItem(AnyView(content().value.7), id: AnyHashable(7))]
    }

    public init<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, T: View>(tracks: [TrackSize], spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(C0, C1, C2, C3, C4, C5, C6, ForEach<Range<Int>, Int, T>)> {
        self.trackSizes = tracks
        self.tracksCount = self.trackSizes.count
        self.spacing = spacing
        self.items =
            [GridItem(AnyView(content().value.0), id: AnyHashable(0)),
            GridItem(AnyView(content().value.1), id: AnyHashable(1)),
            GridItem(AnyView(content().value.2), id: AnyHashable(2)),
            GridItem(AnyView(content().value.3), id: AnyHashable(3)),
            GridItem(AnyView(content().value.4), id: AnyHashable(4)),
            GridItem(AnyView(content().value.5), id: AnyHashable(5)),
            GridItem(AnyView(content().value.6), id: AnyHashable(6))]
            + content().value.7.data.map { GridItem(AnyView(content().value.7.content($0)), id: AnyHashable(($0 + 10))) }
    }

    public init<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View, T: View>(tracks: [TrackSize], spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(ForEach<Range<Int>, Int, T>, C0, C1, C2, C3, C4, C5, C6, C7)> {
        self.trackSizes = tracks
        self.tracksCount = self.trackSizes.count
        self.spacing = spacing
        self.items =
            content().value.0.data.map { GridItem(AnyView(content().value.0.content($0)), id: AnyHashable(($0 + 10))) }
            + [GridItem(AnyView(content().value.1), id: AnyHashable(1)),
            GridItem(AnyView(content().value.2), id: AnyHashable(2)),
            GridItem(AnyView(content().value.3), id: AnyHashable(3)),
            GridItem(AnyView(content().value.4), id: AnyHashable(4)),
            GridItem(AnyView(content().value.5), id: AnyHashable(5)),
            GridItem(AnyView(content().value.6), id: AnyHashable(6)),
            GridItem(AnyView(content().value.7), id: AnyHashable(7)),
            GridItem(AnyView(content().value.8), id: AnyHashable(8))]
    }

    public init<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View, T: View>(tracks: [TrackSize], spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(C0, ForEach<Range<Int>, Int, T>, C1, C2, C3, C4, C5, C6, C7)> {
        self.trackSizes = tracks
        self.tracksCount = self.trackSizes.count
        self.spacing = spacing
        self.items =
            [GridItem(AnyView(content().value.0), id: AnyHashable(0))]
            + content().value.1.data.map { GridItem(AnyView(content().value.1.content($0)), id: AnyHashable(($0 + 10))) }
            + [GridItem(AnyView(content().value.2), id: AnyHashable(2)),
            GridItem(AnyView(content().value.3), id: AnyHashable(3)),
            GridItem(AnyView(content().value.4), id: AnyHashable(4)),
            GridItem(AnyView(content().value.5), id: AnyHashable(5)),
            GridItem(AnyView(content().value.6), id: AnyHashable(6)),
            GridItem(AnyView(content().value.7), id: AnyHashable(7)),
            GridItem(AnyView(content().value.8), id: AnyHashable(8))]
    }

    public init<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View, T: View>(tracks: [TrackSize], spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(C0, C1, ForEach<Range<Int>, Int, T>, C2, C3, C4, C5, C6, C7)> {
        self.trackSizes = tracks
        self.tracksCount = self.trackSizes.count
        self.spacing = spacing
        self.items =
            [GridItem(AnyView(content().value.0), id: AnyHashable(0)),
            GridItem(AnyView(content().value.1), id: AnyHashable(1))]
            + content().value.2.data.map { GridItem(AnyView(content().value.2.content($0)), id: AnyHashable(($0 + 10))) }
            + [GridItem(AnyView(content().value.3), id: AnyHashable(3)),
            GridItem(AnyView(content().value.4), id: AnyHashable(4)),
            GridItem(AnyView(content().value.5), id: AnyHashable(5)),
            GridItem(AnyView(content().value.6), id: AnyHashable(6)),
            GridItem(AnyView(content().value.7), id: AnyHashable(7)),
            GridItem(AnyView(content().value.8), id: AnyHashable(8))]
    }

    public init<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View, T: View>(tracks: [TrackSize], spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(C0, C1, C2, ForEach<Range<Int>, Int, T>, C3, C4, C5, C6, C7)> {
        self.trackSizes = tracks
        self.tracksCount = self.trackSizes.count
        self.spacing = spacing
        self.items =
            [GridItem(AnyView(content().value.0), id: AnyHashable(0)),
            GridItem(AnyView(content().value.1), id: AnyHashable(1)),
            GridItem(AnyView(content().value.2), id: AnyHashable(2))]
            + content().value.3.data.map { GridItem(AnyView(content().value.3.content($0)), id: AnyHashable(($0 + 10))) }
            + [GridItem(AnyView(content().value.4), id: AnyHashable(4)),
            GridItem(AnyView(content().value.5), id: AnyHashable(5)),
            GridItem(AnyView(content().value.6), id: AnyHashable(6)),
            GridItem(AnyView(content().value.7), id: AnyHashable(7)),
            GridItem(AnyView(content().value.8), id: AnyHashable(8))]
    }

    public init<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View, T: View>(tracks: [TrackSize], spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(C0, C1, C2, C3, ForEach<Range<Int>, Int, T>, C4, C5, C6, C7)> {
        self.trackSizes = tracks
        self.tracksCount = self.trackSizes.count
        self.spacing = spacing
        self.items =
            [GridItem(AnyView(content().value.0), id: AnyHashable(0)),
            GridItem(AnyView(content().value.1), id: AnyHashable(1)),
            GridItem(AnyView(content().value.2), id: AnyHashable(2)),
            GridItem(AnyView(content().value.3), id: AnyHashable(3))]
            + content().value.4.data.map { GridItem(AnyView(content().value.4.content($0)), id: AnyHashable(($0 + 10))) }
            + [GridItem(AnyView(content().value.5), id: AnyHashable(5)),
            GridItem(AnyView(content().value.6), id: AnyHashable(6)),
            GridItem(AnyView(content().value.7), id: AnyHashable(7)),
            GridItem(AnyView(content().value.8), id: AnyHashable(8))]
    }

    public init<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View, T: View>(tracks: [TrackSize], spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(C0, C1, C2, C3, C4, ForEach<Range<Int>, Int, T>, C5, C6, C7)> {
        self.trackSizes = tracks
        self.tracksCount = self.trackSizes.count
        self.spacing = spacing
        self.items =
            [GridItem(AnyView(content().value.0), id: AnyHashable(0)),
            GridItem(AnyView(content().value.1), id: AnyHashable(1)),
            GridItem(AnyView(content().value.2), id: AnyHashable(2)),
            GridItem(AnyView(content().value.3), id: AnyHashable(3)),
            GridItem(AnyView(content().value.4), id: AnyHashable(4))]
            + content().value.5.data.map { GridItem(AnyView(content().value.5.content($0)), id: AnyHashable(($0 + 10))) }
            + [GridItem(AnyView(content().value.6), id: AnyHashable(6)),
            GridItem(AnyView(content().value.7), id: AnyHashable(7)),
            GridItem(AnyView(content().value.8), id: AnyHashable(8))]
    }

    public init<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View, T: View>(tracks: [TrackSize], spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(C0, C1, C2, C3, C4, C5, ForEach<Range<Int>, Int, T>, C6, C7)> {
        self.trackSizes = tracks
        self.tracksCount = self.trackSizes.count
        self.spacing = spacing
        self.items =
            [GridItem(AnyView(content().value.0), id: AnyHashable(0)),
            GridItem(AnyView(content().value.1), id: AnyHashable(1)),
            GridItem(AnyView(content().value.2), id: AnyHashable(2)),
            GridItem(AnyView(content().value.3), id: AnyHashable(3)),
            GridItem(AnyView(content().value.4), id: AnyHashable(4)),
            GridItem(AnyView(content().value.5), id: AnyHashable(5))]
            + content().value.6.data.map { GridItem(AnyView(content().value.6.content($0)), id: AnyHashable(($0 + 10))) }
            + [GridItem(AnyView(content().value.7), id: AnyHashable(7)),
            GridItem(AnyView(content().value.8), id: AnyHashable(8))]
    }

    public init<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View, T: View>(tracks: [TrackSize], spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(C0, C1, C2, C3, C4, C5, C6, ForEach<Range<Int>, Int, T>, C7)> {
        self.trackSizes = tracks
        self.tracksCount = self.trackSizes.count
        self.spacing = spacing
        self.items =
            [GridItem(AnyView(content().value.0), id: AnyHashable(0)),
            GridItem(AnyView(content().value.1), id: AnyHashable(1)),
            GridItem(AnyView(content().value.2), id: AnyHashable(2)),
            GridItem(AnyView(content().value.3), id: AnyHashable(3)),
            GridItem(AnyView(content().value.4), id: AnyHashable(4)),
            GridItem(AnyView(content().value.5), id: AnyHashable(5)),
            GridItem(AnyView(content().value.6), id: AnyHashable(6))]
            + content().value.7.data.map { GridItem(AnyView(content().value.7.content($0)), id: AnyHashable(($0 + 10))) }
            + [GridItem(AnyView(content().value.8), id: AnyHashable(8))]
    }

    public init<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View, T: View>(tracks: [TrackSize], spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(C0, C1, C2, C3, C4, C5, C6, C7, ForEach<Range<Int>, Int, T>)> {
        self.trackSizes = tracks
        self.tracksCount = self.trackSizes.count
        self.spacing = spacing
        self.items =
            [GridItem(AnyView(content().value.0), id: AnyHashable(0)),
            GridItem(AnyView(content().value.1), id: AnyHashable(1)),
            GridItem(AnyView(content().value.2), id: AnyHashable(2)),
            GridItem(AnyView(content().value.3), id: AnyHashable(3)),
            GridItem(AnyView(content().value.4), id: AnyHashable(4)),
            GridItem(AnyView(content().value.5), id: AnyHashable(5)),
            GridItem(AnyView(content().value.6), id: AnyHashable(6)),
            GridItem(AnyView(content().value.7), id: AnyHashable(7))]
            + content().value.8.data.map { GridItem(AnyView(content().value.8.content($0)), id: AnyHashable(($0 + 10))) }
    }

    public init<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View, C8: View, T: View>(tracks: [TrackSize], spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(ForEach<Range<Int>, Int, T>, C0, C1, C2, C3, C4, C5, C6, C7, C8)> {
        self.trackSizes = tracks
        self.tracksCount = self.trackSizes.count
        self.spacing = spacing
        self.items =
            content().value.0.data.map { GridItem(AnyView(content().value.0.content($0)), id: AnyHashable(($0 + 10))) }
            + [GridItem(AnyView(content().value.1), id: AnyHashable(1)),
            GridItem(AnyView(content().value.2), id: AnyHashable(2)),
            GridItem(AnyView(content().value.3), id: AnyHashable(3)),
            GridItem(AnyView(content().value.4), id: AnyHashable(4)),
            GridItem(AnyView(content().value.5), id: AnyHashable(5)),
            GridItem(AnyView(content().value.6), id: AnyHashable(6)),
            GridItem(AnyView(content().value.7), id: AnyHashable(7)),
            GridItem(AnyView(content().value.8), id: AnyHashable(8)),
            GridItem(AnyView(content().value.9), id: AnyHashable(9))]
    }

    public init<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View, C8: View, T: View>(tracks: [TrackSize], spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(C0, ForEach<Range<Int>, Int, T>, C1, C2, C3, C4, C5, C6, C7, C8)> {
        self.trackSizes = tracks
        self.tracksCount = self.trackSizes.count
        self.spacing = spacing
        self.items =
            [GridItem(AnyView(content().value.0), id: AnyHashable(0))]
            + content().value.1.data.map { GridItem(AnyView(content().value.1.content($0)), id: AnyHashable(($0 + 10))) }
            + [GridItem(AnyView(content().value.2), id: AnyHashable(2)),
            GridItem(AnyView(content().value.3), id: AnyHashable(3)),
            GridItem(AnyView(content().value.4), id: AnyHashable(4)),
            GridItem(AnyView(content().value.5), id: AnyHashable(5)),
            GridItem(AnyView(content().value.6), id: AnyHashable(6)),
            GridItem(AnyView(content().value.7), id: AnyHashable(7)),
            GridItem(AnyView(content().value.8), id: AnyHashable(8)),
            GridItem(AnyView(content().value.9), id: AnyHashable(9))]
    }

    public init<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View, C8: View, T: View>(tracks: [TrackSize], spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(C0, C1, ForEach<Range<Int>, Int, T>, C2, C3, C4, C5, C6, C7, C8)> {
        self.trackSizes = tracks
        self.tracksCount = self.trackSizes.count
        self.spacing = spacing
        self.items =
            [GridItem(AnyView(content().value.0), id: AnyHashable(0)),
            GridItem(AnyView(content().value.1), id: AnyHashable(1))]
            + content().value.2.data.map { GridItem(AnyView(content().value.2.content($0)), id: AnyHashable(($0 + 10))) }
            + [GridItem(AnyView(content().value.3), id: AnyHashable(3)),
            GridItem(AnyView(content().value.4), id: AnyHashable(4)),
            GridItem(AnyView(content().value.5), id: AnyHashable(5)),
            GridItem(AnyView(content().value.6), id: AnyHashable(6)),
            GridItem(AnyView(content().value.7), id: AnyHashable(7)),
            GridItem(AnyView(content().value.8), id: AnyHashable(8)),
            GridItem(AnyView(content().value.9), id: AnyHashable(9))]
    }

    public init<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View, C8: View, T: View>(tracks: [TrackSize], spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(C0, C1, C2, ForEach<Range<Int>, Int, T>, C3, C4, C5, C6, C7, C8)> {
        self.trackSizes = tracks
        self.tracksCount = self.trackSizes.count
        self.spacing = spacing
        self.items =
            [GridItem(AnyView(content().value.0), id: AnyHashable(0)),
            GridItem(AnyView(content().value.1), id: AnyHashable(1)),
            GridItem(AnyView(content().value.2), id: AnyHashable(2))]
            + content().value.3.data.map { GridItem(AnyView(content().value.3.content($0)), id: AnyHashable(($0 + 10))) }
            + [GridItem(AnyView(content().value.4), id: AnyHashable(4)),
            GridItem(AnyView(content().value.5), id: AnyHashable(5)),
            GridItem(AnyView(content().value.6), id: AnyHashable(6)),
            GridItem(AnyView(content().value.7), id: AnyHashable(7)),
            GridItem(AnyView(content().value.8), id: AnyHashable(8)),
            GridItem(AnyView(content().value.9), id: AnyHashable(9))]
    }

    public init<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View, C8: View, T: View>(tracks: [TrackSize], spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(C0, C1, C2, C3, ForEach<Range<Int>, Int, T>, C4, C5, C6, C7, C8)> {
        self.trackSizes = tracks
        self.tracksCount = self.trackSizes.count
        self.spacing = spacing
        self.items =
            [GridItem(AnyView(content().value.0), id: AnyHashable(0)),
            GridItem(AnyView(content().value.1), id: AnyHashable(1)),
            GridItem(AnyView(content().value.2), id: AnyHashable(2)),
            GridItem(AnyView(content().value.3), id: AnyHashable(3))]
            + content().value.4.data.map { GridItem(AnyView(content().value.4.content($0)), id: AnyHashable(($0 + 10))) }
            + [GridItem(AnyView(content().value.5), id: AnyHashable(5)),
            GridItem(AnyView(content().value.6), id: AnyHashable(6)),
            GridItem(AnyView(content().value.7), id: AnyHashable(7)),
            GridItem(AnyView(content().value.8), id: AnyHashable(8)),
            GridItem(AnyView(content().value.9), id: AnyHashable(9))]
    }

    public init<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View, C8: View, T: View>(tracks: [TrackSize], spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(C0, C1, C2, C3, C4, ForEach<Range<Int>, Int, T>, C5, C6, C7, C8)> {
        self.trackSizes = tracks
        self.tracksCount = self.trackSizes.count
        self.spacing = spacing
        self.items =
            [GridItem(AnyView(content().value.0), id: AnyHashable(0)),
            GridItem(AnyView(content().value.1), id: AnyHashable(1)),
            GridItem(AnyView(content().value.2), id: AnyHashable(2)),
            GridItem(AnyView(content().value.3), id: AnyHashable(3)),
            GridItem(AnyView(content().value.4), id: AnyHashable(4))]
            + content().value.5.data.map { GridItem(AnyView(content().value.5.content($0)), id: AnyHashable(($0 + 10))) }
            + [GridItem(AnyView(content().value.6), id: AnyHashable(6)),
            GridItem(AnyView(content().value.7), id: AnyHashable(7)),
            GridItem(AnyView(content().value.8), id: AnyHashable(8)),
            GridItem(AnyView(content().value.9), id: AnyHashable(9))]
    }

    public init<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View, C8: View, T: View>(tracks: [TrackSize], spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(C0, C1, C2, C3, C4, C5, ForEach<Range<Int>, Int, T>, C6, C7, C8)> {
        self.trackSizes = tracks
        self.tracksCount = self.trackSizes.count
        self.spacing = spacing
        self.items =
            [GridItem(AnyView(content().value.0), id: AnyHashable(0)),
            GridItem(AnyView(content().value.1), id: AnyHashable(1)),
            GridItem(AnyView(content().value.2), id: AnyHashable(2)),
            GridItem(AnyView(content().value.3), id: AnyHashable(3)),
            GridItem(AnyView(content().value.4), id: AnyHashable(4)),
            GridItem(AnyView(content().value.5), id: AnyHashable(5))]
            + content().value.6.data.map { GridItem(AnyView(content().value.6.content($0)), id: AnyHashable(($0 + 10))) }
            + [GridItem(AnyView(content().value.7), id: AnyHashable(7)),
            GridItem(AnyView(content().value.8), id: AnyHashable(8)),
            GridItem(AnyView(content().value.9), id: AnyHashable(9))]
    }

    public init<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View, C8: View, T: View>(tracks: [TrackSize], spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(C0, C1, C2, C3, C4, C5, C6, ForEach<Range<Int>, Int, T>, C7, C8)> {
        self.trackSizes = tracks
        self.tracksCount = self.trackSizes.count
        self.spacing = spacing
        self.items =
            [GridItem(AnyView(content().value.0), id: AnyHashable(0)),
            GridItem(AnyView(content().value.1), id: AnyHashable(1)),
            GridItem(AnyView(content().value.2), id: AnyHashable(2)),
            GridItem(AnyView(content().value.3), id: AnyHashable(3)),
            GridItem(AnyView(content().value.4), id: AnyHashable(4)),
            GridItem(AnyView(content().value.5), id: AnyHashable(5)),
            GridItem(AnyView(content().value.6), id: AnyHashable(6))]
            + content().value.7.data.map { GridItem(AnyView(content().value.7.content($0)), id: AnyHashable(($0 + 10))) }
            + [GridItem(AnyView(content().value.8), id: AnyHashable(8)),
            GridItem(AnyView(content().value.9), id: AnyHashable(9))]
    }

    public init<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View, C8: View, T: View>(tracks: [TrackSize], spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(C0, C1, C2, C3, C4, C5, C6, C7, ForEach<Range<Int>, Int, T>, C8)> {
        self.trackSizes = tracks
        self.tracksCount = self.trackSizes.count
        self.spacing = spacing
        self.items =
            [GridItem(AnyView(content().value.0), id: AnyHashable(0)),
            GridItem(AnyView(content().value.1), id: AnyHashable(1)),
            GridItem(AnyView(content().value.2), id: AnyHashable(2)),
            GridItem(AnyView(content().value.3), id: AnyHashable(3)),
            GridItem(AnyView(content().value.4), id: AnyHashable(4)),
            GridItem(AnyView(content().value.5), id: AnyHashable(5)),
            GridItem(AnyView(content().value.6), id: AnyHashable(6)),
            GridItem(AnyView(content().value.7), id: AnyHashable(7))]
            + content().value.8.data.map { GridItem(AnyView(content().value.8.content($0)), id: AnyHashable(($0 + 10))) }
            + [GridItem(AnyView(content().value.9), id: AnyHashable(9))]
    }

    public init<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View, C8: View, T: View>(tracks: [TrackSize], spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(C0, C1, C2, C3, C4, C5, C6, C7, C8, ForEach<Range<Int>, Int, T>)> {
        self.trackSizes = tracks
        self.tracksCount = self.trackSizes.count
        self.spacing = spacing
        self.items =
            [GridItem(AnyView(content().value.0), id: AnyHashable(0)),
            GridItem(AnyView(content().value.1), id: AnyHashable(1)),
            GridItem(AnyView(content().value.2), id: AnyHashable(2)),
            GridItem(AnyView(content().value.3), id: AnyHashable(3)),
            GridItem(AnyView(content().value.4), id: AnyHashable(4)),
            GridItem(AnyView(content().value.5), id: AnyHashable(5)),
            GridItem(AnyView(content().value.6), id: AnyHashable(6)),
            GridItem(AnyView(content().value.7), id: AnyHashable(7)),
            GridItem(AnyView(content().value.8), id: AnyHashable(8))]
            + content().value.9.data.map { GridItem(AnyView(content().value.9.content($0)), id: AnyHashable(($0 + 10))) }
    }
}
