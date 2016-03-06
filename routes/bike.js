"use strict";
module.exports = {
    prepare_headers: function(req, res, next){
        [
	    ['Content-Type', 'text/html']
           ,['Expires', 'Mon, 26 Jul 1997 05:00:00 GMT'] //Дата в прошлом 
           ,['Cache-Control', ' no-cache, must-revalidate']// HTTP/1.1 
           ,['Pragma', ' no-cache']
       ].forEach(cV => res.setHeader(cV[0], cV[1]));

        next();
    }
   ,parse_post: function(job){
        return new Promise(function(resolve, reject){
            if (job.request.method == 'POST') {
                var body = '';

                job.request.on('data', function (data) {
                    body += data;
                    //TODO размер - в config
                    if (body.length > 4096){
                        job.request.connection.destroy();
                        reject();
                    }
                });

                job.request.on('end', function () {
                    var qs = require("querystring");
                    job.request.post = qs.parse(body);
                    resolve(job);
                });
            }else{
                job.request.post = {};
                resolve(job);
            }
        });
    }
   ,parse_cookies: function(job){
        //console.log(job);
        return new Promise(function(resolve, reject){
            job.request.cookies = {};
            "cookie" in job.request.headers &&
            
                job.request.headers.cookie.split(';')
                                          .map(cV => cV.split('='))
                                          .map(cV => cV.length == 2 ? cV : null)
                                          .forEach(cV => cV && (job.request.cookies[cV[0].trim()] = cV[1].trim()));
            resolve(job);
        });
    }
    ,start_session: function(req, res, next){
        //request.cookies = parseCookies(request); 
        if(!("id" in req.cookies && req.cookies.id.trim() != '')){
            console.log("start session: id not found");
	    next();
            return;
        }
        //тянем сессию
        var pg = require("pg");
        var config = require("./config");
        pg.connect(config.common.postgres, function (err, pgClient, done) {
	    if(err){
                console.log(err);
                res.status(500).end();
    	        return;
	    }
            pgClient.query({
                text: "SELECT * FROM users WHERE sid = $1;"
	       ,values: [req.cookies.id]
	    }, function(err, result){
                if(err){
                    console.log(err);
                    res.status(500).end();
    	            return;
                }
                done();
                switch(true){
	            case err:
	                console.log(err); //не надо тут ставить break!!!
                    case result.rows.length != 1:
                        reject();
                        return;
                }
                req.user = result.rows[0];
		next();
            });
        });
    }
   ,output: function(job){
        var mustache = require("mustache");
        if("status" in job.response.habr){
            job.response.writeHead(job.response.habr.status.code, job.response.habr.status.message, job.response.habr.headers);
        }else{
            job.response.writeHead(200, "Ok", job.response.habr.headers);
        }
        if("pattern" in job.response.habr){
            "user" in job.request && (job.response.habr.data.user = job.request.user);
            var output = mustache.render(job.response.habr.pattern, job.response.habr.data, job.response.habr.patterns);
            job.response.write(output);
        }
        job.response.end();
    }
   ,err: function(res){
        res.writeHead(500, "Internal Server Error", {});
        res.end();
    }
};
