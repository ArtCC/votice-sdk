# Votice SDK

| <img src="assets/light_icon.png" alt="Votice Icon" width="120" /> | 🗳️ A lightweight native Swift SDK to collect suggestions, feedback, and votes directly within your iOS or iPadOS app. |
|:---:|:---|

[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org/)
[![Platforms](https://img.shields.io/badge/Platforms-iOS%2017%2B%20%7C%20iPadOS%2017%2B-lightgrey)](#)
[![SPM](https://img.shields.io/badge/SPM-compatible-brightgreen)](https://swift.org/package-manager/)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)

Votice is a native Swift SDK that allows you to integrate user feedback, suggestion boards, and voting mechanisms in your app with a clean UI and a simple setup. It connects to a custom backend using HMAC authentication and does not require Firebase or GoogleService-Info.plist.

---

## ✅ Requirements

- iOS 17+ / iPadOS 17+
- Swift 5.9+
- SwiftUI-based project
- Votice backend properly configured (API key + secret)

> ⚠️ Support for macOS and tvOS will be available in future releases.

---

## 🛠 Installation

Add this line to your `Package.swift` dependencies:

```swift
.package(url: "https://github.com/artcc/votice-sdk", from: "1.0.0"),
```

Or via Xcode:

1. Open your project.
2. Go to **File > Add Packages...**
3. Enter the URL of the Votice repo.
4. Choose the latest version.

## 📦 Package Info

```swift
// swift-tools-version:5.9
let package = Package(
    name: "Votice",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .tvOS(.v17),
        .watchOS(.v10)
    ],
    products: [
        .library(name: "Votice", targets: ["Votice"])
    ],
    targets: [
        .target(name: "Votice", path: "Sources/Votice"),
        .testTarget(name: "VoticeTests", dependencies: ["Votice"], path: "Tests/VoticeTests")
    ]
)
```

---

## 🚀 Getting Started

### 1. Configure the SDK

Before using any Votice component, configure it with your app credentials:

```swift
try Votice.configure(
    apiKey: "your-api-key",
    apiSecret: "your-api-secret",
    appId: "your-app-id" // optional, defaults to "default"
)
```

You can reset or check configuration status:

```swift
Votice.reset()
let configured = Votice.isConfigured
```

---

### 2. Show the Feedback UI

You can embed the main interface as a SwiftUI view:

```swift
Votice.feedbackView()
```

Or present it as a modal sheet:

```swift
Votice.feedbackSheet(isPresented: $isShowingFeedback)
```

---

### 3. Customize Appearance

Use the default system-adaptive theme:

```swift
let theme = Votice.systemTheme()
```

Or create your own theme:

```swift
let theme = Votice.createTheme(
    primaryColor: .blue,
    backgroundColor: .white,
    surfaceColor: .gray.opacity(0.1)
)
```

Advanced configuration is also available:

```swift
let advancedTheme = Votice.createAdvancedTheme(
    primaryColor: .blue,
    successColor: .green,
    errorColor: .red,
    acceptedColor: .blue,
    rejectedColor: .red
)
```

Then pass it into the view:

```swift
Votice.feedbackView(theme: theme)
```

---

### 4. Localize Texts (Optional)

You can provide custom localized texts by conforming to `VoticeTextsProtocol`:

```swift
Votice.setTexts(MyCustomTexts())
```

To reset to the default English:

```swift
Votice.resetTextsToDefault()
```

---

## 👤 Author

Arturo Carretero Calvo

[@artcc](https://github.com/artcc)

---

## License

[Apache License](LICENSE)

---

**Arturo Carretero Calvo - 2025**
