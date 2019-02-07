var quotes = [
    "improvising recipes from stuff in my fridge.",
    "lurking various sneaker and fashion forums.",
    "binging TV shows and movies on Netflix.",
    "curating my Spotify playlists and discovering new tracks.",
    "reading and catching up on manga.",
    "learning more about Android development.",
    "wasting money to feed my materialistic needs.",
    "browsing Reddit.",
    "staring at my ceiling.",
    "staying up until 4AM doing random stuff.",
    "enveloped in a warm duvet, napping/sleeping.",
    "contemplating my soul-crushing student debt."
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