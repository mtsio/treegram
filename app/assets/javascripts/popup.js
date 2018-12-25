
var Popup = {
    setup: function () {
        if ($("#photoInfo")[0] !== undefined) { // prevent again a load of the script
            return;
        }
        // add hidden 'div' to end of page to display popup: 
        var popupDiv = $('<div id="photoInfo"></div>');
        popupDiv.hide().appendTo($('body'));
    }
    , getPhotoInfo: function (element) {
        $.ajax({
            type: 'GET',
            url: element.attr('href'),
            timeout: 5000,
            success: Popup.showPhotoInfo,
            error: function (xhrObj, textStatus, exception) { alert('Error!'); }
            // 'success' and 'error' functions will be passed 3 args 
        });
        return (false);
    }
    , showPhotoInfo: function (data, requestStatus, xhrObject) {
        // center a floater 1/2 as wide and 1/4 as tall as screen 
        var oneFourth = Math.ceil($(window).width() / 4) + 10;
        $('#photoInfo').
            css({ 'left': oneFourth, 'width': 2 * oneFourth, 'top': 300 }).
            html(data).
            show();

        commentFormInit(function() {
            Popup.hidePhotoInfo()
        })
        // make the Close link in the hidden element work 
        $('#closeLink').click(Popup.hidePhotoInfo);
        return (false);  // prevent default link action 
    }
    , hidePhotoInfo: function () {
        $('#photoInfo').hide();
        Slider.startTheShow()
        return (false);
    }
};
$(Popup.setup);