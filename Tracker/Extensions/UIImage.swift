//
//  UIImage.swift
//  Tracker
//
//  Created by Mohssen Fathi on 7/2/18.
//  Copyright © 2018 mohssenfathi. All rights reserved.
//

import UIKit

extension UIImage {
    
    subscript (x: Int, y: Int) -> UIColor? {
        
        if x < 0 || x > Int(size.width) || y < 0 || y > Int(size.height) {
            return nil
        }
        
        guard let cgImage = cgImage,
            let providerData = cgImage.dataProvider?.data,
            let data = CFDataGetBytePtr(providerData) else {
            return nil
        }
        
        let numberOfComponents = 4
        let pixelData = ((Int(size.width) * y) + x) * numberOfComponents
        
        let r = CGFloat(data[pixelData]) / 255.0
        let g = CGFloat(data[pixelData + 1]) / 255.0
        let b = CGFloat(data[pixelData + 2]) / 255.0
        let a = CGFloat(data[pixelData + 3]) / 255.0
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in:UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: image!.cgImage!)
    }

    public func pixelColor(at point: CGPoint) -> UIColor? {
        
        guard let cgImage = cgImage, let pixelData = cgImage.dataProvider?.data else { return nil }
        
        let scaledPoint = CGPoint(x: point.x * UIScreen.main.scale, y: point.y * UIScreen.main.scale)
//        Tools.clamp(&scaledPoint.x, low: 0.0, high: CGFloat(cgImage.width))
//        Tools.clamp(&scaledPoint.y, low: 0.0, high: CGFloat(cgImage.height))
        
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        let bytesPerPixel = cgImage.bitsPerPixel / 8
        let pixelInfo: Int = ((cgImage.bytesPerRow * Int(scaledPoint.y)) + (Int(scaledPoint.x) * bytesPerPixel))
        
        let b = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let r = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
    public func pixelColor(at point: CGPoint, radius: Int = 0) -> UIColor? {
        
        let pixelData = self.cgImage!.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        var ra: CGFloat = 0.0
        var ga: CGFloat = 0.0
        var ba: CGFloat = 0.0
        var aa: CGFloat = 0.0
        var count: CGFloat = 0
        
        for x in max(Int(point.x) - radius, 0) ..< min(Int(point.x) + radius, Int(size.width)) {
            for y in max(Int(point.y) - radius, 0) ..< min(Int(point.y) + radius, Int(size.height)) {
                let pixelInfo: Int = ((Int(self.size.width) * Int(y)) + Int(x)) * 4
                
                ra += CGFloat(data[pixelInfo]) / CGFloat(255.0)
                ga += CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
                ba += CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
                aa += CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
                
                count += 1.0
            }
        }
        
        let r = ra/count
        let g = ga/count
        let b = ba/count
        let a = aa/count
        
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}

func *(lhs: CGPoint, rhs: CGSize) -> CGPoint {
    return CGPoint(x: lhs.x * rhs.width, y: lhs.y * rhs.height)
}
