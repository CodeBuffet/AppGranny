/*

    AppGranny bootstrap file
    Everything exposed in app will be mapped to the platform your compiling for!

*/

var lollol;
lol = 5 / 2;
IAmNotSoRandom = Math.random();

function IShouldntBeAccessible() {
    // IShouldntBeAccessible should become hidden in a local scope as it's not exposed in the app object.
    console.log("If you called me directly, something is wrong....")
}

app.lol = 5;

// Copy from typescript's module example
(function (app) {
    (function (Sayings) {
        var Greeter = (function () {
            function Greeter(message) {
                this.greeting = message;
            }
            Greeter.prototype.greet = function () {
                return "Hello, " + this.greeting;
            };
            return Greeter;
        })();
        Sayings.Greeter = Greeter;
    })(app.Sayings || (app.Sayings = {}));
    var Sayings = app.Sayings;
})(app || (app = {}));

app.app = {fuuu:5}

app.say = function(str) {
    IShouldntBeAccessible();

    lollol = "fuuuuuuuuu";

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