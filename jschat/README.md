
##  方法
### new AVChatClient(settings)
```
settings:{
  appId: 应用ID,
  peerId: 当前用户的PeerID,
  auth: 私聊签名函数(当平台设置启动签名后，需要传递),
  groupAuth: 群组聊天签名函数(当平台设置启动签名后，需要传递),
  watchingPeerIds: (非必须)
}
```
具体签名函数 需要类似下面的示例格式，基于 Promise 的异步操作。

```
function auth(peerId, watchingPeerIds){
  // 类似
  /*
  return new Promise(resolve,reject){

    //这里放ajax auth code
    resolve({
      watchingPeerIds: ajax返回值
    });

  }
  */
  //这里实现了一个空函数
  return Promise.resolve({
    watchingPeerIds: watchingPeerIds||[]
  });
}
function groupAuth(peerId, groupId, action, groupPeerIds){
  return Promise.resolve({
    groupPeerIds: groupPeerIds || []
  });
}

```
实例化一个 消息客户端
### open()
打开链接，需要先执行上面的 new,

```
 open().then(function(data){
  //打开成功
})
```

所有方法都会返回promise then,因为都是异步执行，这样可以确认成功失败。
### close()
关闭链接
### send(msg, to, transient)
 发送私聊消息
 参数：msg:消息内容, to:发送目标 PeerId, transient（非必须):为true时代表无需离线，默认为支持离线发送。

 ```
 send().then(function(data){
  //success full send callback
  },function(err){
  //error callback
})
```

### watch(peers)
参数：peers:单个peerId 或数组。
### unwatch(peers)
参数：peers:单个peerId 或数组。
### getStatus(peers)
查询 peer 在线或离线状态。适应于非 watch 情况下。
参数：peers:单个peerId 或数组。
### on(name, func)
监听时间
参数：name:事件名称,func:事件处理函数
##  事件
### close
 链接关闭
### online
上线
当关注的人上线时触发
### offline
下线
当关注的人下线时触发
### message
收到消息时触发

## 群组方法
### joinGroup(groupId)
创建或加入群组
groupId: 群组Id,创建时无需传递。
### sendToGroup(msg, groupId, transient)
发送消息到指定群组
msg:消息内容,grouipId:群组ID, transient（非必须):为true时代表无需离线，默认为支持离线发送。
### inviteToGroup(groupId, groupPeerIds)
邀请加入群组
groupId:群组ID,groupPeerIds:单个或数组群组ID
### kickFromGroup(groupId, groupPeerIds)
踢出群组
groupId:群组ID,groupPeerIds:单个或数组群组ID
### leaveGroup(groupId)
离开群组
groupId:群组ID

## 群组事件
### membersJoined
有成员加入群
### membersLeft
有成员离开群
### joined
自己加入了群
### left
自己离开了群

## 运行DEMO
直接启动一个 web 服务器 即可运行 demo。
对于不支持 websocket的浏览器 参考demo做法。
依赖   <a href="https://github.com/gimite/web-socket-js">web-socket-js</a> 可以用flash做 gateway


## 浏览器端环境依赖：
1. jQuery (非必须)  用于 jsonp 方式请求 (请求 socket 服务器信息)，主要是针对 ie9 以下浏览器的跨域支持。如果没有 jQuey 会根据 XMLHttpRequest 创建ajax跨域请求。
2. es6-promise (非必须) 当需要签名认证的时候需要，是一个 promise 接口。
3.  /lib/flash/swfobject.js web_socket.js (非必须) 用于跨浏览器支持 websocket.针对 不支持 websocket 的浏览器。 参照 <a href="https://github.com/gimite/web-socket-js">web-socket-js</a>

## 浏览器端 lib 生成

browserify chat.js -o  lib/chat.js --exclude xmlhttprequest --exclude ws -s AVChatClient

## node 环境
npm install lean-cloud-chat
