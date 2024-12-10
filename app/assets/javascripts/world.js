function isFreeMove(player_row, player_col, dest_row, dest_col) {
    const rowDiff = Math.abs(player_row - dest_row);
    const colDiff = Math.abs(player_col - dest_col);
    return (rowDiff === 1 && colDiff === 0) || (rowDiff === 0 && colDiff === 1);
}

function pollWithJitter() {
    // Polling logic
    const url = window.location.protocol + "//" + window.location.hostname + (window.location.port ? ":" + window.location.port : "");
    console.log("about to poll the server for image")
    // You can replace this with your actual polling code, e.g., making an API request
    
    // poll the server for the image with 10 sec
    let jitter = Math.random() * 4 - 2; 
    let nextPollDelay = 10000 + jitter * 1000; 
  
  
    setTimeout(pollWithJitter, nextPollDelay);
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
                $(".modal").find('button').click(async () => {
                    const csrfToken = $("meta[name='csrf-token']").attr("content");
                    const url = window.location.protocol + "//" + window.location.hostname + (window.location.port ? ":" + window.location.port : "");
                    const params = {
                        dest_row: parseInt(row), 
                        dest_col: parseInt(col),
                        world_id: worldId
                      };
                      const response = await fetch(`${url}/worlds/game/move`, {
                        method: 'POST',  // Use POST method
                        headers: {
                            'Content-Type': 'application/json',  // Send as JSON
                            'X-CSRF-Token': csrfToken            // Include CSRF token from meta tag
                          },
                        body: JSON.stringify(params),  // Send params as JSON in the request body
                      });
                      window.location.reload()
                      
                })
            }
        });});

    // TODO: implement polling with jitter
    // pollWithJitter()

    $(".x").click(() => {
        $(".modal").css("display", "none")
    })

    $(".xchat").click(() => {
        $(".chatmodal").css("display", "none")
    })

    function getHTMLForOneChat(chat, idx) {
        const isEven = idx % 2 == 0

        return `
            <div class="message_row ${isEven ? "oddrow" : ""}">
                <div>${chat.display_name}:</div>
                <div>${chat.content}</div>
            </div>
        `
    }

    async function populateChat() {
        const url = window.location.protocol + "//" + window.location.hostname + (window.location.port ? ":" + window.location.port : "");
        const response = await fetch(`${url}/messages/get/${worldId}`)
        const json = await response.json()
        console.log(json)
        $(".messagebox").empty() // clear all messages out
        json.forEach((message_row, idx) => {
            const html = getHTMLForOneChat(message_row, idx)
            $('.messagebox').append(
                html
            );
        });
    }

    $("#chat").click( async (e) => {
        e.preventDefault()
        $(".chatmodal").css("display", "flex")
        populateChat()
    })

    $(".send_chat").click(async () => {
        console.log("called")
        const csrfToken = $("meta[name='csrf-token']").attr("content");
                    const url = window.location.protocol + "//" + window.location.hostname + (window.location.port ? ":" + window.location.port : "");
                    const text = $('textarea.txtarea').val();
                    const params = {
                        world_id: worldId,
                        message: text
                      };
                      const response = await fetch(`${url}/messages/send`, {
                        method: 'POST',  // Use POST method
                        headers: {
                            'Content-Type': 'application/json',  // Send as JSON
                            'X-CSRF-Token': csrfToken            // Include CSRF token from meta tag
                          },
                        body: JSON.stringify(params),  // Send params as JSON in the request body
                      });
                      console.log(response)
        
        populateChat()
    }) 

});