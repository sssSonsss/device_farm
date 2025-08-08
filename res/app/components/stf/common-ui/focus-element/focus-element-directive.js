module.exports = function focusElementDirective($parse, $timeout) {
  return {
    restrict: 'A',
    link: function(scope, element, attrs) {
      var model = $parse(attrs.focusElement)

      scope.$watch(model, function(value) {
        if (value === true) {
          $timeout(function() {
            element[0].focus()
          })
        }
      })

      element.bind('blur', function() {
        if (model && model.assign) {
          scope.safeApply(model.assign(scope, false))
        }
      })
    }
  }
}
