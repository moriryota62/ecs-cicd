'use strict';
const http = require('http');
// const body = require('./body.js')
const env  = process.env

const server = http.createServer((req, res) => {
    res.writeHead(200, {'Content-Type': 'text/html; charset=utf-8'});
    res.write(`
    <!DOCTYPE html>
        <html lang="ja">
            <body>
                <h1>2020 09 24 17:00</h1>
                <h1> ${env.taskdefver} </h1>
            </body>
    </html>`);
    res.end();
});

const port = 80;
server.listen(port, () => {
    console.log('Listening on ' + port);
});
