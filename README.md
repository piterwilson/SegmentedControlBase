# SegmentedControlBase

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
