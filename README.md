# RoderCoreData
<h2>iOS封装CoreData+HandyJson实现本地缓存</h2>

> 准备工作

* <h5>选中Tagets->BuildPhases->LinkBinaryWithLibraries 添加CoreData.framework</h5>

* <h5>使用CocoaPods工具Pod需要使用的相关框架</h5>

		pod 'AlecrimCoreData'
		pod 'HandyJSON', '~> 5.0.1'
		
> CoreData基本使用查看上篇博客《CoreData数据持久化》

 链接如下：
[CoreData数据持久化](https://luodecoding.github.io/2020/06/03/%E4%BD%BF%E7%94%A8CoreData%E5%81%9A%E9%A1%B9%E7%9B%AE%E6%95%B0%E6%8D%AE%E6%8C%81%E4%B9%85%E5%8C%96/)

> 总结

* <h5>利用AlecrimCoreData实现CoreData配置简易化</h5>
* <h5>HandyJson作为中介者，存储到本地的为JsonString字符串，Json字符串与Model或者Models的转换</h5>

[Demo链接](https://github.com/luodeCoding/RoderCoreData)

Roder, [我的博客](https://luodecoding.github.io/) 
