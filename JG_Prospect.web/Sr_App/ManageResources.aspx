<%@ Page Title="" Language="C#" MasterPageFile="~/Sr_App/SR_app.Master" EnableEventValidation="false" AutoEventWireup="true" CodeBehind="ManageResources.aspx.cs" Inherits="JG_Prospect.Sr_App.ManageResources" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="shortcut icon" href="../favicon.ico">
    <link href="../css/style.css" rel="stylesheet" />
    <link href="../css/dropzone/css/basic.css" rel="stylesheet" />
    <link href="../css/dropzone/css/dropzone.css" rel="stylesheet" />
    <link href="../css/chosen.css" rel="stylesheet" />
    <script type="text/javascript" src="../js/dropzone.js"></script>
    <script src="../js/angular/scripts/jgapp.js"></script>
    <script src="../js/angular/scripts/ManageResources.js"></script>
    <script src="../js/Xml2Json.js"></script>
    <style>
        .right_panel {
            background-color: white;
        }
        .dropdown {
            z-index: 999;
        }

       

        .table-resources {
            border-bottom: 3px solid #ccc;
        }

        .div-header {
            padding: 10px;
            background-color: #ccc;
            margin-top: 15px;
            border-radius: 10px
        }

        .table-col {
            width: 100%;
        }

        
        .table-col td {
            width: 33.33%;
        }

        select option:empty {
            display: none
        }

        .required {
            border: 1px solid red;
        }
    </style>    
    <%--Add Head area here--%>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="right_panel" data-ng-controller="ManageResourceController">
        <h1><b>Resources & Training</b></h1>

        <div class="div-table-col" style="width: 100%">
            <form name="resource">
                <table class="table-col table-resources" style="padding-bottom: 25px;">
                    <tr>
                        <td style="width: 15%;">
                            <!-- <select id="ddlDesignations" chosen multiple class="chosen-dropdown" ng-model="resource.designations" data-ng-change="getFolders()" ng-options="item as item.DesignationName for item in Designations track by item.ID" ng-required="true">
                                <%--<option value="0" selected="selected">Designation</option>
                            <option data-ng-repeat="d in Designations" value="{{d.ID}}">{{d.DesignationName}}</option>--%>
                            </select> !-->
                            <asp:ListBox data-placeholder="Select Designation" CssClass="chosen-dropdown" SelectionMode="Multiple" ID="ddlDesignations" runat="server"></asp:ListBox>
                        </td>
                        <td>
                            <select class="wrapper-dropdown-5 folders" ng-model="resource.folders" id="ddlFolder">
                                <option value="0" selected disabled>Folders</option>
                                <option data-ng-repeat="t in Folders" value="{{t.ID}}">{{t.Name}}</option>
                            </select>
                        </td>
                        <td rowspan="3" style="vertical-align: top;">
                            <h3>Attach File(s)</h3>
                            <div style="float: left; margin: 10px 0;">
                                <div id="divBulkUploadFile" class="dropzone work-file" data-hidden="<%=hdnBulkUploadFile.ClientID%>"
                                    data-accepted-files=".zip,.rar,.mp3,.wav,.m4a,.avi,.mov,.mpg,.mp4,.pdf,.xlsx,.xls,.pptx,.ppt,.txt,.rtf,.docx,.doc,.png,.jpg,.jpeg,.bmp,.gif" data-upload-path-code="1">
                                    <div class="fallback">
                                        <input name="WorkFile" id="WorkFile" type="file" />
                                        <input type="submit" value="UploadWorkFile" />
                                    </div>
                                </div>
                                <div id="divBulkUploadFilePreview" class="dropzone-previews work-file-previews">
                                </div>
                            </div>
                            <div class="btn-large">
                                <a class="hide" id="btnSaveMultipleDesignations" href="javascript:void(0);"></a>
                                <a class="hide" id="btnSaveSingleResource" href="javascript:void(0);" ></a>
                                <%--<button type="button" value="Reset" class="resetResource" ng-click="ResetData($event)">Reset</button>--%>
                            </div>
                            <div class="hide">
                                <input id="hdnBulkUploadFile" class="fileName" runat="server" type="hidden" ng-model="resource.fileName" />
                                <asp:Button ID="btnUpload" runat="server" Text="Upload" OnClientClick="return ValidateFile()" />

                                <label>
                                    Upload Prospects using xlsx file:
                                <asp:FileUpload ID="BulkProspectUploader" runat="server" /></label>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" ControlToValidate="BulkProspectUploader" runat="server" ErrorMessage="Select file to import data." ValidationGroup="BulkImport"></asp:RequiredFieldValidator>
                            </div>

                            <br />
                        </td>
                    </tr>
                    <tr>
                        <td style="vertical-align: top;">
                            <select class="wrapper-dropdown-5 locations" ng-model="resource.locations" id="ddlLocation">
                                <option value="0" selected="selected">Location</option>
                                <option data-ng-repeat="d in Locations" value="{{d.Id}}">{{d.Value}}</option>
                            </select>
                        </td>
                        <td style="vertical-align: top;">
                            <input type="text" class="txt" style="width: 70%;" placeholder="FolderName to store files" id="text" ng-model="resource.folder" maxlength="20" />
                            <div  id="divfolderCtl">
                                <button class="btn-jg" ng-click="SaveFolders($event)">Create</button>
                                <button class="btn-jg" ng-click="DeleteFolders($event)">Delete</button>
                            </div>
                        </td>

                    </tr>


                </table>
            </form>
            <div class="div-header">
                <img src="..\img\JG-Logo.gif" style="float: left;">
                <h2 class="itdashtitle" style="margin: 31px 0px 28px 93px;">Resources & Training</h2>
            </div>
            <div class="tab-wrap">
                <input type="radio" id="tab1" name="tabGroup1" class="tab" id-val="1" checked>
                <label for="tab1" class="tab-header" ng-click="GetFiles(1);">Success Popup</label>

                <input type="radio" id="tab2" name="tabGroup1" class="tab" id-val="2">
                <label for="tab2" class="tab-header" ng-click="GetFiles(2);">Interview Date Popup</label>

                <input type="radio" id="tab3" name="tabGroup1" class="tab" id-val="3">
                <label for="tab3" class="tab-header" ng-click="GetFiles(3);">Active/Offer Made Staff</label>

                <div class="tab__content">
                    <ul class="tree-parent">
                        <li data-ng-repeat="module in Categories" class="tree-parent">
                            <span class="tree-desg">{{module.Title}}</span>
                            <ul class="tree-child">
                                <li data-ng-repeat="subModule in module.Categories">
                                    <img src="../img/minus.png" class="icons tree-minus" />
                                    <img src="../img/plus.png" class="icons tree-plus" style="display: none;" />
                                    <img src="../img/folder.png" width="16" height="16" class="icons" />
                                    {{subModule.Title}} <img src="../img/up.png"  class="icons" ng-click="UpdateFolderOrder(subModule.Id,'up',module.Categories)"/> &nbsp;&nbsp;&nbsp;&nbsp;<img src="../img/down.png"  class="icons" ng-click="UpdateFolderOrder(subModule.Id,'down',module.Categories)"/>
                                 <ul class="tree-child-files">
                                     <li data-ng-repeat="subModule1 in subModule.Categories">
                                         <img src="../img/delete-black.png" class="icons" ng-click="DeleteFiles(subModule1.ID,subModule.DesignationId,subModule.Id,1)" />
                                         {{subModule1.Title}}
                                         <img src="../img/video-icon1.png" class="icons icon-right icon-video" ng-if="subModule1.Type == 1" />
                                         <img src="../img/image-icon1.png" class="icons icon-right icon-image" ng-if="subModule1.Type == 2" />
                                         <img src="../img/file.png" class="icons icon-right" ng-if="subModule1.Type == 3" />
                                         <img src="../img/up.png"  class="icons" ng-click="UpdateFileOrder(subModule1.ID,'up',subModule.Categories)"/> &nbsp;&nbsp;&nbsp;&nbsp;<img src="../img/down.png"  class="icons" ng-click="UpdateFileOrder(subModule1.ID,'down',subModule.Categories)"/>
                                     </li>
                                 </ul>
                                </li>
                            </ul>
                        </li>
                    </ul>
                </div>

                <div class="tab__content">
                    <ul class="tree-parent">
                        <li data-ng-repeat="module in Categories" class="tree-parent">
                            <span class="tree-desg">{{module.Title}}</span>
                            <ul class="tree-child">
                                <li data-ng-repeat="subModule in module.Categories">
                                    <img src="../img/minus.png" class="icons tree-minus" />
                                    <img src="../img/plus.png" class="icons tree-plus" style="display: none;" />
                                    <img src="../img/folder.png" width="16" height="16" class="icons" />
                                    {{subModule.Title}} <img src="../img/up.png"  class="icons" ng-click="UpdateFolderOrder(subModule.Id,'up',module.Categories)"/> &nbsp;&nbsp;&nbsp;&nbsp;<img src="../img/down.png"  class="icons" ng-click="UpdateFolderOrder(subModule.Id,'down',module.Categories)"/>
                                 <ul class="tree-child-files">
                                     <li data-ng-repeat="subModule1 in subModule.Categories">
                                         <img src="../img/delete-black.png" class="icons" ng-click="DeleteFiles(subModule1.ID,subModule.DesignationId,subModule.Id,1)" />
                                         {{subModule1.Title}} 
                                         <img src="../img/video-icon1.png" class="icons icon-right icon-video" ng-if="subModule1.Type == 1" />
                                         <img src="../img/image-icon1.png" class="icons icon-right icon-image" ng-if="subModule1.Type == 2" />
                                         <img src="../img/file.png" class="icons icon-right" ng-if="subModule1.Type == 3" />
                                         <img src="../img/up.png"  class="icons" ng-click="UpdateFileOrder(subModule1.ID,'up',subModule.Categories)"/> &nbsp;&nbsp;&nbsp;&nbsp;<img src="../img/down.png"  class="icons" ng-click="UpdateFileOrder(subModule1.ID,'down',subModule.Categories)"/>
                                     </li>
                                 </ul>
                                </li>
                            </ul>

                        </li>
                    </ul>
                </div>

                <div class="tab__content">
                    <ul class="tree-parent">
                        <li data-ng-repeat="module in Categories" class="tree-parent">
                            <span class="tree-desg">{{module.Title}}</span>
                            <ul class="tree-child">
                                <li data-ng-repeat="subModule in module.Categories">
                                    <img src="../img/minus.png" class="icons tree-minus" />
                                    <img src="../img/plus.png" class="icons tree-plus" style="display: none;" />
                                    <img src="../img/folder.png" width="16" height="16" class="icons" />
                                    {{subModule.Title}} <img src="../img/up.png"  class="icons" ng-click="UpdateFolderOrder(subModule.Id,'up',module.Categories)"/> &nbsp;&nbsp;&nbsp;&nbsp;<img src="../img/down.png"  class="icons" ng-click="UpdateFolderOrder(subModule.Id,'down',module.Categories)"/>
                                 <ul class="tree-child-files">
                                     <li data-ng-repeat="subModule1 in subModule.Categories">
                                         <img src="../img/delete-black.png" class="icons" ng-click="DeleteFiles(subModule1.ID,subModule.DesignationId,subModule.Id,1)" />
                                         {{subModule1.Title}}
                                         <img src="../img/video-icon1.png" class="icons icon-right icon-video" ng-if="subModule1.Type == 1" />
                                         <img src="../img/image-icon1.png" class="icons icon-right icon-image" ng-if="subModule1.Type == 2" />
                                         <img src="../img/file.png" class="icons icon-right" ng-if="subModule1.Type == 3" />
                                         <img src="../img/up.png"  class="icons" ng-click="UpdateFileOrder(subModule1.ID,'up',subModule.Categories)"/> &nbsp;&nbsp;&nbsp;&nbsp;<img src="../img/down.png"  class="icons" ng-click="UpdateFileOrder(subModule1.ID,'down',subModule.Categories)"/>
                                     </li>
                                 </ul>
                                </li>
                            </ul>

                        </li>
                    </ul>
                </div>

            </div>
        </div>


    </div>
    <script type="text/javascript" src="../js/chosen.jquery.js"></script>
    <script type="text/javascript" src="../js/angular/scripts/angular-chosen.min.js"></script>
    <script>
        Dropzone.autoDiscover = false;
        $(function () {            
            MakeDropdownChosen();
            BindEvents();
            applydropzone(btnSaveSingleResources);
        });
        var objworkfiledropzone;

        function BindEvents() {
            $(btnSaveResources).click(function () {
                ManageResourceScope.SaveMultipleDesignationFiles();
            });

            $(btnSaveSingleResources).click(function () {
                ManageResourceScope.SaveData();
            });
        }
        function applydropzone(btnClick) {
            ////user's drag and drop file attachment related code
            var ddlDesignation = '#<%=ddlDesignations.ClientID%>';
            
            var selectedValues = $(ddlDesignation).val();
            var IsmultiDesg = false;
            // if multiple value is selected than hide folder dropdown and allow only creation for multiple designation folder creation.
            if (selectedValues && selectedValues.length > 1) {
                IsmultiDesg = true;
            }
            //remove already attached dropzone.
            if (objworkfiledropzone) {
                objworkfiledropzone.destroy();
                objworkfiledropzone = null;
            }
            
            objworkfiledropzone = GetWorkFileDropzoneWithFolderValidation("div#divBulkUploadFile", 'div#divBulkUploadFilePreview', '#<%= hdnBulkUploadFile.ClientID %>', btnClick, true , IsmultiDesg);
        }


        function ValidateFile() {
            var file = document.getElementById("<%=BulkProspectUploader.ClientID%>");
            var path = file.value;
            var ext = path.substring(path.lastIndexOf(".") + 1, path.length).toLowerCase();
            var isValidFile = false;

            for (var i = 0; i < validFilesTypes.length; i++) {
                if (ext == validFilesTypes[i]) {
                    isValidFile = true;
                    break;
                }
            }
            if (!isValidFile) {
                alert('Select file of type csv or xlsx ');
                //label.style.color = "red";
                //label.innerHTML = "Invalid File. Please upload a File with" +

                // " extension:\n\n" + validFilesTypes.join(", ");

            }
            return isValidFile;
        }



    </script>
    

    <script type="text/javascript">
        var ddlDesignation = '#<%=ddlDesignations.ClientID%>';
        var txtFolder = '#text';
        var ddlLocation = '#ddlLocation';
        var ddlFolder = '#ddlFolder';
        var hdnBulkUploadFiles = '#<%=hdnBulkUploadFile.ClientID%>';
        var btnSaveResources = '#btnSaveMultipleDesignations';
        var btnSaveSingleResources = '#btnSaveSingleResource';
        
        $('#text').keypress(function (e) {
            var regex = new RegExp("^[a-zA-Z0-9-]+$");
            var str = String.fromCharCode(!e.charCode ? e.which : e.charCode);
            if (regex.test(str)) {
                return true;
            }
            e.preventDefault();
            return false;
        });

        $("body").off("click", ".tree-plus").on("click", ".tree-plus", function () {
            $(this).parent('li').find('.tree-child-files').fadeIn(100);
            $(this).hide();
            $(this).siblings('.tree-minus').show();
        });

        $("body").off("click", ".tree-minus").on("click", ".tree-minus", function () {
            $(this).parent('li').find('.tree-child-files').fadeOut(100);
            $(this).hide();
            $(this).siblings('.tree-plus').show();
        });

        
        function MakeDropdownChosen() {
            $(ddlDesignation).chosen().change(function () {
                var selectedValues = $(this).val();
                // if multiple value is selected than hide folder dropdown and allow only creation for multiple designation folder creation.
                if (selectedValues && selectedValues.length > 1) {
                    //1. Hide folder dropdown and delete button.
                    showhideFolderControls(true);
                    
                    //2. Once user drop file upload it for all designations.

                    // Apply dropdoze with multiple designation file save post upload.
                    applydropzone(btnSaveResources);
                }
                else if (selectedValues && selectedValues.length == 1) {
                    // Load already created folders for that designations.
                    
                    ManageResourceScope.getFolders();
                    // Apply dropdoze with multiple designation file save post upload.
                    applydropzone(btnSaveSingleResources);

                    showhideFolderControls(false);                    
                }
                else {
                    //Unhide select folder dropdown and create delete,button.
                    showhideFolderControls(false);                    
                }
            });

            $(ddlLocation).change(function () {
                ManageResourceScope.getFolders();
            });
            //$('#ddlDesignations').trigger("chosen:updated");
        }
        //function DesignatonsUpdated() {
        //        $('#ddlDesignations').trigger("chosen:updated");
        //}

        function showhideFolderControls(flag) {
            if (flag == true) {
                $('#ddlFolder').hide();
                $('#divfolderCtl').hide();
            }
            else {
                $('#ddlFolder').show();
                $('#divfolderCtl').show();
            }
        }
    </script>
    <%--Add body area here. Don't include body tag--%>
</asp:Content>

