(self["webpackChunk_devicefarmer_stf"] = self["webpackChunk_devicefarmer_stf"] || []).push([[5],{

/***/ 13:
/***/ ((module, __unused_webpack_exports, __webpack_require__) => {

/**
* Copyright © 2019 contains code contributed by Orange SA, authors: Denis Barbaron - Licensed under the Apache license 2.0
**/

__webpack_require__(14)

module.exports = angular.module('stf.signin', [
  (__webpack_require__(23).name),
  (__webpack_require__(24).name)
])
  .config(function($routeProvider) {
    $routeProvider
      .when('/auth/ldap/', {
        template: __webpack_require__(123)
      })
  })
  .controller('SignInCtrl', __webpack_require__(124))


/***/ }),

/***/ 14:
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "default": () => (__WEBPACK_DEFAULT_EXPORT__)
/* harmony export */ });
/* harmony import */ var _node_modules_style_loader_dist_runtime_injectStylesIntoStyleTag_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(15);
/* harmony import */ var _node_modules_style_loader_dist_runtime_injectStylesIntoStyleTag_js__WEBPACK_IMPORTED_MODULE_0___default = /*#__PURE__*/__webpack_require__.n(_node_modules_style_loader_dist_runtime_injectStylesIntoStyleTag_js__WEBPACK_IMPORTED_MODULE_0__);
/* harmony import */ var _node_modules_style_loader_dist_runtime_styleDomAPI_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(16);
/* harmony import */ var _node_modules_style_loader_dist_runtime_styleDomAPI_js__WEBPACK_IMPORTED_MODULE_1___default = /*#__PURE__*/__webpack_require__.n(_node_modules_style_loader_dist_runtime_styleDomAPI_js__WEBPACK_IMPORTED_MODULE_1__);
/* harmony import */ var _node_modules_style_loader_dist_runtime_insertBySelector_js__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(17);
/* harmony import */ var _node_modules_style_loader_dist_runtime_insertBySelector_js__WEBPACK_IMPORTED_MODULE_2___default = /*#__PURE__*/__webpack_require__.n(_node_modules_style_loader_dist_runtime_insertBySelector_js__WEBPACK_IMPORTED_MODULE_2__);
/* harmony import */ var _node_modules_style_loader_dist_runtime_setAttributesWithoutAttributes_js__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(18);
/* harmony import */ var _node_modules_style_loader_dist_runtime_setAttributesWithoutAttributes_js__WEBPACK_IMPORTED_MODULE_3___default = /*#__PURE__*/__webpack_require__.n(_node_modules_style_loader_dist_runtime_setAttributesWithoutAttributes_js__WEBPACK_IMPORTED_MODULE_3__);
/* harmony import */ var _node_modules_style_loader_dist_runtime_insertStyleElement_js__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(19);
/* harmony import */ var _node_modules_style_loader_dist_runtime_insertStyleElement_js__WEBPACK_IMPORTED_MODULE_4___default = /*#__PURE__*/__webpack_require__.n(_node_modules_style_loader_dist_runtime_insertStyleElement_js__WEBPACK_IMPORTED_MODULE_4__);
/* harmony import */ var _node_modules_style_loader_dist_runtime_styleTagTransform_js__WEBPACK_IMPORTED_MODULE_5__ = __webpack_require__(20);
/* harmony import */ var _node_modules_style_loader_dist_runtime_styleTagTransform_js__WEBPACK_IMPORTED_MODULE_5___default = /*#__PURE__*/__webpack_require__.n(_node_modules_style_loader_dist_runtime_styleTagTransform_js__WEBPACK_IMPORTED_MODULE_5__);
/* harmony import */ var _node_modules_css_loader_dist_cjs_js_signin_css__WEBPACK_IMPORTED_MODULE_6__ = __webpack_require__(21);
/* harmony import */ var _node_modules_css_loader_dist_cjs_js_signin_css__WEBPACK_IMPORTED_MODULE_6___default = /*#__PURE__*/__webpack_require__.n(_node_modules_css_loader_dist_cjs_js_signin_css__WEBPACK_IMPORTED_MODULE_6__);
/* harmony reexport (unknown) */ var __WEBPACK_REEXPORT_OBJECT__ = {};
/* harmony reexport (unknown) */ for(const __WEBPACK_IMPORT_KEY__ in _node_modules_css_loader_dist_cjs_js_signin_css__WEBPACK_IMPORTED_MODULE_6__) if(__WEBPACK_IMPORT_KEY__ !== "default") __WEBPACK_REEXPORT_OBJECT__[__WEBPACK_IMPORT_KEY__] = () => _node_modules_css_loader_dist_cjs_js_signin_css__WEBPACK_IMPORTED_MODULE_6__[__WEBPACK_IMPORT_KEY__]
/* harmony reexport (unknown) */ __webpack_require__.d(__webpack_exports__, __WEBPACK_REEXPORT_OBJECT__);

      
      
      
      
      
      
      
      
      

var options = {};

options.styleTagTransform = (_node_modules_style_loader_dist_runtime_styleTagTransform_js__WEBPACK_IMPORTED_MODULE_5___default());
options.setAttributes = (_node_modules_style_loader_dist_runtime_setAttributesWithoutAttributes_js__WEBPACK_IMPORTED_MODULE_3___default());

      options.insert = _node_modules_style_loader_dist_runtime_insertBySelector_js__WEBPACK_IMPORTED_MODULE_2___default().bind(null, "head");
    
options.domAPI = (_node_modules_style_loader_dist_runtime_styleDomAPI_js__WEBPACK_IMPORTED_MODULE_1___default());
options.insertStyleElement = (_node_modules_style_loader_dist_runtime_insertStyleElement_js__WEBPACK_IMPORTED_MODULE_4___default());

var update = _node_modules_style_loader_dist_runtime_injectStylesIntoStyleTag_js__WEBPACK_IMPORTED_MODULE_0___default()((_node_modules_css_loader_dist_cjs_js_signin_css__WEBPACK_IMPORTED_MODULE_6___default()), options);




       /* harmony default export */ const __WEBPACK_DEFAULT_EXPORT__ = ((_node_modules_css_loader_dist_cjs_js_signin_css__WEBPACK_IMPORTED_MODULE_6___default()) && (_node_modules_css_loader_dist_cjs_js_signin_css__WEBPACK_IMPORTED_MODULE_6___default().locals) ? (_node_modules_css_loader_dist_cjs_js_signin_css__WEBPACK_IMPORTED_MODULE_6___default().locals) : undefined);


/***/ }),

/***/ 21:
/***/ ((module, exports, __webpack_require__) => {

// Imports
var ___CSS_LOADER_API_IMPORT___ = __webpack_require__(22);
exports = ___CSS_LOADER_API_IMPORT___(false);
// Module
exports.push([module.id, "body {\n    background: #eeeeee;\n}\n\n.login2 {\n    padding: 15px;\n    background: #eeeeee;\n}\n\n.login2 .login-wrapper {\n    max-width: 420px;\n    margin: 0 auto;\n    text-align: center;\n}\n\n.login2 .login-wrapper img {\n    margin: 40px auto;\n}\n\n.login2 .login-wrapper .input-group-addon {\n    padding: 8px 0;\n    background: #f4f4f4;\n    min-width: 48px;\n    text-align: center;\n}\n\n.login2 .login-wrapper .input-group-addon i.falock {\n    font-size: 18px;\n}\n\n.login2 .login-wrapper input.form-control {\n    height: 48px;\n    font-size: 15px;\n    box-shadow: none;\n}\n\n.login2 .login-wrapper .checkbox {\n    margin-bottom: 30px;\n}\n\n.login2 .login-wrapper input[type=\"submit\"] {\n    padding: 10px 0 12px;\n    margin: 20px 0 30px;\n}\n\n.login2 .login-wrapper input[type=\"submit\"]:hover {\n    background: transparent;\n}\n\n.login2 .login-wrapper .social-login {\n    margin-bottom: 20px;\n    padding-bottom: 25px;\n    border-bottom: 1px solid #cccccc;\n}\n\n.login2 .login-wrapper .social-login > .btn {\n    width: 49%;\n    margin: 0;\n}\n\n.login2 .login-wrapper .social-login .facebook {\n    background-color: #335397;\n    border-color: #335397;\n}\n\n.login2 .login-wrapper .social-login .facebook:hover {\n    background-color: transparent;\n    color: #335397;\n}\n\n.login2 .login-wrapper .social-login .twitter {\n    background-color: #00c7f7;\n    border-color: #00c7f7;\n}\n\n.login2 .login-wrapper .social-login .twitter:hover {\n    background-color: transparent;\n    color: #00c7f7;\n}\n", ""]);
// Exports
module.exports = exports;


/***/ }),

/***/ 123:
/***/ ((module) => {

module.exports = "<!--Copyright © 2019 contains code contributed by Orange SA, authors: Denis Barbaron - Licensed under the Apache license 2.0--><!----><div ng-controller=\"SignInCtrl\" class=\"login2\"><div class=\"login-wrapper\"><a href=\"./\"><img width=\"160\" height=\"160\" src=\"/static/logo/exports/STF-512.png\" title=\"STF\"/></a><form name=\"signin\" novalidate=\"novalidate\" ng-submit=\"submit()\"><div ng-show=\"error\" class=\"alert alert-danger\"><span ng-show=\"error.$invalid\" translate=\"translate\">Check errors below</span><span ng-show=\"error.$incorrect\" translate=\"translate\">Incorrect login details</span><span ng-show=\"error.$server\" translate=\"translate\">Server error. Check log output.</span></div><div class=\"form-group\"><div class=\"input-group\"><span class=\"input-group-addon\"><i class=\"fa fa-user\"></i></span><input ng-model=\"username\" name=\"username\" required=\"required\" type=\"text\" placeholder=\"LDAP Username\" autocorrect=\"off\" autocapitalize=\"off\" spellcheck=\"false\" autocomplete=\"section-login username\" class=\"form-control\"/></div><div ng-show=\"signin.username.$dirty &amp;&amp; signin.username.$invalid\" class=\"alert alert-warning\"><span ng-show=\"signin.username.$error.required\" translate=\"translate\">Please enter your LDAP username</span></div></div><div class=\"form-group\"><div class=\"input-group\"><span class=\"input-group-addon\"><i class=\"fa fa-lock\"></i></span><input ng-model=\"password\" name=\"password\" required=\"required\" type=\"password\" placeholder=\"Password\" autocorrect=\"off\" autocapitalize=\"off\" spellcheck=\"false\" autocomplete=\"section-login current-password\" class=\"form-control\"/></div><div ng-show=\"signin.password.$dirty &amp;&amp; signin.password.$invalid\" class=\"alert alert-warning\"><span translate=\"translate\">Please enter your password</span></div></div><input type=\"submit\" value=\"Log In\" class=\"btn btn-lg btn-primary btn-block\"/><button type=\"button\" uib-tooltip=\"{{'Write a mail to the support team' | translate}}\" ng-disabled=\"!contactEmail\" ng-click=\"mailToSupport()\" tooltip-placement=\"top\" tooltip-popup-delay=\"500\" class=\"btn btn-sm btn-default-outline\"><i class=\"fa fa-envelope-o\"></i><span translate=\"translate\">Contact Support </span></button></form></div></div>"

/***/ }),

/***/ 124:
/***/ ((module) => {

/**
* Copyright © 2019-2024 contains code contributed by Orange SA, authors: Denis Barbaron - Licensed under the Apache license 2.0
**/

module.exports = function SignInCtrl($window, $scope, $http, CommonService) {

  $window.angular.version = {}

  $scope.error = null

  $scope.submit = function() {
    var data = {
      username: $scope.signin.username.$modelValue
      , password: $scope.signin.password.$modelValue
    }
    $scope.invalid = false
    $http.post('/auth/api/v1/ldap', data)
      .then(function(response) {
        $scope.error = null
        location.replace(response.data.redirect)
      })
      .catch(function(response) {
        switch (response.data.error) {
          case 'ValidationError':
            $scope.error = {
              $invalid: true
            }
            break
          case 'InvalidCredentialsError':
            $scope.error = {
              $incorrect: true
            }
            break
          default:
            $scope.error = {
              $server: true
            }
            break
        }
      })
  }

  $scope.mailToSupport = function() {
    CommonService.url('mailto:' + $scope.contactEmail)
  }

  $http.get('/auth/contact').then(function(response) {
    $scope.contactEmail = response.data.contact.email
  })
}


/***/ })

}]);