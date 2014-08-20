# Creating a new Backend Module
In order to create a new backend module you have.... at ./components/backend/

* Folder structure and Files
* Module Configuration
* Serverside / Nodejs
* Translation
* Tests


## Folder structure and Files

mymodule/MyModule.coffee
mymodule/configuration.json
mymodule/server.coffee
mymodule/model/MyModuleSchema.coffee
mymodule/model/MyModuleModel.coffee
mymodule/model/MyModuleCollection.coffee
mymodule/controller/MyModuleController.coffee
mymodule/view/MyModuleView.coffee

## Module Configuration
In your module directory you have to put a configuration.json to hook your module into the feature of the backend

```json
{
    "config": {
        "name": "Module",
        "namespace": "module"
    },

    "navigation": {
        "button": 0,
        "route": "modules",
    },

    "settings": {
        "defaultAuthor" : {
          "value": "dnilabs e.U",
          "type": "text"
        },
        "categories" : {
          "value": "Webdevelopment, Interactive, Webdesign",
          "type": "text"
        }
    }
}
```

## Translation


```js
git clone https://github.com/dni/publish-.git
cd publish- && npm install
```


## Tests

Before you visit the Frontend you should

* create a new admin user
* go through the settings
* customize your staticblocks
* add some article



## Serverside / Nodejs

```js
apt-get install nodejs phantomjs git mongodb imagemagick graphicsmagick zip
```
On Mac OSX use Homebrew
```js
brew install nodejs phantomjs git mongodb imagemagick graphicsmagick
```
Install node.js modules
```js
npm install -g bower grunt-cli coffee-script
```
Make sure mongod process is running, start it with mongod