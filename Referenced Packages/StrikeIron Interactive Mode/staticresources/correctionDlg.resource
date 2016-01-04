var checkNeedCorrection = {
    obj: {},
    requestUrl: '',
    sessionid: '',
    server: '',
    nextActionFunc: undefined,
    changableObject: [],
    autoUpdate: false,

    _nextAction: function (obj) {
        if (this.nextActionFunc != undefined) {
            this.nextActionFunc(obj);
        }
    },

    _checkNeedAcceptance: function (address) {
        return address.output.needAcceptance === "true";
    },

    _isValidAddress: function (address) {
        return address.input.fieldname.indexOf('Street') >= 0 && (address.output.itemState == 'VALID' || address.output.itemState == 'LIKELY_VALID');
    },

    _setAutoUpdate: function (address) {
        this.autoUpdate = address.output.autoUpdate === "true";
    },

    _getAddresses: function () {
        var a = [];
        var self = this;
        j$.each(this.obj.params, function (index, value) {
            self._setAutoUpdate(value);
            if (self._isValidAddress(value) && self._checkNeedAcceptance(value)) {
                a.push({indx: index, val: value});
            }
        });
        return a;
    },

    _drawValue: function ($parent, name, oldValue, newValue, style) {
        var $c = j$('<span class="container"></span>').appendTo($parent);
        j$('<span class="label">' + this._getValue(name) + '</span>').appendTo($c);
        var changedClass = style;
        
        var $s = this._getOldNewSpan($c,'oldvalue',this._getValue(oldValue));
        var $s1 = this._getOldNewSpan($c,'newvalue',this._getValue(newValue));
        
        if (oldValue != newValue && style == undefined) {
        	$s.addClass("changed");
        	$s1.addClass("changed");
        }
    },
    
    _getOldNewSpan: function(parent,clazz,value) {
        var $s = j$('<span class="'+clazz+'"></span>');
        var v = $('<div></div>').text(value).html();
        $s.attr('title',v);
        $s.html( v );
        parent.append($s);
        return $s;
    },

    _getValue: function (value) {
        return value == undefined ? "" : value;
    },

    _checkNeedDisableAcceptButton: function () {
        var existsChecked = false;
        j$('.item-container .check-control input[type=checkbox]').each(function () {
            if (j$(this).is(':checked')) {
                existsChecked = true;
            }
        });
        var confirmButton = $('.ui-dialog-buttonpane button:first');
        if (!existsChecked) {
            confirmButton[0].disabled = "disabled";
        } else {
            confirmButton.removeAttr("disabled");
        }
    },

    _draw: function (addressesList) {
        var $container = j$('<div class="item-container"></div>');
        var self = this;
        var showCheckBox = addressesList.length > 1;
        j$.each(addressesList, function (index, value) {
            var $item = j$('<span class="address-item"></span>').appendTo($container);
            $item.append(j$('<span class="item-header"><b>Field Name:</b> ' + value.val.input.fieldname + '</span>'));
            var cntrl_item = j$('<span class="check-control"></span>').appendTo($item);
            var $cb = j$('<input type="checkbox" checked="checked"/>');

            $cb.bind('click', function () {
                self._checkNeedDisableAcceptButton();
            });

            var $hf = j$('<input type="hidden" class="indx" value="' + value.indx + '" />');

            var act_cntrl = j$('<span class="checkbox"></span>').appendTo(cntrl_item);
            if (!showCheckBox) {
                j$('#ifMoreThatOneItem').hide();
                act_cntrl.hide();
            } else {
                j$('#ifMoreThatOneItem').show();
            }

            act_cntrl.append($cb);
            act_cntrl.append($hf);

            var $cntrl = j$('<span class="control"></span>').appendTo(cntrl_item);
            self._drawValue($cntrl, '', 'Current', 'Changed', 'header');
            self._drawValue($cntrl, 'Street', value.val.input.street, value.val.output.AddressLine1);
            self._drawValue($cntrl, 'City', value.val.input.city, value.val.output.City);

            var state = value.val.output.State;
            if (state == undefined) state = value.val.output.Province;
            var zip = value.val.output.ZIPPlus4;
            if (zip == undefined) zip = value.val.output.PostalCode;
            self._drawValue($cntrl, 'State/Province', value.val.input.state, state);
            self._drawValue($cntrl, 'ZIP/PostalCode', value.val.input.zip, zip);
        });
        return $container;
    },

    _drawDialogMsg: function () {
        var addressesList = this._getAddresses();
        var $container = this._draw(addressesList);

        if (!this.autoUpdate) {
            j$('#dialog .dlg-body').empty().append($container);
            if (addressesList.length > 0) {
                this._showDialog();
            } else {
                this._nextAction(this.obj);
            }
        } else {
            if (addressesList.length > 0) {
                this._sendToServer(undefined);
            }
            this._nextAction(this.obj);
        }
        ;
    },

    _getChecked: function () {
        var indx = [];

        j$('#dialog .check-control input[type=checkbox]').each(function () {
            var cb = j$(this);
            if (cb.is(':checked')) {
                var p = cb.parent();
                var h = p.find('.indx');
                indx.push(parseInt(h.val()));
            }
        });
        return indx;
    },

    _getResult: function () {
        this._sendToServer(this._getChecked());
    },

    // if checkedList == undefined that mean all checked
    _sendToServer: function (checkedList) {
        var self = this;
        j$.each(this._getAddresses(), function (index, value) {
            if (checkedList == undefined || j$.inArray(value.indx, checkedList) >= 0) {
                // send ajax request
                self._fillInputs(value.val);
                var rUrl = self.requestUrl + '/acceptlog?sessionid=' + self.sessionid + '&server=' + self.server + '&logid=' + value.val.output.logId;
                //XDomainRequest for IE
                if ('XDomainRequest' in window && window.XDomainRequest !== null) {
                    var xdr = new XDomainRequest();
                    if (xdr) {
                        xdr.onerror = function () {
                            console.log(a + ' ' + b + ' ' + c + ' - ' + rUrl);
                        };
                        xdr.ontimeout = function () {
                            console.log(a + ' ' + b + ' ' + c + ' - ' + rUrl);
                        };
                        xdr.onload = function () {
                            console.log('Successful - ' + rUrl);
                        };
                        xdr.open('GET', rUrl);
                        xdr.send();
                    }
                } else {
                    j$.ajax({
                        url: rUrl,
                        success: function (result) {
                            console.log('Successful - ' + rUrl);
                        },
                        error: function (a, b, c) {
                            console.log(a + ' ' + b + ' ' + c + ' - ' + rUrl);
                        }
                    });
                }
            }
        });
    },

    _fillInputs: function (object) {
        var control = undefined;
        j$.each(this.changableObject, function (index, value) {
            if (object.input.fieldname === value.fieldname) {
                control = value;
            }
        });

        if (control != undefined) {
            j$('.' + control.cssclass).val(object.output.AddressLine1);
            j$('.' + control.cityclass).val(object.output.City);
            j$('.' + control.stateclass).val((object.output.Province == undefined) ? object.output.State : object.output.Province);
            j$('.' + control.zipclass).val((object.output.PostalCode == undefined) ? object.output.ZIPPlus4 : object.output.PostalCode);
        }
    },

    _showDialog: function () {
        var self = this;
        var dlg = j$("#dialog").dialog({
            autoOpen: false,
            width: "650px",
            modal: true,
            buttons: {
                "Accept Changes": function () {
                    self._getResult();
                    j$(this).dialog("close");
                    self._nextAction(self.obj);
                },
                "Cancel": function () {
                    j$(this).dialog("close");
                    self._nextAction(self.obj);
                }
            },

            beforeClose: function (event, ui) {
                self._nextAction(self.obj);
            }

        });
        dlg.dialog("open");
    },


    show: function (result, ajaxUrl, session, srv, changableObjectArray, func) {
        this.obj = result;
        this.requestUrl = ajaxUrl;
        this.sessionid = session;
        this.server = srv;
        this.nextActionFunc = func;
        this.changableObject = changableObjectArray;
        this._drawDialogMsg();
    }
};




