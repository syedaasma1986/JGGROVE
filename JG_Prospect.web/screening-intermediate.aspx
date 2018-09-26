<%@ Page Title="" Language="C#" MasterPageFile="~/JGApplicant.Master" AutoEventWireup="true" CodeBehind="screening-intermediate.aspx.cs" Inherits="JG_Prospect.screening_intermediate" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="css/intTel/intlTelInput.css" rel="stylesheet" />
    <style type="text/css">
        .right_panel{ background-color: #fff;}
    </style>
</asp:Content>



<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="right_panel">
        <%--    <asp:ScriptManager ID="scmPopup" runat="server" ScriptMode="Auto">
        </asp:ScriptManager>--%>
        
         <h1>JMGrove Employment Application - Stage 1 (Complete Your Profile)</h1>
        <div class="w3-light-grey">
        <div class="w3-grey">0%</div>
    </div>

        <table width="100%" class="header-table">
            <tr>
                <td ><b>Stage 1 - Application</b></td>
                <td ><b>Stage 2 - On Boarding</b></td>
                <td ><b>Stage 3 - Approval</b></td>
            </tr>
            <tr>
                <td ><asp:CheckBox ID="chkRegComplete" runat="server" Checked="true"/> Registration Complete</td>
                <td ><asp:CheckBox ID="chkNotifiedAboutOpportunity" runat="server"/> Notified About Opportunity</td>
                <td ><asp:CheckBox ID="chkApplicationApproval" runat="server"/> Application Approval</td>
            </tr>
            <tr>
                <td ><asp:CheckBox ID="chkApplicationInProgress" runat="server" Checked="true"/> Application In Progress</td>
                <td ><asp:CheckBox ID="chkAccountSetup" runat="server"/> Account Setup</td>
                <td ><asp:CheckBox ID="chkServiceProviderFullyOnBoard" runat="server"/> Service Provider Fully On-Board</td>
            </tr>
            <tr>
                <td >&nbsp;</td>
                <td ><asp:CheckBox ID="chkBackgroundOrders" runat="server" /> Background Orders</td>
                <td >&nbsp;</td>
            </tr>

        </table>

        <div id="profileMaster">
            <div class="profiletitle">
                <h2>Complete your profile</h2>
                
            </div>

            <div class="clear">
            </div>
            <span class="errortext">*</span><label>All fields are mandatory</label>
            <asp:UpdatePanel ID="upnlProfile" runat="server">
                <ContentTemplate>
                    <div class="profilediv">
                        <table class="profiletable">
                            <tr>
                                <td>Position applying for: <span class="errortext">*</span><br />
                                    <asp:DropDownList ID="ddlPositionAppliedFor" CssClass="emp-ddl" TabIndex="1" AppendDataBoundItems="true" runat="server" ClientIDMode="Static" AutoPostBack="false">
                                    </asp:DropDownList><br />
                                    <asp:RequiredFieldValidator ID="rfvPositionApplied" runat="server" ControlToValidate="ddlPositionAppliedFor"
                                        ValidationGroup="vgUpProf" CssClass="errortext" Display="Dynamic" ErrorMessage="Required" SetFocusOnError="true"
                                        InitialValue="0"></asp:RequiredFieldValidator>
                                </td>
                                <td>Source: <span class="errortext">*</span><br />
                                    <asp:DropDownList ID="ddlSource" CssClass="emp-ddl" runat="server" AutoPostBack="false" TabIndex="2">
                                    </asp:DropDownList><br />
                                    <asp:RequiredFieldValidator ID="rfvSource" runat="server" ControlToValidate="ddlSource" SetFocusOnError="true"
                                        ValidationGroup="vgUpProf" CssClass="errortext" Display="Dynamic" ErrorMessage="Required"
                                        InitialValue="0"></asp:RequiredFieldValidator>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div>
                                        <div class="parallerinput-left" style="width: 80%; display: inline-table">
                                            <asp:TextBox ID="txtfirstname" CssClass="emp-txtbox" Placeholder="First Name*" runat="server" MaxLength="40" autocomplete="off" EnableViewState="false" AutoCompleteType="None" TabIndex="3"></asp:TextBox><br />
                                            <asp:RequiredFieldValidator ID="rfvFirstName" runat="server" ControlToValidate="txtfirstname" SetFocusOnError="true"
                                                ValidationGroup="vgUpProf" CssClass="errortext" Display="Dynamic" ErrorMessage="Required"></asp:RequiredFieldValidator>
                                        </div>
                                        <div class="parallerinput-right" style="width: 9%; display: inline-table">
                                            <asp:TextBox ID="txtMiddleInitial" Placeholder="I" runat="server" CssClass="emp-txtbox emp-txtboxsmall" MaxLength="3" TabIndex="4"></asp:TextBox>
                                            <br />
                                        </div>
                                    </div>

                                </td>
                                <td>
                                    <asp:TextBox ID="txtlastname" CssClass="emp-txtbox" Placeholder="Last Name*" runat="server" MaxLength="40" autocomplete="off"
                                        TabIndex="5"></asp:TextBox>
                                    <br />
                                    <asp:RequiredFieldValidator ID="rfvLastName" runat="server" ControlToValidate="txtlastname" SetFocusOnError="true"
                                        ValidationGroup="vgUpProf" CssClass="errortext" Display="Dynamic" ErrorMessage="Required"></asp:RequiredFieldValidator>
                                </td>
                            </tr>
                            <tr>

                                <td>
                                    <asp:DropDownList ID="ddlCountry" CssClass="emp-ddl" runat="server" TabIndex="6"></asp:DropDownList><br />
                                    <asp:RequiredFieldValidator ID="rfvCountry" runat="server" ControlToValidate="ddlCountry" SetFocusOnError="true"
                                        ValidationGroup="vgUpProf" CssClass="errortext" Display="Dynamic" ErrorMessage="Required"
                                        InitialValue="0"></asp:RequiredFieldValidator>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtZip" CssClass="emp-txtbox" Placeholder="Zip*" runat="server" MaxLength="10" TabIndex="7"></asp:TextBox><br />
                                    <asp:RequiredFieldValidator ID="rfvZip" runat="server" ControlToValidate="txtZip" SetFocusOnError="true"
                                        ValidationGroup="vgUpProf" CssClass="errortext" Display="Dynamic" ErrorMessage="Required"></asp:RequiredFieldValidator>
                                </td>
                            </tr>
                            <tr>
                                
                                <td>
                                    <asp:TextBox ID="txtCity" CssClass="emp-txtbox" Placeholder="City*" runat="server" MaxLength="50" TabIndex="8"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvCity" runat="server" ControlToValidate="txtCity" SetFocusOnError="true"
                                        ValidationGroup="vgUpProf" CssClass="errortext" Display="Dynamic" ErrorMessage="Required"></asp:RequiredFieldValidator>
                                </td>  <td>
                                    <asp:TextBox ID="txtState" CssClass="emp-txtbox" Placeholder="State*" runat="server" MaxLength="50" TabIndex="9"></asp:TextBox>
                                    <br />
                                    <asp:RequiredFieldValidator ID="rfvState" runat="server" ControlToValidate="txtState" SetFocusOnError="true"
                                        ValidationGroup="vgUpProf" CssClass="errortext" Display="Dynamic" ErrorMessage="Required"></asp:RequiredFieldValidator>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:TextBox ID="txtAddress" CssClass="emp-mltxtbox" Rows="4" Width="90%" Placeholder="Address*" runat="server" TextMode="MultiLine" TabIndex="10"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvAddress" runat="server" ControlToValidate="txtAddress" SetFocusOnError="true"
                                        ValidationGroup="vgUpProf" CssClass="errortext" Display="Dynamic" ErrorMessage="Required"></asp:RequiredFieldValidator>
                                </td>
                                <td>Reason for leaving your current job(if applicable) : <span class="errortext">*</span><br />
                                    <asp:TextBox ID="txtReasontoLeave" Rows="4" CssClass="emp-mltxtbox" runat="server" Width="90%" MaxLength="50" TextMode="MultiLine" TabIndex="11"></asp:TextBox><br />
                                    <asp:RequiredFieldValidator ID="rfvReasontoLeave" SetFocusOnError="true" runat="server" ControlToValidate="txtReasontoLeave"
                                        ValidationGroup="vgUpProf" CssClass="errortext" Display="Dynamic" ErrorMessage="Required"></asp:RequiredFieldValidator>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:TextBox ID="txtPhone" CssClass="emp-txtbox" ValidationGroup="vgQuickSave" TabIndex="12"
                                        placeholder="Phone * - Ex. (111)-111-1111" runat="server" data-mask="(000)-000-0000"></asp:TextBox><br />
                                    <asp:HiddenField ID="hdnPhone" runat="server" />
                                    <label id="error-msg" class="errortext hide">Invalid phone number</label><asp:RequiredFieldValidator ID="rfvPhone" runat="server" ControlToValidate="txtPhone"
                                        ValidationGroup="vgUpProf" CssClass="errortext" SetFocusOnError="true" Display="Dynamic" ErrorMessage="Required"></asp:RequiredFieldValidator>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtEmail" CssClass="emp-txtbox" ValidationGroup="vgQuickSave" Placeholder="Email*" TabIndex="13" runat="server"></asp:TextBox><br />
                                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" SetFocusOnError="true"
                                        ValidationGroup="vgUpProf" CssClass="errortext" Display="Dynamic" ErrorMessage="Required"></asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="revEmail" runat="server" SetFocusOnError="true" ControlToValidate="txtEmail" ErrorMessage="Invalid Email" CssClass="errortext" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"> </asp:RegularExpressionValidator>
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
                                    <asp:RequiredFieldValidator ID="rfvStartDate" runat="server" ControlToValidate="txtStartDate" SetFocusOnError="true" ValidationGroup="vgUpProf" CssClass="errortext" Display="Dynamic" ErrorMessage="Required"></asp:RequiredFieldValidator>
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
                                        ValidationGroup="vgUpProf" CssClass="errortext" SetFocusOnError="true" Display="Dynamic" ErrorMessage="Required"
                                        InitialValue="0"></asp:RequiredFieldValidator>
                                </td>
                            </tr>
                            <tr>
                                <td>Salary Requirements<span class="errortext">*</span>
                                      <div>
                                        <div class="parallerinput-left" style="width: 78%; display: inline-table">
                                            <asp:TextBox ID="txtSalaryRequirments" CssClass="emp-txtbox" TabIndex="20" runat="server"></asp:TextBox>
                                            / Year
                                            <br />
                                            <asp:RequiredFieldValidator ID="rfvSalary" runat="server" ControlToValidate="txtSalaryRequirments" SetFocusOnError="true" ValidationGroup="vgUpProf" CssClass="errortext" Display="Dynamic" ErrorMessage="Required"></asp:RequiredFieldValidator>
                                        </div>
                                        <div class="parallerinput-right" style="width: 16%; display: inline-table">
                                            <asp:DropDownList ID="ddlCurrency" CssClass="emp-ddl" runat="server" TabIndex="6"></asp:DropDownList><br />
                                        </div>
                                    </div>
                                    
                                </td>
                                <td>Are you currently employed?<span class="errortext">*</span><asp:RadioButtonList ID="rblEmployed" RepeatDirection="Horizontal" RepeatLayout="Flow" TabIndex="21" runat="server">
                                    <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                                    <asp:ListItem Text="No" Value="0"></asp:ListItem>
                                </asp:RadioButtonList>
                                    <br />
                                    <asp:RequiredFieldValidator ID="rfvEmployed" runat="server" ControlToValidate="rblEmployed" SetFocusOnError="true" ValidationGroup="vgUpProf" CssClass="errortext" Display="Dynamic" ErrorMessage="Required"></asp:RequiredFieldValidator>
                                </td>
                            </tr>
                            <tr>
                                <td>Will you be able to pass a drug test and background check?<span class="errortext">*</span><asp:RadioButtonList ID="rblDrugTest" RepeatDirection="Horizontal" RepeatLayout="Flow" TabIndex="22" runat="server">
                                    <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                                    <asp:ListItem Text="No" Value="0"></asp:ListItem>
                                </asp:RadioButtonList>
                                    <br />
                                    <asp:RequiredFieldValidator ID="rfvDrug" runat="server" SetFocusOnError="true" ControlToValidate="rblDrugTest" ValidationGroup="vgUpProf" CssClass="errortext" Display="Dynamic" ErrorMessage="Required"></asp:RequiredFieldValidator>
                                </td>
                                <td>Have you ever plead guilty to a Felony or been convicted of crime?<span class="errortext">*</span><asp:RadioButtonList ID="rblFelony" RepeatDirection="Horizontal" RepeatLayout="Flow" TabIndex="23" runat="server">
                                    <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                                    <asp:ListItem Text="No" Value="0"></asp:ListItem>
                                </asp:RadioButtonList>
                                    <br />
                                    <asp:RequiredFieldValidator ID="rfvFelony" runat="server" SetFocusOnError="true" ControlToValidate="rblFelony" ValidationGroup="vgUpProf" CssClass="errortext" Display="Dynamic" ErrorMessage="Required"></asp:RequiredFieldValidator>
                                </td>
                            </tr>
                            <tr>
                                <td>Have you previously worked for JMGrove?<span class="errortext">*</span><asp:RadioButtonList ID="rblWorkedForJMG" RepeatDirection="Horizontal" RepeatLayout="Flow" TabIndex="24" runat="server">
                                    <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                                    <asp:ListItem Text="No" Value="0"></asp:ListItem>
                                </asp:RadioButtonList><br />
                                    <asp:RequiredFieldValidator ID="rfvWorked" runat="server" SetFocusOnError="true" ControlToValidate="rblWorkedForJMG" ValidationGroup="vgUpProf" CssClass="errortext" Display="Dynamic" ErrorMessage="Required"></asp:RequiredFieldValidator>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtMessageToRecruiter" Rows="4" Width="90%" CssClass="emp-mltxtbox" Placeholder="Message to Recruiter*" runat="server" TextMode="MultiLine" RepeatDirection="Horizontal" RepeatLayout="Flow" TabIndex="25"></asp:TextBox>
                                    <br />
                                    <asp:RequiredFieldValidator ID="rfvMSGRec" runat="server" SetFocusOnError="true" ControlToValidate="txtMessageToRecruiter" ValidationGroup="vgUpProf" CssClass="errortext" Display="Dynamic" ErrorMessage="Required"></asp:RequiredFieldValidator>
                                </td>
                            </tr>
                            <tr>
                                <td>Attach resume with References<span class="errortext">*</span><br />
                                    <asp:FileUpload ID="fupResume" TabIndex="26" runat="server" />
                                    <br />
                                    <asp:CustomValidator ID="cvResume" runat="server" EnableClientScript="true" SetFocusOnError="true" CssClass="errortext" ValidationGroup="vgUpProf" ClientValidationFunction="validateResume" Display="Dynamic"> </asp:CustomValidator>
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
                                        <asp:CustomValidator ID="cvProfilePic" runat="server" SetFocusOnError="true" EnableClientScript="true" CssClass="errortext" ValidationGroup="vgUpProf" ClientValidationFunction="validateProfilePic" Display="Dynamic"> </asp:CustomValidator>

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
        <script src="js/jquery.mask.js"> </script>
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
                var btnSaveId = "#<%= btnSaveProfile.ClientID %>";
                $('body').off('click', btnSaveId).on('click', btnSaveId, function () {
                    debugger
                    $(".errortext").each(function (i) {
                        if ($(this).css('display') != 'none') {
                            $(".errortext:first").focus();
                            return false;
                        }
                    })
                })

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
                //setTimeout(function () {  }, 300);
                $(txtStartDate).datepicker();
                SetPhoneValidation($(txtPhone), $("#error-msg"));
                setTimeout(function () {
                    $(txtPhone).unmask('(000)-000-0000').mask('(000)-000-0000');
                }, 300);
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

            function getUserConutry() {
                if (navigator.geolocation) {
                    navigator.geolocation.getCurrentPosition(function (position) {
                        var pos = {
                            lat: position.coords.latitude,
                            lng: position.coords.longitude
                        };
                        getCountryFromLocation(pos);
                    }, function () {

                    });
                }

            }

            function getCountryFromLocation(pos) {
                var geocoder = new google.maps.Geocoder();
                geocoder.geocode({ 'location': pos }, function (results, status) {
                    if (status == google.maps.GeocoderStatus.OK) {
                        for (var component in results[0]['address_components']) {
                            for (var i in results[0]['address_components'][component]['types']) {
                                if (results[0]['address_components'][component]['types'][i] == "country") {
                                    var country = results[0]['address_components'][component]['short_name'];
                                    if ($(txtPhone).val() == '') {
                                        $(txtPhone).intlTelInput("setCountry",country);
                                    }
                                }
                            }
                        }
                    } else {
                    }
                });
            }

            function SetPhoneValidation(telInput, errorMsg) {
                // initialise plugin
                telInput.intlTelInput({
                    nationalMode: true,
                    separateDialCode: true,
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

                if ($(txtPhone).val() == '') {
                    setTimeout(function () { getUserConutry(); }, 300);
                }   
                else {
                    telInput.intlTelInput("setCountry", $(ddlCountry).val().toLowerCase());
                }
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
    </div>
    <%-- <div id="screeningPopup" class="modal hide">
        <iframe id="ifScreening" style="width: 100%; overflow: auto; height: 100%;"></iframe>
    </div>--%>

    <style>
        .profiletitle h2 {
            text-align: center;
            color: #A33E3F;
            font-size: 20px;
        }

        .profilediv {
            width: 99%;
            border: 1px solid gray;
            border-radius: 10px;
            padding: 10px 0 0 10px;
        }

        input:not([type=radio]), select {
            width: 90%;
            padding: 5px;
            border-radius: 5px;
        }

        .profiletable {
            width: 100%;
        }
        #profileMaster {
            margin:10px;
        }
        .InputBtn {
            width: 95px !important;
            line-height: 28px;
            background: #A33E3F;
            color: #fff;
            cursor: pointer;
            border-radius: 10px;
            margin-top: 10px;
        }

        .intl-tel-input {
            width: 100%
        }
        .w3-light-grey{
                color: #000!important;
            border:  2px solid #9e9e9e!important;
            border-bottom: 5px solid #9e9e9e!important;
        }
        .w3-grey{
                color: #000!important;
                background-color: #f1f1f1!important;
                margin-top:6px;
                height: 18px; width: 0%;
                margin-left:25px;
        }

        .header-table {
            padding: 15px 0 0 15px;
        }
        .header-table tr {
            line-height: 1.75;
        }
            .header-table input[type=checkbox] {
                width:auto;
            }

          .header-table   td:nth-child(1) {width:40% }
          .header-table   td:nth-child(2) {width:40% }
          .header-table   td:nth-child(3) {width:20% }
        .errortext {color:red;
        }
    </style>
</asp:Content>
<%--<script type="text/javascript">
        var screeningDialog;
        function showScreeningPopup(urlToRedirect) {
            console.log("return url is: " + urlToRedirect);

            $("#ifScreening").attr('src', "screening-popup.aspx?returnurl=" + urlToRedirect);

            $('#screeningPopup').removeClass('hide');

          screeningDialog =  $('#screeningPopup').dialog({
                modal: false,
                height: 700,
                width: 1000,
                title: "Your attention required...",
                closeOnEscape: false,
                open: function (event, ui) {
                    $(".ui-dialog-titlebar-close", ui.dialog | ui).hide();
                }
            }).parent().appendTo($("#formScreening"));

            $('#screeningPopup').show();
            return true;
        }

    </script>--%>
