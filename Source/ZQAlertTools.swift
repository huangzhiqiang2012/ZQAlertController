//
//  ZQAlertTools.swift
//  ZQAlertController
//
//  Created by Darren on 2019/1/12.
//  Copyright © 2019 Darren. All rights reserved.
//

import Foundation
import Accelerate

// MARK:自定义log打印
// Swift没有宏的概念,所以得在TARGET -> Build Setting -> Other Swift Flags的Debug状态加一个 -D DEBUG
public func ZQLog<T>(message: T, fileName: String = #file, methodName: String = #function, lineNumber: Int = #line) {
    #if DEBUG
    let fName = ((fileName as NSString).pathComponents.last!)
    print("\(fName).\(methodName)[\(lineNumber)]: \(message)")
    #endif
}

// MARK:自定义颜色
public func ZQColor(red:CGFloat, green:CGFloat, blue:CGFloat) -> UIColor {
    return UIColor.init(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1)
}

// MARK: UIWindow extension
public extension UIWindow {
    public func zq_topViewController() -> UIViewController? {
        var topViewController = self.rootViewController
        while topViewController?.presentedViewController != nil {
            topViewController = topViewController?.presentedViewController
        }
        return topViewController
    }
}

// MARK: UIApplication extension
public extension UIApplication {
    public class func zq_topWindow() -> UIWindow? {
        let reversedWindows:[UIWindow] = UIApplication.shared.windows.reversed()
        for window in reversedWindows {
            if NSStringFromClass(window.classForCoder) == "UIWindow" && window.bounds.equalTo(UIScreen.main.bounds) {
                return window
            }
        }
        return UIApplication.shared.keyWindow
    }
}

// MARK: UIImage extension
public extension UIImage {
    public class func zq_createImage(withColor color:UIColor, size:CGSize? = CGSize(width: 1, height: 1)) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: size!.width, height: size!.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 模糊照片,用高斯模糊算法生成
    public func zq_applyBlur(WithRadius blurRadius:CGFloat, tintColor:UIColor?, saturationDeltaFactor: Double, maskImage:UIImage?) -> UIImage? {
        let size:CGSize = self.size
        if size.width < 1 || size.height < 1 || self.cgImage == nil || (maskImage != nil && (maskImage!.cgImage == nil))  {
            return nil
        }
        let imageRect:CGRect = CGRect(origin: CGPoint.zero, size: size)
        var effectImage:UIImage = self
        let hasBlur:Bool = blurRadius > .ulpOfOne
        let hasSaturationChange:Bool = abs(Float(saturationDeltaFactor) - 1.0) > .ulpOfOne
        let screenScale:CGFloat = UIScreen.main.scale
        if hasBlur || hasSaturationChange {
            UIGraphicsBeginImageContextWithOptions(size, false, screenScale)
            guard let effectInContext:CGContext = UIGraphicsGetCurrentContext() else {
                return nil
            }
            effectInContext.scaleBy(x: 1.0, y: -1.0)
            effectInContext.translateBy(x: 0, y: -size.height)
            effectInContext.draw(self.cgImage!, in: imageRect)
            
            var effectInBuffer = vImage_Buffer() /// 需要import Accelerate
            effectInBuffer.data = effectInContext.data
            effectInBuffer.width = vImagePixelCount(effectInContext.width)
            effectInBuffer.height = vImagePixelCount(effectInContext.height)
            effectInBuffer.rowBytes = effectInContext.bytesPerRow
            
            UIGraphicsBeginImageContextWithOptions(size, false, screenScale)
            guard let effectOutContext:CGContext = UIGraphicsGetCurrentContext() else {
                return nil
            }
            var effectOutBuffer = vImage_Buffer()
            effectOutBuffer.data = effectOutContext.data
            effectOutBuffer.width = vImagePixelCount(effectOutContext.width)
            effectOutBuffer.height = vImagePixelCount(effectOutContext.height)
            effectOutBuffer.rowBytes = effectOutContext.bytesPerRow
            
            if hasBlur {
                let inputRadius:Double = Double(blurRadius) * Double(screenScale)
                var radius = floor(inputRadius * 3.0 * sqrt(2 * .pi) / 4 + 0.5)
                let result = radius.truncatingRemainder(dividingBy: 2)
                if result != 1 {
                    radius += 1
                }
                var unsafePointer:UInt8 = 0
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, UInt32(radius), UInt32(radius), &unsafePointer, UInt32(kvImageEdgeExtend))
                vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, nil, 0, 0, UInt32(radius), UInt32(radius), &unsafePointer, UInt32(kvImageEdgeExtend))
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, UInt32(radius), UInt32(radius), &unsafePointer, UInt32(kvImageEdgeExtend))
            }
            var effectImageBuffersAreSwapped:Bool = false
            if hasSaturationChange {
                let s:Double = saturationDeltaFactor
                let floatingPointSaturationMatrix:[Double] = [
                    0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                    0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                    0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                    0,                    0,                    0,                    1,
                ]
                let divisor:Int32 = 256
                let matrixSize:Int = MemoryLayout.size(ofValue: floatingPointSaturationMatrix) / MemoryLayout.size(ofValue: floatingPointSaturationMatrix[0])
                var saturationMatrix = [Int16]()
                for _ in 0...matrixSize {
                    saturationMatrix.append(0)
                }
                for i in 0...matrixSize {
                    saturationMatrix[i] = Int16(roundf(Float(floatingPointSaturationMatrix[i]) * Float(divisor)))
                }
                if hasBlur {
                    vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, divisor, nil, nil, UInt32(kvImageNoFlags))
                    effectImageBuffersAreSwapped = true
                }
                else {
                    vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, divisor, nil, nil, UInt32(kvImageNoFlags))
                }
            }
            if !effectImageBuffersAreSwapped {
                effectImage = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsEndImageContext()
            }
            if effectImageBuffersAreSwapped {
                effectImage = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsEndImageContext()
            }
        }
        UIGraphicsBeginImageContextWithOptions(size, false, screenScale)
        guard let outputContext:CGContext = UIGraphicsGetCurrentContext() else {
            return nil
        }
        outputContext.scaleBy(x: 1.0, y: -1.0)
        outputContext.translateBy(x: 0, y: -size.height)
        outputContext.draw(self.cgImage!, in: imageRect)
        
        if hasBlur {
            outputContext.saveGState()
            if maskImage != nil {
                outputContext.draw(maskImage!.cgImage!, in: imageRect)
            }
            else {
                outputContext.draw(effectImage.cgImage!, in: imageRect)
            }
            outputContext.restoreGState()
        }
        if tintColor != nil {
            outputContext.saveGState()
            outputContext.setFillColor(tintColor!.cgColor)
            outputContext.fill(imageRect)
            outputContext.restoreGState()
        }
        let outputImage:UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return outputImage
    }
    
    /// 模糊照片,用高斯模糊算法生成,效率也快,但是相比第一种方法,扩展性较差
    public func zq_blurImage(withBlurLevel blurLevel:CGFloat) -> UIImage? {
        var blur = blurLevel
        if blur < 0 || blur > 1 {
            blur = 0.5
        }
        var boxSize:Int = Int(blur * 100)
        boxSize = boxSize - (boxSize % 2) + 1
        let image:CGImage = self.cgImage!
        var inBuffer = vImage_Buffer()
        var outBuffer = vImage_Buffer()
        let inProvider = image.dataProvider
        let inBitmapData = inProvider?.data
        inBuffer.width = vImagePixelCount(image.width)
        inBuffer.height = vImagePixelCount(image.height)
        inBuffer.rowBytes = image.bytesPerRow
        inBuffer.data = UnsafeMutableRawPointer(mutating: CFDataGetBytePtr(inBitmapData))
        
        let pixelBuffer = malloc(image.bytesPerRow * image.height)
        outBuffer.width = vImagePixelCount(image.width)
        outBuffer.height = vImagePixelCount(image.height)
        outBuffer.rowBytes = image.bytesPerRow
        outBuffer.data = pixelBuffer
        
        var error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, nil, vImagePixelCount(0), vImagePixelCount(0), UInt32(boxSize), UInt32(boxSize), nil, vImage_Flags(kvImageEdgeExtend))
        if kvImageNoError != error {
            error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, nil, vImagePixelCount(0), vImagePixelCount(0), UInt32(boxSize), UInt32(boxSize), nil, vImage_Flags(kvImageEdgeExtend))
            if kvImageNoError != error {
                error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, nil, vImagePixelCount(0), vImagePixelCount(0), UInt32(boxSize), UInt32(boxSize), nil, vImage_Flags(kvImageEdgeExtend))
            }
        }
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let ctx = CGContext(data: outBuffer.data,
                            width: Int(outBuffer.width),
                            height: Int(outBuffer.height),
                            bitsPerComponent: 8,
                            bytesPerRow: outBuffer.rowBytes,
                            space: colorSpace,
                            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        let imageRef = ctx!.makeImage()
        free(pixelBuffer)
        return UIImage(cgImage: imageRef!)
    }
    
    /// 模糊照片,用高斯模糊滤镜生成,相比上面的两种用算法计算,这个方法更加耗时--__--||
    public func zq_blurImage(WithRadius blurRadius:CGFloat) -> UIImage? {
        let inputImage = CIImage(image: self)
        let filter = CIFilter(name: "CIGaussianBlur")!
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setValue(blurRadius, forKey: kCIInputRadiusKey)
        guard let outputCIImage = filter.outputImage  else {
            return nil
        }
        let context:CIContext = CIContext(options: nil)
        guard let cgImage = context.createCGImage(outputCIImage, from: outputCIImage.extent)  else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
}

// MARK: String extension
public extension String {
    public static func zq_isEmpty(str:String?) -> Bool {
        if let content = str {
            return content.isEmpty
        } else {
            return true
        }
    }
}

// MARK: NSAttributedString extension
public extension NSAttributedString {
    public func zq_sizeWidth(withMaxWidth maxWidth:CGFloat) -> CGSize {
        if self.length == 0 {
            return CGSize.zero
        }
        let rect = self.boundingRect(with: CGSize(width: maxWidth, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, context: nil)
        return CGSize(width:CGFloat(ceilf(Float(rect.size.width))), height: CGFloat(ceilf(Float(rect.size.height))))
    }
    
    public static func zq_isEmpty(str:NSAttributedString?) -> Bool {
        if let content = str {
            return content.string.isEmpty
        } else {
            return true
        }
    }
}

// MARK: UIView extension
public extension UIView {
    public var zq_x:CGFloat {
        get {
            return self.frame.origin.x
        }
        set(newX) {
            var frame = self.frame
            frame.origin.x = newX
            self.frame = frame
        }
    }
    
    public var zq_y:CGFloat {
        get {
            return self.frame.origin.y
        }
        set(newY) {
            var frame = self.frame
            frame.origin.y = newY
            self.frame = frame
        }
    }
    
    public var zq_width:CGFloat {
        get {
            return self.frame.size.width
        }
        set(newWidth) {
            var frame = self.frame
            frame.size.width = newWidth
            self.frame = frame
        }
    }
    
    public var zq_height:CGFloat {
        get {
            return self.frame.size.height
        }
        set(newHeight) {
            var frame = self.frame
            frame.size.height = newHeight
            self.frame = frame
        }
    }
    
    public var zq_centX:CGFloat {
        get {
            return self.center.x
        }
        set(newCentX) {
            var center = self.center
            center.x = newCentX
            self.center = center
        }
    }
    
    public var zq_centY:CGFloat {
        get {
            return self.center.y
        }
        set(newCentY) {
            var center = self.center
            center.y = newCentY
            self.center = center
        }
    }
    
    public var zq_size:CGSize {
        get {
            return self.frame.size
        }
        set(newSize) {
            var frame = self.frame
            frame.size = newSize
            self.frame = frame
        }
    }
    
    public func zq_containInputView() -> Bool {
        for view:UIView in subviews {
            if view.isKind(of: UITextField.classForCoder()) || view.isKind(of: UITextView.classForCoder()) {
                return true
            }
            let contain:Bool = view.zq_containInputView()
            if contain {
                return true
            }
            continue
        }
        return false
    }
}

// MARK:UI相关
let ZQScreenW:CGFloat = UIScreen.main.bounds.size.width

let ZQScreenH:CGFloat = UIScreen.main.bounds.size.height

let ZQDefaultTextColor:UIColor = ZQColor(red: 0, green: 0, blue: 0)

public typealias ZQAlertButtonClick = () -> ()

public typealias ZQAlertKeyboardShowClosure = (_ keyboardHeight:CGFloat, _ duration:CGFloat) -> ()

public typealias ZQAlertKeyboardHideClosure = (_ duration:CGFloat) -> ()
