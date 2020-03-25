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
    // MARK: Resize
    func cropsToSquare() -> UIImage {
        let refWidth = CGFloat(self.cgImage!.width)
        let refHeight = CGFloat(self.cgImage!.height)
        let cropSize = refWidth > refHeight ? refHeight : refWidth

        let x = (refWidth - cropSize) / 2.0
        let y = (refHeight - cropSize) / 2.0

        let cropRect = CGRect(x: x, y: y, width: cropSize, height: cropSize)
        let imageRef = self.cgImage!.cropping(to: cropRect)
        let cropped = UIImage(cgImage: imageRef!, scale: 0.0, orientation: self.imageOrientation)

        return cropped
    }
    
}
