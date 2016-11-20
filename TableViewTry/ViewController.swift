//
//  ViewController.swift
//  TableViewTry
//
//  Created by 扶摇先生 on 16/10/28.
//  Copyright © 2016年 扶摇先生. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    
//    tableView
    
    var tableView:UITableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: 414, height: UIScreen.main.bounds.size.height), style: UITableViewStyle.plain)
//    数据源（一个firstModelTry类型的数组）
    var dataSource:[firstModelTry] = Array()
//    单位长度
    var singleLength:CGFloat = 0.0
//    网络请求工具
    var manager:NetManager = NetManager()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = true;
        singleLength = UIScreen.main.bounds.size.width/640.0
        self.view.addSubview(tableView)
        self.title = "我的第一个swifttableView"
        tableView.delegate = self
        tableView.dataSource = self
//        加载数据源
        self.loadData()
        // Do any additional setup after loading the view, typically from a nib.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count;
        
    }
    func loadData() -> Void {
        manager.post(domain: "http://appapi.yx.dreamore.com/index/banners", path: "", form: ["":""], parameters: ["":""]) { (_ response: AnyObject?, message: String?) -> Void in
            
//            接请求下来的数组
            let arr3:NSArray = response as! NSArray
            for dict3:NSDictionary in arr3 as! [NSDictionary]{
//                遍历得到Model
                var model3 = firstModelTry()
                model3.mj_setKeyValues(dict3)//用到mjextension
                self.dataSource.append(model3)
            }
            self.tableView.reloadData()
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:firstCellTry = firstCellTry.init(style: UITableViewCellStyle.default, reuseIdentifier: nil)
//        创建cell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        let model:firstModelTry = self.dataSource[indexPath.row]
//        设置Model
        cell.model = model
        return cell
        
    }
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//    返回单元格高度
        return 400 * singleLength;
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

