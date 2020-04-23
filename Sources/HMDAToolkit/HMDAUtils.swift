//
//  HMDAUtils.swift
//  HMDAToolkit
//
//  Created by Konstantinos Kontos on 20/09/2016.
//  Copyright © 2016 Handmade Apps Ltd. All rights reserved.
//

import UIKit
import AVFoundation

public typealias NotificationUserInfo = [AnyHashable: Any]
public typealias VoidClosure = () -> Void

public func delayedRun(interval: TimeInterval, code: @escaping VoidClosure) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + interval) {
        code()
    }
}

public func mainQueueRun(code: @escaping VoidClosure) {
    DispatchQueue.main.async {
        code()
    }
}

public class GlobalURLSession: URLSession {
    
    static let sharedInstance = URLSession(configuration: GlobalURLSession.sessionConfig())
    
    static let timeout = 60
    
    class func sessionConfig() -> URLSessionConfiguration {
        let sessionCache = URLCache(memoryCapacity: 1 * 1024 * 1024, diskCapacity: 10 * 1024 * 1024, diskPath: "http_cache")
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.urlCache = sessionCache
        sessionConfig.timeoutIntervalForRequest = Double(timeout)
        sessionConfig.requestCachePolicy = NSURLRequest.CachePolicy.returnCacheDataElseLoad
        
        return sessionConfig
    }
    
}

public extension CGRect {
    
    var center: CGPoint {
        return CGPoint(x: self.width / 2.0, y: self.height / 2.0)
    }
    
}


public extension UIDeviceOrientation {
    
    var interfaceOrientation: UIInterfaceOrientationMask {
        
        switch self {
            
        case .portrait:
            return .portrait
            
        case .portraitUpsideDown:
            return .portraitUpsideDown
            
        case .landscapeLeft:
            return .landscapeLeft
            
        case .landscapeRight:
            return .landscapeRight
            
        default:
            return .all
            
        }
        
    }
    
}

public extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
    var whole: Self { return modf(self).0 }
    var fraction: Self { return modf(self).1 }
}

public extension CGFloat {
    
    func normalizedAnimationValue(referenceValue: CGFloat, boundaryValue: CGFloat) -> CGFloat {
        guard referenceValue > 0 else {
            return self
        }
        
        return (self / referenceValue) * boundaryValue
    }
    
    var doubleValue: Double {
        return Double(self)
    }
    
    var floatValue: Float {
        return Float(self)
    }
    
}

public extension Double {
    
    var cgFloatValue: CGFloat {
        return CGFloat(self)
    }
    
}

public extension URL {
    
    var exists: Bool {
        return FileManager.default.fileExists(atPath: path)
    }
    
    var folderContents: [URL]? {
        return try? FileManager.default.contentsOfDirectory(at: self,
                                                includingPropertiesForKeys: nil,
                                                options: [.skipsHiddenFiles, .skipsPackageDescendants, .skipsSubdirectoryDescendants])
    }
    
    var fileContents: String? {
        return try? String(contentsOf: self)
    }
    
    var imageContents: UIImage? {
        return UIImage(contentsOfFile: self.path)
    }
    
    var jsonObject: Any? {
        return JSONSerialization.jsonObject(from: self)
    }
    
    mutating func setSkipBackupAttribute() {
        var resourceValues = URLResourceValues()
        resourceValues.isExcludedFromBackup = true
        
        _ = try? setResourceValues(resourceValues)
    }
    
    func eraseFile() throws {
        try FileManager.default.removeItem(at: self)
    }
    
    func eraseAllFiles() throws {
        
        if let folderContents = self.folderContents {
            
            for url in folderContents {
                try url.eraseFile()
            }
            
        }
        
    }
    
    func streamCopy(toURL destinationURL: URL, appending: Bool) {
        let inputStream = InputStream(url: self)
        let outputStream = OutputStream(url: destinationURL, append: appending)
        
        inputStream?.open()
        outputStream?.open()
        
        var buffer = [UInt8](repeating: 0, count: 1024)
        
        var bytesRead = inputStream?.read(&buffer, maxLength: 1024)
        
        while bytesRead! > 0 {
            outputStream?.write(buffer, maxLength: bytesRead!)
            bytesRead = inputStream?.read(&buffer, maxLength: 1024)
        }
        
        outputStream?.close()
        inputStream?.close()
    }
    
    func thumbnailForVideo(atPlaybackSeconds seconds: Double) -> UIImage? {
        let videoAsset = AVURLAsset(url: self)
        let assetGenerator = AVAssetImageGenerator(asset: videoAsset)
        let thumbnailSnapshotTime = CMTime(seconds: seconds, preferredTimescale: CMTimeScale(exactly: 1.0)!)
        
        guard let cgImage = try? assetGenerator.copyCGImage(at: thumbnailSnapshotTime, actualTime: nil) else {
            return nil
        }
        
        let thumbnail = UIImage(cgImage: cgImage)
        
        return thumbnail
    }
    
}

public extension URLResponse {
    
    var contentLength: Int {
        let httpResponse = (self as! HTTPURLResponse)
        return Int((httpResponse.allHeaderFields["Content-Length"] as! String))!
    }
    
}

public extension NSObject {
    
    static func classStr() -> String {
        return classForCoder().description().components(separatedBy: ".").last!
    }
    
    var classStr: String {
        String(describing: self.classForCoder)
    }
    
}

public extension Data {
    
    func jsonObject() -> Any? {
        return try? JSONSerialization.jsonObject(with: self, options: .allowFragments)
    }
    
    var asUTF8String: String? {
        return String(data: self, encoding: .utf8)
    }
    
    func decoded<T: Decodable>() throws -> T {
        return try JSONDecoder().decode(T.self, from: self)
    }
    
}


public extension Encodable {
    
    func encoded() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
}

public extension UIButton {
    
    func setTitleForAllStates(_ string: String) {
        setTitle(string, for: .normal)
        setTitle(string, for: .highlighted)
    }
    
    func setImageAsTemplateImageForAllStates(_ image: UIImage) {
        setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
        setImage(image.withRenderingMode(.alwaysTemplate), for: .highlighted)
    }
    
    func setImageForAllStates(_ image: UIImage) {
        setImage(image, for: .normal)
        setImage(image, for: .highlighted)
    }
    
    func setBackgroundForAllStates(_ image: UIImage) {
        setBackgroundImage(image, for: .normal)
        setBackgroundImage(image, for: .highlighted)
    }
    
}

public extension String {
    
    static var nonBreakingSpace: String {
        return "\u{00A0}"
    }
    
    var formattedForNonOrphanWrapping: String {
        let reversedString = String(self.reversed())
        
        if let lastSpaceRange = reversedString.range(of: " ") {
            
            let fixedStr = reversedString.replacingOccurrences(of: " ",
                                                               with: " \(String.nonBreakingSpace) ",
                options: .anchored,
                range: lastSpaceRange)
            
            return String(fixedStr.reversed())
        } else {
            return self
        }
        
    }
    
    var jsonObject: JSONObject? {
        return JSONSerialization.jsonObject(fromJSON: self) as? JSONObject
    }
    
    var jsonArray: JSONArray? {
        return JSONSerialization.jsonObject(fromJSON: self) as? JSONArray
    }
    
    var fileContents: String? {
        return try? String(contentsOfFile: self)
    }
    
    var fileDataContents: Data? {
        
        if let contents = try? String(contentsOfFile: self) {
            return contents.data(using: .utf8)
        } else {
            return nil
        }
        
    }
    
    var bundledPath: String? {
        return Bundle.main.path(forResource: self, ofType: nil)
    }
    
    var fileURL: URL {
        return URL(fileURLWithPath: self)
    }
    
    func regexMatches(pattern: String, options: NSRegularExpression.Options) -> [Substring]? {
        
        if let regex = try? NSRegularExpression(pattern: pattern,
                                                options: options) {
            
            let results = regex.matches(in: self, options: .reportCompletion, range: NSMakeRange(0, self.count))
            
            var matches: [Substring]?
            
            for result in results {
                
                if result.numberOfRanges == 1 {
                    
                    let startIndex = self.index(self.startIndex, offsetBy: result.range.location)
                    let endIndex = self.index(self.startIndex, offsetBy: result.range.length + result.range.location - 1)
                    
                    let substr = self[startIndex...endIndex]
                    
                    if matches == nil {
                        matches = [Substring]()
                    }
                    
                    matches?.append(substr)
                } else {
                    var n = 1
                    
                    while n < result.numberOfRanges {
                        let captureGroupRange = result.range(at: n)
                        
                        if captureGroupRange.location >= self.count {
                            return nil
                        }
                        
                        let startIndex = self.index(self.startIndex, offsetBy: captureGroupRange.location)
                        let endIndex = self.index(self.startIndex, offsetBy: captureGroupRange.length + captureGroupRange.location - 1)
                        
                        let substr = self[startIndex...endIndex]
                        
                        if matches == nil {
                            matches = [Substring]()
                        }
                        
                        matches?.append(substr)
                        
                        n += 1
                    }
                    
                }
                
            }
            
            return matches
            
        } else {
            return nil
        }
        
    }

    func url() -> URL? {
        return URL(string: self)
    }
    
    func urlEncoded() -> String {
        let encodedStr = self.addingPercentEncoding(withAllowedCharacters: .alphanumerics)
        return encodedStr ?? self
    }
    
    func rgbColor() -> UIColor? {
        
        guard hasPrefix("#") else {
            return nil
        }
        
        let hexString = self[self.index(self.startIndex, offsetBy: 1)...]
        
        guard hexString.count == 6 else {
            return nil
        }
        
        var hexValue: Float = 0
        
        // Get RED value
        var subStr = String(hexString)[index(startIndex, offsetBy: 0)..<index(startIndex, offsetBy: 2)]
        
        Scanner(string: "0x\(subStr)").scanHexFloat(&hexValue)
        let redComponent = hexValue / 255.0
        
        
        // Get GREEN value
        subStr = String(hexString)[index(startIndex, offsetBy: 2)..<index(startIndex, offsetBy: 4)]
        
        Scanner(string: "0x\(subStr)").scanHexFloat(&hexValue)
        let greenComponent = hexValue / 255.0
        
        
        // Get BLUE value
        subStr = String(hexString)[index(startIndex, offsetBy: 4)..<index(startIndex, offsetBy: 6)]
        
        Scanner(string: "0x\(subStr)").scanHexFloat(&hexValue)
        let blueComponent = hexValue / 255.0
        
        return UIColor(red: CGFloat(redComponent), green: CGFloat(greenComponent), blue: CGFloat(blueComponent), alpha: 1.0)
    }
    
    func rgbColor(withAlpha alpha: Float) -> UIColor {
        let color = rgbColor()
        
        var redComponent: CGFloat = 0
        var greenComponent: CGFloat = 0
        var blueComponent: CGFloat = 0
        var alphaComponent: CGFloat = 0
        
        color?.getRed(&redComponent, green: &greenComponent, blue: &blueComponent, alpha: &alphaComponent)
        
        return UIColor(red: redComponent, green: greenComponent, blue: blueComponent, alpha: CGFloat(alpha))
    }
    
    func htmlAttrStr() -> NSAttributedString? {
        let attrStr = try? NSAttributedString(data: self.data(using: .utf8)!,
                                              options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        return attrStr
    }
    
    func htmlAttrStr(usingSourceEncoding encoding: String.Encoding) -> NSAttributedString? {
        let attrStr = try? NSAttributedString(data: self.data(using: encoding)!,
                                              options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        return attrStr
    }
    
    
    var unicodeUnescaped: String? {
        let regex = try? NSRegularExpression(pattern: "\\\\U(\\d{4})", options: NSRegularExpression.Options.dotMatchesLineSeparators)
        
        let mutableRawStr = NSMutableString(string: self)
        
        if regex!.replaceMatches(in: mutableRawStr,
                                 options: NSRegularExpression.MatchingOptions.reportCompletion,
                                 range: NSMakeRange(0, self.count),
                                 withTemplate: "\\\\u$1") > 0 {
            
            if let cString = mutableRawStr.cString(using: String.Encoding.utf8.rawValue) {
                
                if let unEscapedString = NSString(cString: cString, encoding: String.Encoding.nonLossyASCII.rawValue) {
                    return unEscapedString as String
                } else {
                    return self
                }
                
            } else {
                
                return self
                
            }
            
        } else {
            
            return self
            
        }
        
    }
    
    func serverDate(withFormat dateFormat: String) -> Date? {
        // 2015-04-23T01:11:00.000Z
        // "yyyy-MM-dd'T'HH:mm:ss'.'zzz'Z'"
        
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale.autoupdatingCurrent
        inputFormatter.dateFormat = dateFormat
        
        return inputFormatter.date(from: self)
    }
    
    func attributedString(withColor color: UIColor) -> NSAttributedString {
        var attributes = [NSAttributedString.Key : Any]()
        attributes[NSAttributedString.Key.foregroundColor] = color
        
        return NSAttributedString(string: self, attributes: attributes)
    }
    
}

public extension FileManager {
    
    func cleanup(folder: URL) {
        
        if let contents = try? contentsOfDirectory(atPath: folder.path) {
            
            for file in contents {
                
                let filePathURL = folder.appendingPathComponent(file)
                
                _ = try? removeItem(at: filePathURL)
            }
            
        }
        
    }
    
    func cleanupTempDir() {
        
        if let contents = try? FileManager.default.contentsOfDirectory(atPath: NSTemporaryDirectory()) {
            
            for file in contents {
                var filePathURL = URL(fileURLWithPath: NSTemporaryDirectory())
                filePathURL.appendPathComponent(file)
                _ = try? FileManager.default.removeItem(at: filePathURL)
            }
            
        }
        
    }

    class func applicationCachesDocumentsFolder() -> URL {
        let urls = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return urls[urls.count - 1]
    }
    
    class func applicationDocumentsFolder() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count - 1]
    }
    
    class func applicationSupportFolder() -> URL {
        let urls = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        return urls[urls.count - 1]
    }
    
    class func temporaryFolder() -> URL {
        return URL(fileURLWithPath: NSTemporaryDirectory())
    }
    
    func sizeForItem(atFileURL url: URL) -> UInt64 {
        
        if let fileAttrs = try? self.attributesOfItem(atPath: url.path) {
            let byteCount = (fileAttrs as NSDictionary).fileSize()
            return byteCount
        } else {
            return 0
        }
        
    }
    
    
    // via Ole Begemann
    // (https://oleb.net/blog/2018/03/temp-file-helper/?utm_campaign=Swift%2BWeb%2BWeekly&utm_medium=email&utm_source=Swift_Web_Weekly_50)
    /// Creates a temporary directory with a unique name and returns its URL.
    ///
    /// - Returns: A tuple of the directory's URL and a delete function.
    ///   Call the function to delete the directory after you're done with it.
    ///
    /// - Note: You should not rely on the existence of the temporary directory
    ///   after the app is exited.
    func urlForUniqueTemporaryDirectory(preferredName: String? = nil) throws
        -> (url: URL, deleteDirectory: () throws -> Void)
    {
        let basename = preferredName ?? UUID().uuidString
        
        var counter = 0
        var createdSubdirectory: URL? = nil
        repeat {
            do {
                let subdirName = counter == 0 ? basename : "\(basename)-\(counter)"
                let subdirectory = temporaryDirectory
                    .appendingPathComponent(subdirName, isDirectory: true)
                try createDirectory(at: subdirectory, withIntermediateDirectories: false)
                createdSubdirectory = subdirectory
            } catch CocoaError.fileWriteFileExists {
                // Catch file exists error and try again with another name.
                // Other errors propagate to the caller.
                counter += 1
            }
        } while createdSubdirectory == nil
        
        let directory = createdSubdirectory!
        let deleteDirectory: () throws -> Void = {
            try self.removeItem(at: directory)
        }
        return (directory, deleteDirectory)
    }
    
}

public extension Int {
    
    var humanReadableFilesize: String {
        
        switch self {
            
        case ..<1024:
            return "\(self) bytes"
            
        case 1024..<1024*1024:
            return "\(self/1024) kb"
            
        case (1024*1024)..<(1024*1024*1024):
            return "\(self/(1024*1024)) mb"
        
        case (1024*1024*1024)...:
            return "\(self/(1024*1024*1024)) gb"
            
        default:
            return ""
        }
        
    }
    
}

public extension UInt64 {
    
    var inMB: Double {
        return Double(self) / Double(1024.0 * 1024.0)
    }
    
    var inGB: Double {
        return Double(self) / Double(1024.0 * 1024.0 * 1024.0)
    }
    
}

public extension UIView {
    
    enum hierarchy {
        case top
        case bottom
        case belowTop
    }
    
    @available (iOS 10.0, *)
    func screenshot(forRect rect: CGRect) -> UIImage {
        let imageRenderer = UIGraphicsImageRenderer(bounds: rect)
        
        let screenshotImage = imageRenderer.image { (context) in
            layer.render(in: context.cgContext)
        }
        
        return screenshotImage
    }
    
    func animateShake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20, 20, -20, 20, -10, 10, -5, 5, 0]
        layer.add(animation, forKey: "shake")
    }
    
    func center(inView view: UIView) {
        self.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor).isActive = true
    }
    
    func makeEqual(toView view: UIView) {
        self.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
        self.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
    }
    
    func makeEqual(toView view: UIView, withPadding padding: CGFloat) {
        self.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: padding).isActive = true
        self.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -padding).isActive = true
        self.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: padding).isActive = true
        self.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -padding).isActive = true
    }
    
    func makeEqual(toView view: UIView, withInsets insets: UIEdgeInsets) {
        self.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: insets.top).isActive = true
        self.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -insets.bottom).isActive = true
        self.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: insets.left).isActive = true
        self.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -insets.right).isActive = true
    }
    
    func addConstraints(forWidth width: CGFloat, andHeight height: CGFloat) {
        let widthConstraint = NSLayoutConstraint(item: self,
                                                 attribute: .width,
                                                 relatedBy: .equal,
                                                 toItem: nil,
                                                 attribute: .notAnAttribute,
                                                 multiplier: 0,
                                                 constant: width)
        
        let heightConstraint = NSLayoutConstraint(item: self,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: nil,
                                                  attribute: .notAnAttribute,
                                                  multiplier: 0,
                                                  constant: height)
        
        addConstraints([widthConstraint,heightConstraint])
    }
    
    func insertSubview(view: UIView, at position: UIView.hierarchy) {
        
        switch position {
            
        case .top:
            
            insertSubview(view, at: subviews.count)
            
        case .bottom:
            insertSubview(view, at: 0)
            
        case .belowTop:
            
            if subviews.count == 0 {
                addSubview(view)
            } else {
                insertSubview(view, belowSubview: subviews[subviews.count - 1])
            }
            
        }

    }
    
    func constraints(withItem item: AnyObject) -> [NSLayoutConstraint]? {
        
        let filteredConstraintArr=self.constraints.filter { (constraint: NSLayoutConstraint) -> Bool in
            
            if constraint.firstItem === item || constraint.secondItem === item {
                return true
            } else {
                return false
            }
            
        }
        
        if !filteredConstraintArr.isEmpty {
            return filteredConstraintArr;
        } else {
            return nil;
        }
        
    }
    
    func constraint(withIdentifier constraintIdentifier: String) -> NSLayoutConstraint? {
        
        let filteredConstraintArr=self.constraints.filter { (constraint: NSLayoutConstraint) -> Bool in
            if constraint.identifier == constraintIdentifier {
                return true
            } else {
                return false
            }
        }
        
        if !filteredConstraintArr.isEmpty {
            return filteredConstraintArr[0];
        } else {
            return nil;
        }
        
    }
    
    func makeCircular() {
        let circlePath = UIBezierPath(ovalIn: bounds)
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = circlePath.cgPath
        
//        maskLayer.position = CGPoint(x: 1, y: 1)
        
        self.layer.mask = maskLayer
        self.layer.shouldRasterize = true
    }
    
    func makeCircular(withBorderColor borderColor: UIColor, size: CGFloat) {
        let borderShape = CAShapeLayer()
        borderShape.frame = bounds
        borderShape.path = UIBezierPath(ovalIn: bounds).cgPath
        borderShape.fillColor = nil
        borderShape.lineWidth = size
        borderShape.strokeColor = borderColor.cgColor
        
        self.layer.addSublayer(borderShape)
        
        self.makeCircular()
    }
    
    func addSubViews(subviews: [UIView]) {
        for subView in subviews {
            addSubview(subView)
        }
    }
    
    func animatePopSmallFrame(startScale: CGSize = CGSize(width: 0.5, height: 0.5)) {
        UIView.animate(withDuration: 0.3,
                       delay: 0.0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.1,
                       options: [.curveEaseOut],
                       animations: {
                        self.transform = CGAffineTransform(scaleX: startScale.width, y: startScale.height)
        }) { (complete) in
            
            UIView.animate(withDuration: 0.3,
                           delay: 0.0,
                           usingSpringWithDamping: 0.2,
                           initialSpringVelocity: 0.1,
                           options: [.curveEaseOut],
                           animations: {
                            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }) { (complete) in
                
            }
            
        }
    }
    
}

public extension TimeInterval {
    
    static var halfHour: TimeInterval {
        return 30.0 * 60.0
    }
    
    static var hour: TimeInterval {
        return 60.0 * 60.0
    }
    
    static var day: TimeInterval {
        return 24.0 * 60.0 * 60.0
    }
    
    static var fiveMin: TimeInterval {
        return 5 * 60.0
    }
    
    static var tenMin: TimeInterval {
        return 10 * 60.0
    }
    
    static var minute: TimeInterval {
        return 60.0
    }
    
}

public extension Date {
    
    static func autoupdatingFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale.autoupdatingCurrent
        formatter.timeZone = TimeZone.autoupdatingCurrent
        formatter.calendar = Calendar.autoupdatingCurrent
        
        return formatter
    }
    
    func memberSinceDateStr() -> String {
        let outputFormatter = Date.autoupdatingFormatter()
        outputFormatter.dateFormat = "MMMM, yyyy"
        
        return outputFormatter.string(from: self)
    }
    
    func formattedServerDateShortStr() -> String {
        let outputFormatter = Date.autoupdatingFormatter()
        outputFormatter.dateFormat = "dd/MM/yyyy"
        
        return outputFormatter.string(from: self)
        
    }
    
    func formattedServerDateStr() -> String {
        let outputFormatter = Date.autoupdatingFormatter()
        outputFormatter.dateFormat = "dd MMMM, yyyy HH:mm"
        
        return outputFormatter.string(from: self)
    }
    
    func year() -> Int? {
        let dateComponents = Calendar.autoupdatingCurrent.dateComponents(in: TimeZone.current, from: self)
        return dateComponents.year
    }
    
    
    func dateOnlyStr(dateStyle: DateFormatter.Style) -> String {
        
        return { () -> DateFormatter in
            let fmt = Date.autoupdatingFormatter()
            fmt.dateStyle = dateStyle
            fmt.timeStyle = .none
            return fmt
            }().string(from: self)
        
    }
    
}


public extension Bundle {
    
    class func configValue(forRootKey key: String) -> Any? {
        return Bundle.main.infoDictionary![key]
    }

    class var version: String {
        return Bundle.configValue(forRootKey: "CFBundleShortVersionString") as! String
    }
    
    class var build: String {
        return Bundle.configValue(forRootKey: "CFBundleVersion") as! String
    }
    
}


// via Ole Begemann
// (https://oleb.net/blog/2018/03/temp-file-helper/?utm_campaign=Swift%2BWeb%2BWeekly&utm_medium=email&utm_source=Swift_Web_Weekly_50)

/// A wrapper around a temporary file in a temporary directory. The directory
/// has been especially created for the file, so it's safe to delete when you're
/// done working with the file.
///
/// Call `deleteDirectory` when you no longer need the file.
struct TemporaryFile {
    let directoryURL: URL
    let fileURL: URL
    /// Deletes the temporary directory and all files in it.
    let deleteDirectory: () throws -> Void
    
    /// Creates a temporary directory with a unique name and initializes the
    /// receiver with a `fileURL` representing a file named `filename` in that
    /// directory.
    ///
    /// - Note: This doesn't create the file!
    init(creatingTempDirectoryForFilename filename: String) throws {
        let (directory, deleteDirectory) = try FileManager.default
            .urlForUniqueTemporaryDirectory()
        self.directoryURL = directory
        self.fileURL = directory.appendingPathComponent(filename)
        self.deleteDirectory = deleteDirectory
    }
}


public extension NSLayoutConstraint {
    
    class func fullScreenConstraints(forView view: UIView) -> [NSLayoutConstraint] {
        
        var constraints = [NSLayoutConstraint]()
        
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|",
                                                                   options: .alignAllLeft,
                                                                   metrics: nil,
                                                                   views: ["view":view])
        
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|",
                                                                 options: .alignAllTop,
                                                                 metrics: nil,
                                                                 views: ["view":view])
        
        
        constraints.append(contentsOf: horizontalConstraints)
        constraints.append(contentsOf: verticalConstraints)
        
        return constraints
    }
    
}

public extension UIColor {
    
    var cssRGBAString: String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
    
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    
        red = red * 255.0
        green = green * 255.0
        blue = blue * 255.0
    
        return "rgba(\(Int(red)),\(Int(green)),\(Int(blue)),\(alpha))"
    }
    
}
