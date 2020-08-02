var cancelledTimer = null;

$('document').ready(function() {
    Progress = {};

    Progress.Start = function(data) {
        clearTimeout(cancelledTimer);
        $("#progress-label").text(data.label);

        $(".progress-container").fadeIn('fast', function() {
            $("#progress-bar").stop().css({"width": 0, "background-color": "#3aaaf9"}).animate({
                width: '100%'
            }, {
                duration: parseInt(data.duration),
                complete: function() {
                    $(".progress-container").fadeOut('fast', function() {
                        $("#progress-bar").css("width", 0);
                        $.post('http://bs_progress/actionFinish', JSON.stringify({
                            })
                        );
                    })
                }
            });
        });
    };

    Progress.Cancel = function() {
        $("#progress-label").text("CANCELLED");
        $("#progress-bar").stop().css( {"width": "100%", "background-color": "#470000"});

        cancelledTimer = setTimeout(function () {
            $(".progress-container").fadeOut('fast', function() {
                $("#progress-bar").css("width", 0);
            });
        }, 1000);
    };

    Progress.Fail = function() {
        $("#progress-label").text("FAILED");
        $("#progress-bar").stop().css( {"width": "100%", "background-color": "#1e1e1e"});

        cancelledTimer = setTimeout(function () {
            $(".progress-container").fadeOut('fast', function() {
                $("#progress-bar").css("width", 0);
            });
        }, 1000);
    };

    Progress.CloseUI = function() {
        $('.main-container').fadeOut('fast');
    };
    
    window.addEventListener('message', function(event) {
        switch(event.data.action) {
            case 'start':
                Progress.Start(event.data);
                break;
            case 'cancel':
                Progress.Cancel();
                break;
            case 'fail':
                Progress.Fail();
                break;
        }
    });
});