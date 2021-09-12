$(function () {
    function display(bool) {
        if (bool) {
            $("#container").show();
        } else {
            $("#container").hide();
        }
    }

    function helpfunc(bool) {
        if (bool) {
            $(".help").show();
        } else {
            $(".help").hide();
        }
    }

    display(false)
    helpfunc(false)

    window.addEventListener('message', function(event) {
        var item = event.data;
        if (item.type === "ui") {
            if (item.status == true) {
                display(true)
            } else {
                display(false)
            }
        }else if (item.type == "help") {
            if (item.status == true) {
                helpfunc(true)
            }
            else{
                helpfunc(false)
            }
        }
    })
    
    document.onkeyup = function (data) {
        if (data.which == 27) {
            $.post('http://Nakres_objespawns/exit', JSON.stringify({}));
            return
        }
    };

    $("#buttons").click(function () {
        let inputValue = $("#input").val()
        if (inputValue.length >= 100) {
            $.post("http://Nakres_objespawns/error", JSON.stringify({
                error: "Bu kadar uzun giremezsin"
            }))
            return
        } else if (!inputValue) {
            $.post("http://Nakres_objespawns/error", JSON.stringify({
                error: "Geçerli bir değer girmelisin"
            }))
            return
        }
        $.post('http://Nakres_objespawns/objectspawn', JSON.stringify({
            objname: inputValue,
        }));
        return;
    })

    $("#deleteobj").click(function () {
        let inputValue = $("#input").val()
        if (inputValue.length >= 100) {
            $.post("http://Nakres_objespawns/error", JSON.stringify({
                error: "Bu kadar uzun giremezsin"
            }))
            return
        } else if (!inputValue) {
            $.post("http://Nakres_objespawns/error", JSON.stringify({
                error: "Geçerli bir değer girmelisin"
            }))
            return
        }
        $.post('http://Nakres_objespawns/deleteobj', JSON.stringify({
            objname: inputValue,
        }));
        return;
    })
})
