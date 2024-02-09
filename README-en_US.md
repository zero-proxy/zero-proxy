<p align="center">
  <a href="https://zeroproxy.app">
    <img width="200" src="https://zeroproxy.app/static/images/logo.svg">
  </a>
</p>

<h1 align="center">Zero Proxy</h1>

<div align="center">

The lightest, most efficient, transparent, and stable multi-cryptocurrency mining pool proxy.

</div>

[简体中文](./README.md) | English

## ✨ Features

- 🎨 Multi-cryptocurrency support: Zero Proxy can simultaneously multi-port proxy various coins like BTC, ETC, RVN, NICEHASH, XNA, ETHW, ERGO, and more.
- 🔥 Supports various well-known mining pools such as 2miners, hiveon, poolin, f2pool, ezil, etc.
- 🚀 A aws-ts.medium server can stably connect to over 3000 mining machines and operate smoothly.
- 🌈 Supports defining multiple listening ports, meaning launching one proxy can provide multiple ports, each connecting to a different mining pool.
- 📦 Efficient fee extraction algorithm, greatly reducing extra share losses for mining machines, with normal client-side computing power display.
- 💰 Supports adding multiple fee extraction accounts (we call them agents), and each agent can have different wallet addresses and fee extraction ratios for flexible customization.
- 🪟 A fixed 0.5% development fee, with all data visible in the web dashboard, no additional fee extraction.
- 🔒 Supports users adopting custom certificates to replace built-in certificates.
- ⛏️ The web dashboard has built-in multiple common mining pools for easy configuration.
- 🛡 Developed using cutting-edge technologies like Go and Node.js, ensuring security and reliability.

## 🖥 Supported OS

- Linux (Ubuntu / CentOS / Debian / AlmaLinux / Rocky Linux / Fedora)
- Windows 7 +
- OSX

## 📦 One click Install (For Linux)

The one-click installation script includes features such as install, uninstall, start, stop, restart, and update.

```bash
curl -o install.sh https://raw.githubusercontent.com/zero-proxy/zero-proxy/master/install.sh && chmod u+x install.sh && bash install.sh
```

Zero Proxy comes with a built-in daemon, enabling one-click installation without the need for additional setup. Once the proxy is installed, you can still manage it using the install.sh script, which includes functions such as install, uninstall, start, stop, restart, and update the proxy. These functions can be accessed by executing the install.sh script and selecting the corresponding number.

After installation, you can log in to the web dashboard via following url (please ensure that port 3001 is allowed in your cloud service provider's security group):

```
http://IP:3001

user: zero-proxy
pwd: zeroproxypwd
```

You can set the credential on [config.json](./config.json), please update it as soon as possible to avoid unattempted login or MITM attack.

## Change Log

### 2024-02-09

zero-proxy V1.3.1 is officially released, a better support for BTC proxy, and setting the developer fee as 0.5%。

### 2023-01-13

Zero-Proxy V1.3.0 is officially released, supporting multiple mining pool protocols and multi-cryptocurrency proxy.

## 💻 Web Dashboard

<div>
  <img src="https://zeroproxy.app/static/images/dashboard.png">
  <img src="https://zeroproxy.app/static/images/workers.png">
  <img src="https://zeroproxy.app/static/images/agents.png">
  <img src="https://zeroproxy.app/static/images/proxy-config.png">
</div>

## ⚒️ Instal Manually (For Linux)

```bash
git clone https://github.com/zero-proxy/zero-proxy.git
cd zero-proxy
chmod u+x zero-proxy_linux

# install node.js if needed, you can skip this step if the node.js is already installed
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
source ~/.nvm/nvm.sh
nvm install 16

# install pm2 as daemon
npm install -g pm2

# initialize logging system
pm2 install pm2-logrotate
pm2 set pm2-logrotate:max_size 20M
pm2 set pm2-logrotate:compress true
pm2 set pm2-logrotate:retain 10

# start
pm2 start zero-proxy_linux --name zero-proxy -e logs/zero-proxy-error.log -o logs/zero-proxy-out.log

# stop
pm2 stop zero-proxy

# restart
pm2 restart zero-proxy

# check logs
pm2 logs
```

## ⚒️ Instal Manually (For Windows)

Go to the download page to download the latest version. After unzipping, run zero-proxy_win64.exe to start. Please note, if you run it directly, there will be no daemon process. You can refer to the above commands to install pm2 and then run it.

## ✈️ Update Proxy

It is highly recommended to update the zero-proxy via install.sh script.

```bash
./install.sh

# and then enter "6"
```

## ⚙️ Update Proxy Manually

```bash
cd zero-proxy
git pull origin master

# delete previous version
pm2 delete zero-proxy

# start the new version
pm2 start zero-proxy_linux --name zero-proxy
```

## 🗂️ Config

[config.js](./config.json) is the config file for Zero Proxy, you can config it via dashboard or edit the file directly.

| config item  |                                                                                     explain                                                                                     |
| :----------: | :-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
|  maxWorkers  |   Max connections count, usually set it to 0 for "unlimited", but you can also set the number accordingly for some poor performance servers.   |
| workerPrefix | This prefix will be added to all joined workers and shown in the agent mining pool with the format [prefix]-[worker name], the prefix will not be added if you manually set it as empty. |
|     user     |    The username and password to login the web dashboard                                                                   |
|    agents    |    Fee extraction account(agent) list, where you can set up multiple fee extraction accounts. For a detailed explanation, see below. This can be configured in the web dashboard.                                         |
|   servers    |    Listening port list, where you can set up multiple listening ports, each connecting to a different mining pool. For a detailed explanation, see below. This can be configured in the web dashboard       |
|     cert     |    Certificate config                                                                                |

### agents config (config via dashboard is recommended)

|   config item   |                            explain                            |
| :------: | :--------------------------------------------------------: |
|   user   |     The wallet of agent                     |
| password |     The password for agent pool, you can enter "x" or empty if there is no password     |
|   name   |   Name of the agent   |
|   fee    | Fee extraction ratio, a number between 0 and 1. If you want to set it to 1% fee extraction, enter 0.01 |
|  enable  |   Whether to enable the agent or not     |
|   pool   |  Fee extraction account's corresponding mining pool, including the coin, host, port, and whether TLS is enabled |

### servers config (config via web dashboard is highly recommended)

| config item  |                                        explain                                         |
| :--: | :---------------------------------------------------------------------------------: |
| port |       The port is used when workers connect to your proxy, please make sure that this port is not occupied by other process.  |
| tls  | TLS (A.K.A latest version of SSL) can protect the connections between wokers and your sever from attacking, It is highly recommended to enable this. If enabled, the mining machine also needs to enable TLS/SSL to connect. |
| pool |       All workers that join to the same port will connect to this pool.    |
| id | The ID does not need to be configured; the system will automatically generate an ID during subsequent startups. If you choose to manually configure it, please ensure that the ID does not duplicate an existing one. |

We can configure various connection methods through the combination of listening ports and corresponding mining pools, as shown below:

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

This example shows that Zero Proxy has opened 3 listening ports, which are:

1. Listening on port 10200, the connection from the mining machine to this proxy does not enable TLS, and the corresponding mining pool is hiveon, with TLS enabled for the connection from the proxy to the mining pool.
2. Listening on port 10201, the connection from the mining machine to this proxy enables TLS, and the corresponding mining pool is 2miners, with TLS also enabled for the connection from the proxy to the mining pool.
3. Listening on port 10300, the connection from the mining machine to this proxy does not enable TLS, and the corresponding mining pool is nicehash-kawpow, with TLS not enabled for the connection from the proxy to the mining pool.

## 💡 FAQ

1. Is it normal for the fee extraction account to show an ECG-like curve in the mining pool?

The goal of the fee extraction algorithm is to maximize efficiency and minimize impact on client mining machines, which results in the fee extraction account showing an ECG-like power curve. However, this does not affect earnings, and the power curve for client mining machines remains completely normal.

2. Can Zero Proxy support large-scale mining machine access?

Yes, during internal use, we connected more than 3200 mining machines using just a single aws-t3.micro server, and it operated stably for a long time with CPU usage within 50%.

3. After deploying Zero Proxy myself, how long before I can see fee extraction in the web dashboard when user mining machines connect?

To ensure user experience, mining machines are prioritized for client work upon first connection. The first fee extraction period begins after approximately 2-4 hours, at which time you can check the web dashboard. Please be patient. Subsequently, a new round of fee extraction starts at regular intervals. If a mining machine disconnects and reconnects, it will automatically resume the state before disconnection to ensure the overall fee extraction ratio remains consistent with the set value.

4. What's the difference between TLS and SSL, and do I need to enable SSL if the TLS is already enabled?

No need. TLS is the latest version of SSL and includes all the features of SSL, but is more secure and reliable. Typically, TLS and SSL are considered equivalent, representing reliable security encryption for the transport layer, and can be used interchangeably without needing further distinction.

5. Can one proxy connect to multiple mining pools at the same time?

Yes, as shown in the aforementioned example configuration, we have connected the proxy simultaneously to hiveon, 2miners, and nicehash. Clients can connect to different mining pools by connecting to different ports (10200, 10201, 10300 respectively).

6. Why can't client machines connect even though I set up a listening port?

Usually, cloud service providers (like Amazon Cloud) restrict access to ports in their security groups. When you create a listening port, make sure that this port is also allowed in the security group of the cloud service provider's console

7. What is pm2, and is it optional?

pm2 is a daemon process similar to supervisor, ensuring that Zero Proxy runs stably at all times. It is highly recommended to use it in conjunction.

8. Is the development fee fixed? How can I check it?

Zero Proxy consistently extracts 0.5% as a development fee, regardless of how many fee extraction accounts are added or what the fee extraction ratio is. Users can verify this through the web dashboard, backend logs, or by capturing traffic packets.

## 🔗 Links

- [Zero Proxy Official Website](https://zeroproxy.app/)

## ❤️ Donation

BTC: bc1qu0atqnnp3ms7dcc42y76aa7a9fwtyzrdzgm8cy

ETH: 0xa99428129b7278f20470d72d287B8FEb4276A046

USDT: 0xa99428129b7278f20470d72d287B8FEb4276A046
