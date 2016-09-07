# multri

multri is a web app for annotating PDFs a la
[Genius](http://genius.com). A copy of this app is running at
https://multri.herokuapp.com.

I designed this with deep learning papers in mind. Deep learning is
becoming very popular but many papers are still difficult for
layprogrammers to read. There's no documentation like there is for
React.  I hoped this would make things easier.

The backend uses [Livescript](http://livescript.net/). The frontend
uses [CoffeeScript with JSX](https://github.com/jsdf/coffee-react)
with React/Redux, and is compiled by Webpack into one big file.

## Usage

I'll publish it to npm at some point; for now just clone the repo. multri
uses MongoDB, so set the `MONGODB_URI` environment variable, then run

```
npm install
npm start
```

To add a paper, install
[pdf2htmlEX](https://github.com/coolwanglu/pdf2htmlEX) and
[Ghostscript](http://www.ghostscript.com/) (on OS X, these are
available via Homebrew), then go into [scripts/addpdf](scripts/addpdf)
and run

```
./addpdf.sh <link to pdf> <title>
```

Again, this will add the paper to the database specified by the
`MONGODB_URI` environment variable.

## multri's approach to dealing with callback hell

I use [asyncawait](https://www.npmjs.com/package/asyncawait). async
and await are implemented as functions, but since Livescript lets you
omit parentheses in function calls, they look enough like operators.
I found `async` and `await` annoyingly verbose, though, so I
aliased them as `$` and `_` in [common.ls](common.ls), which I load
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

I think it's ugly too, but until JavaScript supplies a better solution
than to write a five-letter keyword just to do the obvious thing, I'm
holding on to my apology.

Since asyncawait only works on Node, the frontend just uses ordinary
Promises.

## What does the name mean?

It's short for Multiverse Triangle. It's an inside joke, but it's
a parody of the name Cosmosquare. I might come up with a better name
at some point.
