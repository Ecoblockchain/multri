# multri

multri is a web app for annotating research papers a la
[Genius](http://genius.com), designed with deep learning papers in mind. A copy
of this app is running at https://multri.herokuapp.com.

The backend uses [Livescript](http://livescript.net/). The frontend uses
[CoffeeScript with JSX](https://github.com/jsdf/coffee-react) with React/Redux,
and is compiled by Webpack into one big file.

## Usage

multri uses MongoDB, so set the `MONGODB_URI` environment variable, then run

```
git clone https://github.com/brhs/multri
npm install
npm start
```

To add a paper, install [pdf2htmlEX](https://github.com/coolwanglu/pdf2htmlEX)
and [Ghostscript](http://www.ghostscript.com/) (on OS X, these are available
via Homebrew), then go into [scripts/addpdf](scripts/addpdf) and run

```
./addpdf.sh <link to pdf> <title>
```

Again, this will add the paper to the database specified by the
`MONGODB\_URI` environment variable.

## multri's defense against callback hell

I use [asyncawait](https://www.npmjs.com/package/asyncawait). async
and await are implemented as functions, but because Livescript lets you
omit parentheses in function calls, they look enough like operators.
`async` and `await` are annoyingly verbose, though, so I
aliased them as `$` and `\_` in [common.ls](common.ls), which I load
with:

```livescript
global <<< require './common'
```

Example usage:

```livescript
app.get '/someroute', $ (i, o) ->  # a function that uses await
  doc = _ Model.find({})           # await the promise returned by Model.find
  o.json({doc})
```

I think it's ugly too. I wish JavaScript would supply a better
solution than to write a five-letter keyword just to do the obvious
thing.

asyncawait only works on Node, so the frontend just uses ordinary
Promises.
