<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="screening-popup.aspx.cs" Inherits="JG_Prospect.screening_popup" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

    <link href="css/popup.css" rel="stylesheet" />
    <link rel="stylesheet" href="css/jquery-ui.css" />
    <link href="css/intTel/intlTelInput.css" rel="stylesheet" />
</head>
<body>
    
    <form id="formScreening" runat="server">
        <asp:ScriptManager ID="scmPopup" runat="server" ScriptMode="Auto">
        </asp:ScriptManager>
        <div id="profileMaster">
            <div class="profiletitle">
                <h2>Complete your profile</h2>
                <p><span class="errortext">*</span><label>All fields are mandatory</label></p>
            </div>

            <div class="clear">
            </div>

            <asp:UpdatePanel ID="upnlProfile" runat="server">
                <ContentTemplate>
                    <div class="profilediv">
                        <table class="profiletable">

                            <tr>
                                <td>Position applying for: <span class="errortext">*</span><br />
                                    <asp:DropDownList ID="ddlPositionAppliedFor" CssClass="emp-ddl" TabIndex="1" AppendDataBoundItems="true" runat="server" ClientIDMode="Static" AutoPostBack="false">
                                    </asp:DropDownList><br />
                                    <asp:RequiredFieldValidator ID="rfvPositionApplied" runat="server" ControlToValidate="ddlPositionAppliedFor"
                                        ValidationGroup="vgUpProf" CssClass="errortext" Display="Dynamic" ErrorMessage="Required"
                                        InitialValue="0"></asp:RequiredFieldValidator>
                                </td>
                                <td>Source: <span class="errortext">*</span><br />
                                    <asp:DropDownList ID="ddlSource" CssClass="emp-ddl" runat="server" AutoPostBack="false" TabIndex="2">
                                    </asp:DropDownList><br />
                                    <asp:RequiredFieldValidator ID="rfvSource" runat="server" ControlToValidate="ddlSource"
                                        ValidationGroup="vgUpProf" CssClass="errortext" Display="Dynamic" ErrorMessage="Required"
                                        InitialValue="0"></asp:RequiredFieldValidator>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="parallerinput-left">
                                        <asp:TextBox ID="txtfirstname" CssClass="emp-txtbox" Placeholder="First Name*" runat="server" MaxLength="40" autocomplete="off" EnableViewState="false" AutoCompleteType="None" TabIndex="3"></asp:TextBox><br />
                                        <asp:RequiredFieldValidator ID="rfvFirstName" runat="server" ControlToValidate="txtfirstname"
                                            ValidationGroup="vgUpProf" CssClass="errortext" Display="Dynamic" ErrorMessage="Required"></asp:RequiredFieldValidator>
                                    </div>
                                    <div class="parallerinput-right">
                                        <asp:TextBox ID="txtMiddleInitial" Placeholder="I*" runat="server" CssClass="emp-txtbox emp-txtboxsmall" MaxLength="3" TabIndex="4"></asp:TextBox>
                                        <br />
                                        <asp:RequiredFieldValidator ID="rfvMIName" runat="server" ControlToValidate="txtMiddleInitial"
                                            ValidationGroup="vgUpProf" CssClass="errortext" Display="Dynamic" ErrorMessage="Required"></asp:RequiredFieldValidator>
                                    </div>

                                    <br />
                                </td>
                                <td>
                                    <asp:TextBox ID="txtlastname" CssClass="emp-txtbox" Placeholder="Last Name*" runat="server" MaxLength="40" autocomplete="off"
                                        TabIndex="5"></asp:TextBox>
                                    <br />
                                    <asp:RequiredFieldValidator ID="rfvLastName" runat="server" ControlToValidate="txtlastname"
                                        ValidationGroup="vgUpProf" CssClass="errortext" Display="Dynamic" ErrorMessage="Required"></asp:RequiredFieldValidator>
                                </td>
                            </tr>
                            <tr>
                                <td></td>
                                <td>
                                    <asp:DropDownList ID="ddlCountry" CssClass="emp-ddl" runat="server" TabIndex="6"></asp:DropDownList><br />
                                    <asp:RequiredFieldValidator ID="rfvCountry" runat="server" ControlToValidate="ddlCountry"
                                        ValidationGroup="vgUpProf" CssClass="errortext" Display="Dynamic" ErrorMessage="Required"
                                        InitialValue="0"></asp:RequiredFieldValidator>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:TextBox ID="txtZip" CssClass="emp-txtbox" Placeholder="Zip*" runat="server" MaxLength="10" TabIndex="7"></asp:TextBox><br />
                                    <asp:RequiredFieldValidator ID="rfvZip" runat="server" ControlToValidate="txtZip"
                                        ValidationGroup="vgUpProf" CssClass="errortext" Display="Dynamic" ErrorMessage="Required"></asp:RequiredFieldValidator>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtCity" CssClass="emp-txtbox" Placeholder="City*" runat="server" MaxLength="50" TabIndex="8"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvCity" runat="server" ControlToValidate="txtCity"
                                        ValidationGroup="vgUpProf" CssClass="errortext" Display="Dynamic" ErrorMessage="Required"></asp:RequiredFieldValidator>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:TextBox ID="txtState" CssClass="emp-txtbox" Placeholder="State*" runat="server" MaxLength="50" TabIndex="9"></asp:TextBox>
                                    <br />
                                    <asp:RequiredFieldValidator ID="rfvState" runat="server" ControlToValidate="txtState"
                                        ValidationGroup="vgUpProf" CssClass="errortext" Display="Dynamic" ErrorMessage="Required"></asp:RequiredFieldValidator>
                                </td>
                                <td></td>
                            </tr>
                            <tr>
                                <td>
                                    <br />
                                    <asp:TextBox ID="txtAddress" CssClass="emp-mltxtbox" Placeholder="Address*" runat="server" TextMode="MultiLine" TabIndex="10"></asp:TextBox>
                                    <br />
                                    <asp:RequiredFieldValidator ID="rfvAddress" runat="server" ControlToValidate="txtAddress"
                                        ValidationGroup="vgUpProf" CssClass="errortext" Display="Dynamic" ErrorMessage="Required"></asp:RequiredFieldValidator>
                                </td>
                                <td>Reason for leaving your current job(if applicable) : <span class="errortext">*</span><br />
                                    <asp:TextBox ID="txtReasontoLeave" CssClass="emp-mltxtbox" runat="server" MaxLength="50" TextMode="MultiLine" TabIndex="11"></asp:TextBox><br />
                                    <asp:RequiredFieldValidator ID="rfvReasontoLeave" runat="server" ControlToValidate="txtReasontoLeave"
                                        ValidationGroup="vgUpProf" CssClass="errortext" Display="Dynamic" ErrorMessage="Required"></asp:RequiredFieldValidator>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:TextBox ID="txtPhone" CssClass="emp-txtbox" ValidationGroup="vgQuickSave" TabIndex="12" runat="server"></asp:TextBox><br />
                                    <asp:HiddenField ID="hdnPhone" runat="server" />
                                    <label id="error-msg" class="errortext hide">Invalid phone number</label><asp:RequiredFieldValidator ID="rfvPhone" runat="server" ControlToValidate="txtPhone"
                                        ValidationGroup="vgUpProf" CssClass="errortext" Display="Dynamic" ErrorMessage="Required"></asp:RequiredFieldValidator>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtEmail" CssClass="emp-txtbox" ValidationGroup="vgQuickSave" Placeholder="Email*" TabIndex="13" runat="server"></asp:TextBox><br />
                                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail"
                                        ValidationGroup="vgUpProf" CssClass="errortext" Display="Dynamic" ErrorMessage="Required"></asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="Invalid Email" CssClass="errortext" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"> </asp:RegularExpressionValidator>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <table>
                                        <tr>
                                            <td>Contact Preference<span class="errortext">*</span>
                                            </td>
                                            <td>
                                                <asp:CheckBox ID="ContactPreferenceChkEmail" TabIndex="14" runat="server" Checked="true" Text="Email" />
                                            </td>
                                            <td>
                                                <asp:CheckBox ID="ContactPreferenceChkCall" TabIndex="15" runat="server" Text="Call" />
                                            </td>
                                            <td>
                                                <asp:CheckBox ID="ContactPreferenceChkText" TabIndex="16" runat="server" Text="Text" />
                                            </td>
                                            <td>
                                                <asp:CheckBox ID="ContactPreferenceChkMail" TabIndex="17" runat="server" Text="Mail" />
                                            </td>
                                        </tr>
                                    </table>
                                </td>

                            </tr>
                            <tr>
                                <td>
                                    <asp:TextBox ID="txtStartDate" CssClass="emp-txtbox date" Placeholder="Available Start Date*" TabIndex="18" onkeypress="return false" runat="server"></asp:TextBox><br />
                                    <asp:RequiredFieldValidator ID="rfvStartDate" runat="server" ControlToValidate="txtStartDate" ValidationGroup="vgUpProf" CssClass="errortext" Display="Dynamic" ErrorMessage="Required"></asp:RequiredFieldValidator>
                                </td>
                                <td>Job Type: <span class="errortext">*</span><br />
                                    <asp:DropDownList ID="ddlEmpType" CssClass="emp-ddl" runat="server" TabIndex="19" AutoPostBack="false">
                                        <asp:ListItem Text="Select" Value="0"></asp:ListItem>
                                        <asp:ListItem Text="Part Time - Remote" Value="1"></asp:ListItem>
                                        <asp:ListItem Text="Full Time - Remote" Value="2"></asp:ListItem>
                                        <asp:ListItem Text="Part Time - Onsite" Value="3"></asp:ListItem>
                                        <asp:ListItem Text="Full Time - Onsite" Value="4"></asp:ListItem>
                                        <asp:ListItem Text="Internship" Value="5"></asp:ListItem>
                                        <asp:ListItem Text="Temp" Value="6"></asp:ListItem>
                                        <asp:ListItem Text="Sub" Value="7"></asp:ListItem>
                                    </asp:DropDownList>
                                    <br />
                                    <asp:RequiredFieldValidator ID="rfvEmpType" runat="server" ControlToValidate="ddlEmpType"
                                        ValidationGroup="vgUpProf" CssClass="errortext" Display="Dynamic" ErrorMessage="Required"
                                        InitialValue="0"></asp:RequiredFieldValidator>
                                </td>
                            </tr>
                            <tr>
                                <td>Salary Requirements<span class="errortext">*</span><asp:TextBox ID="txtSalaryRequirments" CssClass="emp-txtbox" TabIndex="20" runat="server"></asp:TextBox>
                                    <br />
                                    <asp:RequiredFieldValidator ID="rfvSalary" runat="server" ControlToValidate="txtSalaryRequirments" ValidationGroup="vgUpProf" CssClass="errortext" Display="Dynamic" ErrorMessage="Required"></asp:RequiredFieldValidator>
                                </td>
                                <td>Are you currently employed?<span class="errortext">*</span><asp:RadioButtonList ID="rblEmployed" RepeatDirection="Horizontal" RepeatLayout="Flow" TabIndex="21" runat="server">
                                    <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                                    <asp:ListItem Text="No" Value="0"></asp:ListItem>
                                </asp:RadioButtonList>
                                    <br />
                                    <asp:RequiredFieldValidator ID="rfvEmployed" runat="server" ControlToValidate="rblEmployed" ValidationGroup="vgUpProf" CssClass="errortext" Display="Dynamic" ErrorMessage="Required"></asp:RequiredFieldValidator>
                                </td>
                            </tr>
                            <tr>
                                <td>Will you be able to pass a drug test and background check?<span class="errortext">*</span><asp:RadioButtonList ID="rblDrugTest" RepeatDirection="Horizontal" RepeatLayout="Flow" TabIndex="22" runat="server">
                                    <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                                    <asp:ListItem Text="No" Value="0"></asp:ListItem>
                                </asp:RadioButtonList>
                                    <br />
                                    <asp:RequiredFieldValidator ID="rfvDrug" runat="server" ControlToValidate="rblDrugTest" ValidationGroup="vgUpProf" CssClass="errortext" Display="Dynamic" ErrorMessage="Required"></asp:RequiredFieldValidator>
                                </td>
                                <td>Have you ever plead guilty to a Felony or been convicted of crime?<span class="errortext">*</span><asp:RadioButtonList ID="rblFelony" RepeatDirection="Horizontal" RepeatLayout="Flow" TabIndex="23" runat="server">
                                    <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                                    <asp:ListItem Text="No" Value="0"></asp:ListItem>
                                </asp:RadioButtonList>
                                    <br />
                                    <asp:RequiredFieldValidator ID="rfvFelony" runat="server" ControlToValidate="rblFelony" ValidationGroup="vgUpProf" CssClass="errortext" Display="Dynamic" ErrorMessage="Required"></asp:RequiredFieldValidator>
                                </td>
                            </tr>
                            <tr>
                                <td>Have you previously worked for JMGrove?<span class="errortext">*</span><asp:RadioButtonList ID="rblWorkedForJMG" RepeatDirection="Horizontal" RepeatLayout="Flow" TabIndex="24" runat="server">
                                    <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                                    <asp:ListItem Text="No" Value="0"></asp:ListItem>
                                </asp:RadioButtonList><br />
                                    <asp:RequiredFieldValidator ID="rfvWorked" runat="server" ControlToValidate="rblWorkedForJMG" ValidationGroup="vgUpProf" CssClass="errortext" Display="Dynamic" ErrorMessage="Required"></asp:RequiredFieldValidator>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtMessageToRecruiter" CssClass="emp-mltxtbox" Placeholder="Message to Recruiter*" runat="server" TextMode="MultiLine" RepeatDirection="Horizontal" RepeatLayout="Flow" TabIndex="25"></asp:TextBox>
                                    <br />
                                    <asp:RequiredFieldValidator ID="rfvMSGRec" runat="server" ControlToValidate="txtMessageToRecruiter" ValidationGroup="vgUpProf" CssClass="errortext" Display="Dynamic" ErrorMessage="Required"></asp:RequiredFieldValidator>
                                </td>
                            </tr>
                            <tr>
                                <td>Attach resume with References<span class="errortext">*</span><br />
                                    <asp:FileUpload ID="fupResume" TabIndex="26" runat="server" />
                                    <br />
                                    <asp:CustomValidator ID="cvResume" runat="server" EnableClientScript="true" CssClass="errortext" ValidationGroup="vgUpProf" ClientValidationFunction="validateResume" Display="Dynamic"> </asp:CustomValidator>
                                    <asp:HiddenField ID="hdnResume" runat="server" />
                                    <asp:Literal ID="ltlresume" runat="server"></asp:Literal><br />
                                    <span id="spnResume" class="text-small text-disabled">(resume size should be less than 2MB , extention allowed: pdf|doc|txt|gif|jpg|png|jpeg)</span>
                                </td>
                                <td>
                                    <div id="divProfilePic" runat="server">
                                        Attach profile picture<span class="errortext">*</span><br />
                                        <asp:FileUpload ID="fupProfilePic" TabIndex="27" runat="server" />
                                        <br />
                                        <asp:Image ID="imgProfilePic" Height="100" Width="100" runat="server" />
                                        <asp:HiddenField ID="hdnprofilePic" runat="server" />
                                        <br />
                                        <%--<asp:CustomValidator ID="cvValidProfilePic" runat="server" EnableClientScript="true" ErrorMessage="Profile picture required" CssClass="errortext" ValidationGroup="vgUpProf" ClientValidationFunction="validateProfilePic" Display="Dynamic"> </asp:CustomValidator>--%>
                                        <asp:CustomValidator ID="cvProfilePic" runat="server" EnableClientScript="true" CssClass="errortext" ValidationGroup="vgUpProf" ClientValidationFunction="validateProfilePic" Display="Dynamic"> </asp:CustomValidator>

                                        <br />
                                        <span id="spnProfilePic" class="text-small text-disabled">(profile pic size should be less than 2MB , extention allowed: gif|jpg|png|jpeg)</span>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" align="center">
                                    <asp:Button ID="btnSaveProfile" ValidationGroup="vgUpProf" Text="Save Profile" CssClass="InputBtn" runat="server" OnClick="btnSaveProfile_Click" />
                                </td>
                            </tr>
                        </table>
                    </div>
                </ContentTemplate>
                <Triggers>
                    <asp:PostBackTrigger ControlID="btnSaveProfile" />
                </Triggers>
            </asp:UpdatePanel>

        </div>

        <div id="divWait" class="hide" style="margin: 20% auto; text-align: center;">
            <h2>We are redirecting you to your dashboard, Please wait for few seconds...</h2>
            <img src="img/ui-anim_basic_16x16.png" />
        </div>
        <div class="progress" style="display: none">Loading&#8230;</div>
        <script src="//code.jquery.com/jquery-2.2.4.min.js" integrity="sha256-BbhdlvQf/xTY9gja0Dq3HiwQF8LaCRTXxZKRutelT44=" crossorigin="anonymous"></script>
        <script src="https://code.jquery.com/ui/1.10.1/jquery-ui.js" type="text/javascript"></script>
        <script src="js/intTel/intlTelInput.js"></script>
        <script src="https://maps.googleapis.com/maps/api/js?v=3.exp&key=AIzaSyCn_qhX9dltK0qQfjmEfqlJ-FjU9tUb408"></script>
        <script type="text/javascript">
            var txtStartDate = "#<%= txtStartDate.ClientID %>";
            var txtPhone = "#<%= txtPhone.ClientID %>";
            var ddlCountry = "#<%= ddlCountry.ClientID%> ";
            var hdnProfilePic = "#<%= hdnprofilePic.ClientID %>";
            var hdnPhone = "#<%= hdnPhone.ClientID %>";
            var fupProfilePic = "#<%= fupProfilePic.ClientID %>";
            var hdnResume = "#<%= hdnResume.ClientID %>";
            var fupResume = "#<%= fupResume.ClientID %>";
            var txtZip = "#<%= txtZip.ClientID %>";
            var txtCity = "#<%= txtCity.ClientID %>";
            var txtState = "#<%= txtState.ClientID %>";


            $(function () {
                Initialize();
            });

            var prm = Sys.WebForms.PageRequestManager.getInstance();
            if (prm != null) {
                // debugger;
                prm.add_beginRequest(function (sender, e) {
                    if (sender._postBackSettings.panelsToUpdate != null) {
                        $(".progress").show();
                    }
                });
                prm.add_endRequest(function (sender, e) {
                    $(".progress").hide();
                });
            };

            function Initialize() {
                $(txtStartDate).datepicker();
                SetPhoneValidation($(txtPhone), $("#error-msg"));
                $(txtZip).blur(function () {
                    if ($(this).val() && $(this).val().length > 3) {
                        console.log($(ddlCountry + "option:selected").val() + " " + $(txtZip).val());
                        getAddressDetails($(ddlCountry + "option:selected").text(), $(txtZip).val(), txtCity, txtState);
                    }
                });
            }

            function closeScreeningPopup(URLtoRedirect) {

                $('#profileMaster').addClass('hide');
                $('#divWait').removeClass('hide');

                window.top.location.href = URLtoRedirect;

            }

            function getAddressDetails(country, zip, txtCity, txtState) {

                $(txtZip).addClass("loading");

                var str = zip + ',' + country;
                var geocoder;
                var map;

                geocoder = new google.maps.Geocoder();
                var address = str;
                var city;

                geocoder.geocode({ 'address': address }, function (results, status) {
                    if (status == google.maps.GeocoderStatus.OK) {

                        for (var component in results[0]['address_components']) {
                            for (var i in results[0]['address_components'][component]['types']) {
                                if (results[0]['address_components'][component]['types'][i] == "administrative_area_level_1") {
                                    state = results[0]['address_components'][component]['long_name'];
                                    city = results[0]['address_components'][1]['long_name'];
                                    $(txtCity).val(city);
                                    $(txtState).val(state);
                                    $(txtState).focus();
                                    $(txtZip).removeClass("loading");
                                }
                            }
                        }
                    } else {
                        alert('It looks like, you have entered invalid zipcode, we are unable to verify!');
                        $(txtZip).removeClass("loading");
                    }
                });
            }

            function SetPhoneValidation(telInput, errorMsg) {

                // initialise plugin
                telInput.intlTelInput({
                    nationalMode: true,
                    utilsScript: "../js/intTel/utils.js"
                });

                var reset = function () {
                    errorMsg.addClass("hide");

                };

                // on blur: validate
                telInput.blur(function () {
                    if ($.trim(telInput.val())) {
                        if (telInput.intlTelInput("isValidNumber")) {
                            var intlNumber = telInput.intlTelInput("getNumber");
                            if (intlNumber) {
                                $(hdnPhone).val(intlNumber);
                            }
                        } else {
                            errorMsg.removeClass("hide");
                            telInput.focus();
                        }
                    }
                });

                // on keyup / change flag: reset
                telInput.on("keyup change", reset);

                telInput.intlTelInput("setCountry", $(ddlCountry).val().toLowerCase());

                // listen to the telephone input for changes
                telInput.on("countrychange", function (e, countryData) {
                    $(ddlCountry).val(countryData.iso2.toUpperCase());
                });

                // listen to the address dropdown for changes
                $(ddlCountry).change(function () {
                    telInput.intlTelInput("setCountry", $(this).val().toLowerCase());
                });
            }


            function validateProfilePic(sender, args) {
                var valid = false;
                var fileExtension = ['jpeg', 'jpg', 'gif', 'png'];
                var maxFileSize = 2097152; // 2MB -> 2 * 1024 * 1024

                var fileUpload = $(fupProfilePic);

                if ($(hdnProfilePic).val() && $(hdnProfilePic).val().length > 0) {// user has already profile picture

                    if (fileUpload[0].files.length > 0) {// if user has attached file than verify its validity else its valid by default.

                        if (validateExtensionFileSize(fileExtension, fileUpload, maxFileSize)) {
                            valid = true;
                        }
                    }
                    else { // if no file attached than user dont want to change prfile picture.
                        valid = true;
                    }

                }
                else {// if not than check user has attached file.

                    if (fileUpload[0].files.length > 0) {// if user has attached file than verify validity

                        if (validateExtensionFileSize(fileExtension, fileUpload, maxFileSize)) {
                            valid = true;
                        }
                    }

                }

                // if valid than remove error class
                if (valid) {
                    $('#spnProfilePic').removeClass('errortext');
                }
                else {
                    $("#spnProfilePic").addClass("errortext");
                }
                //alert('profile pic is : ' +  valid);
                args.IsValid = valid;
            }

            function validateResume(sender, args) {

                var valid = false;
                var fileExtension = ['jpeg', 'jpg', 'gif', 'png', 'pdf', 'doc', 'txt', 'docx'];
                var maxFileSize = 2097152; // 2MB -> 2 * 1024 * 1024

                var fileUpload = $(fupResume);

                if ($(hdnResume).val() && $(hdnResume).val().length > 0) {// user has already profile picture

                    if (fileUpload[0].files.length > 0) {// if user has attached file than verify its validity else its valid by default.

                        if (validateExtensionFileSize(fileExtension, fileUpload, maxFileSize)) {
                            valid = true;
                        }
                    }
                    else { // if no file attached than user dont want to change prfile picture.
                        valid = true;
                    }

                }
                else {// if not than check user has attached file.

                    if (fileUpload[0].files.length > 0) {// if user has attached file than verify validity

                        if (validateExtensionFileSize(fileExtension, fileUpload, maxFileSize)) {
                            valid = true;
                        }
                    }

                }


                // if valid than remove error class
                if (valid) {
                    $('#spnResume').removeClass('errortext');
                }
                else {
                    $("#spnResume").addClass("errortext");
                }
                //alert('resume is : ' + valid);
                args.IsValid = valid;
            }


            function validateExtensionFileSize(fileExtension, fileUpload, maxFileSize) {
                var valid = false;

                var extension = fileUpload[0].files[0].name.substring(fileUpload[0].files[0].name.lastIndexOf('.') + 1).toLowerCase();

                if ($.inArray(extension, fileExtension) != -1) {// if attached file has valid extension
                    if (fileUpload[0].files[0].size < maxFileSize) {
                        $('#spnResume').removeClass('errortext');
                        valid = true;
                    }
                }

                return valid;
            }



        </script>
    </form>
</body>
</html>
