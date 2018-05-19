choose principle

* 1.生产级 选择成熟稳定的技术
* 2.有大公司落地参考
* 3.社区活跃度



# 服务框架
----

* dubbo 较弱的跨语言特性
* gRPC google 最新推出的基于protobuf  的RPC 协议 适合内部调用
* RESTful 适合对外暴露端口
* springcloud  接口使用RESTful 通过swagger 生成统一api

# 服务支撑服务
-----
注册中心服务发现

* 当选 EUREKA springcloud中已经集成 eureka 结合ribbon 实现软负载

* consul 天然支撑跨数据中心 KV模型存储

网关使用springcloud 的 zuul 现有开源版本异步性较差

