//
//  UIKit.swift
//  Twiletter
//
//  Created by subdiox on 2017/12/08.
//  Copyright © 2017年 subdiox. All rights reserved.
//

import UIKit
import SKPhotoBrowser

extension UIApplication {
    var topViewController: UIViewController? {
        guard var topViewController = UIApplication.shared.keyWindow?.rootViewController else { return nil }
        
        while let presentedViewController = topViewController.presentedViewController {
            topViewController = presentedViewController
        }
        return topViewController
    }
    
    var topNavigationController: UINavigationController? {
        return topViewController as? UINavigationController
    }
}

extension UIAlertController {
    
    func addAction(title: String, style: UIAlertActionStyle = .default, handler: ((UIAlertAction) -> Void)? = nil) -> Self {
        let okAction = UIAlertAction(title: title, style: style, handler: handler)
        addAction(okAction)
        return self
    }
    
    func addActionWithTextFields(title: String, style: UIAlertActionStyle = .default, handler: ((UIAlertAction, [UITextField]) -> Void)? = nil) -> Self {
        let okAction = UIAlertAction(title: title, style: style) { [weak self] action in
            handler?(action, self?.textFields ?? [])
        }
        addAction(okAction)
        return self
    }
    
    func configureForIPad(sourceRect: CGRect, sourceView: UIView? = nil) -> Self {
        popoverPresentationController?.sourceRect = sourceRect
        if let sourceView = UIApplication.shared.topViewController?.view {
            popoverPresentationController?.sourceView = sourceView
        }
        return self
    }
    
    func configureForIPad(barButtonItem: UIBarButtonItem) -> Self {
        popoverPresentationController?.barButtonItem = barButtonItem
        return self
    }
    
    func addTextField(handler: @escaping (UITextField) -> Void) -> Self {
        addTextField(configurationHandler: handler)
        return self
    }
    
    func show(on: UIViewController = UIApplication.shared.topViewController!) {
        on.present(self, animated: true, completion: nil)
    }
}

extension NSObject {
    func viewController(id: String, storyboard: String = "Main") -> UIViewController {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: id)
    }
}

extension UIButton {
    func setTemplate(color: UIColor? = nil) {
        let image = self.imageView?.image
        let template = image?.withRenderingMode(.alwaysTemplate)
        self.setImage(template, for: .normal)
        if let color = color {
            self.tintColor = color
        }
    }
    
    /*
     position 0 ... fill super view
     position 1 ... left half of super view
     position 2 ... right half of super view
     position 3 ... left-top of super view
     position 4 ... right-top of super view
     position 5 ... left-bottom of super view
     position 6 ... right-bottom of super view
     */
    convenience init(url: URL) {
        self.init()
        self.af_setImage(for: .normal, url: url)
        self.imageView?.contentMode = .scaleAspectFill
        self.clipsToBounds = true
        self.layer.cornerRadius = 8
        self.contentHorizontalAlignment = .fill
        self.contentVerticalAlignment = .fill
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension UIImageView {
    func setTemplate(color: UIColor? = nil) {
        let image = self.image
        let template = image?.withRenderingMode(.alwaysTemplate)
        self.image = template
        if let color = color {
            self.tintColor = color
        }
    }
}


extension UIView {
    func removeAllSubviews() {
        let subviews = self.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
    
    func addSubview(_ view: UIView, position: Int) {
        self.addSubview(view)
        
        let space: CGFloat = 5.0
        switch position {
        case 0:
            view.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        case 1:
            view.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
            view.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5, constant: -space / 2).isActive = true
        case 2:
            view.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
            view.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5, constant: -space / 2).isActive = true
        case 3:
            view.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
            view.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5, constant: -space / 2).isActive = true
            view.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5, constant: -space / 2).isActive = true
        case 4:
            view.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
            view.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5, constant: -space / 2).isActive = true
            view.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5, constant: -space / 2).isActive = true
        case 5:
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
            view.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5, constant: -space / 2).isActive = true
            view.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5, constant: -space / 2).isActive = true
        case 6:
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
            view.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5, constant: -space / 2).isActive = true
            view.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5, constant: -space / 2).isActive = true
        default:
            print("position must be in the range of [0, 6]")
        }
    }
}

extension UIViewController {
    func add(mediaTweet: Tweet, to view: UIView, index: Int) {
        SKPhotoBrowserOptions.displayToolbar = true
        SKPhotoBrowserOptions.backgroundColor = UIColor.black
        //SKPhotoBrowserOptions.indicatorColor = UIColor.black
        SKCaptionOptions.textColor = .gray
        SKToolbarOptions.textShadowColor = UIColor.black
        
        let media = mediaTweet.entities.media
        var images: [SKPhoto] = []
        for medium in media {
            let photo = SKPhoto.photoWithImageURL(medium.mediaUrl.absoluteString)
            photo.shouldCachePhotoURLImage = true
            //photo.caption = mediaTweet.text
            images.append(photo)
        }
        Common.skphotoimages.append(images)
        switch media.count {
        case 1:
            let media1 = UIButton(url: media[0].mediaUrl)
            media1.tag = 0 + index * 4
            media1.addTarget(self, action: #selector(mediaTapped), for: .touchUpInside)
            view.addSubview(media1, position: 0)
        case 2:
            let media1 = UIButton(url: media[0].mediaUrl)
            let media2 = UIButton(url: media[1].mediaUrl)
            media1.tag = 0 + index * 4
            media2.tag = 1 + index * 4
            media1.addTarget(self, action: #selector(mediaTapped), for: .touchUpInside)
            media2.addTarget(self, action: #selector(mediaTapped), for: .touchUpInside)
            view.addSubview(media1, position: 1)
            view.addSubview(media2, position: 2)
        case 3:
            let media1 = UIButton(url: media[0].mediaUrl)
            let media2 = UIButton(url: media[1].mediaUrl)
            let media3 = UIButton(url: media[2].mediaUrl)
            media1.tag = 0 + index * 4
            media2.tag = 1 + index * 4
            media3.tag = 2 + index * 4
            media1.addTarget(self, action: #selector(mediaTapped), for: .touchUpInside)
            media2.addTarget(self, action: #selector(mediaTapped), for: .touchUpInside)
            media3.addTarget(self, action: #selector(mediaTapped), for: .touchUpInside)
            view.addSubview(media1, position: 1)
            view.addSubview(media2, position: 4)
            view.addSubview(media3, position: 6)
        case 4:
            let media1 = UIButton(url: media[0].mediaUrl)
            let media2 = UIButton(url: media[1].mediaUrl)
            let media3 = UIButton(url: media[2].mediaUrl)
            let media4 = UIButton(url: media[3].mediaUrl)
            media1.tag = 0 + index * 4
            media2.tag = 1 + index * 4
            media3.tag = 2 + index * 4
            media4.tag = 3 + index * 4
            media1.addTarget(self, action: #selector(mediaTapped), for: .touchUpInside)
            media2.addTarget(self, action: #selector(mediaTapped), for: .touchUpInside)
            media3.addTarget(self, action: #selector(mediaTapped), for: .touchUpInside)
            media4.addTarget(self, action: #selector(mediaTapped), for: .touchUpInside)
            view.addSubview(media1, position: 3)
            view.addSubview(media2, position: 4)
            view.addSubview(media3, position: 5)
            view.addSubview(media4, position: 6)
        default:
            print("number of media must be in the range of [1, 4]")
        }
    }
    
    @objc func mediaTapped(sender: AnyObject) {
        let tag = sender.tag!
        let index = tag / 4
        let touchedIndex = tag % 4
        let browser = SKPhotoBrowser(photos: Common.skphotoimages[index])
        browser.initializePageIndex(touchedIndex)
        present(browser, animated: true, completion: nil)
    }
}
