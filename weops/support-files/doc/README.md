## 嘉为蓝鲸Apache插件使用说明

## 使用说明

### 插件功能

向Apache服务器的server-status模块页面发送请求，获取服务器的运行状态信息。

### 版本支持

操作系统支持: linux, windows

是否支持arm: 支持

**组件支持版本：**

Apache版本: 2.2, 2.4

**是否支持远程采集:**

是

### 参数说明


| **参数名**              | **含义**                                                                                            | **是否必填** | **使用举例**                             |
|----------------------|---------------------------------------------------------------------------------------------------|----------|--------------------------------------|
| SCRAPE_URI           | apache server-status模块访问地址(环境变量)，如果有http auth则使用http://user:password@localhost/server-status?auto | 是        | http://localhost/server-status/?auto |
| --web.listen-address | exporter监听id及端口地址                                                                                 | 否        | 127.0.0.1:9601                       |
| --log.level          | 日志级别                                                                                              | 否        | info                                 |

### 使用指引

1. 配置server-status
   默认配置文件存放于 `/etc/httpd/conf/httpd.conf`
   需要先检查是否开启mod_status模块，检查文件内容是否含有 `LoadModule status_module modules/mod_status.so`，若没有则需要手动添加
   开启模块后，在文件末尾添加以下内容，若已存在则修改对应配置

   ```
   ExtendedStatus On				# 开启ExtendedStatus
   <Location /server-status> 		# server-status服务地址，按需配置
      SetHandler server-status      # 开启server-status服务
      Deny from all                # 禁止任何来源访问，按需配置
      Allow from 127.0.0.1         # 允许指定IP访问
   </Location>
   ```

   修改后使用 `apachectl -t` 检查配置文件内容是否正确，如果正确会返回 `Syntax OK`，否则会返回错误信息

   注意: 配置更改后需要重启服务，使用 `apachectl graceful` 重启apache服务不会中断原有连接
2. 验证server-status
   配置完成后，使用 `curl http://localhost/server-status?auto` 验证server-status是否正常工作，如果正常会返回以下内容

   ```
   Total Accesses: 1
   Total kBytes: 0
   CPULoad: .000797
   Uptime: 884
   ReqPerSec: .00113208
   BytesPerSec: .000797
   BytesPerReq: 702.5
   BusyWorkers: 1
   IdleWorkers: 7
   Scoreboard: _W_______
   ```

   如果返回 `Forbidden`，则需要检查配置文件中的 `Allow from` 是否正确配置，如果返回 `Not Found`，则需要检查配置文件中的 `Location` 是否正确配置

### 指标简介


| **指标ID**                      | **指标中文名**            | **维度ID**     | **维度含义**   | **单位**    |
|-------------------------------|----------------------|--------------|------------|-----------|
| apache_up                     | Apache监控探针运行状态       | -            | -          | -         |
| apache_uptime_seconds_total   | Apache服务已运行时长        | -            | -          | s         |
| apache_info                   | Apache服务版本信息         | mpm, version | 多进程模块, 版本号 | -         |
| apache_version                | Apache服务版本号          | -            | -          | -         |
| apache_cpuload                | Apache服务CPU使用负载      | -            | -          | -         |
| apache_accesses_total         | Apache服务总访问次数        | -            | -          | -         |
| apache_cpu_time_ms_total      | Apache服务的CPU时间总和     | type         | 类型         | ms        |
| apache_duration_ms_total      | Apache服务中所有已注册请求的总时间 | -            | -          | ms        |
| apache_generation             | Apache服务重启配置次数       | type         | 类型         | -         |
| apache_load                   | Apache服务平均负载         | interval     | 时间间隔       | -         |
| apache_sent_kilobytes_total   | Apache服务已发送千字节总量     | -            | -          | kilobytes |
| apache_scoreboard             | Apache服务工作状态记分板      | state        | 状态         | -         |
| apache_workers                | Apache服务工作进程状态       | state        | 状态         | -         |
| process_cpu_seconds_total     | Apache监控探针进程CPU秒数总计  | -            | -          | s         |
| process_max_fds               | Apache监控探针进程最大文件描述符数 | -            | -          | -         |
| process_open_fds              | Apache监控探针进程打开文件描述符数 | -            | -          | -         |
| process_resident_memory_bytes | Apache监控探针进程常驻内存大小   | -            | -          | bytes     |
| process_virtual_memory_bytes  | Apache监控探针进程虚拟内存大小   | -            | -          | bytes     |

### 版本日志

#### weops_apache_exporter 1.0.3

- weops调整

添加“小嘉”微信即可获取Apache监控指标最佳实践礼包，其他更多问题欢迎咨询

<img src="https://wedoc.canway.net/imgs/img/小嘉.jpg" width="50%" height="50%">
