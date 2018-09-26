/********************************************* CK Editor (Html Editor) ******************************************************/
var arrCKEditor = new Array();

function SetCKEditor(Id, onBlurCallBack) {

    var $target = $('#' + Id);

    // The inline editor should be enabled on an element with "contenteditable" attribute set to "true".
    // Otherwise CKEditor will start in read-only mode.

    $target.attr('contenteditable', true);

    CKEDITOR.inline(Id,
        {
            // Show toolbar on startup (optional).
            //startupFocus: true,
            startupFocus: false,
            enterMode: CKEDITOR.ENTER_BR,
            on: {
                blur: function (event) {
                    event.editor.updateElement();
                },
                fileUploadResponse: function (evt) {
                    // Prevent the default response handler.
                    evt.stop();

                    // Ger XHR and response.
                    var data = evt.data,
                        xhr = data.fileLoader.xhr,
                        response = xhr.responseText.split('|');

                    var jsonarray = JSON.parse(response[0]);

                    if (jsonarray && jsonarray.uploaded != "1") {
                        // Error occurred during upload.                
                        evt.cancel();
                    } else {
                        data.url = jsonarray.url;
                    }
                }
            }
        });

    var editor = CKEDITOR.instances[Id];

    //console.log(editor.name + ' editor created.');

    arrCKEditor.push(editor);

    // Commented yogesh keraliya : 02152017 
    // Editor blur event auto update of underlying element.
    //editor.on('blur', function (event) {

    //    event.editor.updateElement();

    //    if (typeof (onBlurCallBack) == 'function') {
    //        console.log(event.editor.name + ' editor lost focus.');
    //        onBlurCallBack(event.editor);
    //    }
    //});

    //editor.on('fileUploadResponse', function (evt) {
    //    // Prevent the default response handler.
    //    evt.stop();

    //    // Ger XHR and response.
    //    var data = evt.data,
    //        xhr = data.fileLoader.xhr,
    //        response = xhr.responseText.split('|');

    //    var jsonarray = JSON.parse(response[0]);

    //    if (jsonarray && jsonarray.uploaded != "1") {
    //        // Error occurred during upload.                
    //        evt.cancel();
    //    } else {
    //        data.url = jsonarray.url;
    //    }
    //});
}

function SetCKEditorForPageContent(Id, AutosavebuttonId) {

    var $target = $('#' + Id);

    // The inline editor should be enabled on an element with "contenteditable" attribute set to "true".
    // Otherwise CKEditor will start in read-only mode.

    $target.attr('contenteditable', true);

    CKEDITOR.inline(Id,
        {
            // Show toolbar on startup (optional).
            //startupFocus: true,
            startupFocus: false,
            enterMode: CKEDITOR.ENTER_BR,
            on: {
                blur: function (event) {
                    event.editor.updateElement();
                    $(AutosavebuttonId).click();
                },
                fileUploadResponse: function (event) {
                    // Prevent the default response handler.
                    event.stop();

                    // Ger XHR and response.
                    var data = event.data,
                        xhr = data.fileLoader.xhr,
                        response = xhr.responseText.split('|');

                    var jsonarray = JSON.parse(response[0]);

                    if (jsonarray && jsonarray.uploaded != "1") {
                        // Error occurred during upload.                
                        event.cancel();
                    } else {
                        data.url = jsonarray.url;
                    }
                }

            }
        });

    var editor = CKEDITOR.instances[Id];

    arrCKEditor.push(editor);
}
function SetCKEditorForRomanDesc(Id) {

    var $target = $('#' + Id);
    var taskid = $('#' + Id).attr('data-taskid');

    // The inline editor should be enabled on an element with "contenteditable" attribute set to "true".
    // Otherwise CKEditor will start in read-only mode.

    $target.attr('contenteditable', true);
    var editor = CKEDITOR.instances[Id];

    CKEDITOR.inline(Id,
        {
            // Show toolbar on startup (optional).
            //startupFocus: true,
            startupFocus: false,
            enterMode: CKEDITOR.ENTER_BR,
            on: {
                blur: function (event) {
                    event.editor.updateElement();
                    //updateDesc(GetCKEditorContent(Id));
                },
                fileUploadResponse: function (event) {

                }

            },
            on: {
                'key': ckeditorKeyPress
            }
        });

    CKEDITOR.instances[Id].on('fileUploadResponse', function (event) {
        // Prevent the default response handler.
        event.stop();

        // Ger XHR and response.
        var data = event.data,
            xhr = data.fileLoader.xhr,
            response = xhr.responseText.split('|');

        var jsonarray = JSON.parse(response[0]);

        attachImagesByCKEditor(event.data.fileLoader.fileName, jsonarray.fileName);

        if (jsonarray && jsonarray.uploaded != "1") {
            // Error occurred during upload.                
            event.cancel();
        } else {
            data.url = jsonarray.url;
        }

        RefreshData = false;
        var data = {
            FileName: jsonarray.fileName
        };
        CurrentFileName = jsonarray.fileName;
        CurrentEditor = CKEDITOR.instances[Id];
        SaveChildAttchmentToDB(taskid);
    });
    //Save when leaves editing
    CKEDITOR.instances[Id].on('blur', function () {
        //CKEDITOR.instances[Id].updateElement();        

        //OnSaveSubTask(taskid, GetCKEditorContent('subtaskDesc' + taskid));
        //CKEDITOR.instances[Id].setData('');
    });

    //Auto Save after 30 seconds
    CKEDITOR.instances[Id].updateElement();

    arrCKEditor.push(editor);


    function ckeditorKeyPress(event) {
        switch (event.data.keyCode) {
            case 13: //enter key
                //var desc = GetCKEditorContent('subtaskDesc' + taskid);
                //CKEDITOR.instances[Id].setData('');
                //OnSaveSubTask(taskid, desc);
                break;
            default:
                if (timeoutId != undefined) {
                    console.log('removing timer: ' + timeoutId);
                    clearTimeout(timeoutId);
                }

                timeoutId = setTimeout(function () {
                    // Runs 1 second (1000 ms) after the last change    
                    var desc = GetCKEditorContent('subtaskDesc' + taskid);
                    if (desc != undefined && desc.trim() != '') {
                        console.log('saving desc...');
                        CKEDITOR.instances[Id].setData('');
                        OnRomanSave(taskid, desc);
                    }
                    else
                        console.log('not saving empty desc');
                }, 30000);
                console.log('adding timer: ' + timeoutId);
                break;
        }
        //trigger an imitation key event here and it lets you catch the enter key
        //outside the ckeditor
    }
}
function SetCKEditorForChildren(Id) {

    var $target = $('#' + Id);
    var taskid = $('#' + Id).attr('data-taskid');

    // The inline editor should be enabled on an element with "contenteditable" attribute set to "true".
    // Otherwise CKEditor will start in read-only mode.

    $target.attr('contenteditable', true);
    var editor = CKEDITOR.instances[Id];

    CKEDITOR.inline(Id,
        {
            // Show toolbar on startup (optional).
            //startupFocus: true,
            startupFocus: true,
            enterMode: CKEDITOR.ENTER_BR,
            on: {
                blur: function (event) {
                    event.editor.updateElement();
                    //updateDesc(GetCKEditorContent(Id));
                },
                fileUploadResponse: function (event) {

                }

            },
            on: {
                'key': ckeditorKeyPress
            }
        });

    CKEDITOR.instances[Id].on('fileUploadResponse', function (event) {
        // Prevent the default response handler.
        event.stop();

        // Ger XHR and response.
        var data = event.data,
            xhr = data.fileLoader.xhr,
            response = xhr.responseText.split('|');

        var jsonarray = JSON.parse(response[0]);

        attachImagesByCKEditor(event.data.fileLoader.fileName, jsonarray.fileName);

        if (jsonarray && jsonarray.uploaded != "1") {
            // Error occurred during upload.                
            event.cancel();
        } else {
            data.url = jsonarray.url;
        }

        RefreshData = false;
        var data = {
            FileName: jsonarray.fileName
        };
        CurrentFileName = jsonarray.fileName;
        CurrentEditor = CKEDITOR.instances[Id];
        SaveChildAttchmentToDB(taskid);
    });
    //Save when leaves editing
    CKEDITOR.instances[Id].on('blur', function () {
        //CKEDITOR.instances[Id].updateElement();        

        //OnSaveSubTask(taskid, GetCKEditorContent('subtaskDesc' + taskid));
        //CKEDITOR.instances[Id].setData('');
    });

    //Auto Save after 30 seconds
    CKEDITOR.instances[Id].updateElement();

    arrCKEditor.push(editor);


    function ckeditorKeyPress(event) {
        switch (event.data.keyCode) {
            case 13: //enter key
                event.cancel();
                event.stop();
                var desc = GetCKEditorContent('subtaskDesc' + taskid);
                CKEDITOR.instances[Id].setData('');
                OnSaveSubTask(taskid, desc);
                break;
            default:
                if (timeoutId != undefined) {
                    console.log('removing timer: ' + timeoutId);
                    clearTimeout(timeoutId);
                }

                timeoutId = setTimeout(function () {
                    // Runs 1 second (1000 ms) after the last change    
                    var desc = GetCKEditorContent('subtaskDesc' + taskid);
                    if (desc != undefined && desc.trim() != '') {
                        console.log('saving desc...');
                        CKEDITOR.instances[Id].setData('');
                        OnSaveSubTask(taskid, desc);
                    }
                    else
                        console.log('not saving empty desc');
                }, 30000);
                console.log('adding timer: ' + timeoutId);
                break;
        }
        //trigger an imitation key event here and it lets you catch the enter key
        //outside the ckeditor
    }
}

var timeoutId;

function SetCKEditorForSubTask(Id) {

    var $target = $('#' + Id);

    // The inline editor should be enabled on an element with "contenteditable" attribute set to "true".
    // Otherwise CKEditor will start in read-only mode.

    $target.attr('contenteditable', true);

    CKEDITOR.inline(Id,
        {
            // Show toolbar on startup (optional).
            //startupFocus: true,
            startupFocus: true,
            enterMode: CKEDITOR.ENTER_BR,
            on: {
                blur: function (event) {
                    event.editor.updateElement();
                    //updateDesc(GetCKEditorContent(Id));
                },

            },
            on: {
                'key': ckeditorKeyPress
            }
        });
    CKEDITOR.instances[Id].on('fileUploadResponse', function (event) {
        // Prevent the default response handler.
        event.stop();

        // Ger XHR and response.
        var data = event.data,
            xhr = data.fileLoader.xhr,
            response = xhr.responseText.split('|');

        var jsonarray = JSON.parse(response[0]);

        attachImagesByCKEditor(event.data.fileLoader.fileName, jsonarray.fileName);

        if (jsonarray && jsonarray.uploaded != "1") {
            // Error occurred during upload.                
            event.cancel();
        } else {
            data.url = jsonarray.url;
        }

        RefreshData = false;
        var data = {
            FileName: jsonarray.fileName
        };
        CurrentFileName = jsonarray.fileName;
        CurrentEditor = CKEDITOR.instances[Id];
        SaveAttchmentToDB();
    });

    CKEDITOR.instances[Id].on('blur', function () {
        //if (Id != 'txteditChild') {
        //    console.log('clear interval: ' + TimerId);
        //    clearInterval(TimerId);
        //    CKEDITOR.instances[Id].updateElement();
        //    updateDesc(GetCKEditorContent(Id), false);
        //}
        //else {
        //    //update child
        //    var htmldata = GetCKEditorContent('txteditChild');
        //    updateMultiLevelChild(CurrentEditingTaskId, htmldata, false);
        //}
    });

    var editor = CKEDITOR.instances[Id];

    arrCKEditor.push(editor);


    function ckeditorKeyPress(event) {
        if (Id == 'txteditChild') {
            if (timeoutId != undefined) {
                console.log('removing timer: ' + timeoutId);
                clearTimeout(timeoutId);
            }

            timeoutId = setTimeout(function () {
                // Runs 1 second (1000 ms) after the last change    
                var desc = GetCKEditorContent('txteditChild');
                if (desc != undefined && desc.trim() != '') {
                    console.log('saving child...');
                    updateMultiLevelChild(CurrentEditingTaskId, desc, true);
                    //CKEDITOR.instances[Id].setData('');
                }
                else
                    console.log('not saving empty child');
            }, 30000);
            console.log('adding timer: ' + timeoutId);
        }
    }
}
function clearCKEditor(Id) {
    var $target = $('#' + Id);
    $target.attr('contenteditable', true);
    CKEDITOR.instances[Id].setData('');
}
function SetCKEditorForTaskPopup(Id) {

    var $target = $('#' + Id);
    // The inline editor should be enabled on an element with "contenteditable" attribute set to "true".
    // Otherwise CKEditor will start in read-only mode.
    $target.attr('contenteditable', true);

    CKEDITOR.replace(Id,
        {
            // Show toolbar on startup (optional).
            //startupFocus: true,
            height: 200,
            startupFocus: false,
            enterMode: CKEDITOR.ENTER_BR,
            on: {
                blur: function (event) {
                    event.editor.updateElement();
                },

            },
            on: {
                'key': ckeditorKeyPress
            }
        });
    CKEDITOR.instances[Id].on('fileUploadResponse', function (event) {
        if (TaskSaved == true) {
            // Prevent the default response handler.
            event.stop();
            // Ger XHR and response.
            var data = event.data,
                xhr = data.fileLoader.xhr,
                response = xhr.responseText.split('|');
            var jsonarray = JSON.parse(response[0]);

            //Attach image
            attachImagesByCKEditor(event.data.fileLoader.fileName, jsonarray.fileName);

            if (jsonarray && jsonarray.uploaded != "1") {
                // Error occurred during upload.                
                event.cancel();
            } else {
                data.url = jsonarray.url;
            }
            var data = {
                FileName: jsonarray.fileName
            };
            CurrentFileName = jsonarray.fileName;
            CurrentEditor = CKEDITOR.instances[Id];
            SaveAttchmentToDBPopup();
        }
        else {
            alert('Please save the task before adding any attachment.');
        }
    });

    var editor = CKEDITOR.instances[Id];

    arrCKEditor.push(editor);


    function ckeditorKeyPress(event) {
        if (Id == 'txtTaskDescription') {
            if (timeoutId != undefined) {
                console.log('removing timer: ' + timeoutId);
                clearTimeout(timeoutId);
            }

            timeoutId = setTimeout(function () {
                // Runs 1 second (1000 ms) after the last change    
                SaveSubTask(true);
            }, 10000);
            console.log('adding timer: ' + timeoutId);
        }
    }
}
function SetCKEditorForChildrenPopup(Id) {

    var $target = $('#' + Id);

    // The inline editor should be enabled on an element with "contenteditable" attribute set to "true".
    // Otherwise CKEditor will start in read-only mode.

    $target.attr('contenteditable', true);
    var editor = CKEDITOR.instances[Id];

    CKEDITOR.inline(Id,
        {
            // Show toolbar on startup (optional).
            //startupFocus: true,
            startupFocus: true,
            enterMode: CKEDITOR.ENTER_BR,
            on: {
                blur: function (event) {
                    event.editor.updateElement();
                    //updateDesc(GetCKEditorContent(Id));
                },
                fileUploadResponse: function (event) {

                }

            },
            on: {
                'key': ckeditorKeyPress
            }
        });

    CKEDITOR.instances[Id].on('fileUploadResponse', function (event) {
        if (TaskSaved == true) {
            // Prevent the default response handler.
            event.stop();

            // Ger XHR and response.
            var data = event.data,
                xhr = data.fileLoader.xhr,
                response = xhr.responseText.split('|');

            var jsonarray = JSON.parse(response[0]);

            //Attach image
            attachImagesByCKEditor(event.data.fileLoader.fileName, jsonarray.fileName);

            if (jsonarray && jsonarray.uploaded != "1") {
                // Error occurred during upload.                
                event.cancel();
            } else {
                data.url = jsonarray.url;
            }
            var data = {
                FileName: jsonarray.fileName
            };

            CurrentFileName = jsonarray.fileName;
            CurrentEditor = CKEDITOR.instances[Id];
            SaveAttchmentToDBPopup();
        }
        else {
            alert('Please save the task before adding any attachment.');
        }
    });
    //Save when leaves editing
    CKEDITOR.instances[Id].on('blur', function () {
        //CKEDITOR.instances[Id].updateElement();        

        //OnSaveSubTask(taskid, GetCKEditorContent('subtaskDesc' + taskid));
        //CKEDITOR.instances[Id].setData('');
    });

    //Auto Save after 30 seconds
    CKEDITOR.instances[Id].updateElement();

    arrCKEditor.push(editor);

    function ckeditorKeyPress(event) {
        if (TaskSaved) {
            switch (event.data.keyCode) {
                case 13: //enter key
                    event.cancel();
                    event.stop();
                    var desc = GetCKEditorContent('multilevelChildDesc');
                    CKEDITOR.instances[Id].setData('');
                    OnSaveSubTaskPopup(SavedTaskID, desc);
                    break;
                default:
                    if (timeoutId != undefined) {
                        console.log('removing timer: ' + timeoutId);
                        clearTimeout(timeoutId);
                    }

                    timeoutId = setTimeout(function () {
                        // Runs 1 second (1000 ms) after the last change    
                        var desc = GetCKEditorContent('multilevelChildDesc');
                        if (desc != undefined && desc.trim() != '') {
                            console.log('saving desc...');
                            CKEDITOR.instances[Id].setData('');
                            OnSaveSubTaskPopup(SavedTaskID, desc);
                        }
                        else
                            console.log('not saving empty desc');
                    }, 30000);
                    console.log('adding timer: ' + timeoutId);
                    break;
            }
        }
        else {
            alert('Please save the task before adding feedback point.');
        }
        //trigger an imitation key event here and it lets you catch the enter key
        //outside the ckeditor
    }
}

function GetCKEditorContent(Id) {

    var editor = CKEDITOR.instances[Id];

    var encodedHTMLData = editor.getData();

    //editor.updateElement();

    //CKEDITOR.instances[Id].destroy();

    return encodedHTMLData;
}

function DestroyCKEditors() {
    for (var i = 0; i < arrCKEditor.length; i++) {
        if (typeof (arrCKEditor[i]) != 'undefined') {
            arrCKEditor[i].updateElement();
            //arrCKEditor[i].removeAllListeners();
        }
    }

    setTimeout(StartDestroying, 1);

    function StartDestroying() {
        for (var i = 0; i < arrCKEditor.length; i++) {
            if (typeof (arrCKEditor[i]) != 'undefined') {
                arrCKEditor[i].destroy();
            }
            console.log(arrCKEditor[i].name + ' editor destroyed.');
        }
        arrCKEditor = new Array();
    }
}

/********************************************* Dialog (jQuery Ui Popup) ******************************************************/
function ShowPopupWithTitle(varControlID, strTitle) {
    var windowWidth = (parseInt($(window).width()) / 2) - 10;

    var dialogwidth = windowWidth + "px";

    if ($(varControlID).attr('data-width')) {
        dialogwidth = $(varControlID).attr('data-width');
    }

    var objDialog = $(varControlID).dialog({ width: dialogwidth, height: "auto" });

    // this will update title of current dialog.
    objDialog.parent().find('.ui-dialog-title').html(strTitle);

    // this will enable postback from dialog buttons.
    objDialog.parent().appendTo(jQuery("form:first"));
}

function HidePopup(varControlID) {
    $(varControlID).dialog("close");
}

/********************************************* Dropzone (File upload on drag - drop) ******************************************************/
var arrDropzone = new Array();

function GetWorkFileDropzone(strDropzoneSelector, strPreviewSelector, strHiddenFieldIdSelector, strButtonIdSelector, isHTMLbutton) {
    
    var strAcceptedFiles = '';
    if (typeof (enabledisable) == 'function')
        enabledisable(false);


    if ($(strDropzoneSelector).attr("data-accepted-files")) {
        strAcceptedFiles = $(strDropzoneSelector).attr("data-accepted-files");
    }

    var strUrl = 'taskattachmentupload.aspx';
    switch ($(strDropzoneSelector).attr("data-upload-path-code")) {
        case '1':
            strUrl = 'userbulkupload.aspx';
            break;
        default:
            strUrl = 'taskattachmentupload.aspx';
            break;
    }

    var objDropzone = new Dropzone(strDropzoneSelector,
        {
            maxFiles: 5,
            url: strUrl,
            thumbnailWidth: 90,
            thumbnailHeight: 90,
            acceptedFiles: strAcceptedFiles,
            previewsContainer: strPreviewSelector,
            init: function () {
                this.on("maxfilesexceeded", function (data) {
                    //var res = eval('(' + data.xhr.responseText + ')');
                    alert('you are reached maximum attachment upload limit.');
                });
                this.on("drop", function (event) {
                    alert('Put Validation here old');
                });
                // when file is uploaded successfully store its corresponding server side file name to preview element to remove later from server.
                this.on("success", function (file, response) {
                    
                    var filename = response.split("^");
                    $(file.previewTemplate).append('<span class="server_file">' + filename[0] + '</span>');
                    AddAttachmenttoViewState(filename[0] + '@' + file.name, strHiddenFieldIdSelector);
                    if (typeof (strButtonIdSelector) != 'undefined' && strButtonIdSelector.length > 0) {
                        // saves attachment. 
                        if (typeof (isHTMLbutton) != 'undefined' && isHTMLbutton == true) {
                            if (this.getUploadingFiles().length === 0 && this.getQueuedFiles().length === 0) {
                                $(strButtonIdSelector).trigger('click');
                            }
                        }
                        else {
                            $(strButtonIdSelector).click();
                        }

                        //this.removeFile(file);
                    }
                    if (typeof (enabledisable) == 'function')
                        enabledisable(true);
                });

                //when file is removed from dropzone element, remove its corresponding server side file.
                //this.on("removedfile", function (file) {
                //    var server_file = $(file.previewTemplate).children('.server_file').text();
                //    RemoveTaskAttachmentFromServer(server_file);
                //});

                // When is added to dropzone element, add its remove link.
                //this.on("addedfile", function (file) {

                //    // Create the remove button
                //    var removeButton = Dropzone.createElement("<a><small>Remove file</smalll></a>");

                //    // Capture the Dropzone instance as closure.
                //    var _this = this;

                //    // Listen to the click event
                //    removeButton.addEventListener("click", function (e) {
                //        // Make sure the button click doesn't submit the form:
                //        e.preventDefault();
                //        e.stopPropagation();
                //        // Remove the file preview.
                //        _this.removeFile(file);
                //    });

                //    // Add the button to the file preview element.
                //    file.previewElement.appendChild(removeButton);
                //});
            }

        });

    arrDropzone.push(objDropzone);

    return objDropzone;
}

function GetWorkFileDropzoneWithFolderValidation(strDropzoneSelector, strPreviewSelector, strHiddenFieldIdSelector, strButtonIdSelector, isHTMLbutton,IsmultiDesg) {

    var strAcceptedFiles = '';
    if (typeof (enabledisable) == 'function')
        enabledisable(false);


    if ($(strDropzoneSelector).attr("data-accepted-files")) {
        strAcceptedFiles = $(strDropzoneSelector).attr("data-accepted-files");
    }
    var dateObj = new Date();
    var month = dateObj.getMonth();
    var day = dateObj.getDate();
    var second = dateObj.getSeconds();

    var newdate = month.toString() + day.toString() + second.toString();
    var mergedfilename = "";
    var strUrl = 'chunkuploadhandler.aspx';
    var foldername = "";
    var objDropzone = new Dropzone(strDropzoneSelector,
        {
            maxFiles: 1,
            url: strUrl + "?foldername=" + newdate,
            thumbnailWidth: 90,
            thumbnailHeight: 90,
            acceptedFiles: strAcceptedFiles,
            previewsContainer: strPreviewSelector,
            maxFilesize: 20000,   // max individual file size 1024 MB
            chunking: true,      // enable chunking
            chunkSize: 1000000,  // chunk size 1,000,000 bytes (~1MB)
            retryChunks: true,   // retry chunks on failure
            retryChunksLimit: 3, // retry maximum of 3 times (default is 3)
            chunksUploaded: function (file, done) {

                $.ajax({
                    url: "chunkuploadhandler.aspx?completed=true&foldername=" + newdate+"&filename="+file.name,
                    type: 'POST',
                    success: function (data, response) {
                        mergedfilename = data;
                        done();
                    },
                    error: function (request, error) {
                        
                    }
                });
                
            },
            init: function () {
                this.on("maxfilesexceeded", function (data) {
                    //var res = eval('(' + data.xhr.responseText + ')');
                    alert('you are reached maximum attachment upload limit.');
                });
                var isvalid = true;
                this.on("drop", function (event) {
                    isvalid = true;
                    if (IsmultiDesg) {
                        foldername = $('#text').val();
                        if (foldername === undefined || foldername == "") {
                            isvalid = false;
                            alert("Enter folder name");
                        }
                    }
                    else {
                        if ($(ddlFolder).val() == null) {
                            isvalid = false;
                            alert('Select Folders');
                        }
                    }
                    if ($(ddlDesignation).val() == null || $(ddlDesignation).val() == "") {
                        isvalid = false;
                        alert("Select Designations");
                    }
                    if (parseInt($(ddlLocation).val()) == 0) {
                        isvalid = false;
                        alert('Select Location');
                    }

                    if (isvalid) {
                        this.processQueue();
                    }
                    else {
                        this.removeFile(event);
                        event.preventDefault();
                        event.stopPropagation();
                    }
                });
                // when file is uploaded successfully store its corresponding server side file name to preview element to remove later from server.
                this.on("success", function (file, response) {
                        if (response == "")
                            response = mergedfilename;
                        var filename = response.split("^");
                        $(file.previewTemplate).append('<span class="server_file">' + filename[0] + '</span>');
                        AddAttachmenttoViewState(filename[0] + '@' + file.name, strHiddenFieldIdSelector);
                        if (typeof (strButtonIdSelector) != 'undefined' && strButtonIdSelector.length > 0) {
                            // saves attachment. 
                            if (typeof (isHTMLbutton) != 'undefined' && isHTMLbutton == true) {
                                if (this.getUploadingFiles().length === 0 && this.getQueuedFiles().length === 0) {
                                    $(strButtonIdSelector).trigger('click');
                                }
                            }
                            else {
                                $(strButtonIdSelector).click();
                            }

                            //this.removeFile(file);
                        }
                        if (typeof (enabledisable) == 'function')
                            enabledisable(true);
                    });
                //when file is removed from dropzone element, remove its corresponding server side file.
                this.on("removedfile", function (file) {
                    var server_file = $(file.previewTemplate).children('.server_file').text();
                    //RemoveTaskAttachmentFromServer(server_file);
                });
                 //When is added to dropzone element, add its remove link.
                this.on("addedfile", function (file) {
                    
                    // Create the remove button
                    var removeButton = Dropzone.createElement("<a><small>Remove file</smalll></a>");

                    // Capture the Dropzone instance as closure.
                    var _this = this;

                    // Listen to the click event
                    removeButton.addEventListener("click", function (e) {
                        // Make sure the button click doesn't submit the form:
                        e.preventDefault();
                        e.stopPropagation();
                        // Remove the file preview.
                        _this.removeFile(file);
                    });
                    isvalid = true;
                    if (IsmultiDesg) {
                        foldername = $('#text').val();
                        if (foldername === undefined || foldername == "") {
                            isvalid = false;
                            alert("Enter folder name");
                        }
                    }
                    else {
                        if ($(ddlFolder).val() == null) {
                            isvalid = false;
                            alert('Select Folders');
                        }
                    }
                    
                    if ($(ddlDesignation).val() == null || $(ddlDesignation).val() == ""){
                        isvalid = false;
                        alert("Select Designations");
                    }
                    if (parseInt($(ddlLocation).val()) == 0) {
                        isvalid = false;
                        alert('Select Location');
                    }
                    
                    if (isvalid) {
                        _this.processQueue();
                    }
                    else {
                        _this.removeFile(file);
                    }
                       
                });
            }

        });

    arrDropzone.push(objDropzone);

    return objDropzone;
}

function DestroyDropzones() {
    for (var i = 0; i < arrDropzone.length; i++) {
        arrDropzone[i].destroy();
    }
    arrDropzone = new Array();
}

/********************************************* Image Gallery ******************************************************/
var subtaskSliders;

function LoadImageGallery(strSelector) {

    if (typeof ($.fn.lightSlider) == 'function') {
        subtaskSliders = $(strSelector).lightSlider({
            gallery: true,
            item: 1,
            thumbItem: 6,
            slideMargin: 0,
            speed: 500,
            currentPagerPosition: 'left',
            pauseOnHover: true,
            auto: true,
            loop: true,
            onSliderLoad: function () {
                $(strSelector).removeClass('cS-hidden');
            }
        });
    }
}


function DestroyGallery() {
    if (subtaskSliders && typeof (subtaskSliders.destroy) == 'function') {
        subtaskSliders.destroy();
    }
}
/********************************************* Chosen Dropdown Functions ******************************************************/
function ChosenDropDown(options) {
    var _options = options || {};
    $('.chosen-select').chosen(_options);
}

/********************************************* jQuery Ajax Functions ******************************************************/
function CallJGWebService(strWebMethod, objPostDataJSON, OnSuccessCallBack, OnErrorCallBack) {
    ShowAjaxLoader();
    $.ajax
        (
        {
            url: '../WebServices/JGWebService.asmx/' + strWebMethod,
            contentType: 'application/json; charset=utf-8;',
            type: 'POST',
            dataType: 'json',
            data: JSON.stringify(objPostDataJSON),
            asynch: false,
            success: function (data) {
                HideAjaxLoader();
                if (typeof (OnSuccessCallBack) === 'function') {
                    OnSuccessCallBack(data);
                }
            },
            error: function (a, b, c) {
                HideAjaxLoader();
                console.log('jQuery ajax error.');
                console.log(a);
                console.log(b);
                console.log(c);
                if (typeof (OnErrorCallBack) === 'function') {
                    OnErrorCallBack(a, b, c);
                }
            }
        }
        );
}

/********************************************* General Functions ******************************************************/
function htmlEncode(value) {
    //create a in-memory div, set it's inner text(which jQuery automatically encodes)
    //then grab the encoded contents back out.  The div never exists on the page.
    return $('<div/>').text(value).html();
}

function htmlDecode(value) {
    return $('<div/>').html(value).text();
}

function ShowAjaxLoader() {
    $('.loading').show();
}

function HideAjaxLoader() {
    $('.loading').hide();
}

function AddAttachmenttoViewState(serverfilename, hdnControlID) {

    var attachments;

    if ($(hdnControlID).val()) {
        attachments = $(hdnControlID).val() + serverfilename + "^";
    }
    else {
        attachments = serverfilename + "^";
    }

    $(hdnControlID).val(attachments);
}

function copyToClipboard(strDataToCopy) {
    window.prompt("Copy to clipboard: Ctrl+C, Enter", strDataToCopy);

    //var $temp = $('<button/>', {
    //    id: 'btnClipBoardContext'
    //});

    //$temp.attr("data-clipboard-text",strDataToCopy);
    //$temp.attr("class", "contextcopy");

    //$("body").append($temp);

    //var clipboard = new Clipboard('.contextcopy');

    //clipboard.on('success', function (e) {       
    //    console.info('Text:', e.text);
    //   e.clearSelection();
    //});


    // $temp.remove();

    //clipboard.destroy();
}

// gets value of a parameter from query string.
function GetQueryStringParameterValue(param) {
    var url = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
    for (var i = 0; i < url.length; i++) {
        var urlparam = url[i].split('=');
        if (urlparam[0] == param) {
            return urlparam[1];
        }
    }
}

//common code check query string parameter, if already exists then replace value else add that parameter. 
function updateQueryStringParameter(uri, key, value, Mainkey, MainValue) {
    var re = new RegExp("([?&])" + key + "=.*?(&|$)", "i");
    var separator = uri.indexOf('?') !== -1 ? "&" : "?";

    if (uri.match(re)) {
        return uri.replace(re, '$1' + key + "=" + value + '$2');
    }
    else {
        uri = uri.replace("ITDashboard", "TaskGenerator");
        return uri + separator + Mainkey + "=" + MainValue + '&' + key + "=" + value;
    }
}

function updateQueryStringParameterTP(uri, key, value) {
    var re = new RegExp("([?&])" + key + "=.*?(&|$)", "i");
    var separator = uri.indexOf('?') !== -1 ? "&" : "?";
    if (uri.match(re)) {
        return uri.replace(re, '$1' + key + "=" + value + '$2');
    }
    else {
        return uri + separator + key + "=" + value;
    }
}

function IsNumeric(e, blWholeNumber) {
    var keyCode = e.which ? e.which : e.keyCode;

    if (keyCode >= 48 && keyCode <= 57) {
        return true; // 0-9    
    }
    else if (keyCode == 9) {
        return true; // tab 
    }
    else if (keyCode == 37 || keyCode == 38) {
        return true; // left - right arrow
    }
    else if (keyCode == 8 || keyCode == 46) {
        return true; // back space - delete
    }
    else if (!blWholeNumber && keyCode == 190) {
        if (this.value.indexOf('.') == -1) {
            return true; // period
        }
    }
    return false;
}

function ScrollTo(target) {
    //console.log(target);
    //  console.log('Scroll to called for ' + target.Id);
    if (target.length > 0) {
        var offset = target.offset();
        if (typeof (offset) != 'undefined' && offset != null) {
            $('html, body').animate({
                scrollTop: offset.top
            }, 1000);
        }
    }
}

function ScrollToChild(target, childId, parentId) {
    //console.log(target);
    //  console.log('Scroll to called for ' + target.Id);
    if (target.length > 0) {
        var myElement = document.getElementById('ChildEdit' + childId);
        var topPos = myElement.offsetTop;
        document.getElementById('TaskContainer' + parentId).scrollTop = topPos - 35;

        var offset = target.offset();
        if (typeof (offset) != 'undefined' && offset != null) {
            $('html, body').animate({
                scrollTop: offset.top - 20
            }, 1000);
        }
    }
}

function tConvert(time) {
    // Check correct time format and split into components
    time = time.toString().match(/^([01]\d|2[0-3])(:)([0-5]\d)(:[0-5]\d)?$/) || [time];

    if (time.length > 1) { // If time format correct
        time = time.slice(1);  // Remove full string match value
        time[5] = +time[0] < 12 ? 'AM' : 'PM'; // Set AM/PM
        time[0] = +time[0] % 12 || 12; // Adjust hours
    }
    return time.join(''); // return adjusted time or original string
}

function hidePlaceholder(sender) {
    $(sender).prev().hide(100);
}
function showPlaceHolder(sender) {
    if ($(sender).val().length == 0) {
        $(sender).prev().show(100);
    } else {
        $(sender).prev().hide(100);
    }
}