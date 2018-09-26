

function TheConfirm_OkOnly(dialogText, dialogTitle) {
    TheConfirm_Ok(dialogText
                          , function () {
                          }, function () {
                          },
                            dialogTitle
                        );
}

function TheConfirm_Ok(dialogText, okFunc, dialogTitle) {
    $('<div style="padding: 10px; max-width: 500px; word-wrap: break-word;">' + dialogText + '</div>').dialog({
        draggable: false,
        modal: true,
        resizable: false,
        width: 'auto',
        title: dialogTitle,
        minHeight: 75,
        buttons: {
            OK: function () {
                if (typeof (okFunc) == 'function') {
                    setTimeout(okFunc, 50);
                }
                $(this).dialog('destroy');
            }
        }
    });
}


function TheConfirm_Ok_Cancel(dialogText, okFunc, cancelFunc, dialogTitle) {
    $('<div style="padding: 10px; max-width: 500px; word-wrap: break-word;">' + dialogText + '</div>').dialog({
        draggable: false,
        modal: true,
        resizable: false,
        width: 'auto',
        title: dialogTitle || 'Confirm',
        minHeight: 75,
        buttons: {
            OK: function () {
                //Comment: Yogesh Keraliya
                //if (typeof (okFunc) == 'function') {
                //    setTimeout(okFunc, 50);
                //}
                //$(this).dialog('destroy');
                if (okFunc) {
                    var vals = okFunc.split("^");
                    if (vals && vals.length > 0) {
                        AutoLoginApplicant(vals[0], vals[1]);
                    }
                }
            },
            Cancel: function () {
                if (typeof (cancelFunc) == 'function') {
                    setTimeout(cancelFunc, 50);
                }
                $(this).dialog('destroy');
            }
        }
    });
}


function showCustomPopUp(PageUrl, Pagetitle) {

    var $dialog = $('<div></div>')
            .html('<div> <i> <h3>Soon we are coming up with new functionality.!!</h3> </i></div>')
                   //.html('<iframe style="border: 0px; " src="' + PageUrl + '" width="100%" height="100%"></iframe>')
                   .dialog({
                       autoOpen: false,
                       modal: true,
                       height: 325,
                       width: 400,
                       title: Pagetitle
                   });
    $dialog.dialog('open');
}

