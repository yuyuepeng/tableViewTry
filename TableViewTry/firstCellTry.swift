//
//  firstCellTry.swift
//  TableViewTry
//
//  Created by 扶摇先生 on 16/10/31.
//  Copyright © 2016年 扶摇先生. All rights reserved.
//

import UIKit
let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height


class firstCellTry: UITableViewCell {
    // 相当于oc的setModel
    var model1 : firstModelTry!
    
    var model : firstModelTry {
        set{
            self.model1 = newValue
            self.nameLabel.text = self.model1.title;
            self.backImage.sd_setImage(with: URL.init(string: self.model1.pic), placeholderImage: UIImage.init(named: "banner_placeHolder"))
        }
        get{
            return self.model1
        }
    }
    
    //懒加载创建标题label
    lazy var nameLabel: UILabel = {
        var singleLength = screenWidth/640.0
        var nameLabel = UILabel.init(frame: CGRect.init(x: 100 * singleLength, y: 300 * singleLength, width: 440 * singleLength, height: 80 * singleLength))
        nameLabel.font = UIFont.systemFont(ofSize: 15)
        nameLabel.textAlignment = NSTextAlignment.center;
        nameLabel.backgroundColor = UIColor.white
        return nameLabel
    }()
//    懒加载创建背景图
    lazy var backImage:UIImageView = {
        var singleLength = screenWidth/640.0
        var backImage = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 400 * singleLength))
        return backImage
    } ()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createSubViews()
    }
    fileprivate func createSubViews() {
        addSubview(backImage)
        self.backImage.addSubview(nameLabel)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
