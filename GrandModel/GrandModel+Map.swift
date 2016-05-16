//
//  GrandModel+Map.swift
//  GrandModelDemo
//
//  Created by HuStan on 5/15/16.
//  Copyright © 2016 StanHu. All rights reserved.
//

import Foundation
//我写的什么破玩意，
//和别人的没法比啊，
//让我无地自容啊
extension GrandModel{
    static func map(obj:AnyObject)->Self{
        //  let modelName = "\(self)"
        let model = self.init()
        let modelName = "\(model.dynamicType)"
        let dictTypes = GrandModel.typeMapTable[modelName]
        if let dict = obj as? [String:AnyObject]
        {
            for item in dict{
                var key = item.0  //如果Server传过来的Key和自己写的key完全是一样的，那么用这个
                if model.selfMapDescription != nil { //如果Server传过来的Key和自己写的key不一样的，那么用这个
                    key = model.selfMapDescription![item.0]!    //如果Server传过来的Key只有部分是一样的？那么怎么办，不好意思，还是老实地写个映射表吧
                }
                print("key 为\(item.0)将要被设成\(key),其值是 \(item.1)")
                let type = dictTypes![key]
                if type == nil {  //正常这里不会是nil
                    continue
                }
                if item.1 is NSNull {
                    continue
                }
                if type!.isArray{
                    //这里就比较麻烦点
                    if let res = type!.isAggregate(){
                        var arrAggregate = []
                        if res is Int.Type {
                            arrAggregate = parseAggregateArray(dict[key] as! NSArray, basicType: GrandType.BasicType.Int, ins: 0)
                        }else if res is Float.Type {
                            arrAggregate = parseAggregateArray(dict[key] as! NSArray, basicType: GrandType.BasicType.Float, ins: 0.0)
                        }else if res is Double.Type {
                            arrAggregate = parseAggregateArray(dict[key] as! NSArray, basicType: GrandType.BasicType.Double, ins: 0.0)
                        }else if res is String.Type {
                            arrAggregate = parseAggregateArray(dict[key] as! NSArray, basicType: GrandType.BasicType.String, ins: "")
                        }else if res is NSNumber.Type {
                            arrAggregate = parseAggregateArray(dict[key] as! NSArray, basicType: GrandType.BasicType.NSNumber, ins: NSNumber())
                        }else{
                            arrAggregate = dict[key] as! [AnyObject]
                        }
                        model.setValue(arrAggregate, forKeyPath: key)
                    }else{
                        let elementModelType =  GrandType.makeClass(type!) as! GrandModel.Type
                        let dictKeyArr = item.1 as! NSArray
                        var arrM: [GrandModel] = []
                        for (_, value) in dictKeyArr.enumerate() {
                            let elementModel = elementModelType.map(value as! NSDictionary)
                            arrM.append(elementModel)
                        }
                        model.setValue(arrM, forKeyPath: key)
                    }
                }
                else if !type!.isReflect {
                    if  type!.typeClass == Bool.self{
                        model.setValue(item.1.boolValue, forKeyPath: key)
                    }else {
                        model.setValue(item.1, forKeyPath: key)
                    }
                    continue
                }
                else {
                    if !(item.1 is NSNull)
                    {
                        let cls = ClassFromString(type!.typeName)
                        model.setValue((cls as! GrandModel.Type).map(item.1 as! NSDictionary), forKeyPath: key)
                    }
                    continue
                }
            }
        }
        return model
    }
    class func parseAggregateArray<T>(arrDict: NSArray,basicType: GrandType.BasicType, ins: T) -> [T]{
        var intArrM: [T] = []
        if arrDict.count == 0 {return intArrM}
        for (_, value) in arrDict.enumerate() {
            var element: T = ins
            let v = "\(value)"
            if T.self is Int.Type {
                element = Int(Float(v)!) as! T
            }
            else if T.self is Float.Type {element = v.floatValue as! T}
            else if T.self is Double.Type {element = v.doubleValue as! T}
            else if T.self is NSNumber.Type {element = NSNumber(double: v.doubleValue!) as! T}
            else{element = value as! T}
            intArrM.append(element)
        }
        return intArrM
    }

    

}

