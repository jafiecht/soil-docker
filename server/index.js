//Imports
//////////////////////////////////////////////////////////////////
const express = require('express');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');
const keys = require('./keys');
require('./models/Task');

//Middleware
//////////////////////////////////////////////////////////////////
mongoose.connect(keys.mongoURI, { useNewUrlParser: true }, (err) => {
  if(err) {
    console.log(err);
  }
});

const app = express();

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(express.static('../client/build'));
app.use(express.static('public'));


//Limit request rate
const rateLimit = require('express-rate-limit');
const requestLimiter = rateLimit({
  windowMs: 5 * 60 * 1000,
  max: 1
});
app.use("/submit", requestLimiter);

const statusLimiter = rateLimit({
  windowMs: 5 * 60 * 1000,
  max: 30
});
app.use("/status", statusLimiter);


/*Nessesary while in development*/
app.use(function (req, res, next) {
  res.setHeader('Access-Control-Allow-Origin', 'http://localhost:3000');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST');
  res.setHeader('Access-Control-Allow-Headers', 'X-Requested-With,content-type');
  res.setHeader('Access-Control-Allow-Credentials', false);
  next();
});


//Routes
//////////////////////////////////////////////////////////////////
require('./routes')(app);

app.get('*', function(request, response){
  response.sendFile('../client/build/index.html');
});

app.listen(5000, function() {
  console.log('Listening on port 5000');
})

