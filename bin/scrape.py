# -*- coding: utf-8 -*-

from __future__ import print_function

import datetime
import glob
from sys import argv
from bs4 import BeautifulSoup
import re
import os
import sys
reload(sys)
sys.setdefaultencoding('utf-8')

lineno=0

def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)

def getjulian(datestr):
  "gets the J2000-based Julian day based on the date string"
  # https://stackoverflow.com/questions/13943062/extract-day-of-year-and-julian-day-from-a-string-date-in-python
  # epochoffset is the number of days between python and unix epoch times
  # python being 1-Jan-0001 and Unix being 1-Jan-1970
  # adjusted further to make the epoch 1-Jan-2000 for this project
  # just to keep the numbers not unreasonably large
  # 1-Jan-0001 = 1721424 
  # 1-Jan-1970 = 2440587
  # 1-Jan-2000 = 2451545
  # 1-Jan-2010 = 2455197
  # 1-Jan-2016 = 2457388 
  # eprint("julian datestr: ", datestr)
  J0001 = 1721424 
  J1970 = 2440587
  J2000 = 2451545
  J2010 = 2455197
  J2016 = 2457388 
  epochoffset = J0001 - J2000
  y=int(datestr[:4])
  m=int(datestr[5:7])
  d=int(datestr[8:10])
  j=datetime.date(y,m,d).toordinal() + epochoffset
  # eprint("YYYYMMDD ", y, m, d, "Julian: ", j)
  return j

def getprettydatestr(datestr):
  mmm='Unk'
  y=datestr[:4]
  d=datestr[8:10]
  m=int(datestr[5:7])
  if m ==  1: mmm='Jan'
  if m ==  2: mmm='Feb'
  if m ==  3: mmm='Mar'
  if m ==  4: mmm='Apr'
  if m ==  5: mmm='May'
  if m ==  6: mmm='Jun'
  if m ==  7: mmm='Jul'
  if m ==  8: mmm='Aug'
  if m ==  9: mmm='Sep'
  if m == 10: mmm='Oct'
  if m == 11: mmm='Nov'
  if m == 12: mmm='Dec'
  return y + '-' + mmm + '-' + d

def getdatefromfile(filename):
  "gets the system date of the filename"
  t=os.path.getmtime(filename)
  return datetime.datetime.fromtimestamp(t).strftime("%Y-%m-%d")

def getdatefromheader(datestr):
  "gets the date from the header or title string"
  # Header string text is formatted as follows
  # StrictlyVC: February 24, 2017
  # Title string text is formatted as follows
  # StrictlyVC - February 24, 2017
  # The only difference being the separator before the date

  hdate=77
  hyear=9999
  hmon=88
  hname='Zebra'
  # get the date
  m = re.search(' ([0-9]*), ', datestr)
  if m: hdate=m.group(1)
  # get the year
  m = re.search(', ([0-9][0-9][0-9][0-9])$', datestr)
  if m: hyear=m.group(1)
  # get the month name
  m = re.search('^StrictlyVC: ([^ ]+) ', datestr)
  if m: hname=m.group(1)
  m = re.search('^StrictlyVC - ([^ ]+) ', datestr)
  if m: hname=m.group(1)

  # make the month number
  if 'Jan' in hname: hmon='01'
  if 'Feb' in hname: hmon='02'
  if 'Mar' in hname: hmon='03'
  if 'Apr' in hname: hmon='04'
  if 'May' in hname: hmon='05'
  if 'Jun' in hname: hmon='06'
  if 'Jul' in hname: hmon='07'
  if 'Aug' in hname: hmon='08'
  if 'Sep' in hname: hmon='09'
  if 'Oct' in hname: hmon='10'
  if 'Nov' in hname: hmon='11'
  if 'Dec' in hname: hmon='12'
  # print(hyear, "-", hmon, "-", hdate, sep='')
  hdrdate=str(hyear) + '-' + hmon + '-' + str(hdate).zfill(2)
  # print(hdrdate)
  return hdrdate

def vcparse( filename, htag ):
  "extracts desired sections from StrictlyVC daily newsletters"
  # ref:
  # http://vstark.net/2012/10/02/html-processing-with-python-and-beautifulsoup/
 
  global lineno
  # calculates how many entries are found
  # because some days they are at H2 levels, 
  # other days they are at H3 levels
  # finally, I dealt with this by just calling this function twice
  # I never saw any situation where h2 and h3 were mixed.

  # Open the html file
  vcfile = open(filename)
  # get the system file date as fallback
  fdate = getdatefromfile(filename)
  # parse the html
  doc = BeautifulSoup(vcfile, "html.parser")

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


  # initially assume that the newsletter date is the system file date
  # eprint("fdate: ", fdate)
  nldate=fdate
  nldatestr=getprettydatestr(nldate)
  jday = getjulian(fdate)
  # eprint("date,        default file system: ", fdate,     "J2000", jday)
  # reset the item counter
  item=0
  # it will be overridden if a newsletter date is found in the file
  # (a) in the title, in the case of a single-day newsletter
  # (b) in headers, in the case of archived, multi-day newsletters

  title=doc.title.text
  # eprint("Document Title: ", title)

  if u'StrictlyVC, LLC' not in title:
    titledate=getdatefromheader(title)
    nldate=titledate
    nldatestr=getprettydatestr(nldate)
    jday=getjulian(nldate)
    # eprint("date,  override using title date: ", titledate, "J2000", jday )

  # Show the result
  # for e in entries: 
  for e in entries: 
    #print ("***", e[0])
    if u'StrictlyVC' in e[0][0]:
      hdrdate=getdatefromheader(e[0][0])
      nldate=hdrdate
      nldatestr=getprettydatestr(nldate)
      jday=getjulian(nldate)
      # reset the item counter
      item=0
      # eprint("date, override using header date: ", hdrdate,   "J2000", jday)
    if u'New Funds' in e[0][0]:
      for p in e[1]: 
        item += 1
        seq=str(jday).zfill(4)+str(item).zfill(2)
        print(seq, nldatestr, " nf ", p, sep='\t')
    if u'New Fundings' in e[0][0]:
      for p in e[1]: 
        item += 1
        seq=str(jday).zfill(4)+str(item).zfill(2)
        print(seq, nldatestr, " ng ", p, sep='\t')

def extract_key_data ( entries ):
  "this attempt to fetch the key data is nearly a complete failure"

  # I'm doing this data extraction in a bash shell script, parse.sh
  # probably could be done in python, see comments in parse.sh 

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
    print (e[0], e[1], e[2], e[3], e[4])

  return


 
# path to data files is hard-coded here
# should learn to pass this as a command line argument
# path = "/files/proj/erudite/vc/data3/group-*.html"
# path = "/files/proj/erudite/vc/data-test/*.html"

# use command line argument for the filename
# using glob requires escaping the wildcard at the bash level
#   e.g., scrape 'data/*.html'
# using the array slice notation argv[1:] results in more natural
# commane line (no escaping quotes)
#   e.g., scrape data/*.html
sep = "========================="
for filename in argv[1:]:
  if os.path.isfile(filename):
    eprint (sep, filename, sep)
    print (sep, filename, sep)
    vcparse( filename, "h2" )
    vcparse( filename, "h3" )

