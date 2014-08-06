express = require 'express'
compression = require 'compression'

app = express()
app.use compression()

app.use '/', express.static "#{__dirname}/public/html"
app.use '/fonts', express.static "#{__dirname}/bin/fonts"
app.use '/js', express.static "#{__dirname}/public/js"
app.use '/css', express.static "#{__dirname}/public/css"
app.use '/test', express.static "#{__dirname}/public/test"

app.listen 3000
