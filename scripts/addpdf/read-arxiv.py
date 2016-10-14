import json
import requests
import bs4
import sys


def main(url):
    r = requests.get(url)
    soup = bs4.BeautifulSoup(r.text, 'html.parser')

    title = soup.find('meta', name='citation_title')['content']
    url = soup.find('meta', name='citation_pdf_url')['content']

    print json.dumps({'title': title, 'url': url})


if __name__ == '__main__':
    sys.exit(0 if main(*sys.argv[1:]) else 1)
