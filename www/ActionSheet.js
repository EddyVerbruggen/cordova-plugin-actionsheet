function ActionSheet() {
}

ActionSheet.prototype.show = function (options, successCallback, errorCallback) {
  cordova.exec(successCallback, errorCallback, "ActionSheet", "show", [options]);
};

ActionSheet.install = function () {
  if (!window.plugins) {
    window.plugins = {};
  }

  window.plugins.actionsheet = new ActionSheet();

  // for wp8 we need to manually hide the popup when the backbutton is clicked
  document.addEventListener("backbutton", function () {
    cordova.exec(null, null, "ActionSheet", "hide", []);
  }, false);

  return window.plugins.actionsheet;
};

cordova.addConstructor(ActionSheet.install);