//
//  DZCarDetialTableView.swift
//  FSZCItem
//
//  Created by apple on 2016/11/16.
//  Copyright © 2016年 Mrshan. All rights reserved.
//

import UIKit
import IIUIAndBizConfig
import IIBLL
import Foundation

public protocol MoreTableProtocol: NSObjectProtocol {
    func progress(index: Int)
}

/// 自定义弹出tableview ----使用方式：  只要定义他的origin即可，也可以受用snp定义他的 origin---然后顺序添加闭包到tapactions数组, allwidth是自己需要的宽度，默认为150
@objc public class MoreTableView: UIView, UITableViewDelegate, UITableViewDataSource {

    //文字列表
    @objc public var dataListName = NSMutableArray()
    //图片列表
    @objc public var dataListImage = NSMutableArray()
    //背景图片
    @objc public var backGroundImageView = UIImageView()
    //当前页面的tableview
    @objc public var myTableView: UITableView!
    //遮蔽层
    @objc public var bigBGGrayView = UIView()
    //处理事件代理方法
    public weak var del: MoreTableProtocol?
    /// 对外暴露 - cell背景颜色
    @objc public var cellBgColor: UIColor = UIColor.white
    /// 对外暴露 - cell tint color
    @objc public var cellTintColor: UIColor!// = APPUIConfig.mainCharColor
    /// 遮蔽层 - 背景色： 默认为黑色
    @objc public var bigBGVwBackColor: UIColor = UIColor.black
    /// 遮蔽层 - 背景色透明度： 默认0.2
    @objc public var bigBGVwBackColorAlpha: CGFloat = 0.2
    /// action方式执行 - 不适用代理
    @objc public var action: ((_ idx: Int) -> Void)?

    /// 使用方式：只要定义他的origin即可，也可以受用snp定义他的 origin---然后顺序添加闭包到tapactions数组, allwidth是自己需要的宽度，默认为150
    ///
    /// - Parameters:
    ///   - frame: 无意义
    ///   - dataList: 文字数组
    ///   - imageList: 图片名字数组
    @objc public init(frame: CGRect, dataList: NSMutableArray, imageList: NSMutableArray, allWidth: Int = 150) {
        super.init(frame: frame)
        self.dataListImage = imageList
        self.dataListName = dataList
        self.frame.origin = CGPoint(x: 0, y: 0)
        //设置背景图片的 size
        let heightI = 15 + 15 + 50 * dataList.count
        self.frame.size = CGSize(width: allWidth, height: heightI)
        let aks = UIEdgeInsets(top: 30, left: 20, bottom: 20, right: 20)
        let ak = UIImage(named: "Combined Shape")?.resizableImage(withCapInsets: aks, resizingMode: .stretch)
        backGroundImageView.image = ak
        self.addSubview(backGroundImageView)
        backGroundImageView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        }
        myTableView = UITableView(frame: CGRect.zero)
        myTableView.backgroundColor = UIColor(red: 7 / 255, green: 142 / 255, blue: 206 / 255, alpha: 1)
        self.addSubview(myTableView)
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        self.myTableView.isScrollEnabled = false
        self.myTableView.separatorStyle = .none
        myTableView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(10)
            make.top.equalTo(17)
            make.bottom.equalTo(-15)
            make.right.equalTo(-10)
        }
        myTableView.separatorStyle = .none
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataListName.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CustomMoreTabVCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "noreuse")
        cell.selectionStyle = .none
        cell.setInfo(image: UIImage(named: "\(dataListImage[indexPath.row])")!, titleInfo: "\(dataListName[indexPath.row])", tintColor: self.cellTintColor, bgColor: self.cellBgColor)
        return cell
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //执行每个cell的点击事件
        del?.progress(index: indexPath.row)
        //action方式执行点击事件
        if let realAction = self.action {
            realAction(indexPath.row)
        }
        //隐藏这个TABLE
        hidenSelf()
    }

    /**
     显示自己--添加一个遮蔽层
     */
    @objc public func showSelf() {
        if self.superview != nil {
            bigBGGrayView.isHidden = false
            bigBGGrayView.frame = CGRect(x: 0, y: 0, width: APPUIConfig.aWeight, height: APPUIConfig.aHeight)
            bigBGGrayView.alpha = bigBGVwBackColorAlpha
            bigBGGrayView.backgroundColor = bigBGVwBackColor
            bigBGGrayView.tapActionsGesture({ [weak self] in
                self?.hidenSelf()
            })
            self.superview?.insertSubview(bigBGGrayView, belowSubview: self)
        }
        self.alpha = 1
        self.isHidden = false
        self.transform = CGAffineTransform.identity
        myTableView.isHidden = false
        myTableView.alpha = 1
        self.myTableView.reloadData()
    }

    /**
     隐藏自己
     */
    @objc public func hidenSelf() {
        UIView.animate(withDuration: 0.3, animations: {[weak self]  in
            self?.bigBGGrayView.isHidden = true
            self?.alpha = 0
        }) { (_) in

        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
