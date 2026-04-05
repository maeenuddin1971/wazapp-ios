import SwiftUI

/// Returns the top safe-area inset of the key window.
/// Works correctly even when the parent view uses `.ignoresSafeArea(.container, edges: .top)`.
var topSafeAreaInset: CGFloat {
    guard let windowScene = UIApplication.shared.connectedScenes
        .compactMap({ $0 as? UIWindowScene }).first,
          let window = windowScene.windows.first(where: \.isKeyWindow)
    else { return 54 } // fallback for previews / tests
    return window.safeAreaInsets.top
}
