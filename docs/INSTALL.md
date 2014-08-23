# Installation

## Software Requirements

```sh
apt-get install npm phantomjs git mongodb imagemagick graphicsmagick zip
```

On Mac OSX use [Homebrew](http://brew.sh/)
```sh
brew install npm phantomjs git mongodb imagemagick graphicsmagick
```

Install node.js modules
```sh
npm i -g bower grunt-cli coffee-script
```

Make sure mongod process is running, you can start it with mongod


## Dowload and Install
```sh
git clone https://github.com/dni/publish-cms && cd publish-cms && npm i
```
requirejs:buildBackend can take 4-5 minutes :(

## Configuration
You can specify your database name and production port in this [config](configuration.json)

## Enjoy the App
Before you visit the Frontend you should
* create a new admin user
* go through the settings
* customize your staticblocks
* add some articles
