//
//  *******************************************
//
//  File.swift
//  impcloud_dev
//
//  Created by Noah_Shan on 2019/1/16.
//  Copyright © 2018 Inpur. All rights reserved.
//
//  *******************************************
//

import UIKit
import Foundation
@_exported import II18N
@_exported import IIOCUtis

/// 弹出选择相册 & 拍照功能
public class IIAlbumAndPhoto: NSObject, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    /// III18NStaticClass().iiexcCancel
    @objc public static var cancelTxt: String = ""

    /// III18NStaticClass().iipersonCerterUploadAlbum
    @objc public static var uploadTxt: String = ""

    /// III18NStaticClass().iipersonCenterUploadCamera
    @objc public static var uploadCameraTxt: String = ""

    var con: UIViewController?

    var endAction: ((_ image: UIImage) -> Void)?

    public override init() {
        super.init()
    }

    public func showSheet(vi: UIView, con: UIViewController, endAction: @escaping (_ image: UIImage) -> Void) {
        self.con = con
        let sheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: getI18NStr(key: IIAlbumAndPhoto.cancelTxt), destructiveButtonTitle: nil, otherButtonTitles: getI18NStr(key: IIAlbumAndPhoto.uploadTxt), getI18NStr(key: IIAlbumAndPhoto.uploadCameraTxt))
        sheet.actionSheetStyle = UIActionSheetStyle.default
        sheet.show(in: vi)
        self.endAction = endAction
    }

    public func actionSheet(_ actionSheet: UIActionSheet, didDismissWithButtonIndex buttonIndex: Int) {
        switch buttonIndex {
        case 0:
            break
        case 1:
            self.openAlbum()
        default:
            self.openPicture()
        }
    }

    /// 使用相机
    public func openPicture() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            if !Utilities.judgeCameraPermissions() {
                self.con?.present(ShowAlertClass.getCameraSettingAlert(cancelHandler: {}), animated: true, completion: nil)
            } else {
                let pick = UIImagePickerController()
                pick.delegate = self
                pick.allowsEditing = false
                pick.sourceType = .camera
                self.con?.present(pick, animated: true, completion: nil)
            }
        } else {
        }
    }

    /// 去相册
    public func openAlbum() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            let pick = UIImagePickerController()
            pick.delegate = self
            pick.allowsEditing = false
            pick.sourceType = .photoLibrary
            self.con?.present(pick, animated: true, completion: {
                UIApplication.shared.statusBarStyle = .default
            })
        }
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        //拍照直接显示，从相册选择显示一个确认页面
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        if picker.sourceType == .camera {
            self.endAction?(image)
        } else {
            SelectPictureConfirmManager().showPictureConfirmPage(image) { (resultImage: UIImage?) in
                self.endAction?(resultImage!)
            }
        }
    }
    //替换系统默认拍照的使用照片按钮
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        CameraReplaceSystemTakePhotoButtonClass.replaceSystemTakePhotoButtons(viewController)
    }

}
