function QuickSaveInstallUser() {

    var isPageValid = Page_ClientValidate("vgQuickSave");



    if (isPageValid) {
        ShowAjaxLoader();

        var postData = {
            FirstName: txtFirstName.val(),
            NameMiddleInitial: txtMiddleInitialName.val(),
            LastName: txtLastName.val(),
            Email: txtEmailQs.val(),
            Phone: txtPhoneQs.val(),
            Zip: txtZipHomeAdd.val(),
            DesignationText: $(ddlDesignation + "  option:selected").text(),
            DesignationId: $(ddlDesignation + "  option:selected").val(),
            Status: $(ddlstatus + "  option:selected").val(),
            SourceText: $(ddlSource + "  option:selected").text(),
            EmpType: $(ddlEmpType + "  option:selected").val(),
            StartDate: txtStartDate.val(),
            SalaryReq: txtSalaryRequirments.val(),
            SourceUserId: hdnAddedByUserId.val(),
            PositionAppliedForDesignationId: $(ddlPositionAppliedFor + "  option:selected").val(),
            SourceID: $(ddlSource + "  option:selected").val(),
            AddedByUserId: hdnAddedByUserId.val(),
            IsEmailContactPreference: chkIsEmailContactPreference,
            IsCallContactPreference: chkIsCallContactPreference,
            IsTextContactPreference: chkIsTextContactPreference,
            IsMailContactPreference: chkIsMailContactPreference
        };

        console.log(postData);

        CallJGWebService('QuickSaveInstallUsers', postData, OnQuickSaveInstallUserSuccess, OnQuickSaveInstallUserError);

        function OnQuickSaveInstallUserSuccess(data) {
            console.log(data);
            if (data.d) {
                alert('User saved successfully.');
                window.location.href = "ViewSalesUser.aspx?id=" + data.d;
            }
            else {
                alert('User cannot be saved. Please try again.');
            }
            HideAjaxLoader();
        }

        function OnQuickSaveInstallUserError(err) {
            alert('User cannot be saved. Please try again.');
        }

        HideAjaxLoader();

        return false;
    }

}
function QuickSaveUserWithEmailorPhone() {



    if (ValidateQuickSave()) {
        ShowAjaxLoader();

        var postData = {
            FirstName: txtFirstName.val(),
            LastName: txtLastName.val(),
            Email: txtEmailQs.val(),
            Phone: txtPhoneQs.val(),
            AddedByUserId: hdnAddedByUserId.val()
        };

        console.log(postData);

        CallJGWebService('QuickSaveUserwithEmailOrPhone', postData, OnQuickSaveUserSuccess, OnQuickSaveUserError);

        function OnQuickSaveUserSuccess(data) {
            console.log(data);
            if (data.d) {

                if (data.d != '') {
                    alert(data.d);
                }

            }
            else {
                alert('User cannot be saved. Please try again.');
            }
            HideAjaxLoader();
        }

        function OnQuickSaveUserError(err) {
            console.log(err);
            HideAjaxLoader();
            alert('User cannot be saved. Please try again.');
        }


    }
    else {
        alert('Please enter Email!');
    }

    return false;

}

function ValidateQuickSave() {

    var returnVal = true;

    if (txtEmailQs.val() == '') {
        returnVal = false;
    }

    return returnVal;

}