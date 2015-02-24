$(document).ready(function() {
    var tvInput = $('#showname');
    var searchbutton = $('#searchbutton')

    tvInput.focus();

    tvInput.keyup(function(event) {
        if (event.keyCode == 13) {
            searchbutton.click();
        }
    });

    searchbutton.click(function() {
        input = tvInput.val();
        $('#searchcontent').removeClass('fa-search').addClass('fa-refresh fa-spin');
        $.ajax({
            url: '/api/autocomplete',
            data: {
                term: input
            },
            dataType: 'html',
            type: 'GET',
            cache: false,
            timeout: 60000,
            error: function() {
                $('#searchcontent').addClass('fa-search').removeClass('fa-refresh fa-spin');
                $('#results').html("<h2>No results.</h2>");
                return false;
            },
            success: function(msg) {
                console.log(msg);
                $('#searchcontent').addClass('fa-search').removeClass('fa-refresh fa-spin');
                $('#results').html(msg);
                return true;
            }
        });
    });
});
