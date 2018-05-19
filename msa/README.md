choose principle

* 1.生产级 选择成熟稳定的技术
* 2.有大公司落地参考
* 3.社区活跃度


|服务框架|服务容错|运行支撑服务|服务监控|后台服务|服务安全|服务部署|
|-------|-------|-------|-------|-------|-------|-------|
|RPCvsREST|超时|服务网管|日志监控|消息系统|OAuth认证|发布机制|
|二进制vs文本序列化|熔断|服务注册发现|调用链监控|分布式数据访问|jwt授权|容器调度|
|TCPvsHTTP|隔离|负载均衡|Metrics监控|任务调度|IAM|发布系统
|契约vs优先代码编程|限流|配置中心|告警通知|缓存管理||镜像治理|
|客户端自动生成|降级||健康检查|||发布流水线|
|跨语言互操作|||||||

其中发布机制还包括 ：蓝绿,金丝雀,灰度 





# 服务框架
----

* dubbo 较弱的跨语言特性

* gRPC google 最新推出的基于protobuf的强契约模型,能自动生成各种语言客户端且保证互操作,支撑HTTP2, 适合内部服务调用

* RESTful 适合对外暴露端口

* springcloud  接口使用RESTful 通过swagger 生成统一api

# 服务支撑服务
-----
#### 注册中心服务发现

* 当选 EUREKA springcloud中已经集成 eureka 结合ribbon 实现软负载

* consul 天然支撑跨数据中心 KV模型存储

#### 网关

* 网关可以使用springcloud的zuul，支持动态过滤器脚本(估计没人会用把),现有开源版本异步性较差

* 基于nginx/OpenResty的Kong, nginx 内核,异步性较强 兼顾lua插件 安全，限流，熔断，管理UI 

#### 参数中心

* 首选携程apollo

* 其次是springcloud 自带的 config


# 服务监控
----

#### 日志监控

* ELK 标配 (Elastalert 是Yelp开源的告警模块)

#### 调用链路监控

* cat 点评开源

* Twitter开源的zipkin,

* Naver开源的pinpoint

||CAT|Zipkin|Pinpoint|
|----|----|----|----|
|调用链路可视化|有|有|有|
|报表|非常丰富|少|中|
|ServerMap|简单依赖|简单|好|
|埋点|侵入|侵入|不侵入字节码增强|
|Heartbeat|有|无|有|
|Metric|支持|无|无|
|java/.net客户端|有|有|只有java|
|Dashboard中文|好|无|无|
|社区|好,文档丰富,点评出品|好,文档一般,无中文|好,文档一般,无中文|
|国内案例|携程,点评,陆金所|京东.阿里不开源|无|
|开源|eBay-CAL|Google Dapper|Google Dapper|


#### metric监控

* stumbleUpon开源的OpenTSDB ，具有分布式能力，较重,适合中大企业
  
  * 基于Cassandra的KariosDB(OpenTSDB的cassandra版本)
  
  * Argus是Salesforce开源的OpenTSDB的告警平台
  
  * InfluxDB是轻量级的版本(分布式不足)

* Grafana是Metrics报表展示标配

#### 健康检查 & 告警

* Sensu能对springboot的端点，时间序列库中的metrics,ELK错误日志检查

* Esty开源的411

* Zalando的ZMon,采用KairosDB时间序列数据库

# 服务容错
----

* Hystrix在框架内埋点，门槛高

    * zuul网管集成了Hystrix
 
* 集中式反向代理的使用Nginx或者Kong




# 后台服务选型
----

* 消息系统

    * Kafka
      
      * 日志 可靠性不高
      
      * Allegro开源的hermes,封装了企业治理能力
    
    * RabbitMQ
        
        * 性能，分布式较弱
         
    * RocketMQ 阿里开源
    
* 分布式缓存
    
    * SohuTv开源的cachecloud ，Redis治理平台文档丰富
    
    * Twitter开源的twemproxy 
    
    * CodisLab开源的codis
    

* 分布式数据访问
    
    * java技术栈：shardingjdbc
        
        * 将分库分表坐在客户端jdbcdriver 中 适用小场景
        
        * 数据库中间层proxy模式,有Cobar演化的MyCAT 这种成本比较大

* 任务调度
    
    * 徐雪开源的xxl-job,功能更复杂
    
    * 当当开源的elastic-job

# 服务安全

现有情况：
    
* OAuth和OpenID connect标准协议

* AperepCAS

* jboss开源的keycloak

* springcloud security

建议：

* 1.使用OAuth和OpenID connect标准协议的服务(定制)

* 2.API网管作为治理的入口

* 3.OAuth用作对外暴露的token不包含用户信息

* 4.内部使用 JWTtoken可以携带用户的信息


![](https://github.com/cloudgc/note/blob/master/msa/safe.png)

#服务部署
---

#### 容器调度

   *K8S(kubernetes)
   
   *Swarm,使用portainer管理界面
   
   *Mesos需要较高门槛
    

#### 发布系统

   * jenkins 

#### 镜像治理
    
   * DockerReistry
   
   * VMharbor
   

#### 资源治理

#### IAM



    