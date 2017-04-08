# -*- coding: utf-8 -*-

import datetime
import glob
from bs4 import BeautifulSoup
import os
import sys
reload(sys)
sys.setdefaultencoding('utf-8')

def getfiledate(filename):
  "gets the system date of the filename"
  t=os.path.getmtime(filename)
  return datetime.datetime.fromtimestamp(t).strftime("%Y-%b-%d")

def vcparse( filename, htag ):
  "extracts desired sections from StrictlyVC daily newsletters"
  # ref:
  # http://vstark.net/2012/10/02/html-processing-with-python-and-beautifulsoup/
 
  # calculates how many entries are found
  # because some days they are at H2 levels, 
  # other days they are at H3 levels
  nent=0

  # Open the html file
  vcfile = open(filename)
  doc = BeautifulSoup(vcfile, "html.parser")
  fdate = getfiledate(filename)

  # Prepare array to store data
  entries = []

  # Find all specified header tags
  for section in doc.find_all(htag):

    # Get header text
    header = section.find_all(text=True)[0].split('.')

    # Get paragraph content
    content = []

    # Find next tag
    for p in section.find_next_siblings():

      # ... if it's specified header tag - then stop, as we reached next header
      # print p.name, p.text
      if p.name == htag:
        break

      # We can do some HTML cleanup here
      # ... remove 'span' tags
      if p.span:
        p.span.unwrap()
      # ... delete paragraph class
      del p['class']

      # Take care of newline characters
      # ... and tell Python to treat it as Unicode
      # content += unicode(p).replace("n", u' ')
      # print "===", len(p.text), " = ", p.text
      content.append(p.text)


    # Add new header plus its content into array
    entries.append([header, content])


  # Show the result
  # for e in entries: 
  for e in entries: 
    if "New Funds" in e[0]:
      # print "***", e[0]
      for p in e[1]: 
        nent += 1
        print fdate+"-nf:  ", p
    if "New Fundings" in e[0]:
      # print "***", e[0]
      for p in e[1]: 
        nent += 1
        print fdate+"-ng:  ", p


  return nent

def extract_key_data ( entries ):
  "this attempt to fetch the key data is nearly a complete failure"

  newfunds = []
  companies = []
  ageof = []
  basedin = []
  series = []
  howmuch = []

  for e in entries: 
     if "New Fundings" in e[0] or "New Funds" in e[0]:
       for p in e[1]: 
        # Get the company name, usually the words up until the first comma
        c = p.partition(',')[0]
        # Get the age of the company
        a = p.partition(", a ")[2].partition("-year-old")[0]
        # Location
        b = p.partition("-year-old, ")[2].partition("-based")[0]
        # amount raised
        h = p.partition("raised ")[2].partition("million")[0]
        # series
        s = "Series " + p.partition("Series ")[2].partition("fund")[0]
        # print c, a, b, h, s
        newfunds.append([c,a,b,h,s,p])
        # companies.append(c)
        # ageof.append(a)
        # basedin.append(b)
        # howmuch.append(h)
        # series.append(s)

  for e in newfunds: 
    print e[0], e[1], e[2], e[3], e[4]

  return


 
# test opening dirs in a specified directory
path = "./data/2017-02-*.html"
sep = "========================="
# for fn in os.listdir('./data'):
#   filename="./data/" + fn
for filename in glob.glob(path):
  if os.path.isfile(filename):
    print sep, filename, sep
    vcparse( filename, "h2" )
    vcparse( filename, "h3" )


# vcparse( "./data/2017-02feb-10-index.html" )
# vcparse( "./test.html", "h3" )
# vcparse( "./svc201702.html", "h2" )


