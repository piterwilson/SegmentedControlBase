//
//  SegmentedControlBase.swift
//
//
//  Created by Juan Carlos Ospina Gonzalez on 31/05/2021.
//
import SwiftUI
/**
 `SegmentedControlBase` is a base (SwiftUI) `View` that can be used to construct custom segment control components.
  
 A Segmented control is a component used to display "segments" (choices) and a background indicating the active segment (chosen by the user). This background **slides** to a new position when the selected segment changes.
  
 The component has properties to configure the values for the segments (`segments`) as well as a two way binding to the control's selected segment index (`selectedSegmentIndex`). Additionally there's a 2 way binding to control whether the segment control is enabled or not (`isEnabled`).
  
 The `View` used to display each segment are specified with the `segmentBuilder` view builder. This view builder is passed three parameters: the first parameter passed is a `String` contaning a value for the segment being displayed.  the second parameter is a `Bool` indicating whether the segment is selected or not and the third parameter is a `Bool` indicating whether or not the control is enabled.
  
 The background view for the active is specified with the `activeSegmentBackgroundBuilder` view builder. This view builder is passed a parameter (`Bool`)  indicating whether or not the control is enabled.

 **Example**
 ```swift
 /// A sample implementation of `SegmentedControlBase`
 struct ExampleSegmentedControl: View {
     /// Data source for the segments in the control
     @State var segments: [String]
     /// A `Int` indicating which segement is selected
     @State var selection: Int = 0
     /// Indicates whether or not `ExampleSegmentedControl` is enabled
     @State var isEnabled: Bool = true
     var body: some View {
         SegmentedControlBase(
             segments: self.segments,
             selectedIndex: self.$selection,
             isEnabled: self.$isEnabled,
             interimSpace: 5.0,
             segmentBuilder: { (text, isSelected, isEnabled) in
                 Text(text)
                     .foregroundColor(isEnabled ? isSelected ? .blue : .gray : .gray)
                     .opacity(isEnabled ? 1.0 : 0.5)
             },
             activeSegmentBackgroundBuilder: {(isEnabled) in
                 Capsule()
                     .foregroundColor(isEnabled ? .primary : .secondary)
                     .opacity(isEnabled ? 1.0 : 0.5)
             })
     }
 }
 ```
 */
public struct SegmentedControlBase<Segment: View, SegmentBackground: View>: View {
    
    // MARK: Properties
    // MARK: Private
    /// Computed property that calculates the x position offset for the active segment background view
    private var activeSegmentXBackgroundOffsset: CGFloat {
        segmentSize.width * CGFloat(selectedSegmentIndex)
    }
    /// property that holds the size each segement has to have in order to split the available (horizontal) space evenly. This value is populated by `SizeAwareViewModifier` which is a view that can pass its calculated size up to its parent using `SizePreferenceKey`.
    @State private var segmentSize: CGSize = .zero
    
    // MARK: Public
    /// Data source for the segments in the control
    @State public var segments: [String]
    /// Selected index in the control
    @Binding public var selectedSegmentIndex: Int
    /// Whether or not the control is enabled
    @Binding public var isEnabled: Bool
    /// Amount of space between segments
    @State public var interimSpace: CGFloat
    /// A function that builds the views used for each of the segments. The first parameter passed is a `String` contaning a value for `segments`, the second parameter is a `Bool` indicating whether the segment is selected or not and the third parameter is a `Bool` indicating whether or not the control is enabled.
    @ViewBuilder
    public var segmentBuilder: (String /* Text */, Bool /* isSelected */, Bool /* isEnabled */ ) -> Segment
    /// A function that builds the view used as the background for the active segment. The parameter is a `Bool` indicating whether or not the control is enabled.
    @ViewBuilder
    public var activeSegmentBackgroundBuilder: (Bool /* isEnabled */) -> SegmentBackground
    
    public init(
        segments: [String],
        selectedIndex: Binding<Int>,
        isEnabled: Binding<Bool>,
        interimSpace: CGFloat = 0.0,
        segmentBuilder: @escaping (String /* Text */, Bool /* isSelected */, Bool /* isEnabled */ ) -> Segment,
        activeSegmentBackgroundBuilder: @escaping (Bool /* isEnabled */) -> SegmentBackground) {
        self.segments = segments
        self._selectedSegmentIndex = selectedIndex
        self._isEnabled = isEnabled
        self.interimSpace = interimSpace
        self.segmentBuilder = segmentBuilder
        self.activeSegmentBackgroundBuilder = activeSegmentBackgroundBuilder
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // active segment background
                activeSegmentBackgroundBuilder(self.isEnabled)
                    .frame(width: segmentSize.width)
                    .offset(x: activeSegmentXBackgroundOffsset)
                
                HStack(spacing: 0.0) {
                    ForEach(0 ..< segments.count) { index in
                        Button(
                            action: {
                                withAnimation {
                                    guard self.isEnabled else {
                                        return
                                    }
                                    self.selectedSegmentIndex = index
                                }
                            },
                            label: {
                                segmentBuilder(
                                    segments[index],
                                    self.selectedSegmentIndex == index,
                                    self.isEnabled)
                            })
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding(EdgeInsets(top: 0.0, leading: index == 0 ? 0.0 : interimSpace, bottom: 0.0, trailing: 0.0))
                            .modifier(SizeAwareViewModifier(viewSize: self.$segmentSize))
                    }
                }
            }
        }
    }
}

/// A sample implementation of `SegmentedControlBase`
struct ExampleSegmentedControl: View {
    /// Data source for the segments in the control
    @State var segments: [String]
    /// A `Int` indicating which segement is selected
    @State var selection: Int = 0
    /// Indicates whether or not `ExampleSegmentedControl` is enabled
    @State var isEnabled: Bool = true
    var body: some View {
        SegmentedControlBase(
            segments: self.segments,
            selectedIndex: self.$selection,
            isEnabled: self.$isEnabled,
            interimSpace: 5.0,
            segmentBuilder: { (text, isSelected, isEnabled) in
                Text(text)
                    .foregroundColor(isEnabled ? isSelected ? .blue : .gray : .gray)
                    .opacity(isEnabled ? 1.0 : 0.5)
            },
            activeSegmentBackgroundBuilder: {(isEnabled) in
                Capsule()
                    .foregroundColor(isEnabled ? .primary : .secondary)
                    .opacity(isEnabled ? 1.0 : 0.5)
            })
    }
}

struct SegmentedControl_Previews: PreviewProvider {
    @State static var selection: Int = 0
    static var previews: some View {
        Group {
            ExampleSegmentedControl(segments: ["M", "T", "W", "T", "F"])
                .background(Color(.systemBackground))
                .previewLayout(.fixed(width: 320.0, height: 37.0))
                .environment(\.colorScheme, .light)
            
            ExampleSegmentedControl(segments: ["M", "T", "W", "T", "F"], isEnabled: false)
                .background(Color(.systemBackground))
                .previewLayout(.fixed(width: 320.0, height: 37.0))
                .environment(\.colorScheme, .light)
            
            ExampleSegmentedControl(segments: ["M", "T", "W", "T", "F"])
                .background(Color(.systemBackground))
                .previewLayout(.fixed(width: 320.0, height: 37.0))
                .environment(\.colorScheme, .dark)
            
            ExampleSegmentedControl(segments: ["M", "T", "W", "T", "F"], isEnabled: false)
                .background(Color(.systemBackground))
                .previewLayout(.fixed(width: 320.0, height: 37.0))
                .environment(\.colorScheme, .dark)
        }
    }
}
