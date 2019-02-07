var quotes = [
    "looking for parts to upgrade my computer.",
    "searching for inspiration.",
    "discovering music on Spotify.",
    "learning more about data analysis pipelines.",
    "trying to motivate myself to go to the gym.",
    "playing hockey with my league team the Fantasia Flops.",
    "staring at the ceiling.",
];

var counter = 0; 
var timerRef;

function cycleQuotes() {
    if (counter >= quotes.length) {
        counter = 0;
    }   
    var quote = quotes[counter++];
    $("#quote").fadeOut("slow", function() {
         $("#quote").html(quote);
    });
    $("#quote").fadeIn("slow");
}

$(function() {
    clearInterval(timerRef);
    timerRef = setInterval(cycleQuotes, 5000);
});
