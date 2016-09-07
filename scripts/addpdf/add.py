#!/usr/bin/env python
import os
import sys
from bs4 import BeautifulSoup
import csscompressor
import htmlmin
from pymongo import MongoClient
from bson.objectid import ObjectId

db = MongoClient(os.environ['MONGODB_URI']).get_default_database()


def main(htmlfile, cssfile, mongo_id, *args):
    with open(htmlfile) as f:
        soup = BeautifulSoup(f.read(), 'html.parser')
        html = unicode(soup.find(id='page-container'))
        html = htmlmin.minify(html, remove_comments=True, remove_empty_space=True)

    with open(cssfile) as f:
        css = csscompressor.compress(f.read())

    db.paper.update_one({
        '_id': ObjectId(mongo_id)
    }, {
        '$set': {
            'content.css': css,
            'content.html': html,
        }
    })


if __name__ == '__main__':
    sys.exit(0 if main(*sys.argv[1:]) else 1)
