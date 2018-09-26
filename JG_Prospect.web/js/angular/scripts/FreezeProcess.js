function SaveTaskQuery(sender) {
    var QueryText = $('#txtQueryText').val();
    var RomanId = $(sender).attr('data-romanid');
    var QueryTypeId = $('.dropdown-query-type').val();

    CallJGWebService('SaveTaskQuery', {
        TaskId: RomanId,
        QueryDesc: QueryText,
        QueryTypeId: QueryTypeId
    },
        function (success) {
            $('#txtQueryText').val('');
            $('.dropdown-query-type').val(0);

            //Reload Query Grid

        },
        function (err) {
        }
    );

}