# Scille Form (for Angularjs)

A Form is a collection of Controls for AngularJS. Controls are ways for a user to enter data. This library is created by DUBOIS Romain and maintained by the Scille team.


## Installation

### Required Node Tools

In order to get started, you'll want to install some tools globally.
```bash
$ sudo apt-get install nodejs
$ sudo ln /usr/bin/nodejs /usr/bin/node

$ sudo apt-get install npm
$ sudo npm install -g bower gulp coffee-script karma-cli protractor
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
<div sc-text-input-directive
    ng-model="textModel"
    icon="{{icon}}"
    label="{{label}}"
    placeholder="{{placeholder}}"
    popover-msg="{{popoverMsg}}"
    error-msg="errorMsg"
    upper-first-letter="upperFirstLetter"
    is-disabled="isDisabled">
</div>

<div sc-list-text-input-directive
    ng-model="listModel"
    icon="{{icon}}"
    label="{{label}}"
    placeholder="{{placeholder}}"
    popover-msg="{{popoverMsg}}"
    error-msg="errorMsg"
    is-disabled="isDisabled"
    upper-first-letter="upperFirstLetter">
</div>

<div sc-number-input-directive
    ng-model="numberModel"
    icon="{{icon}}"
    label="{{label}}"
    placeholder="{{placeholder}}"
    popover-msg="{{popoverMsg}}"
    error-msg="errorMsg"
    is-disabled="isDisabled"
    step="step">
</div>

<div sc-date-input-directive
    ng-model="dateModel"
    icon="{{icon}}"
    label="{{label}}"
    popover-msg="{{popoverMsg}}"
    type="{{type}}}"
    approximative-model="approximativeModel"
    error-msg="errorMsg"
    is-disabled="isDisabled">
</div>

<div sc-select-input-directive
    ng-model="selectModel"
    icon="{{icon}}"
    label="{{label}}"
    options-json="{{json}}"
    error-msg="errorMsg"
    is-disabled="isDisabled"
    options-model="optionsModel">
</div>

<div sc-list-select-input-directive
    ng-model="listSelectModel"
    icon="{{icon}}"
    label="{{label}}"
    options-json="{{json}}"
    error-msg="errorMsg"
    is-disabled="isDisabled"
    options-model="optionsModel">
</div>

<div sc-array-input-directive
    ng-model="arrayModel"
    add-button="{{addButton}}"
    json="{{json}}"
    label="{{label}}"
    is-disabled="isDisabled">
</div>

<div sc-img-input-directive
    ng-model="imgModel"
    label="{{label}}"
    placeholder="{{placeholder}}"
    error-msg="errorMsg"
    is-disabled="isDisabled">
</div>

<div sc-file-input-directive
    ng-model="fileModel"
    label="{{label}}"
    placeholder="{{placeholder}}"
    error-msg="errorMsg"
    is-disabled="isDisabled">
</div>
```

*Note:*
* **ng-model:** Will try to bind to the property given by evaluating the expression on the current scope. If the property doesn't already exist on this scope, it will be created implicitly and added to the scope.
* **add-button**: Sets the button value.
* **icon**: Sets the icon.
* **json**: Sets the JSON file.
* **label**: Sets the label text.
* **options-json**: Sets the select options values as JSON file.
* **placeholder**: Sets the input placeholder.
* **popover-msg**: Sets the popover message.
* **type**: Sets the input type (date or datetime-local).
* **approximative-model**: Determines if the input is an approximate date.
* **error-msg**: Sets the error message.
* **is-disabled**: Determines if the input is disabled or not.
* **options-model**: Sets the select options values.
* **step**: Specifies the legal number intervals.
* **upper-first-letter**: Capitalizes the first letter of string.

## Directory structure

```
sc-form/
    |
    |- demo/                    -> Contains JavaScript file and HTML file. (Used by Gulp to run the demonstration)
    |
    |- release/                 -> Contains the production minified release of the app.
    |   |- sc-form.min.css          -> Minified CSS file.
    |   '- sc-form.min.js           -> Minified JavaScript file.
    |
    |- src/                     -> Contains CoffeeScript sources, LESS styles and other assets.
    |   |- script/                  -> CoffeeScript sources and HTML that contains Angular-specific elements and attributes.
    |   '- style/                   -> LESS sources.
    |
    '- test/                    -> Contains tests for the application.
        |- e2e/                     -> End-To-End tests for AngularJS applications. (Protractor)
        '- unit/                    -> Unit tests for AngularJS components. (Karma)
```

## Demonstration

Executing the demo with:
```bash
$ gulp serve
```

Executing demo on GitHub Pages:
[scille.github.io/sc-form](http://scille.github.io/sc-form/)

## Running tests

### Unit Tests (Karma)

Executing Unit Tests with Gulp:
```bash
$ gulp unit-test
```

Executing Unit Tests by Karma:
```bash
$ karma start ./test/karma_conf.coffee --single-run
```

It will also generate HTML test coverage report inside ./.tmp/report-html directory.

### End-To-End Tests (Protractor)

Executing End-To-End Tests with Gulp:
```bash
$ gulp e2e-test
```

Executing End-To-End Tests by Protractor:
```bash
$ protractor ./test/protractor_conf.coffee
```

## Dependencies

* see [Bootstrap](http://getbootstrap.com/)

## Contributors

DUBOIS Romain, Engineer R&D at [SCILLE](http://scille.eu/)
<romain.dubois@scille.fr>

LANDIETH Jérôme, Engineer R&D at [SCILLE](http://scille.eu/)
<jerome.landieth@scille.fr>

MEZINO Vincent, Engineer R&D at [SCILLE](http://scille.eu)
<vincent.mezino@scille.fr>

STEMPERT Nicolas, Engineer R&D at [SCILLE](http://scille.eu)
<nicolas.stempert@scille.fr>


## License

Licensed under the MIT License
