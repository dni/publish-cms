# Grunt Tasks

Restart the app daemon, mostly afterwards changes on the serverside script
```js
grunt restart
```
install the publish app
```js
grunt install
```
clean the project, drop the database and reinstall
```js
grunt reinstall
```
build all components use build:backend, build:frontend to build single components
```js
grunt build
```
reset the whole project, use npm install afterwards
```js
grunt reset
```
watch your coffeescript files while development
```js
grunt watch
```
view all available tasks
```js
grunt --help
```