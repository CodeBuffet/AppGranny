/*

AppGranny bootstrap file
Everything exposed in app will be mapped to the platform your compiling for!

*/

app = {

};

int = 5;

app.app = {fuuu:5}

app.say = function(str) {
    var prefix = "Granny Says";
    console.log(prefix + ": " + str);
}

app.vars = {
    lol: 1,
    fuuuu: "YEAAHß"
}

app.random = function(max, min) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
};