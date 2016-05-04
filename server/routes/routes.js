module.exports = function(server) {
    // Defining all the routes
    server.get('/', function(req, res) {
        res.render('index.html');
    });
    server.get('/post', function(req, res) {
        res.render('index.html');
    });
    server.get('/post/*', function(req, res) {
        res.render('index.html');
    });
    server.get('/topics', function(req, res) {
        res.render('index.html');
    });
    server.get('/topics/*', function(req, res) {
        res.render('index.html');
    });
    server.get('/login', function(req, res) {
        res.render('index.html');
    });

};