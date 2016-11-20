//
//  NetManager.swift
//  TableViewTry
//
//  Created by 扶摇先生 on 16/10/31.
//  Copyright © 2016年 扶摇先生. All rights reserved.
//

import UIKit
//网络封装afn
class NetManager: NSObject {
//    懒加载
    lazy var netManager:AFHTTPSessionManager = {
        var netManager = AFHTTPSessionManager.init()
        var set:NSSet = NSSet.init(objects: "application/json","text/html","text/json","text/javascript","text/plain")
        netManager.responseSerializer.acceptableContentTypes = set as? Set<String>
        return netManager
    }()
//    回调方法闭包返回数据和结果
    typealias finished = (_ response:AnyObject?, _ result:String?) ->Void
    override init() {
        
    }
//    post请求
    func post(domain:String,path:String,form:NSDictionary,parameters:NSDictionary,finished: @escaping finished) -> Void {
        var url:String = String()
//        拼接url方法
        url = self.pinjie(domain: domain, path: path, parameters: parameters)
        
        netManager.post(url as String, parameters: nil, constructingBodyWith: {(_ formData: AFMultipartFormData) -> Void in
//            上传表单的参数
            self.generate(formData: formData, data: form)
            }, progress: {(_ uploadProgress: Progress) -> Void in
                
            }, success: {(_ task: URLSessionDataTask, _ responseObject: Any) -> Void in
//                以下这句代码可以根据公司的数据结构文档修改，是获取我请求的url的返回的数据
                var dict:NSDictionary = NSDictionary.init(dictionary: responseObject as! NSDictionary)
                if (dict.object(forKey: "data") != nil) {
                    var arr:NSArray = dict["data"] as! NSArray
                    finished(arr,"成功")

                }else {
                    finished(["11","11"] as AnyObject,"失败")
                }
            }, failure: {(_ task: URLSessionDataTask?, _ error: Error) -> Void in
                finished(["11","11"] as AnyObject,"失败")
        })

    }
//    拼接url
    func pinjie(domain:String,path:String,parameters:NSDictionary) -> String {
        var url = "\(domain)"
        if !path.isEmpty {
            url += path
        }
        if parameters.allKeys.count != 0 {
            if parameters.allKeys[0] as! String == "" {
                
            }else {
            url += "?"
            for key: String in parameters.allKeys as! [String] {
                var value = (parameters.value(forKey: key) as! String)
                url += "\(key)=\(value)&"
            }
            url = "\(url as NSString).substring(with: NSRange(location: 0, length: url.characters.count - 1))"
            }
        }
        return url
//        var url = "\(domain)"
//            url += path
//        
//            url += "?"
//        
//            for key: String in parameters.allKeys as! [String]{
//                var value = (parameters.value(forKey: key) as! String)
//                url += "\(key)=\(value)&"
//            }
//            url = "\(url as NSString).substring(with: NSRange(location: 0, length: url.characters.count - 1))"
//            return url
    }
     func generate(formData:AFMultipartFormData,data:NSDictionary) -> Void {
        for key in data.allKeys {
//            遍历上传
            var value = data.value(forKey: (key as? String)!)
            if value is NSDictionary {
//                如果value是字典，继续执行该方法
                self.generate(formData: formData, data: value as! NSDictionary)
            }else if value is String {
                let strValue = value as! String
                
            formData.appendPart(withForm: strValue.data(using: String.Encoding.utf8)!, name: key as! String)
            }else if value is NSData {
                let keyStr = key as! NSString
                if keyStr.contains(".") {
                    let arr:[String] = keyStr.components(separatedBy: ".")
                    if arr.last == "png" || arr.last == "jpg"||arr.last == "jpeg" || arr.last == "m4a" {
                        let typeArray = TShopTools.mineType(with: value as! Data!).components(separatedBy: "/")
                        let fileName = "\(TShopTools.uniqueString()).\(typeArray.last!)"
                        formData.appendPart(withFileData: value as! Data, name: arr[0], fileName: fileName, mimeType: TShopTools.mineType(with: value as! Data))
                    }
                }else {
                formData.appendPart(withForm: value as! Data, name: (key as! NSString) as String)
                }
            }else if value is NSArray {//value是数组
                let valueArr:NSArray = value as! NSArray
                if valueArr.firstObject is UIImage {//上传图片的数组
                    var imageData:NSData = NSData()
                    var a = 1
                    
                    for image:UIImage in valueArr as! [UIImage]{
                        if UIImagePNGRepresentation(image) == nil {
                            let imageData1:Data = UIImageJPEGRepresentation(image, 1.0)!
                            imageData = imageData1 as NSData
                        }else {
                            let imageData2:Data = UIImagePNGRepresentation(image)!
                            imageData = imageData2 as NSData
                        }
                        formData.appendPart(withFileData: imageData as Data, name: key as! String, fileName: "\(TShopTools.uniqueString())\(a).jpg", mimeType: "image/jpg")
                        a += 1
                    }
                }else {
//                    上传字符串数组
                    var i = 0
                    for stringValue: String in valueArr as! [String] {
                        print("woshi\(i)---\(stringValue)")
                        formData.appendPart(withForm: stringValue.data(using: String.Encoding.utf8)!, name: key as! String)
                        i += 1
                    }
                }
                
            }else if value is UIImage {//上传单张图片
                var imageData:NSData = NSData();
                let image = (value as! UIImage)
                if UIImagePNGRepresentation(image) == nil {
                    let imageData1:Data = UIImageJPEGRepresentation(image, 1.0)!
                    imageData = imageData1 as NSData
                }else {
                    let imageData2:Data = UIImagePNGRepresentation(image)!
                    imageData = imageData2 as NSData
                }
                formData.appendPart(withFileData: imageData as Data, name: key as! String, fileName: "\(TShopTools.uniqueString()).jpg", mimeType: "image/jpg")
            }else {
                let valueStr = value as! NSValue
                let valueStr1 = value as! NSString
                let valueStr3 = valueStr as! NSNumber
                
                if valueStr.responds(to: #selector(getter: NSNumber.stringValue)) {
                    formData.appendPart(withForm:valueStr3.stringValue.data(using: String.Encoding.utf8)! , name: key as! String)
                }else if valueStr.responds(to: #selector(NSString.data(using:))) {
                formData.appendPart(withForm: valueStr1.data(using: String.Encoding.utf8.rawValue)!, name: key as! String)
                }
            }
        }
    }
}

