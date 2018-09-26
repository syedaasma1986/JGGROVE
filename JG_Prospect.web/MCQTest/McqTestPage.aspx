<%@ Page Language="C#" AutoEventWireup="true" EnableViewState="true" CodeBehind="McqTestPage.aspx.cs" Inherits="JG_Prospect.MCQTest.McqTestPage" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>

    <link href="../css/screen.css" rel="stylesheet" media="screen" type="text/css" />
    <link href="../css/jquery-ui.css" rel="stylesheet" />
    <link href="../datetime/css/jquery-ui-1.7.1.custom.css" rel="stylesheet" type="text/css" />
    <%--<link rel="stylesheet" href="../css/flipclock.css" type="text/css" />--%>
    <link rel="stylesheet" href="../css/TimeCircles.css" type="text/css" />

    <style>
        .tblResult {
            text-align-last: auto;
            width: 100%;
            padding: 50px;
        }

            .tblResult tr td {
                background: url('../img/line.png') repeat-x 50% bottom;
                padding: 10px 15px 12px 15px;
            }

        .tblExamStartup {
            width: 100%;
            padding: 50px;
        }

        .ui-button {
            background: url('../img/main-header-bg.png') repeat-x;
            color: #fff;
        }
    </style>
</head>
<body style="background: none;">
    <script type="text/javascript">
        function redirectParentToLoginPage(URL) {
            window.top.location.href = URL;
        }
    </script>
    <form id="form1" method="post" runat="server">

        <div>
            <ajaxToolkit:ToolkitScriptManager ID="scmExam" runat="server" AsyncPostBackTimeout="360000">
                <Services>
                </Services>
            </ajaxToolkit:ToolkitScriptManager>
            <asp:UpdateProgress ID="upnlProgress" class="examProgress" runat="server">
                <ProgressTemplate>
                    ...Loading
                </ProgressTemplate>
            </asp:UpdateProgress>
        </div>
        <h2>Thank you for applying JMGrove, This is timebound test, so once you start the test you will not be able to Stop/Restart/Pause the test.</h2>
        <div id="divExams" style="text-align: center; align-items: center; border: 2px solid #e55456; margin: 0 0 5px 0;">
            <h6>Click on Take Test button link to start exam</h6>
            <!-- Repeater to load exam titles -->

            <asp:UpdatePanel ID="upnlMainExams" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <asp:Repeater ID="rptExams" runat="server" OnItemDataBound="rptExams_ItemDataBound">
                        <HeaderTemplate>
                            <table>
                                <tbody>
                                    <tr class="trHeader">
                                        <th>
                                            <h5>Exam  </h5>
                                        </th>

                                        <th>
                                            <h5>Duration</h5>
                                        </th>
                                        <th>
                                            <h5>Result</h5>
                                        </th>
                                    </tr>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr>
                                <td>
                                    <asp:Literal ID="ltlExamId" runat="server" Visible="false" Text='<%#Eval("ExamID")%>'></asp:Literal><strong><%#Eval("ExamTitle")%></strong></td>
                                <td><%#Eval("ExamDuration")%> Mins</td>
                                <td>
                                    <asp:Label ID="lblMarks" runat="server"></asp:Label><br />
                                    <asp:Label ID="lblPercentage" runat="server"></asp:Label><br />
                                    <asp:Label ID="lblResult" runat="server"></asp:Label>
                                </td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate>
                            </tbody>
                    </table>
                        </FooterTemplate>
                    </asp:Repeater>
                </ContentTemplate>
            </asp:UpdatePanel>

        </div>
        <div id="divTakeExam" runat="server" style="text-align: center;">
            <asp:Button ID="btnTakeTest" Text="Take Test" CssClass="ui-button" runat="server" OnClick="btnTakeTest_Click" />
            <%--<asp:Button ID="btnClosePopup" Text="Go to Task" Visible="false" CssClass="ui-button" runat="server" OnClick="btnClosePopup_Click" />--%>
            <asp:Button ID="btnCancelTest" runat="server" OnClick="btnCancelTest_Click" OnClientClick="javascript:return confirm('Are you sure you want to Cancel Test?');" Text="Cancel Test" CssClass="ui-button" />
        </div>

        <asp:UpdatePanel ID="upnlExamSection" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <asp:Button ID="btnEndExamTimeOut" runat="server" OnClick="btnEndExam_Click" Style="display: none;" Text="Button" />
                <div id="divExamSection" runat="server" visible="false" class="mcqquesMain">

                    <div id="divTimer" style="height: 100px;" class="stopwatch" data-timer=""></div>

                    <!-- Questions Section Start-->
                    <asp:Repeater ID="rptQuestions" runat="server" OnItemCommand="rptQuestions_ItemCommand">
                        <HeaderTemplate>
                            <ul>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <li class="mcqques">
                                <asp:LinkButton ID="hypQuestion" runat="server" CommandName="LoadQuestion" Text='<%#String.Concat("Q",(Container.ItemIndex + 1).ToString()) %>' CommandArgument='<%#Eval("QuestionID") %>'></asp:LinkButton>
                                <asp:Literal ID="ltlQuestionText" runat="server" Visible="false" Text='<%#Eval("Question") %>' />
                                <asp:HiddenField ID="hdnPMarks" runat="server" Value='<%#Eval("PositiveMarks") %>' />
                                <asp:HiddenField ID="hdnNMarks" runat="server" Value='<%#Eval("NegetiveMarks") %>' />
                            </li>

                        </ItemTemplate>
                        <FooterTemplate>
                            </ul>
                        </FooterTemplate>

                    </asp:Repeater>
                    <!-- Questions Section Ends-->


                    <div id="divQues" class="mcqQuestion">
                        <span class="bluetext">
                            <strong>
                                <asp:Literal ID="ltlQuesNo" runat="server"></asp:Literal></strong>
                            <asp:Literal ID="ltlQuestionTitle" runat="server"></asp:Literal></span>
                        <asp:RadioButtonList ID="rblQuestionOptions" AutoPostBack="true" runat="server" OnSelectedIndexChanged="rblQuestionOptions_SelectedIndexChanged"></asp:RadioButtonList>
                        <asp:HiddenField ID="hdnPMarks" runat="server" />
                        <asp:HiddenField ID="hdnNMarks" runat="server" />
                        <asp:HiddenField ID="hdnCorrectAnswer" runat="server" />
                        <asp:HiddenField ID="hdnTimeLeft" runat="server" />
                        <asp:HiddenField ID="hdnCurrentExamTime" runat="server" />

                    </div>

                    <div id="divEndExam" class="endExam" visible="false" runat="server">
                        <asp:Button ID="btnEndExam" runat="server" CssClass="ui-button" OnClick="btnEndExam_Click" Text="Submit Exam/View Result" />

                    </div>


                    <asp:HiddenField ID="hdnExamsOver" runat="server" />

                </div>




            </ContentTemplate>
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="btnEndExamTimeOut" EventName="Click" />
            </Triggers>
        </asp:UpdatePanel>
        <div class="hide">
            <p class="hide">
                <asp:Label ID="Label1" runat="server" BackColor="RosyBrown"></asp:Label>
            </p>
            <p>
                <asp:Label ID="lblSPI" runat="server" Text=""></asp:Label>
            </p>

        </div>


    </form>

    <script src="https://code.jquery.com/jquery-2.2.4.min.js" integrity="sha256-BbhdlvQf/xTY9gja0Dq3HiwQF8LaCRTXxZKRutelT44=" crossorigin="anonymous"></script>
    <script type="text/javascript" src='<%=Page.ResolveUrl("~/js/jquery-ui.js")%>'></script>
    <%--<script src="../js/flipclock.min.js"></script>--%>
    <script src="../js/TimeCircles.js"></script>
    <script type="text/javascript">
        $(function () {
            Initialize();
        });

        //On UpdatePanel Refresh
        var prm = Sys.WebForms.PageRequestManager.getInstance();
        if (prm != null) {

            prm.add_beginRequest(function () {
                if (clock) {
                    $('#divTimer').TimeCircles().destroy();
                    clock = null;
                }
            });

            prm.add_endRequest(function (sender, e) {
                if (sender._postBackSettings.panelsToUpdate != null) {
                    Initialize();
                }
            });
        };


        function Initialize() {
            //disableOperations();
            startExamTimer();

        }
        function disableOperations() {

            //Disable right click.
            $("body").on("contextmenu", function (e) {
                alert('This operation is disabled on this page.');
                return false;
            });

            //Disable Cut,Copy,Paste.
            $('body').bind('cut copy paste', function (e) {
                alert('This operation is disabled on this page.');
                e.preventDefault();

            });
        }

        var clock;

        <%-- 
        function startExamTimer() {

            var TimeLeft = parseInt($('#<%=hdnTimeLeft.ClientID%>').val());
            console.log("Time left is...");
            console.log(TimeLeft);

            if (TimeLeft > 0) {

                clock = $('#divTimer').FlipClock($('#<%=hdnTimeLeft.ClientID%>').val(), {
                    countdown: true,
                    clockFace: 'MinuteCounter',
                    callbacks: {
                        stop: function () {
                            if (clock && $('#<%=hdnTimeLeft.ClientID%>').val() != "" && $('#<%=hdnExamsOver.ClientID%>').val() != "1") {
                                var postData = {};

                                CallJGWebService('ExamTimeLeft', postData, OnAddNewSubTaskSuccess, OnAddNewSubTaskError);
                                function OnAddNewSubTaskSuccess(data) {
                                    if (data.d) {
                                        alert('Time left ...');
                                        callEndExam();
                                    }
                                }

                                function OnAddNewSubTaskError(err) {

                                }

                                return false;

                            }
                        }
                    }

                });

            }
        }--%>

        function startExamTimer() {

            var timeLeft = parseInt($('#<%=hdnTimeLeft.ClientID%>').val());

            $('#divTimer').attr("data-timer", $('#<%=hdnTimeLeft.ClientID%>').val());

            if (timeLeft > 0) {
                clock = null;

                var totalTime = parseInt($('#<%=hdnCurrentExamTime.ClientID%>').val());

                clock = $('#divTimer').TimeCircles({
                    count_past_zero: false,
                    total_duration: totalTime * 60,
                    "circle_bg_color": "#EEEEEE",
                    time: {
                        Days: { show: false },
                        Hours: { show: false },
                        Minutes: { color: "#ac0c0c" },
                        Seconds: { color: "#ac0c0c" }
                    }
                }).addListener(function (unit, amount, total) {
                    if (total == 0) {
                        callEndExam();
                    }
                });
            }

        }

        //function SuccessRedirect(ID) {
        //    window.parent.location.href = "../ViewApplicantUser.aspx?Id=" + ID + "&IE=1";
        //}
        function SuccessRedirect(ID, DId) {
            window.parent.location.href = "../postapptitude.aspx?DId=" + DId + "&UId=" + ID;
        }
        function callEndExam() {
            $('#<%=divExamSection.ClientID%>').find("input,button,select").attr("disabled", "disabled");
            $('#<%=divExamSection.ClientID%>').find("a").attr("href", "javascript:void(0);");
            $('#<%=hdnTimeLeft.ClientID%>').val("");
            $('#<%=hdnCurrentExamTime.ClientID%>').val("");
            $('#<%=btnEndExamTimeOut.ClientID%>').click();

        }

    </script>
</body>
</html>
