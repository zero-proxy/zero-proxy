<p align="center">
  <a href="https://zeroproxy.app">
    <img width="200" src="https://zeroproxy.app/static/images/logo.svg">
  </a>
</p>

<h1 align="center">Zero Proxy</h1>

<div align="center">

最轻量、高效、透明、稳定的多币种矿池代理。

</div>

简体中文 | [English](./README-en_US.md)

## ✨ 特性

- 🎨 多币种支持，zero proxy 可同时多端口代理 BTC, ETC, RVN, NICEHASH, XNA, ETHW, ERGO 等多币种。
- 🔥 支持 2miners/hiveon/poolin/f2pool/ezil 等多种知名矿池。
- 🚀 以 aws-t3.micro 为例，单台服务器可稳定接入 3000+ 台矿机并稳定运行。
- 🌈 支持定义多个监听端口，即启动一个代理，就能提供多个端口，分别连入不同的矿池。
- 📦 高效抽水算法，极大减少矿机额外份额损失，客户端算力显示正常。
- 💰 支持添加多个抽水账号，且每个账号可设置不同钱包地址及抽水比例，让您灵活定制抽水。
- 🪟 固定 0.5% 开发费用，所有数据均可在控制台查看，无额外抽水。
- 🔒 支持用户采用自定义证书来替换内置证书。
- ⛏️ 控制台内置了多个常用矿池，方便您进行配置。
- 🛡 采用 Go 及 Node.js 等前沿技术开发，安全可靠。

## 🖥 支持的操作系统

- Linux (Ubuntu / CentOS / Debian / AlmaLinux / Rocky Linux / Fedora)
- Windows 7 +
- OSX

## 📦 一键安装(Linux)

一键安装脚本包括了安装/卸载/启动/关闭/重启/更新等功能。

```bash
curl -o install.sh https://raw.githubusercontent.com/zero-proxy/zero-proxy/master/install.sh && chmod u+x install.sh && bash install.sh
```

通过一键安装，Zero Proxy 自带了守护进程，无需额外进行设置。当安装完成本代理后，您依然可以通过 install.sh 脚本进行代理管理，其功能包括：安装、卸载、启动、关闭、重启、更新代理等。通过执行 install.sh 脚本并选取相应数字即可。

安装完成后即可通过浏览器登陆web控制台（请确保3001端口在云服务商的安全组中已经开启）：

```
http://ip:3001

账号：zero-proxy
密码: zeroproxypwd
```

账号密码可在[config.json](./config.json)文件中配置。<b>请及时更改密码</b>，以防止被恶意第三方扫描登陆。

## 更新日志

### 2024-04-02

zero-proxy V1.3.4发布，修复部分bug。

### 2024-03-10

zero-proxy V1.3.3正式发布，新增BTG和ZEPH币种。

### 2024-02-27

zero-proxy V1.3.2正式发布，提高BTC代理性能。

### 2024-02-09

zero-proxy V1.3.1正式发布，更好地支持BTC，并将开发者费用设置为0.5%。

### 2024-01-13

zero-proxy V1.3.0正式发布，支持多矿池协议及多币种代理。

## 💻 Web 控制台截图

<div>
  <img src="https://zeroproxy.app/static/images/dashboard.png">
  <img src="https://zeroproxy.app/static/images/workers.png">
  <img src="https://zeroproxy.app/static/images/agents.png">
  <img src="https://zeroproxy.app/static/images/proxy-config.png">
</div>

## ⚒️ 手动安装(Linux)

```bash
git clone https://github.com/zero-proxy/zero-proxy.git
cd zero-proxy
chmod u+x zero-proxy_linux

# 若未安装node.js，则先通过nvm安装，若已安装node.js可跳过
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
source ~/.nvm/nvm.sh
nvm install 16

# 安装pm2，作为守护进程
npm install -g pm2

# 初始化日志系统
pm2 install pm2-logrotate
pm2 set pm2-logrotate:max_size 20M
pm2 set pm2-logrotate:compress true
pm2 set pm2-logrotate:retain 10

# 启动
pm2 start zero-proxy_linux --name zero-proxy -e logs/zero-proxy-error.log -o logs/zero-proxy-out.log

# 停止
pm2 stop zero-proxy

# 重启
pm2 restart zero-proxy

# 查看日志
pm2 logs
```

## ⚒️ 手动安装(Windows)

进入下载页面下载最新版本，解压后运行 zero-proxy_win64.exe 即可，请注意，若直接运行则无守护进行，可参照上述命令安装 pm2 后运行。

## ✈️ 更新代理

可以通过 install.sh 脚本一键更新代理

```bash
./install.sh

# 输入: 6
```

## ⚙️ 手动更新（推荐使用 install.sh 脚本进行更新）

```bash
cd zero-proxy
git pull origin master

# 删除之前的版本
pm2 delete zero-proxy

# 启动最新版本
pm2 start zero-proxy_linux --name zero-proxy
```

## 🗂️ 配置文件

[config.js](./config.json)为矿池代理的配置文件，可以通过在控制台中设置，亦可直接在文件中配置。

|     配置     |                                          解释                                          |
| :----------: | :------------------------------------------------------------------------------------: |
|  maxWorkers  |        矿池最大连接数，设置为 0 则表示无上限（Linux 系统需要打开文件连接上限）         |
| workerPrefix |              全局矿机前缀，会加在矿机名的前面，在抽水账户的矿池界面中显示，设置为空则不添加前缀              |
|     user     |                                  控制台登录的用户密码                                  |
|    agents    |           抽水账户列表，可设置多个抽水账户，详细解释见下方，可在控制台中设置           |
|   servers    | 监听端口列表，可设置多个监听端口，分别连接不同的矿池，详细解释见下方，可在控制台中设置 |
|     cert     |               证书配置，可设置为内置证书或自定义证书，推荐通过控制台设置               |

### agents 抽水账户配置 (建议通过 Web 控制台配置)

|   配置   |                            解释                            |
| :------: | :--------------------------------------------------------: |
|   user   |                     抽水账户的钱包地址                     |
| password |      抽水账户接入矿池的密码，若无密码可不填，或填“x”       |
|   name   |            抽水账户名称，仅做备注用，可随意命名            |
|   fee    | 抽水比例，为 0 到 1 之间的数，若要设置为 1%抽水，则填 0.01 |
|  enable  |                     是否开启该抽水账户                     |
|   pool   |    抽水账户对应的矿池，包含币种，host, port 以及是否开启 TLS    |

### servers 监听端口配置 (建议通过 Web 控制台配置)

| 配置 |                                        解释                                         |
| :--: | :---------------------------------------------------------------------------------: |
| port |       表示矿池代理对接入连接的监听端口，一个监听端口可以对应连接一个矿池，请确保端口不被其它程序占用        |
| tls  |      该监听端口是否要开启 TLS/SSL，若开启，则矿机需要相应开启 TLS/SSL 才可接入      |
| pool |                    所有接入该监听端口的矿机，都将连接到本矿池中                     |
|  id  | ID可不配置，系统会在后续启动中自动生成 ID，若手动配置，请确保 ID 不与现有 ID 重复 |

通过对监听端口、对应矿池的自由组合，我们可以配置成各种连接方式，如下所示：

```json
"servers": [
    {
      "port": 10200,
      "tls": false,
      "pool": {
        "host": "etc.hiveon.com",
        "port": 20443,
        "tls": true,
        "coin": "ETC"
      },
      "id": "etc"
    },
    {
      "port": 10201,
      "tls": true,
      "pool": {
        "host": "asia-rvn.2miners.com",
        "port": 16060,
        "tls": true,
        "coin": "RVN"
      },
      "id": "rvn-tls"
    },
    {
      "port": 10300,
      "tls": false,
      "pool": {
        "host": "kawpow.auto.nicehash.com",
        "port": 9200,
        "tls": false,
        "coin": "NICEHASH-KAWPOW"
      },
      "id": "nicehash"
    },
  ],

```

该示例表示 Zero Proxy 开启了 3 个监听端口，分别为：

1. 监听 10200 口，矿机到本代理的连接不开启 TLS，对应矿池为 hiveon，且从代理到矿池的连接开启 TLS。
2. 监听 10201 口，矿机到本代理的连接开启 TLS，对应矿池为 2miners，且从代理到矿池的连接也开启 TLS。
3. 监听 10300 口，矿机到本代理的连接不开启 TLS，对应矿池为 nicehash-kawpow，且从代理到矿池的连接也不开启 TLS。

## 💡 FAQ

1. 抽水账号在矿池中显示的曲线为心电图，正常吗？

抽水算法的目标是为了尽量提高抽水效率，尽最大可能降低对客户矿机的影响，这会导致抽水账户显示的算力曲线为心电图曲线，但是不影响收益，同时，客户矿机的算力曲线完全正常。

2. 可以支持大规模的矿机接入吗？

可以，在内部使用的过程中，我们仅使用单台aws-t3.micro服务器即可接入 3200+ 台矿机，并且能够长时间稳定运行，CPU保持在50%使用率内。

3. 我自己部署 Zero Proxy 后，用户矿机接入多久后，我才能在控制台中看到抽水？

为了保证用户体验，在矿机第一次接入时，会优先为矿机客户工作，约2-4小时候后会进入第一次抽水时间，届时可进入控制台中查看，请耐心等待。而后每隔一定时间开启新一轮抽水。若矿机中途掉线，重新连接后会自动恢复掉线前的状态，以保证整体抽水比例与设定值一致。

4. TLS和SSL的区别是什么，我通过代理开启了TLS，还需要开启SSL吗？

不需要，TLS即是最新版本的SSL，具有全部的SSL功能，同时比旧的SSL更加安全可靠。通常情况下我们认为TLS和SSL是一样的，都代表对传输层进行可靠的安全加密，可以进行混用，不需要做额外区分。

5. 可以用一个代理同时接入多个矿池吗？

可以，通过上述示例配置，我们就让本代理同时接入了hiveon和2miners和nicehash中，客户端只要连接不同的端口（分别为10200，10201，10300）即可接入不同的矿池。

6. 为什么我设置了监听端口，但是客户端机器还是连接不进来

通常情况下，云服务商（如亚马逊云）会在安全组中限制接入的端口，当你创建了一个监听端口时，请务必确保该端口在云服务商控制台的安全组中也被放行。

7. pm2 是什么，可以不使用吗？

pm2 是一个类似于 supervisor 的守护进程，能够保证 Zero Proxy 在任何时候都能够稳定运行，非常建议配合使用。

8. 开发费用是固定的吗？如何查看？

Zero Proxy 固定抽取0.5%作为开发费用，无论用户添加几个抽水账号，设置多少抽水比例，该费用均不变。用户可通过控制台、后端日志或者抓取流量包的形式进行判断。

## 🔗 链接

- [Zero Proxy 官网](https://zeroproxy.app/)

## ❤️ 捐赠

BTC: bc1qu0atqnnp3ms7dcc42y76aa7a9fwtyzrdzgm8cy

ETH: 0xa99428129b7278f20470d72d287B8FEb4276A046

USDT: 0xa99428129b7278f20470d72d287B8FEb4276A046
