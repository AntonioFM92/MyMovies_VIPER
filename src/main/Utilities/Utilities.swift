//
//  Utilities.swift
//  MyMovie
//
//  Created by Antonio Fernández Martín on 27/08/2019.
//  Copyright © 2019 Antonio Fernández Martín. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    
    static func getParametersSearchMovie(movieTitle: String) -> [String:String]{
        return ["s":movieTitle, "apikey": Environment.apiKey]
    }
    
    static func getParametersSearchMovieDetail(movieID: String) -> [String:String]{
        return ["i":movieID, "apikey": Environment.apiKey]
    }
    
    //Load movieImage or image by default
    static func checkImageUrl(imageURL: String) -> String {
        let urlString = !imageURL.isEmpty ? imageURL : "https://via.placeholder.com/150"
        return urlString
    }
    
    static func showAlert(vc: UIViewController) {
        let refreshAlert = UIAlertController(title: NSLocalizedString("Info", comment: ""), message: NSLocalizedString("errorLoading", comment: ""), preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .cancel, handler: nil))
        
        vc.present(refreshAlert, animated: true, completion: nil)
    }
    
    
    
    func topViewController()-> UIViewController{
        var topViewController:UIViewController = UIApplication.shared.keyWindow!.rootViewController!

        while ((topViewController.presentedViewController) != nil) {
            topViewController = topViewController.presentedViewController!;
        }

        return topViewController
    }
    
    func showShareActivity(msg:String?, image:UIImage?, url:String?, sourceRect:CGRect?){
        var objectsToShare = [AnyObject]()

        if let url = url {
            objectsToShare = [url as AnyObject]
        }

        if let image = image {
            objectsToShare = [image as AnyObject]
        }

        if let msg = msg {
            objectsToShare = [msg as AnyObject]
        }

        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.modalPresentationStyle = .popover
        activityVC.popoverPresentationController?.sourceView = topViewController().view
        if let sourceRect = sourceRect {
            activityVC.popoverPresentationController?.sourceRect = sourceRect
        }

        topViewController().present(activityVC, animated: true, completion: nil)
    }
}


extension UIImageView {
    
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
    
    //ParentView of UIImageView
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    func setSaveGesture() {
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressed(_:)))
        self.addGestureRecognizer(longGesture)
    }
    
    @objc func longPressed(_ sender: UILongPressGestureRecognizer? = nil) {
        
        let alert = UIAlertController(title: NSLocalizedString("saveImage", comment: ""), message: NSLocalizedString("saveMessage", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: {
            action in UIImageWriteToSavedPhotosAlbum(self.image!, nil, nil, nil)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("no", comment: ""), style: .cancel, handler: nil))
        
        self.parentViewController!.present(alert, animated: true)
        
    }
    
}


extension UITextView {
    
    //ParentView of UITextView
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    func setAsLink(value: String) {
        let attributedString = NSMutableAttributedString(string: value, attributes:[NSAttributedString.Key.link: URL(string: value) ?? ""])
        self.attributedText = attributedString
    }
    
    func setTappable(value: String) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapped(_:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapped(_ sender: UITapGestureRecognizer? = nil) {
        if !self.text.isEmpty {
            let urlToOpen = URL(string: self.text)!
            
            let activityViewController = UIActivityViewController(activityItems: [urlToOpen], applicationActivities: nil)
            self.parentViewController!.present(activityViewController, animated: true)
        }
    }
    
}


var loadingView : UIView?

extension UIViewController {
    
    func showProgress(onView: UIView) {
        if loadingView == nil {
            let loadingProgressView = UIView.init(frame: onView.bounds)
            loadingProgressView.backgroundColor = UIColor.init(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.3)
            
            let indicatorView = UIActivityIndicatorView.init(style: .whiteLarge)
            indicatorView.startAnimating()
            indicatorView.center = loadingProgressView.center
            
            DispatchQueue.main.async {
                loadingProgressView.addSubview(indicatorView)
                onView.addSubview(loadingProgressView)
            }
            
            loadingView = loadingProgressView
        }
    }
    
    func removeProgress() {
        DispatchQueue.main.async {
            loadingView?.removeFromSuperview()
            loadingView = nil
        }
    }
    
}
