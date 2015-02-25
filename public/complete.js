$(document).ready(function() {
    var tvInput = $('#showname');
    //var searchbutton = $('#searchbutton')

    tvInput.focus();

    tvInput.autocomplete({
        source: "/api/autocomplete/json",
        dataType: 'json',
        autoFocus: true,
        minLength: 3,
        appendTo: ".top-level",
        messages: {
            noResults: '',
            results: function() {}
        },
        select: function(e, ui) {
            location.href = ui.item.link;
        },
        search: function() {
            $('#searchcontent').removeClass('fa-search').addClass('fa-refresh fa-spin');
        },
        open: function() {
            $('#searchcontent').addClass('fa-search').removeClass('fa-refresh fa-spin');
            tvInput.css('border-bottom-left-radius', '0');
        },
        close: function() {
            tvInput.css('border-bottom-left-radius', '8px');
        }
    });
});
