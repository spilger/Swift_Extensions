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
    func pngFrom() -> UIImage {
        let imageData = self.pngData()
        let imagePng = UIImage(data: imageData!)
        return imagePng!
       }
    
}
