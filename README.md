# multri

multri is a web app for annotating research papers a la
[Genius](http://genius.com), designed with deep learning papers in mind. A copy
of this app is running at http://www.multiversetriangle.com.

The backend uses [Livescript](http://livescript.net/). The frontend uses
[CoffeeScript with JSX](https://github.com/jsdf/coffee-react) with React/Redux,
and is compiled by Webpack into one big file.

## Installation & Usage

multri uses MongoDB, so set the `MONGODB_URI` environment variable, then run

    git clone https://github.com/brhs/multri
    npm install
    npm start

To run with nodemon, replace `npm start` with

    npm test

To build/watch the web app, run

    npm run build

To add a paper, install [pdf2htmlEX](https://github.com/coolwanglu/pdf2htmlEX)
and [Ghostscript](http://www.ghostscript.com/) (on OS X, these are available
via Homebrew), then go into [scripts/addpdf](scripts/addpdf) and run

    ./addpdf.sh <link to pdf> <title>

Again, this will add the paper to the database specified by the `MONGODB_URI`
environment variable.

## Roadmap

There are lots of things to be done. See the [todo
list](https://github.com/brhs/multri/projects/1?fullscreen=true).
