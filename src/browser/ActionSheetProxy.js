function ActionSheet() {
}

ActionSheet.prototype.show = function (options, successCallback, errorCallback) {

    if (successCallback) {
        ActionSheet.prototype.successCallBack = successCallback;
    }

    var actionSheetContainer = document.getElementById('actionSheetProxyContainer');
    if (!actionSheetContainer) {
        var body = document.getElementsByTagName('body')[0];
        actionSheetContainer = document.createElement('div');
        actionSheetContainer.setAttribute('class', 'action-sheet-container');
        actionSheetContainer.setAttribute('id', 'actionSheetProxyContainer');
        body.appendChild(actionSheetContainer);
    }

    if (actionSheetContainer.hidden) {
        actionSheetContainer.hidden = false;
    }

    if (options) {
        this._clearChildren(actionSheetContainer);

        if (options.title) {
            this._addTitle(options.title, actionSheetContainer);
        }

        if (!options.destructiveButtonLast && options.addDestructiveButtonWithLabel) {
            this._addDestructiveButton(options.addDestructiveButtonWithLabel, actionSheetContainer, 1);
            ActionSheet.prototype._btnOffsetIndex = 2;
        } else {
            ActionSheet.prototype._btnOffsetIndex = 1;
        }

        if (options.buttonLabels) {
            this._addbuttons(options.buttonLabels, actionSheetContainer);
        }

        if (options.destructiveButtonLast && options.addDestructiveButtonWithLabel) {    //Generate Desctructive Button
            this._addDestructiveButton(options.addDestructiveButtonWithLabel, actionSheetContainer, options.buttonLabels.length + 1);
        }

        if (options.addCancelButtonWithLabel) {
            this._addCancelButton(options.addCancelButtonWithLabel, actionSheetContainer);
        }

    }
};

ActionSheet.prototype.hide = function (options, successCallback, errorCallback) {
    var actionSheetContainer = document.getElementById('actionSheetProxyContainer');
    actionSheetContainer.hidden = true;
};

ActionSheet.prototype.install = function () {
    if (!window.plugins) {
        window.plugins = {};
    }
    window.plugins.actionsheet = new ActionSheet();

    return window.plugins.actionsheet;
};

cordova.addConstructor(ActionSheet.prototype.install);
cordova.commandProxy.add('ActionSheet', ActionSheet);

//Helpers
ActionSheet.prototype._addTitle = function (label, destination) {
    var title = document.createElement('h3');
    title.setAttribute('class', 'action-sheet-title');
    title.innerHTML = label;
    destination.appendChild(title);
};


ActionSheet.prototype._addDestructiveButton = function (label, destination, position) {
    var btn = document.createElement('button');
    btn.setAttribute('value', position);
    btn.setAttribute('class', 'action-sheet-button action-sheet-destructive-button');
    btn.innerHTML = label;
    btn.onclick = ActionSheet.prototype._onclick;
    destination.appendChild(btn);
};

ActionSheet.prototype._addCancelButton = function (label, destination) {
    var btn = document.createElement('button');
    btn.setAttribute('class', 'action-sheet-button action-sheet-cancel-button');
    btn.innerHTML = label;
    btn.onclick = function () {
        ActionSheet.prototype.hide();
    };
    destination.appendChild(btn);
};

ActionSheet.prototype._addbuttons = function (labels, destination) {
    for (var i = 0; i < labels.length; i++) {
        var btn = document.createElement('button');
        btn.setAttribute('value', i + ActionSheet.prototype._btnOffsetIndex);
        btn.setAttribute('class', 'action-sheet-button action-sheet-normal-button');
        btn.innerHTML = labels[i];
        btn.onclick = ActionSheet.prototype._onclick;
        destination.appendChild(btn);
    }
};

ActionSheet.prototype._onclick = function (ev) {
    ev.preventDefault();
    ev.stopPropagation();
    ActionSheet.prototype.hide();
    if (ActionSheet.prototype.successCallBack) {
        ActionSheet.prototype.successCallBack(parseInt(ev.target.value, 10));
    }
};

ActionSheet.prototype._clearChildren = function (element) {
    if (element && element.hasChildNodes) {
        while (element.hasChildNodes()) {
            element.removeChild(element.lastChild);
        }
    }
};

ActionSheet.prototype.ANDROID_THEMES = {
    THEME_TRADITIONAL: 1, // default
    THEME_HOLO_DARK: 2,
    THEME_HOLO_LIGHT: 3,
    THEME_DEVICE_DEFAULT_DARK: 4,
    THEME_DEVICE_DEFAULT_LIGHT: 5
};

