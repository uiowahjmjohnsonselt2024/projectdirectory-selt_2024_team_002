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