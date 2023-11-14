//
//  NetplixImageDownloadManager.swift
//  Netplix
//
//  Created by Octo Siswardhono on 11/11/23.
//

import UIKit

enum NetplixImageDownloaderConstants {
    static let path = "NetplixImageDownloadCache"
    static let memoryCache = 20 * 1024 * 1024
    static let discCache = 100 * 1024 * 1024
    static let errorDomain = "NetplixError"
}

public typealias NetplixImageDownloadCompletion = (UIImage?, Error?, URL?) -> Void

public enum ImageError: Error {
    case badUrl
    case badImage
    case badNetwork
}

public class NetplixImageSession {

    let session: URLSession
    let urlCache = URLCache(memoryCapacity: NetplixImageDownloaderConstants.memoryCache,
                            diskCapacity: NetplixImageDownloaderConstants.discCache,
                            diskPath: NetplixImageDownloaderConstants.path)
    
    init() {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.requestCachePolicy = NSURLRequest.CachePolicy.useProtocolCachePolicy
        sessionConfiguration.urlCache = urlCache
        session = URLSession(configuration: sessionConfiguration)
    }
    
    @discardableResult public func download(with url: URL, isCache: Bool, completed:@escaping (Result<UIImage?, ImageError>) -> Void) -> URLSessionDataTask?{
        
        let urlRequest = URLRequest(url: url, cachePolicy: NSURLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 60.0)
        
        if let cache = urlCache.cachedResponse(for: urlRequest), isCache  {
            if let newImage = UIImage(data: cache.data) {
                completed(.success(newImage))
            } else {
                completed(.failure(.badImage))
            }
            return nil
        }
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            if let _ = error {
                completed(.failure(.badNetwork))
            } else if let response = response as? HTTPURLResponse, response.statusCode >= 400 {
                completed(.failure(.badNetwork))
            } else if let data = data, let newImage = UIImage(data: data) {
                completed(.success(newImage))
            } else {
                completed(.failure(.badImage))
            }
        }
        
        task.resume()
        return task
    }
}

public let imageSession = NetplixImageSession()

extension UIImageView {
    
    private struct AssociatedKey {
        static var netplixImageURL = "netplixImageUrl"
    }

    var netplixImageURL: String {
        get {
            withUnsafePointer(to: &AssociatedKey.netplixImageURL) {
                return objc_getAssociatedObject(self, $0) as? String ?? ""
            }
        }
        set {
            withUnsafePointer(to: &AssociatedKey.netplixImageURL) {
                objc_setAssociatedObject(self, $0, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
      }
    
    public func setImage(
        with imageUrl: String,
        placeholder: UIImage? = nil,
        transition: ImageTransition = .none,
        isCache: Bool? = true,
        completed: NetplixImageDownloadCompletion? = nil
        ) {
     
        self.runOnMainThread { [weak self]() -> Void in
            self?.image = placeholder
            self?.layoutIfNeeded()
        }
        
        guard
            let url = URL(string: "https://image.tmdb.org/t/p/w500\(imageUrl)")
        else {
            return
        }
        
        self.netplixImageURL = url.absoluteString
     
        self.runOnMainThread {
            imageSession.download(with: url, isCache: isCache ?? true, completed: { [weak self] result in
                switch result {
                case .success(let image):
                    self?.runOnMainThread { () -> Void in
                        guard
                            let strongSelf = self, strongSelf.netplixImageURL == url.absoluteString
                        else {
                            return
                        }
                        
                        if isCache ?? true {
                            ImageTransition.none.transform(imageView: strongSelf, image: image ?? UIImage())
                        } else {
                            transition.transform(imageView: strongSelf, image: image ?? UIImage())
                        }
                        completed?(image, nil, url)
                    }
                case .failure(let error):
                    completed?(nil, error, nil)
                }
            })
        }
    }
    
    public func clearDownloadTask() {
        netplixImageURL = ""
    }
    
    private func runOnMainThread(block: (() -> (Void))?) {
        if Thread.isMainThread {
            block?()
        } else {
            DispatchQueue.main.async {
                block?()
            }
        }
    }
}

private func errorDownloadingImage() -> NSError {
    let userInfo: [String : Any] = [
        NSLocalizedDescriptionKey :  "Error downloading image",
        NSLocalizedFailureReasonErrorKey : "Error downloading image from Server"
    ]
    
    let error = NSError(domain: NetplixImageDownloaderConstants.errorDomain, code: 520, userInfo: userInfo)
    return error
}

public enum ImageTransition {
    case none
    case fade
    case custom(transition: (UIImageView, UIImage) -> Void)
    
    
    public func transform(imageView: UIImageView, image: UIImage) {
        switch self {
        case .none:
            imageView.image = image
        case .fade:
            UIView.transition(with: imageView, duration: 0.3, options: [.transitionCrossDissolve, .allowUserInteraction], animations: {
                imageView.image = image
            }, completion: nil)
        case .custom(let transition):
            transition(imageView, image)
        }
    }
}


