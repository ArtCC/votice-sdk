//
//  CreateSuggestionView+Functions.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/9/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import SwiftUI

extension CreateSuggestionView {
#if os(macOS)
    func handleImageDrop(providers: [NSItemProvider]) -> Bool {
        guard let provider = providers.first else {
            return false
        }

        if provider.canLoadObject(ofClass: NSImage.self) {
            provider.loadObject(ofClass: NSImage.self) { image, _ in
                if let nsImage = image as? NSImage,
                   let imageData = nsImage.tiffRepresentation,
                   let bitmap = NSBitmapImageRep(data: imageData),
                   let jpegData = bitmap.representation(using: .jpeg, properties: [:]) {
                    DispatchQueue.main.async {
                        if let compressedData = compressImageData(jpegData) {
                            viewModel.setIssueImage(compressedData)
                        }
                    }
                }
            }

            return true
        }

        if provider.hasItemConformingToTypeIdentifier("public.file-url") {
            provider.loadItem(forTypeIdentifier: "public.file-url", options: nil) { item, _ in
                if let data = item as? Data,
                   let url = URL(dataRepresentation: data, relativeTo: nil),
                   let imageData = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        if let compressedData = compressImageData(imageData) {
                            viewModel.setIssueImage(compressedData)
                        }
                    }
                }
            }

            return true
        }

        return false
    }

    func openImagePicker() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.image]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.canChooseFiles = true

        if panel.runModal() == .OK, let url = panel.url {
            do {
                let imageData = try Data(contentsOf: url)

                if let compressedData = compressImageData(imageData) {
                    viewModel.setIssueImage(compressedData)
                }
            } catch {
                LogManager.shared.devLog(.error, "CreateSuggestionView: openImagePicker: error: \(error)")
            }
        }
    }
#endif
}

extension CreateSuggestionView {
    func compressImageData(_ data: Data) -> Data? {
#if os(iOS)
        guard let sourceImage = UIImage(data: data) else {
            return nil
        }

        return sourceImage.jpegData(compressionQuality: 0.75)
#elseif os(macOS)
        guard let sourceImage = NSImage(data: data) else {
            return nil
        }

        guard let tiffData = sourceImage.tiffRepresentation, let bitmap = NSBitmapImageRep(data: tiffData) else {
            return nil
        }

        return bitmap.representation(using: .jpeg, properties: [.compressionFactor: 0.75])
#else
        return data
#endif
    }
}
