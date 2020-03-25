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
    func resizeImageUsingVImage(size:CGSize) -> UIImage? {
         let cgImage = self.cgImage!
         var format = vImage_CGImageFormat(bitsPerComponent: 8, bitsPerPixel: 32, colorSpace: nil, bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.first.rawValue), version: 0, decode: nil, renderingIntent: CGColorRenderingIntent.defaultIntent)
         var sourceBuffer = vImage_Buffer()
         defer {
              free(sourceBuffer.data)
         }
        var error = vImageBuffer_InitWithCGImage(&sourceBuffer, &format, nil, cgImage, numericCast(kvImageNoFlags))
         guard error == kvImageNoError else { return nil }
       // create a destination buffer
       let scale = self.scale
       let destWidth = Int(size.width)
       let destHeight = Int(size.height)
       let bytesPerPixel = self.cgImage!.bitsPerPixel/8
       let destBytesPerRow = destWidth * bytesPerPixel
       let destData = UnsafeMutablePointer<UInt8>.allocate(capacity: destHeight * destBytesPerRow)
       defer {
             destData.deallocate()//deallocate(capacity: destHeight * destBytesPerRow)
       }
      var destBuffer = vImage_Buffer(data: destData, height: vImagePixelCount(destHeight), width: vImagePixelCount(destWidth), rowBytes: destBytesPerRow)
    // scale the image
     error = vImageScale_ARGB8888(&sourceBuffer, &destBuffer, nil, numericCast(kvImageHighQualityResampling))
     guard error == kvImageNoError else { return nil }
     // create a CGImage from vImage_Buffer
     var destCGImage = vImageCreateCGImageFromBuffer(&destBuffer, &format, nil, nil, numericCast(kvImageNoFlags), &error)?.takeRetainedValue()
    guard error == kvImageNoError else { return nil }
    // create a UIImage
     let resizedImage = destCGImage.flatMap { UIImage(cgImage: $0, scale: 0.0, orientation: self.imageOrientation) }
     destCGImage = nil
    return resizedImage
    }
    // MARK: Rotate
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!

        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}
// Compression of Images
// TO MAKE TRY IMAGE


extension UIImage {
    func pngFrom() -> UIImage {
        let imageData = self.pngData()
        let imagePng = UIImage(data: imageData!)
        return imagePng!
       }
    
}



extension UIImage {
  func resizeImage(targetSize: CGSize) -> UIImage {
    let size = self.size
    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height
    let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    self.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return newImage!
  }
}


extension UIImage {
    func imageWithInsets(insets: UIEdgeInsets) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: self.size.width + insets.left + insets.right,
                   height: self.size.height + insets.top + insets.bottom), false, self.scale)
        let _ = UIGraphicsGetCurrentContext()
        let origin = CGPoint(x: insets.left, y: insets.top)
        self.draw(at: origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageWithInsets
    }
}


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

extension UIImage {
    func toCVPixelBuffer() -> CVPixelBuffer? {
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(self.size.width), Int(self.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard status == kCVReturnSuccess else {
            return nil
        }

        if let pixelBuffer = pixelBuffer {
            CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
            let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer)

            let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
            let context = CGContext(data: pixelData, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)

            context?.translateBy(x: 0, y: self.size.height)
            context?.scaleBy(x: 1.0, y: -1.0)

            UIGraphicsPushContext(context!)
            self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
            UIGraphicsPopContext()
            CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))

            return pixelBuffer
        }

        return nil
    }
}

extension UIView {
       func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
