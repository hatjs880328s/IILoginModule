//
// 
//  AOPDiskIOProgressUtility.swift
//  source
//
//  Created by Noah_Shan on 2018/4/10.
//  Copyright © 2018年 Inspur. All rights reserved.
//
// 
import Foundation

class AOPDiskIOProgressUtility: NSObject {
    
    private let realAOPDirFolder: String = "/AOPNBPUTFile"
    
    private let nouseFileName: String = "DS_Store"
    
    private let createTimeKey: String = "NSFileCreationDate"

    /// retains the file 3days
    private let retain3Days: Double = 3 * 3_600 * 24
    
    /// get documents file path
    private func getDocumentsPath() -> String {
        let documentPaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,
                                                                FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentPath = documentPaths[0]
        return documentPath
    }
    
    /// create the [/AOPNBPUTFile] dir
    public func createTheDir() {
        let aopDir = self.getDocumentsPath() + realAOPDirFolder
        if !FileManager.default.fileExists(atPath: aopDir) {
            do {
                try FileManager.default.createDirectory(atPath: aopDir, withIntermediateDirectories: true, attributes: nil)
            } catch {}
        }
    }
    
    /// deleate file with path
    public func deleateFile(with filePath: String) -> Bool {
        do {
            try FileManager.default.removeItem(atPath: filePath)
        } catch {
            return false
        }
        return true
    }
    
    /// get [/AOPNBPUTFile] dirpath's files
    public func loopGetDocumentsFileExceptNewestFile() -> [FilePathModel] {
        let dirPath = self.getDocumentsPath() + realAOPDirFolder
        var filePaths = [FilePathModel]()
        let array = getContentFromFolderDESC()
        if array.count <= 1 {
            return filePaths
        }
        for i in 0 ..< array.count {
            if i == 0 { continue }
            var isDir: ObjCBool = true
            let fullPath = "\(dirPath)/\(array[i].realPath)"
            let model = FilePathModel(date: array[i].date, realPath: fullPath)
            if FileManager.default.fileExists(atPath: fullPath, isDirectory: &isDir) {
                if !isDir.boolValue {
                    filePaths.append(model)
                }
            }
        }
        return filePaths
    }
    
    /// sorted file path
    private func getContentFromFolderDESC() -> [FilePathModel] {
        let dirPath = self.getDocumentsPath() + realAOPDirFolder
        var sortedFilePath: [FilePathModel] = []
        do {
            let fileArr = try FileManager.default.contentsOfDirectory(atPath: dirPath)
            for eachItem in fileArr {
                if eachItem.contains(nouseFileName) { continue }
                let arrInfo = try FileManager.default.attributesOfItem(atPath: "\(dirPath)/\(eachItem)")
                guard let dataInfo = arrInfo[FileAttributeKey(rawValue: createTimeKey)] as? Date else { continue }
                let fileModel = FilePathModel(date: dataInfo.timeIntervalSinceReferenceDate, realPath: eachItem)
                sortedFilePath.append(fileModel)
            }
            let resultFileArr = IIMergeSort.sort(array: sortedFilePath, sortState: "desc")
            return resultFileArr
        } catch {
            return sortedFilePath
        }
    }

    /// save log 3days - then delete it
    public func deleteLogs3DaysBefore() {
        //let today = Date()
        let allFiles = self.loopGetDocumentsFileExceptNewestFile()
        for eachItem in allFiles {
            if Date().timeIntervalSinceReferenceDate - eachItem.date > retain3Days {
                do {
                    try FileManager.default.removeItem(atPath: eachItem.realPath)
                } catch {
                    //dothing...
                }
            }
        }
    }
}

class FilePathModel: NSObject, Comparable {

    var date: TimeInterval = 0
    var realPath: String = ""
    
    init(date: TimeInterval, realPath: String) {
        super.init()
        self.date = date
        self.realPath = realPath
    }
    
    static func < (lhs: FilePathModel, rhs: FilePathModel) -> Bool {
        return lhs.date < rhs.date
    }
    
    static func > (lhs: FilePathModel, rhs: FilePathModel) -> Bool {
        return lhs.date > rhs.date
    }
    
    static func == (lhs: FilePathModel, rhs: FilePathModel) -> Bool {
        return lhs.date == rhs.date
    }
}
