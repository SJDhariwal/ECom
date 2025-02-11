//
//  AsyncCacheImage.swift
//  eCom
//
//  Created by Sumit Kumar Jangra on 04/02/25.
//

import Combine
import SwiftUI

struct AsyncCacheImage: View {
    @State private var viewModel: AsyncCacheImageViewModel
    private let placeholder: Image
    
    init(url: URL?, placeholder: Image = .init(systemName: "photo")) {
        self.viewModel =  AsyncCacheImageViewModel(url: url)
        self.placeholder = placeholder
    }
    
    var body: some View {
        imageView
            .onAppear {
                viewModel.loadImage()
            }
    }
    
    private var imageView: some View {
        Group {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                placeholder
            }
        }
    }
}

@Observable
class AsyncCacheImageViewModel {
    var image: UIImage? = nil
    
    private let url: URL?
    private let cache: ImageCacheProtocol
    private var cancellable: AnyCancellable? = nil
    
    init(url: URL?, cache: ImageCacheProtocol = ImageCache.shared) {
        self.url = url
        self.cache = cache
    }
    
    func loadImage() {
        guard let url else { return }
        if let cachedData = cache.image(for: url.absoluteString) {
            let cachedImage = UIImage(data: cachedData)
            self.image = cachedImage
            return
        }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] image in
                guard let self else { return }
                self.image = image
                self.cache.insert(image?.pngData(), for: url.absoluteString)
            }
    }
}
