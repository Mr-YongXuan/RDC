# RDC v2
内建于DCS World的一款轻量数据导出&amp;控制Web服务器，可让开发者使用任意语言调用WebAPI控制DCS World服务器。

# SHP
<strong>Simple HTTP</strong>简单超文本传输协议, 是基于<a href="https://github.com/Mr-YongXuan/Dkits">Dkits(该项目已经废弃)<a/>转型RDC后最典型的变化, 我在DCS中内建了一个简单Web服务器, 由原先的仅DCS获取开发者接口方式变更为开发者可主动获取数据。
SHP具有以下特征:<br />
  1.HTTP协议版本为HTTP/1.1, 但实际实现为HTTP/1.0, Connection常为close, 不支持保持连接。<br />
  2.一次仅支持一个连接, 无连接池, 不支持阻塞操作。<br />
  3.支持开发者增加额外的动态路由。<br />
  4.由于lua socket问题, 不支持请求头部信息。 注: RDC v2已经支持请求中携带请求头部信息<br />
  5.由于lua socket问题, 不支持请求payload, 全部基于query参数传递数据。注: RDC v2已经支持请求中携带payload。<br />
  6.完整的响应头部, 响应主体信息。<br />

# 它可以做什么?
常规情况下, RDC不会对游戏作出任何实际上的影响, 它更像是一个中转站, 需要您使用其他语言对RDC下达指令, RDC方可正常工作。<br />
如您擅长使用go语言, 邀请您试用我在之前推出的web框架<a href="https://github.com/Mr-YongXuan/chainx">Chainx</a><br />

# 如何使用?
请参考Wiki: <a href="https://github.com/Mr-YongXuan/RDC/wiki">RDC手册</a>
