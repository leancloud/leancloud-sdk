//
//  Constants.swift
//  TutorialAVOSCloud-Swift
//
//  Created by Qihe Bian on 6/9/14.
//  Copyright (c) 2014 AVOS. All rights reserved.
//

let WALL_OBJECT = "WallImageObject"
let KEY_COMMENT = "comment"
let KEY_IMAGE = "image"
let KEY_USER = "user"
let KEY_ID = "objectId"
let KEY_GEOLOC = "location"
let KEY_CREATION_DATE = "createdAt"


func RGB(r:Int, g:Int, b:Int) -> UIColor {
    return UIColor(red:(Float(r) / 255.0), green:(Float(g) / 255.0), blue:(Float(b) / 255.0), alpha:1)
}

func RGBA(r:Int, g:Int, b:Int, a:Float) -> UIColor {
    return UIColor(red:(Float(r) / 255.0), green:(Float(g) / 255.0), blue:(Float(b) / 255.0), alpha:a)
}
