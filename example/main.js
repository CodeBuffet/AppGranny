/*

AppGranny bootstrap file
Everything exposed in app will be mapped to the platform your compiling for!

*/

app = {

};

lol = 5;

app.app = {fuuu:5}

app.say = function(str) {
    // the Granny object may be used for stripping code ahead-of-time,
    // it stays accessible at runtime!
    var prefix = "Granny on " + Granny.platform + " Says";
    console.log(prefix + ": " + str);
}

app.vars = {
    lol: 1,
    fuuuu: "YEAAHß"
}

// Demo of powerful code stripping in AppGranny - this code is stripped out if not compiled on android
if(Granny.platform == "android") {
    android = "lol";
    app.androidOnlyFunction = function(lol) {
        console.log ("Woooooooow - you are a android guy aren't you?")
    }
}

app.random = function(max, min) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
};