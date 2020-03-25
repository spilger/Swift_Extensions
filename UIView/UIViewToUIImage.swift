//
//  UIViewToUIImage.swift
//  Image Segmentor
//
//  Created by Michael Spilger on 29.02.20.
//  Copyright © 2020 Michael Spilger. All rights reserved.
//

import Foundation
import UIKit
import Accelerate

extension UIView {
       func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
