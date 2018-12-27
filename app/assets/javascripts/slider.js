
var Slider = {
    // Add slider window dom element to the body
    setup: function () {
        if ($("#sliderWindow")[0] !== undefined) { // prevent again a load of the script
            return;
        }
        // add hidden 'div' to end of page to display Slider: 
        var sliderDiv = $('<div id="sliderWindow"></div>');
        sliderDiv.hide().appendTo($('body'));
	// $.each($('.galleryPhoto a'), function() {
	//     $(this).attr('a').mouseover(Slider.getPhotoInfo);
	//     $(this).mouseout(Slider.hidePhotoInfo);
	// });
        $('.galleryPhoto a').mouseover(Slider.getPhotoInfo);
        $('.galleryPhoto a').mouseout(Slider.hidePhotoInfo);
    }
    // based on element href load the html data (slides) to show
    , getPhotoInfo: function (e) {
        // if is shown and we hover again dont do anything.
        if (!$('#sliderWindow').is(":hidden")) {
            return;
        }
        $(this).addClass("loading") // Add css loading
        $.ajax({
            type: 'GET',
            url: $(this).attr('href'),
            timeout: 5000,
            success: function success(data, requestStatus, xhrObject) {
                $(this).removeClass("loading") // remove css loading
                Slider.showPhotoInfo(data, requestStatus, xhrObject)
            },
            error: function (xhrObj, textStatus, exception) { alert('Error!'); }
            // 'success' and 'error' functions will be passed 3 args 
        });
        return (false);
    }
    , showPhotoInfo: function (data, requestStatus, xhrObject) {
        // center a floater 1/2 as wide and 1/4 as tall as screen 
        var oneFourth = Math.ceil($(window).width() / 4);
        $('#sliderWindow').
            css({ 'left': oneFourth, 'width': 2 * oneFourth, 'top': 250 }).
            html(data).
            fadeIn();
        // Start the interval
        Slider.startTheShow()

        // setup the handler here! because now we have loaded the dom elements.
        $('ul#slides li a').on('click', function(event) {
            event.preventDefault()
            Slider.stopTheShow()
            Popup.getPhotoInfo($(this))
            return (false)
        })

        // make the Close link in the hidden element work 
        // $('#sliderWindow').mouseout(Slider.hidePhotoInfo);
        return (false);  // prevent default link action 
    }
    , hidePhotoInfo: function () {
        clearInterval(Slider.interval)
        $('#sliderWindow').fadeOut();
        $('#sliderWindow').html('');
        return (false);
    },
    startTheShow: function () {
        // Interval will execute the Slider move every 3 secs
        if (!Slider.interval) {
            Slider.interval = setInterval(function () {
                Slider.move()
            }, 3000)
        }
    },
    stopTheShow: function () {
        // When we want to stop the slider, we clear it's interval.
        if (Slider.interval) {
            clearInterval(Slider.interval)
        }
    },
    // What it does is to show only the first element of the list. So when we choose the first, we ad it in the end
    // the next is coming but doing the left 0. 'sliding it out'
    move: function () {
        const slideWidth = $("#sliderWindow").width()
        $("#sliderWindow ul#slides").animate({
            left: -slideWidth
        }, 200, function () {
            $("#sliderWindow ul#slides li:first-child").appendTo('#sliderWindow ul#slides')
            $("#sliderWindow ul#slides").css('left', '')
        })
    },
    interval: undefined,
};
$(Slider.setup);
