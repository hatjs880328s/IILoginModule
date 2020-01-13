//
// 
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * ** * * * *
//
// AOPSwiftExtension.swift
//
// Created by    Noah Shan on 2018/3/14
// InspurEmail   shanwzh@inspur.com
// GithubAddress https://github.com/hatjs880328s
//
// Copyright © 2018年 Inspur. All rights reserved.
//
// For the full copyright and license information, plz view the LICENSE(open source)
// File that was distributed with this source code.
//
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * ** * * * *
//
//

import UIKit
import Foundation

extension Date {
    
    /// date fromat
    ///
    /// :param format: yyyy-MM-dd HH:mm:ss / yyyy-MM-dd / yyyyMMddHHmmss / MMddHHmmss
    ///
    /// returns: String
    public func dateToString(_ format: String) -> String {
        let formats = DateFormatter()
        formats.dateFormat = format
        formats.timeZone = TimeZone(identifier: "GMT8")
        let resultStr = formats.string(from: self) as NSString
        return resultStr.substring(to: (format as NSString).length)
    }
}

extension UIResponder {
    /// get uiresponder first viewcontroller(belongs which vc)
    @objc public func iiViewController() -> UIViewController? {
        if self.isKind(of: UIViewController.self) { return self as? UIViewController }
        if self.next == nil { return nil }
        if (self.next?.isKind(of: UIViewController.self))! {
            return self.next as? UIViewController
        } else {
            return self.next!.iiViewController()
        }
    }
}

extension NSString {
    
    public var countOfCharacters: Int {
        get {
            return self.length
        }
    }
    
    ///sub str to arr<string>
    public func subStrEachParameterCharacter(countPara: Int) -> Array<String> {
        assert(countPara != 0, "coutld't be 0")
        
        var strArr: Array<String> = Array()
        let charactersCount = self.countOfCharacters
        
        for i in 0 ..< charactersCount / countPara {
            let eachStr = self.substring(with: NSRange(location: i * countPara, length: countPara))
            strArr.append(eachStr)
        }
        
        let lastCharacters = charactersCount % countPara
        if lastCharacters != 0 {
            strArr.append(self.substring(with: NSRange(location: charactersCount - lastCharacters, length: lastCharacters)))
        }
        
        return strArr
    }
}

/// debug print log in console
public func DEBUGPrintLog(_ logInfo: String) {
    func printPro(str: String) -> Bool {
        print(str)
        return true
    }
    assert(printPro(str: logInfo))
}
