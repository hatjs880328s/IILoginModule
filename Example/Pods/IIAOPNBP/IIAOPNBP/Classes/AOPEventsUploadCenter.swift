//
// 
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * ** * * * *
//
// AOPEventsUploadCenter.swift
//
// Created by    Noah Shan on 2018/3/16
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

import Foundation
import UIKit

public class AOPEventUploadCenter: NSObject {
    
    private static let taskID = NSUUID().uuidString
    
    private static var shareInstance: AOPEventUploadCenter!
    
    var timer: Timer!
    
    @objc public var progressAction: ((_ strInfo: Data, _ dataName: String, _ endAction:@escaping (_ result: Bool) -> Void) -> Void)?
    
    private override init() {
        super.init()
    }
    
    public static func getInstance() -> AOPEventUploadCenter {
        if shareInstance == nil {
            shareInstance = AOPEventUploadCenter()
        }
        return shareInstance
    }
    
    /// AOP-NBP-uploadCenter service start
    public func startService() {
        DispatchQueue.once(taskid: AOPEventUploadCenter.taskID) {
            timer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(AOPEventUploadCenter.uploadEvents), userInfo: nil, repeats: true)
        }
    }
    
    @objc func uploadEvents() {
        GCDUtils.asyncProgress(dispatchLevel: 3, asyncDispathchFunc: {
            let allFilepath = AOPDiskIOProgress.getInstance().getAllSavedFilepath()
            for eachItem in allFilepath {
                let result = AOPDiskIOProgress.getInstance().getOneFileDataWithFilePath(with: eachItem)
                if result != nil {
                    if self.progressAction == nil { return }
                    let fileName = String(eachItem.split(separator: "/").last!)
                    self.progressAction!(result!, fileName) { resultAction in
                        if resultAction {
                            var uploadLog = APIEvent()
                            uploadLog.setBaseInfo(apiName: "此次上传总数为\(allFilepath.count),上传成功一个|已删除1个", time: Date(), requestType: 0)
                            AOPNBPCoreManagerCenter.getInstance().writeCustomLog(event: uploadLog)
                            AOPDiskIOProgress.getInstance().deleateFile(with: eachItem)
                        }
                    }
                }
            }
        }) {
        }
    }
    
}

//class SecondProcess: UIView,URLSessionDelegate,URLSessionDownloadDelegate {
//    var opq = OperationQueue()
//
//    func uploadWithSecondProcess(action: @escaping (_ imageData: Data)->Void) {
//        let confige = URLSessionConfiguration.background(withIdentifier: "Inspur.sourceTxt77.secondProcessw")
//        let session = URLSession(configuration: confige, delegate: self, delegateQueue: opq)
//        let url = URL(string: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1523279081571&di=9810b505112794371a8f63d6818a2a05&imgtype=0&src=http%3A%2F%2Fimg3.redocn.com%2Ftupian%2F20160321%2Fxiaolianbaiyunxingzhuangbeijingsucai_6032357_small.jpg")
//        let request = URLRequest(url: url!)
//        let task = session.downloadTask(with: request)
//        task.resume()
//        print("hehe")
//    }
//
//    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL){
//        let path  = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] + "/" + location.absoluteString.components(separatedBy: "/").last!
//        print(path)
//        print(location)
//        let manager = FileManager.default
//        do {
//            try manager.moveItem(at: location, to: URL(fileURLWithPath: path))
//        }catch {
//            print(error)
//        }
//
//        do {
//            let data = try Data(contentsOf: URL(fileURLWithPath: path))
//            DispatchQueue.main.async {
//                let con = (self.viewController() as! TwoViewController)
//                con.image.image = UIImage(data: data)
//            }
//        }catch {
//            print(error)
//        }
//    }
//
//
//}
