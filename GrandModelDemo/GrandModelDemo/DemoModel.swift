//
//  DemoModel.swift
//  GrandModelDemo
//
//  Created by Tyrant on 2/27/16.
//  Copyright © 2016 Qfq. All rights reserved.
//

import Foundation

enum Gender:Int{
    case Male = 0,Female
}

class DemoModel:GrandModel {
    var id:Int = 0
    var name:String?
    var gender:Gender?
    var isTop:Bool = false
}


class DemoModel1: GrandModel {
    var bookId = 0
    var bookName:String?
    var bookClass:String?
}