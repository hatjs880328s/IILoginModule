//
//  OTTablistVw.swift
//  OralStunts
//
//  Created by Noah_Shan on 2018/5/25.
//  Copyright © 2018年 Inspur. All rights reserved.
//

import Foundation
@_exported import IIUIAndBizConfig
@_exported import SnapKit

class OTTablistVw: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var cellInfos = ["编辑", "移动", "删除"]
    
    var tab = UITableView()
    
    var didSelectAction: [(() -> Void)?] = []
    
    init(frame: CGRect, fatherVw: UIView) {
        super.init(frame: frame)
        fatherVw.addSubview(self)
        self.snp.makeConstraints { (mk) in
            mk.right.equalTo(-10)
            mk.width.equalTo(120)
            mk.height.equalTo( CGFloat(cellInfos.count) * 50 + 25)
            mk.top.equalTo(APPUIConfig.naviTopDistance)
        }
        self.alpha = 0
        initVw()
    }
    
    func initVw() {
        // rect add
        let rectImg = UIImageView()
        self.addSubview(rectImg)
        rectImg.snp.makeConstraints { (mk) in
            mk.right.equalTo(-3)
            mk.width.equalTo(20)
            mk.top.equalTo(0)
            mk.height.equalTo(25)
        }
        rectImg.image = UIImage(named: "MenuList.png")
        self.addSubview(tab)
        tab.separatorStyle = .none
        tab.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 14, left: 0, bottom: 0, right: 0))
        }
        tab.delegate = self
        tab.dataSource = self
        tab.layer.borderColor = UIColor.gray.cgColor
        tab.layer.borderWidth = 0.5
        tab.layer.cornerRadius = 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "ottablistTabcellReuseid")
        cell.selectionStyle = .none
        let title = UILabel()
        cell.addSubview(title)
        title.snp.makeConstraints { (mk) in
            mk.centerY.equalTo(cell.snp.centerY)
            mk.centerX.equalTo(cell.snp.centerX)
            mk.width.equalTo(150)
            mk.height.equalTo(15)
        }
        title.textAlignment = .center
        title.text = self.cellInfos[indexPath.row]
        title.font = APPUIConfig.uiFont(with: 12)
        // line
        if indexPath.row != 2 {
        let line = UIView()
            cell.addSubview(line)
            line.snp.makeConstraints { (mk) in
                mk.bottom.equalTo(0)
                mk.centerX.equalTo(cell.snp.centerX)
                mk.width.equalTo(80)
                mk.height.equalTo(0.5)
            }
            line.backgroundColor = APPUIConfig.lineLightGray
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellInfos.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.didSelectAction[indexPath.row] == nil { return }
        didSelectAction[indexPath.row]!()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
