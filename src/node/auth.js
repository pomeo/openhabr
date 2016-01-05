var http = require("http");
var qs = require('querystring');
var fs = require("fs");
var pg = require("pg");
var sha3 = require("js-sha3").sha3_512;
var mustache = require("mustache");
var url = require('url');

var config = require("./config");

var auth = fs.readFileSync("./tpl/auth.tpl", "utf-8");
var footer = fs.readFileSync("./tpl/footer.tpl", "utf-8");

var rndHex = function (len) {
    var id = '';
    var map = '0123456789abcdef';

    for (var $i = 0; $i < len; $i++) {
        id += map.charAt(Math.floor(Math.random() * 16));
    }

    return id;
};

var worker = function(request, response){
    
    //проверим action
    //если newuser - пришли данные на регистрацию
    console.log(request.post);
    console.log(request.url);
    switch(request.url){
        case "/":
            //если нет никаких данных - просто выводим форму авторизации
            var headers = {};

            headers['Content-Type'] = 'text/html';
            headers['Expires'] = 'Mon, 26 Jul 1997 05:00:00 GMT'; //Дата в прошлом 
            headers['Cache-Control'] = ' no-cache, must-revalidate'; // HTTP/1.1 
            headers['Pragma'] = ' no-cache'; // HTTP/1.1 
            //headers['Last-Modified'] = ".gmdate("D, d M Y H:i:s")."GMT");

            response.writeHead(200, "Ok", headers);
            //TODO  тут вообще то если пользователь уже авторизован - надо бы ему сообщать об этом
            var data = {"return": "referer" in request.headers ? request.headers.referer : "/"};
            if("user" in request) data.user = request.user;
            var output = mustache.render(auth, data, {footer: footer});
            response.write(output);
            //response.write(JSON.stringify(result.rows));
            response.end();
            break;
        case "/auth/login/":
            console.log("/login/");
            pg.connect(config.common.postgres, function (err, pgClient, done) {
	        if(err){
                    console.log(err);
                    response.end();
    	            return;
	        }
                var sql = "select * from auth($1, $2, $3);";
                pgClient.query({
                    text: sql
	           ,values: [request.post.nickname, sha3(request.post.sword), rndHex(128)]
	        }, function(err, result){
                    done();
	            if(err){
                        console.log(err);
                        response.end();
    	                return;
	            }
                    console.log(result.rows);
                    //здесь и выводим
                    if(result.rows.length != 1){
                        //что то пошло не так
                    }
                    //response.user = result.rows[0];
                    if("return" in request.post){
                        var parsed = url.parse(request.post.return);
                        headers["Location"] = parsed.hostname == "openhabr.net" ? request.headers.referer : "/"
                    }else{
                        headers["Location"] = "/";
                    }
                    headers['Content-Type'] = 'text/html';
                    headers['Expires'] = 'Mon, 26 Jul 1997 05:00:00 GMT'; //Дата в прошлом 
                    headers['Cache-Control'] = ' no-cache, must-revalidate'; // HTTP/1.1 
                    headers['Pragma'] = ' no-cache'; // HTTP/1.1 
            
                    response.writeHead(303, "See Other", headers);
                    response.end();
                });
            });
            break;
        case "/logout/":
            var headers = {};

            headers["Set-Cookie"] = 'id=; path=/; HttpOnly;';
            //console.log(request.headers);
            if("referer" in request.headers){
                var parsed = url.parse(request.headers.referer);
                headers["Location"] = parsed.hostname == "openhabr.net" ? request.headers.referer : "/"
            }else{
                headers["Location"] = "/";
            }
            //return;
            headers['Content-Type'] = 'text/html';
            headers['Expires'] = 'Mon, 26 Jul 1997 05:00:00 GMT'; //Дата в прошлом 
            headers['Cache-Control'] = ' no-cache, must-revalidate'; // HTTP/1.1 
            headers['Pragma'] = ' no-cache'; // HTTP/1.1 
            //headers['Last-Modified'] = ".gmdate("D, d M Y H:i:s")."GMT");
            
            response.writeHead(303, "See Other", headers);
            response.end();
            break;
    }
};
var parseCookies = function (request) {//TODO audit&refactoring&error handling
    //console.log(this.headers);
    var cookies = {};

    if (request.headers.cookie !== undefined) {
        var rc = request.headers.cookie.split(';');

        for (var cookie in rc) {
            var parts = rc[cookie].split('=');
            //TODO проверка на разбивку (должно быть точно два элемента)
            if (parts.length !== 2) {
                //this.forbidden();
                console.log("wrong cookies");
            }else{
                cookies[parts[0].trim()] = parts[1].trim();
            }
        }
    }
    //console.log(this.cookies);
    return cookies;
};
var start_session = function(request, response){
    request.cookies = parseCookies(request); 
    if("id" in request.cookies){
        //тянем сессию
        pg.connect(config.common.postgres, function (err, pgClient, done) {
	    if(err){
                console.log(err);
                response.end();
    	        return;
	    }
            var sql = "SELECT * FROM users WHERE sid = $1;"
            pgClient.query({
                text: sql
	       ,values: [request.cookies.id]
	    }, function(err, result){
                done();
	        if(err){
		    console.log(err);
                    response.end();
		    return;
	        } 
                if(result.rows.length == 1){
                    request.user = result.rows[0];
                }
                worker(request, response);
            });
        });
    }else{
        worker(request, response);
    }
};
var starter = function (request, response) {
    if (request.method == 'POST') {
        var body = '';

        request.on('data', function (data) {
            body += data;

            if (body.length > 4096)
                request.connection.destroy();
        });

        request.on('end', function () {
            request.post = qs.parse(body);
            start_session(request, response);
        });
    }else{
        request.post = {};
        start_session(request, response);
    }
};

http.createServer(starter).listen(7504, "localhost");
console.log('auth.server running at http://localhost:7504');
