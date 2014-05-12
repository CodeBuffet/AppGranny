/*

AppGranny bootstrap file
Everything exposed in app will be mapped to the platform your compiling for!

*/

app = {

};

app.random = function(max, min) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
};

exports.app = app;