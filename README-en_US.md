<p align="center">
  <a href="https://zero-proxy.com">
    <img width="200" src="https://zero-proxy.com/static/images/logo.svg">
  </a>
</p>

<h1 align="center">Zero Proxy</h1>

<div align="center">

To build the most lightweight, effecient, transparent and stable mining proxy.

</div>

[简体中文](./README.md) | English

## ✨ Features

- 🎨 One proxy can handle ETH and ETC proxy in the same time.
- 🚀 A aws-ts.medium server can accept 3000+ workers and run stably.
- 🌈 One proxy can listen on multiple ports and connect to multiple pools.
- 📦 The highly efficient agent algothrim does it best to reduce the wast of shares and keep the hashrate of client worker normal.
- 💰 You can add multiple agent acount and set the profit sharing rate independently.
- 🪟 A fixed 0.5% developer fee is set and will never get changed whenever what agents you set.
- 🔒 You can replace the built-in certification with your own one.
- ⛏️ Many well-known pools are built-in on the web dashboard and make it easy for you to set up your proxy.
- 🛡 Written with go language and javascript, completely secure and stable.

## 🖥 Supported OS

- Linux (Ubuntu / CentOS / Debian / AlmaLinux / Rocky Linux / Fedora)
- Windows 7 +
- OSX

## 📦 One click Install (For Linux)

One click installer contains multiple functionality including install, uninstall, start, stop, restart update, etc.

```bash
curl -o install.sh https://raw.githubusercontent.com/zero-proxy/zero-proxy/master/install.sh && chmod u+x install.sh && bash install.sh
```

The daemon is setup automatically via one click installer, and you are free to go. You can run it again to start/stop/restart/update the proxy or even completely uninstall it.

Once the proxy is installed, you can visit the dashboard using following url:

```
http://IP:3001

user: zero-proxy
pwd: zeroproxypwd
```

You can set the credential on [config.json](./config.json), please update it as soon as possible to avoid unattempted login or MITM attack.

## Change log

### 2022-05-28

zero-proxy V1.1.0 is released now, the following changes are made in this version:

1. Multiple coins support, now you can proxy ETH and ETC pools.
2. Blacklist functionality is added to the system, you can specify the IPs and block them.
3. Optimizing the profit sharing algorithm and improve the efficiency.

It is highly recommended to update to this version.

## 💻 Web Dashboard

<div>
  <img src="https://zero-proxy.com/static/images/dashboard.png">
  <img src="https://zero-proxy.com/static/images/workers.png">
  <img src="https://zero-proxy.com/static/images/agents.png">
  <img src="https://zero-proxy.com/static/images/proxy-config.png">
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

Just download the latest version of zero-proxy and unzip it, click "zero-proxy_win64.exe" to run.

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

[config.js](./config.json) is the config file for zero-proxy, you can config it via dashboard or edit the file directly.

| config item  |                                                                                     explain                                                                                     |
| :----------: | :-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
|  maxWorkers  |                      Max connections count, usually set it to "unlimited", but you can also set the number accordingly for some poor performance servers.                       |
| workerPrefix | This prefix will be added to all joined workers and shown in the agent mining pool with the format [prefix]-[worker name], the prefix will not be added if you set it to empty. |
|     user     |                                                                  the username and password to login dashboard                                                                   |
|    agents    |                                         agent is for user to earn shares when worker connect to the proxy, you can add multiple agents                                          |
|   servers    |                                                the ports that the proxy listenning on, and the pools that the proxy connects to                                                 |
|     cert     |                                                                               certificate config                                                                                |

### agents config (config via dashboard is recommended)

|   config item   |                            explain                            |
| :------: | :--------------------------------------------------------: |
|   user   |                     the wallet of agent                     |
| password |      the password for agent pool, you can enter "x" or empty if there is no password     |
|   name   |   name of the agent   |
|   fee    | share fee, from 0 to 1 |
|  enable  |   whether to enable the agent     |
|   pool   |  the pool that this agent connects to |

### servers config (onfig via dashboard is recommended)

| config item  |                                        explain                                         |
| :--: | :---------------------------------------------------------------------------------: |
| port |       The port is used when workers connect to your proxy, please make sure that this port is not occupied by other process.  |
| tls  | TLS (A.K.A latest version of SSL) can protect the connections between wokers and your sever from attacking, It is highly recommended to enable this.  |
| pool |       All workers that join this port will connect to this pool.    |

We can configure various connection methods through the combination of listening ports and corresponding mining pools,, as shown below:

```json
"servers": [
    {
      "port": 10200,
      "tls": false,
      "pool": {
        "host": "asia1.ethermine.org",
        "port": 4444,
        "tls": false,
        "coin": "ETH"
      },
      "id": "dcd74305"
    },
    {
      "port": 10201,
      "tls": true,
      "pool": {
        "host": "asia1.ethermine.org",
        "port": 5555,
        "tls": true,
        "coin": "ETH"
      },
      "id": "a614a3a0"
    },
    {
      "port": 10300,
      "tls": false,
      "pool": {
        "host": "eth-hk.flexpool.io",
        "port": 5555,
        "tls": true,
        "coin": "ETH"
      },
      "id": "b75ac91d"
    },
  ],

```

The config indicates that the proxy are listenning on 3 ports, they are:

1. listenning on port 10200, TLS is not enable for the connection between worker and proxy, the mining pool is ethermine, and TLS is also not enable for the connection between the proxy and the pool.
2. listenning on port 10201, TLS is enable for the connection between worker and proxy, the mining pool is ethermine, and TLS is also enable for the connection between the proxy and the pool.
3. listenning on port 10300, TLS is not enable for the connection between worker and proxy, the mining pool is flexpool, but TLS is enable for the connection between the proxy and the pool.

## 💡 FAQ

1. Is it normal that the chart of the agent account in the mining pool is like a ECG?

Yes, our algothrim is aim to maximize the sharing efficiency and reduce the effect to the client as far as possible. This would lead to the chart of agent account like a ECG, but it is completly normal and will not effect your profit.

2. Can the proxy support large-scale mining workers' connection?

Of course, during our internal usage, a single aws-t3.medium server can accept 3200+ mining workers and run stably for a long time, also the CPU usage stays within 50%.

3. What's the different between TLS and SSL, do I still need to enable SSL if I already enable TLS througn the proxy?

No, you don't. The TLS is the latest version of SSL and contains all functions of SSL, and is more secure and reliable than the old version of SSL. Usually, we consider that TLS and SSL are the same by default, they both represent the reliable and secure connection for the transport layer.

4. Can I use one proxy to connect to multiple mining pools?

Yes, you can. You can refer to the example above.

5. I have already set the server port but the workers still can't connect to it.

Usually, cloud service providers (such as Amazon Cloud) will restrict the access ports in the security group. When you create a listening port, please make sure that the port is also released in the security group of the cloud service provider console .

6. What is pm2? Can I run the proxy without it?

Pm2 is a production process manager similar to supervisor, and it can guaratee that the zero-proxy can keep running at any time. It is highly recommended to enable it.

7. Is the development fee fixed? How can I check that?

Yes, zero-proxy charges a fixed 0.5% fee as development fee, this fee keeps constant no matter how many agents are added and how much rate is set. You can check the fee via web dashboard, server logs or via intercepting the traffic packets.

## 🔗 Links

- [Zero Proxy Official Website](https://zero-proxy.com/)

## ❤️ Donation

ETH: 0xa99428129b7278f20470d72d287B8FEb4276A046

USDT: 0xa99428129b7278f20470d72d287B8FEb4276A046
