//
//  UIImage.swift
//  Image Segmentor
//
//  Created by Michael Spilger on 29.02.20.
//  Copyright © 2020 Michael Spilger. All rights reserved.
//

import Foundation
import UIKit
import Accelerate

extension UIImage {
       // sticker image 512 * 512
    func StickerSize512() -> UIImage? {
        let imageView = UIImageView(image: imageWithInsets(insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)))
         imageView.contentMode = .scaleAspectFit
         imageView.frame = CGRect(x: 0, y: 0, width: 512, height: 512)
         let image = imageView.asImage()
         let img = image.pngFrom()
         let newImage = img.resizeImage(targetSize: CGSize(width:512, height: 512))
         return newImage
        
      }
    
    // resize trayImage 96 * 96
    func StickerSize96() -> UIImage? {
        let imageView = UIImageView(image: imageWithInsets(insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)))
         imageView.contentMode = .scaleAspectFit
         imageView.frame = CGRect(x: 0, y: 0, width: 96, height: 96)
         let image = imageView.asImage()
         let img = image.pngFrom()
         let newImage = img.resizeImage(targetSize: CGSize(width:96, height: 96))
         return newImage
        
      }
}
