# -*- coding: utf-8 -*-

import sys
import urllib2
from BeautifulSoup import BeautifulSoup, Tag, NavigableString
from urlparse import urlparse
import re
import htmlentitydefs

date1 = re.compile('(\d\d\d\d)/(\d\d)/(\d\d)')

deref1 = re.compile('&([^;]*);')

def deref_text(text):
    result = ''
    i = 0
    while True:
        match = deref1.search(text, i)
        if match is None:
            result += text[i:]
            break
        result += text[i:match.start()]
        i = match.end()
        name = match.group(1)
        if name in htmlentitydefs.name2codepoint.keys():
            result += unichr(htmlentitydefs.name2codepoint[name]).encode('utf-8')
        else:
            result += match.group(0)
    return result.replace('\xc2\xa0', ' ')


def tag2text(out, tag):
    if isinstance(tag, Tag):
        for child in tag.contents:
            tag2text(out, child)
        if (tag.name == 'p'):
            out.append('\n\n')
        if (tag.name == 'img'):
            out.append('![]()')
        if (tag.name == 'br'):
            out.append('\n')
        if (tag.name in ('ol', 'ul')):
            out.append('\n')
    elif isinstance(tag, NavigableString):
        text = deref_text(str(tag).strip())
        if len(text):
            p = tag.parent
            if p.name == 'a':
                href = p[u'href'].encode('utf-8')
                out.append('[%s](%s)' % (text, href))
            elif p.name == 'strong':
                out.append('**%s**' % text)
            elif p.name == 'li':
                if p.parent.name == 'ul':
                    out.append('* %s\n' % text)
                elif p.parent.name == 'ol':
                    out.append('1. %s\n' % text)
                else:
                    out.append('? %s\n' % text)
            elif p.name == 'pre':
                out.append('```\n%s\n```\n\n' % text)
            elif p.name in ('h2', 'h3', 'h4'):
                out.append('## %s\n\n' % text)
            elif p.name == 'p' and p.has_key('class') \
                    and p['class'] == 'callout':
                out.append('> %s' % text)
            else:
                out.append(text)


def body2text(contents):
    list = []
    for child in contents:
        tag2text(list, child)
    return ''.join(list)

def fetch(url):
    rawdata = urllib2.urlopen(url).read()
    #unidata = unicode(rawdata, 'utf-8')
    soup = BeautifulSoup(rawdata)

    title = soup.h1.renderContents().strip()
    summary = ''.join(map((lambda d: d.renderContents().strip()),
        soup('div', { 'class': 'summary' })))
    permalink = urlparse(url).path
    body = body2text(soup('div', { 'class': 'description' }))
    return { 'title':title, 'summary':summary, 'permalink':permalink,
            'body':body }

def write_blog(data):
    if sys.platform == 'win32':
        import os, msvcrt
        msvcrt.setmode(sys.stdout.fileno(), os.O_BINARY)
    out = sys.stdout
    out.write('''---
layout: en-doc
title: %(title)s
summary: %(summary)s
#sort-priority: 0
#page-id: foo-bar-baz
---
%(body)s
''' % data)
    out.close()

def extract_blog(url):
    write_blog(fetch(url))

if __name__ == '__main__':
    extract_blog(sys.argv[1])
