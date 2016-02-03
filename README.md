# Scille Form (for Angularjs)

A Form is a collection of Controls for AngularJS. Controls are ways for a user to enter data. This library is created by DUBOIS Romain and maintained by the Scille team.


## Installation

### Required Node Tools

In order to get started, you'll want to install some tools globally.
```bash
$ sudo apt-get install nodejs
$ sudo ln /usr/bin/nodejs /usr/bin/node

$ sudo apt-get install npm
$ sudo npm install -g bower grunt-cli coffee-script karma-cli protractor
```

### Download git repository

```bash
$ git clone https://github.com/Scille/sc-form
$ cd sc-form
$ npm install
$ bower install
```

### Install with bower

```bash
$ bower install sc-form --save-dev
```


## Usage

### Registration

To be able to use the directive, you need to register the sc-form module as a dependency:
```javascript
angular.module('yourModule', ['sc-form'
    // other dependencies
]);
```

### Directive

Directives can work on both attribute and element levels.
```html
<div text-input-directive
    ng-model="textModel"
    label="{{label}}"
    icon="{{icon}}"
    placeholder="{{placeholder}}"
    popover-msg="{{popoverMsg}}"
    error-msg="{{errorMsg]}"
    upper-first-letter="upperFirstLetter"
    is-disabled="isDisabled">
</div>

<div number-input-directive
    ng-model="numberModel">
</div>

<div date-input-directive
    ng-model="dateModel">
</div>

<div list-input-directive
    ng-model="listModel">
</div>

<div array-input-directive
    ng-model="arrayModel">
</div>

<div img-input-directive
    ng-model="imgModel">
</div>
```

*Note:*
* **ng-model:** Will try to bind to the property given by evaluating the expression on the current scope. If the property doesn't already exist on this scope, it will be created implicitly and added to the scope.
* **label**: Sets the label text
* **icon**: Sets the icon
* **placeholder**: Sets the input placeholder
* **popover-msg**: Sets the popover message
* **error-msg**: Sets the error message
* **upper-first-letter*: Capitalizes the first letter of string.
* **is-disabled**: Determines if the input is disabled or not.

## Directory structure

```
sc-form/
    |
    |- demo/                    -> Contains JavaScript file and HTML file. (Used by Grunt to run the demonstration)
    |
    |- release/                 -> Contains the production minified release of the app.
    |   |- css/                     -> Minified CSS file.
    |   '- script/                  -> Minified JavaScript file.
    |
    |- src/                     -> Contains CoffeeScript sources, LESS styles and other assets.
    |   |- coffee/                  -> CoffeeScript sources.
    |   |- html_template/           -> HTML that contains Angular-specific elements and attributes.
    |   '- less/                    -> LESS sources.
    |
    '- test/                    -> Contains tests for the application.
        |- e2e/                     -> End-To-End tests for AngularJS applications. (Protractor)
        '- unit/                    -> Unit tests for AngularJS components. (Karma)
```

## Demonstration

Executing the demo with:
```bash
$ grunt serve
```

Executing demo on GitHub Pages:
[scille.github.io/sc-form](http://scille.github.io/sc-form/)

## Running tests

### Unit Tests (Karma)

Executing Unit Tests with Grunt:
```bash
$ grunt unit-test
```

Executing Unit Tests by Karma:
```bash
$ karma start ./test/karma_conf.coffee --single-run
```

It will also generate HTML test coverage report inside ./.tmp/report-html directory.

### End-To-End Tests (Protractor)

Executing End-To-End Tests with Grunt:
```bash
$ grunt e2e-test
```

Executing End-To-End Tests by Protractor:
```bash
$ protractor ./test/protractor_conf.coffee
```

## Dependencies

* see [Bootstrap](http://getbootstrap.com/)
* see [Bootstrap Date/Time Picker](https://github.com/Eonasdan/bootstrap-datetimepicker)

## Contributors

DUBOIS Romain, Engineer R&D at [SCILLE](http://scille.eu/)
<romain.dubois@scille.fr>

Landieth Jérôme, Engineer R&D at [SCILLE](http://scille.eu/)
<jerome.landieth@scille.fr>

MEZINO Vincent, Engineer R&D at [SCILLE](http://scille.eu)
<vincent.mezino@scille.fr>


## License

Licensed under the MIT License
