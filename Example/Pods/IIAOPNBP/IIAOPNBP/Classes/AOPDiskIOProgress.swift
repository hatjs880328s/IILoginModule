//
// 
//  AOPMmapIOProgress.swift
//  source
//
//  Created by Noah_Shan on 2018/4/8.
//  Copyright © 2018年 Inspur. All rights reserved.
//
// 
import Foundation
import IISwiftBaseUti

/*
 DISK-progress center
 TODO:
 1.use mmap save the memory event infos
 2.read event info from file : if success then deleate the file ,
   if deleate file success return the fileStrinfo else return nil.
   user should not invoking the deleate function manual.
 3.basic file/dir progress [file create | file deleate | file read | file write(use mmap)]
 4.if noah_shan folder exists one file return else analyze all expect newest file
 */

public class AOPDiskIOProgress: NSObject {
    
    private override init() {
        super.init()
        AOPDiskIOProgressUtility().createTheDir()
    }
    
    private static var shareInstance: AOPDiskIOProgress!
    
    public static func getInstance() -> AOPDiskIOProgress {
        if shareInstance == nil {
            shareInstance = AOPDiskIOProgress()
        }
        return shareInstance
    }
    
    /// set
    public func writeEventsToDisk(with info: [String: [GodfatherEvent]]) {
        for (eachKey, eachValue) in info {
            var eventStr = ""
            for eachItem in eachValue {
                eventStr += (eachItem.description)
            }
            AOPMmapSwiftUtility.write2MmapFileSys(name: eachKey + "|" + (AOPNBPCoreManagerCenter.mmapFileName), fileContent: eventStr)
        }
    }
    
    /// get all file-path
    @objc func getAllSavedFilepath() -> [String] {
        let result = AOPDiskIOProgressUtility().loopGetDocumentsFileExceptNewestFile()
        var realResult = [String]()
        for i in result {
            realResult.append(i.realPath)
        }
        return realResult
    }
    
    /// get one file strInfo with file-name
    func getOneFileStrinfoWithFilePath(with path: String) -> String? {
        do {
            let resultStr = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
            return resultStr
        } catch {
            return nil
        }
    }
    
    /// get one file data with file-name
    @objc func getOneFileDataWithFilePath(with path: String) -> Data? {
        do {
            var resultStr = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
            resultStr = resultStr.replace(find: "\0", replaceStr: "")
            let dataInfo = resultStr.data(using: String.Encoding.utf8)
            return dataInfo
        } catch {
            return nil
        }
    }
    
    /// deleate file with filePath
    @discardableResult
    @objc func deleateFile(with filePath: String) -> Bool {
        return AOPDiskIOProgressUtility().deleateFile(with: filePath)
    }
}
