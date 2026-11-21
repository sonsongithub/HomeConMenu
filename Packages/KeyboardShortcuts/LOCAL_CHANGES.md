# HomeConMenu AppKit-only KeyboardShortcuts

Source: https://github.com/sonsongithub/KeyboardShortcuts.git
Branch: without-swiftui
Revision: cfdd47815a8550ce29c09a12aa51c9b29292a627
License: MIT (see license).

This local package preserves the pinned implementation, tests and localization resources.
It removes Recorder.swift and ViewModifiers.swift, replaces the SwiftUI import in
Utilities.swift with AppKit, and removes its SwiftUI form-label helpers.
RecorderCocoa and shortcut handling remain unchanged.

The macOS bridge loads inside a Mac Catalyst process. Linking the macOS-only
NSViewRepresentable protocol into that bridge fails when SwiftUI resolves to the
Catalyst framework. Keep executable SwiftUI code out of this package when updating.
SwiftUI examples in documentation comments are not compiled.

After updates, build HomeConMenu and inspect the bridge's undefined symbols for
NSViewRepresentable, then verify launch, shortcut recording and shortcut execution.
