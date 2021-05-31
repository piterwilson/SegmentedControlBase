//
//  SwiftUIView.swift
//  
//
//  Created by Juan Carlos Ospina Gonzalez on 31/05/2021.
//

import SwiftUI

/// A preference key used by `BackgroundGeometryReader` to store the size of a `View` to its parent
struct SizePreferenceKey: PreferenceKey {
    typealias Value = CGSize
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

/// A  transparent background `View` that stores its size in `SizePreferenceKey`
struct BackgroundGeometryReader: View {
    var body: some View {
        GeometryReader { geometry in
            return Color
                    .clear
                    .preference(key: SizePreferenceKey.self, value: geometry.size)
        }
    }
}

/// A `ViewModifier` that provides a binding to share the size of its content
struct SizeAwareViewModifier: ViewModifier {
    @Binding private var viewSize: CGSize
    init(viewSize: Binding<CGSize>) {
        self._viewSize = viewSize
    }
    func body(content: Content) -> some View {
        content
            .background(BackgroundGeometryReader())
            .onPreferenceChange(SizePreferenceKey.self, perform: { if self.viewSize != $0 { self.viewSize = $0 }})
    }
}
