# GeoNag

We had some trouble with our test file and getting a  “use of unresolved identifier” error for our all of out custom models in the test files. We set up all the targets properly (and double/triple/quadruple checked) and even tried making the classes public (per recomendation of GitHub). This problem does not always occur when running the tests, however, if it does occur cleaning the build for every test file (shift-control-k) solves the problems and the tests will run (and pass).

REMEMBER WHEN IN DOUBT TRY AND TRY AGAIN WHEN IT COMES TO CLEANING THE BUILD :)

Link to video of the tests passing just in case: https://cmu.box.com/s/p3e36dhvyzx7kh1z2jv0wpurdnojd6os
