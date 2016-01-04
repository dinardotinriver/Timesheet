function sumOfLengthCityStateZip(value) {
    return j$('.' + value.cityclass).val().length +
        j$('.' + value.stateclass).val().length +
        j$('.' + value.zipclass).val().length;
}

function fieldChanged(changableObjects, ident, fieldName, label, editMode, staticUrl) {
    if (editMode) {
        j$('.' + ident).html(label + ' has not been verified');
        j$('#' + ident).attr('src', staticUrl);
    }

    j$.each(changableObjects, function (index, value) {
        if (value.fieldname === fieldName) {
            value.changed = true;
            if (editMode) {
                var changedField = j$('.' + value.cssclass);
                if ('phone' === value.type || 'email' === value.type) {
                    if (changedField.val() && changedField.val() !== '') {
                        j$('#' + ident).show();
                    } else {
                        j$('#' + ident).hide();
                    }
                } else if ('address' === value.type) {
                    if (changedField.val() && changedField.val() !== '' && sumOfLengthCityStateZip(value) > 0) {
                        j$('#' + ident).show();
                    } else {
                        j$('#' + ident).hide();
                    }
                }
            }
        }
    });
}

function submitQuietly(popUpclass) {
    j$('.' + popUpclass).each(function () {
        j$(this).hide()
    });
    onResponse(buttonClicked);
}

function sendAjax(params, formId, serverUrl, sessionId, partnerServerUrl, popUpclass, editMode, changableObjects, userName) {
    j$('.' + popUpclass).each(function () {
        j$(this).show()
    });
    var p = {};
    p['params'] = params;
    var url = serverUrl + '/Validate?sessionid=' + sessionId + '&server=' + partnerServerUrl + '&username=' + userName;
    if ('XDomainRequest' in window && window.XDomainRequest !== null) {
        var xdr = new XDomainRequest();
        if (xdr) {
            xdr.onerror = function () {
                submitQuietly(popUpclass);
            };
            xdr.ontimeout = function () {
                submitQuietly(popUpclass);
            };
            xdr.onload = function () {
                var result = JSON.parse(xdr.responseText);
                checkNeedCorrection.show(result, serverUrl, sessionId, partnerServerUrl, changableObjects, function (result) {
                    j$.each(j$(result.params), function (index, value) {
                        if (value.input.fieldname != null) {
                            document.getElementById(formId + value.input.fieldname + 'VerResult').value = JSON.stringify(value.output);
                        }
                    });
                    submitQuietly(popUpclass);
                });
            };
            xdr.open('POST', url);
            xdr.send(JSON.stringify(p, undefined, 2));
        } else {
            submitQuietly(popUpclass);
        }
    } else {
        j$.ajax({
            contentType: 'application/json; charset=UTF-8',
            data: JSON.stringify(p, undefined, 2),
            dataType: 'json',
            type: 'POST',
            url: url,
            success: function (result) {
                checkNeedCorrection.show(result, serverUrl, sessionId, partnerServerUrl, changableObjects, function (result) {
                    j$.each(j$(result.params), function (index, value) {
                        if (value.input.fieldname != null) {
                            document.getElementById(formId + value.input.fieldname + 'VerResult').value = JSON.stringify(value.output);
                        }
                    });
                    submitQuietly(popUpclass);
                });
            },
            error: function (a, b, c) {
                submitQuietly(popUpclass);
            }
        });
    }
}

function fillParams(params, changableObjects, objectid, objecttitle, objectName, formId) {
    j$.each(changableObjects, function (index, value) {
        if (value.changed) {
            if ('phone' === value.type || 'email' === value.type) {
                if (j$('.' + value.cssclass).val() && j$('.' + value.cssclass).val() !== '') {
                    if (value.type === 'email') {
                        params.push({
                            "type": value.type,
                            "email": j$('.' + value.cssclass).val(),
                            "objectid": objectid,
                            "fieldname": value.fieldname,
                            "objectname": objectName,
                            "objecttitle": objecttitle
                        });
                    } else if (value.type === 'phone') {
                        params.push({
                            "type": value.type,
                            "phone": j$('.' + value.cssclass).val(),
                            "objectid": objectid,
                            "fieldname": value.fieldname,
                            "objectname": objectName,
                            "objecttitle": objecttitle
                        });
                    }
                } else {
                    var needDeleteField = document.getElementById(formId + value.needDeleteResult);
                    if (needDeleteField != null) {
                        needDeleteField.value = true;
                    }
                }
            } else if ('address' === value.type) {
                if (j$('.' + value.cssclass).val() && j$('.' + value.cssclass).val() !== '' && sumOfLengthCityStateZip(value) > 0) {
                    params.push({
                        "type": value.type,
                        "street": j$('.' + value.cssclass).val(),
                        "state": j$('.' + value.stateclass).val(),
                        "zip": j$('.' + value.zipclass).val(),
                        "city": j$('.' + value.cityclass).val(),
                        "country": j$('.' + value.countryclass).val(),
                        "objectid": objectid,
                        "fieldname": value.fieldname,
                        "objectname": objectName,
                        "objecttitle": objecttitle
                    });
                } else {
                    var needDeleteField = document.getElementById(formId + value.needDeleteResult);
                    if (needDeleteField != null) {
                        needDeleteField.value = true;
                    }
                }
            }
        }
    });
}

function checkIfErrorExists(changableObjects) {
    if (j$('[class^="error"]').length > 0 || j$('.pbError').length > 0) {
        j$.each(changableObjects, function (index, value) {
            value.changed = true;
        });
    }
}

function readyPage(changableObjects, popUpclass, permissionError) {
    if (!permissionError) {
        j$.each(changableObjects, function (index, value) {
            if ('phone' === value.type || 'email' === value.type) {
                if (j$('.' + value.cssclass).val() && j$('.' + value.cssclass).val() !== '') {
                    j$('#' + value.imgcomp).show();
                } else {
                    j$('#' + value.imgcomp).hide();
                }
            } else if ('address' === value.type) {
                if (j$('.' + value.cssclass).val() && j$('.' + value.cssclass).val() !== '' && sumOfLengthCityStateZip(value) > 0) {
                    j$('#' + value.imgcomp).show();
                } else {
                    j$('#' + value.imgcomp).hide();
                }
            }
        });
    }
    j$('.' + popUpclass).each(function () {
        j$(this).hide()
    });
}

function onResponse(button) {
    if (button == 'save') {
        overridedSave();
    }
    if (button == 'savenew') {
        overridedSaveNew();
    }
}

