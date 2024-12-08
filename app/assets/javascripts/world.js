function isFreeMove(player_row, player_col, dest_row, dest_col) {
    const rowDiff = Math.abs(player_row - dest_row);
    const colDiff = Math.abs(player_col - dest_col);
    return (rowDiff === 1 && colDiff === 0) || (rowDiff === 0 && colDiff === 1);
}
$(function () {
    // it needs to be in here, or j query will not find shit!
    $(".grid_cell").each((index, cell) => {  // Note: the second argument is the actual DOM element
        $(cell).click(() => {
            const cellID = $(cell).find(".hidden").text()
            const rowCol = cellID.split('-')
            const row = rowCol[0]
            const col = rowCol[1]
            if (parseInt(row) === usr_row && parseInt(col) === usr_col) {
                $(".modal").css("display", "flex")
                $(".modal").find('h2').html(`You already are at ${row}, ${col}!`)
                $(".modal").find('h3').html("")
                $(".modal").find('button').css('display', 'none')
            }
            else {
                $(".modal").css("display", "flex")
                const isFreeText = isFreeMove(parseInt(usr_row),parseInt(usr_col), row, col) ? 'This move is free!' : 'This move costs 0.75 shards!'
                $(".modal").find('h2').html(`Are you sure you want to move to ${row}, ${col}? `)
                $(".modal").find('h3').html(`${isFreeText}`)

                $(".modal").find('button').css('display', 'flex')
            }
        });
        

    });

    $(".x").click(() => {
        $(".modal").css("display", "none")
        

    })
    const csrfToken = $("meta[name='csrf-token']").attr("content");
    console.log(csrfToken);

});