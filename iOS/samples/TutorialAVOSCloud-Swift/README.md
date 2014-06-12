# AVOSCloud Tutorial iOS Demo Swift版本
###### 这个项目是为了帮助使用AVOSCloud的开发者, 用Swift开发怎么调用SDK。

## 前提
此项目需要安装xcode6-Beta或更新版本

## 安装Frameworks

本项目已经引入了AVOSCloud.framework,新项目请参考 [https://cn.avoscloud.com/start.html](https://cn.avoscloud.com/start.html)

----

## 使用说明

新项目请在`Project`->`Build Settings`->`Swift Compiler - Code Generation`->`Objective-C Bridging Header`设置桥接头文件，并在此头文件中加入

    #import "AVOSCloud/AVOSCloud.h"

[参考](https://developer.apple.com/library/prerelease/ios/documentation/swift/conceptual/buildingcocoaapps/MixandMatch.html#//apple_ref/doc/uid/TP40014216-CH10-XID_78)

----
## 其他

如果您在使用AVOSCloud SDK中, 有自己独特高效的用法, 非常欢迎您fork 并提交pull request, 帮助其他开发者更好的使用SDK. 我们将在本项目的贡献者中, 加入您的名字和联系方式(如果您同意的话)
