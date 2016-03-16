//
//  GrandModel.swift
//  GrandModelDemo
//
//  Created by HuStan on 3/9/16.
//  Copyright © 2016 StanHu. All rights reserved.
//
import Foundation
import UIKit


protocol MapAble{
    static func mapModel(obj:AnyObject)->Self
}

class GrandModel:NSObject,NSCoding{
    class var selfMapDescription:[String:String]?{
        return nil
    }
    static var typeMapTable:[String:[String:(String,AnyClass)]] = [String:[String:(String,AnyClass)]]()
    required override init() {
        super.init()
        let modelName = "\(self.dynamicType)"
        if self.dynamicType == GrandModel.self
        {
            return
        }
        if !GrandModel.typeMapTable.keys.contains(modelName){
            GrandModel.typeMapTable[modelName] = [String:(String,AnyClass)]()
        }
        if GrandModel.typeMapTable[modelName]!.count != 0{
            return
        }
        //  let z = NSClassFromString("_TtC11DemoConsole9DemoOther")
        //对于NSIndexPath还有NSRange之类的就算了
        let count:UnsafeMutablePointer<UInt32> =  UnsafeMutablePointer<UInt32>()
        var properties = class_copyPropertyList(self.dynamicType, count)
        properties.debugDescription
        while properties.memory.debugDescription !=  "0x0000000000000000"{
            let a = property_getAttributes(properties.memory)
            let d = NSString(CString: a, encoding: NSUTF8StringEncoding)
            //这样对于没有赋值的类型，会转为String,这肯定会不行，要想其他的办法,
            //看看Attribute有什么东西,Attribute可以获取一个完整的类名，用这个类名可以获取
            //这个类，下面实战试试
            
            let cTypes = d!.componentsSeparatedByString(",")
            if let className = cTypes.first
            {
                if let proertyName = cTypes.last{
                    let pn = (proertyName as NSString).substringFromIndex(1)
                    if d!.containsString("\""){
                        let cn = (className.stringByReplacingOccurrencesOfString("\"", withString: "") as NSString).substringFromIndex(2)
                        GrandModel.typeMapTable[modelName]![pn] = (cn,NSClassFromString(cn)!)
                    }
                    else if d!.containsString("{"){ //用{来可能比较好一点
                        let cgType = (className as NSString).substringWithRange(NSMakeRange(4, 4))
                        switch cgType{
                        case "Rect":GrandModel.typeMapTable[modelName]![pn] = ("CGRect",NSValue.self)
                        case "Size":GrandModel.typeMapTable[modelName]![pn] = ("CGSize",NSValue.self)
                        case "Poin":GrandModel.typeMapTable[modelName]![pn] = ("CGPoint",NSValue.self)
                        default:break
                        }
                    }
                    else{
                        let numType = (className as NSString).substringWithRange(NSMakeRange(1, 1))
                        switch numType{
                        case "q": GrandModel.typeMapTable[modelName]![pn] = ("Int",NSNumber.self)
                        case "f": GrandModel.typeMapTable[modelName]![pn] = ("Float",NSNumber.self)
                        case "d": GrandModel.typeMapTable[modelName]![pn] = ("Double",NSNumber.self)
                        default:break
                        }
                    }
                }
            }
            properties = properties.successor()
        }
    }
    
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        print("没有这个字段-------\(key)")
    }
    
    // 不能重写这个方法,如果重写的话,子类会无法找到重写的方法
    //    override func setValue(value: AnyObject?, forKey key: String) {
    //        var resultValue:AnyObject?
    //        if let v = value{
    //            if v is NSNull{
    //                  print("这个字段是Null值-------\(key)")
    //                resultValue = ""
    //            }
    //        }
    //        if key == "id"{
    //            print("关键字冲突!  !  !  !  !------\(key)")
    //        }
    //        resultValue = value
    //        super.setValue(resultValue, forKey: key)
    //    }
    /*
    func encodeWithCoder(aCoder: NSCoder) {
        let modelName = "\(self.dynamicType)"
        let dictProperties = GrandModel.typeMapTable[modelName]
        let count:UnsafeMutablePointer<UInt32> =  UnsafeMutablePointer<UInt32>()
        var properties = class_copyPropertyList(self.dynamicType, count)
        while properties.memory.debugDescription !=  "0x0000000000000000"{
            let t = property_getName(properties.memory)
            let n = NSString(CString: t, encoding: NSUTF8StringEncoding) as! String
            let v = self.valueForKey(n)
            encode(dictProperties![n]!.0, propertyName: n, value: v, aCoder: aCoder)
            properties = properties.successor()
        }
        
    }
    
    func encode(classType:String,propertyName:String,value:AnyObject?,aCoder:NSCoder){
        switch classType{
        case "Int": aCoder.encodeInteger(value as! Int, forKey: propertyName)
        case "Float": aCoder.encodeFloat(value as! Float, forKey: propertyName)
        case "Double": aCoder.encodeDouble(value as! Double, forKey: propertyName)
        case "CGRect": aCoder.encodeCGRect((value as! NSValue).CGRectValue(), forKey: propertyName)
        case "CGSize": aCoder.encodeCGSize((value as! NSValue).CGSizeValue(), forKey: propertyName)
        case "CGPoint": aCoder.encodeCGPoint((value as! NSValue).CGPointValue(), forKey: propertyName)
        default:aCoder.encodeObject(value, forKey: propertyName)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        let modelName = "\(self.dynamicType)"
        let dictProperties = GrandModel.typeMapTable[modelName]
        let count:UnsafeMutablePointer<UInt32> =  UnsafeMutablePointer<UInt32>()
        var properties = class_copyPropertyList(self.dynamicType, count)
        var result:AnyObject?
        while properties.memory.debugDescription !=  "0x0000000000000000"{
            let t = property_getName(properties.memory)
            let n = NSString(CString: t, encoding: NSUTF8StringEncoding) as! String
            let classType = dictProperties![n]!.0 //获取类型
            switch classType{
            case "Int": result = aDecoder.decodeIntegerForKey(n)
            case "Float": result = aDecoder.decodeFloatForKey(n)
            case "Double": result = aDecoder.decodeDoubleForKey(n)
            case "CGRect":
                result = NSValue(CGRect:aDecoder.decodeCGRectForKey(n))
            case "CGPoint":
                result = NSValue(CGPoint:aDecoder.decodeCGPointForKey(n))
            case "CGSize":
                result = NSValue(CGSize:aDecoder.decodeCGSizeForKey(n))
            default:result = aDecoder.decodeObjectForKey(n)
            }
            if result != nil{
                self.setValue(result!, forKey: n)
            }
            properties = properties.successor()
        }
    }
*/
    
    
    func encodeWithCoder(aCoder: NSCoder) {
        let item = self.dynamicType.init()
        let properties = item.getSelfProperty()
        for propertyName in properties{
            let value = self.valueForKey(propertyName)
            aCoder.encodeObject(value, forKey: propertyName)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        let item = self.dynamicType.init()
        let properties = item.getSelfProperty()
        for propertyName in properties{
            let value = aDecoder.decodeObjectForKey(propertyName)
            self.setValue(value, forKey: propertyName)
        }
    }
    
    
    func getSelfProperty()->[String]{
        var selfProperties = [String]()
        let count:UnsafeMutablePointer<UInt32> =  UnsafeMutablePointer<UInt32>()
        var properties = class_copyPropertyList(self.dynamicType, count)
        while properties.memory.debugDescription !=  "0x0000000000000000"{
            let t = property_getName(properties.memory)
            let n = NSString(CString: t, encoding: NSUTF8StringEncoding)
            selfProperties.append(n! as String)
            properties = properties.successor()
        }
        return selfProperties
    }
}

extension GrandModel:MapAble{
    static func mapModel(obj:AnyObject)->Self{
        //  let modelName = "\(self)"
        let model = self.init()
        if let mapTable = self.selfMapDescription{
            if let dict = obj as? [String:AnyObject]
            {
                for item in dict{
                    if let key = mapTable[item.0]{
                        print("key 为\(item.0)将要被设成\(mapTable[item.0),其值是 \(item.1)")
                        
                        //首先判断其类型
                        //              if   GrandModel.typeMapTable[modelName]!.keys.contains(key) &&  GrandModel.typeMapTable[modelName]![key]! is GrandModel.Type{
                        //                 let classType = GrandModel.typeMapTable[modelName]![key]!
                        //              var  s =  (classType as! GrandModel.Type).init()
                        //在这里用静态方法是行不通的，只有用非静态方法了
                        //如果使用静态的方式来转换，到这里已经是死胡同了。因为在这里无法获取映射表
                        //以后再研究，
                        
                        //                            let modelItem =
                        //
                        //                            model.setValue(modelItem, forKey: key)
                        //     }
                        //  else{
                        if item.1 is NSNumber{
                            model.setValue("\(item.1)", forKey: key)
                        }
                        else{
                            model.setValue(item.1, forKey: key)
                        }
                        //   }
                    }
                }
            }
        }
        return model
    }
}


extension GrandModel:CustomDebugStringConvertible{
    internal override var description:String{
        get{
            var dict = [String:AnyObject]()
            let count:UnsafeMutablePointer<UInt32> =  UnsafeMutablePointer<UInt32>()
            var properties = class_copyPropertyList(self.dynamicType, count)
            while properties.memory.debugDescription !=  "0x0000000000000000"{
                let t = property_getName(properties.memory)
                let n = NSString(CString: t, encoding: NSUTF8StringEncoding)
                let v = self.valueForKey(n as! String) ?? "nil"
                dict[n as! String] = v
                properties = properties.successor()
            }
            return "\(self.dynamicType):\(dict)"
        }
    }
    internal override var debugDescription:String{
        get{
            return self.description
        }
    }
}