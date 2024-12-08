$(function () {
    // it needs to be in here, or j query will not find shit!
    $(".grid_cell").each((index, cell) => {  // Note: the second argument is the actual DOM element
        $(cell).click(() => {
            const cellID = $(cell).find(".hidden").text()
            const rowCol = cellID.split('-')
            const row = rowCol[0]
            const col = rowCol[1]
            $(".modal").css("display", "flex")
            $(".modal").find('h2').html(`Are you sure you want to move to ${row}, ${col}?`)
        });
        

    });

    $(".x").click(() => {
        $(".modal").css("display", "none")


    })


});