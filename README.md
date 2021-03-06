puppet-example
==============

一个puppet示范项目，兼作我的运维学习笔记，在现实世界运行着，有两个成功案例，各管理100多台服务器，都是小型B2C网站，这些网站的架构大致如下图（图是网站上线前设计的，实际实施有所变化）：

![puppet-example项目成功案例服务器拓扑图](http://ww1.sinaimg.cn/large/6a174839gw1dsp0ptypt4j.jpg "小型B2C网站服务器架构")

[出处：我的微博@qinjianxiang](http://photo.weibo.com/1779910713/wbphotos/large/photo_id/3442830834329049)

我花了约100小时学习这些服务器配置，反复试错，并编写成puppet脚本和bash shell脚本，故本项目只能保证正常运行和基本的性能与安全，没有涉及这些服务器的高级技巧。

## 功能范围
### 已实现的服务器角色
- 编译工具机
- 数据库集群
- 分布式文件系统存储节点
- 分布式文件系统管理节点
- 网关
- 可访问互联网的客户端
- 负载均衡器
- lotusphp应用服务器
- NFS网络文件系统服务器
- NTP时间服务器
- PHP FastCGI服务器
- puppet服务器
- 搜索服务器
- HTTPS Web服务器
- SSH客户端
- SVN服务器
- 高可用集群成员
- VPN拨号网关
- 要使用VPN的客户端
- VPN服务器
- Web服务器
- yum本地镜像
- centos模板祼机

### 已实现的功能模块
- 编译工具
- FastDFS实现的分布式文件系统
- iptables转发实现的网关
- HAProxy实现的负载均衡
- iptables实现的防火墙规则
- Keepalived实现的高可用IP共享
- NFS
- Nginx
- NTP
- Percona over Galera实现的多主同步复制MySQL集群
- PHP
- pptp实现的VPN客户端
- pptpd实现的VPN服务端
- puppet master
- puppet agent
- sphinx实现的搜索引擎（独立于MySQL）
- ssh
- Subversion服务器
- centos、epel、remi（PHP源）、poptop的yum源


## 安装说明
参见[安装说明文档](HowTo-Install.md)

## 在puppet服务器使用本项目

### clone centos vm时应注意的网络配置问题
在XEN和KVM平台，clone一台VM时，新克隆出来的vm，eth0会变成eth1，新克隆出来的vm，eth0由于mac地址冲突已经不能用了，自动生成了个eth1，而ifcfg-eth0配置文件仍然存在，只是不起作用了，要避免这种情况，需这样克隆：

- 启动要克隆的模板vm
- 删除/etc/udev/rules.d/70-persistent-net.rules，这个文件会在每次启动的时候自动生成，最好配个crontab定时删除
- 打开网卡配置文件（如/etc/sysconfig/network-scripts/ifcfg-eth0）
- 删除网上配置文件中的HWADDR那一行，删除它也能正常工作
- 确保ONBOOT=YES，若保留默认值NO，使用service network restart时会关闭这个网上，但并不自动启动这个网卡
- 关闭模板vm
- 克隆

除CentOS外，其它的linux发行版应该也有这个问题，解决方法也是类似的。我验证过的只有Debian，但这是linux kernel的机制决定的，跟发行版关系不大，发行版不同，只是配置文件语法不同。

## 架构
开发本项目的第一版时，我初学puppet，虽然也用到了role，module，config来将我的代码分层，但分层执行不够彻底，抽象得还不够，坏处就是影响项目的通用性。

我重新梳理后的架构，分为五层：config - node - role - module type - module provider，越往右，通用性越强。使用本项目的用户，主要会去修改config和node两层，role层较少修改，module type和module provider层几乎不用修改，如果发现这两层满足不了需求，可以提需求给我，我来改。

![架构图](http://ww3.sinaimg.cn/large/6a174839gw1e3rbunqjlrj.jpg "代码架构图")
