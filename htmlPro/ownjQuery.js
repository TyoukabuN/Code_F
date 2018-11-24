function hideWhenClick() {
    $(document).ready(function () {
        $("p").click(function () { this.hide(); })
    }
    );
}

function hide2() {
    $(document).ready(function () {
        $("p").click(function () {
            $(this).hide();
        });
    }
    );
}