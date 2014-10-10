# Setup the Server
The first thing after installing is editing the [configuration.json](configuration.json)



## Start the App as Daemon
For more information look at (PM)[https://github.com/Unitech/pm2].
```sh
pm2 add server.coffee
```


## Apache Vhosts
```
<VirtualHost *:80>
  ServerName pad.trashserver.net
  ProxyPreserveHost On
  ProxyRequests Off
  ProxyVia Off
  ProxyPass / http://127.0.0.1:2000/
  ProxyPassReverse / http://127.0.0.1:2000/
</VirtualHost>
```

