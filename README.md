# multri

multri is a web app for annotating research papers a la
[Genius](http://genius.com), designed with deep learning papers in mind. A copy
of this app is running at https://multri.herokuapp.com.

The backend uses [Livescript](http://livescript.net/). The frontend uses
[CoffeeScript with JSX](https://github.com/jsdf/coffee-react) with React/Redux,
and is compiled by Webpack into one big file.

## Installation

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
