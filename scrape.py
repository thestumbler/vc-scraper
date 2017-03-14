# -*- coding: utf-8 -*-

from bs4 import BeautifulSoup

# Open HTML file
filename = open('svc201612.html')
filename = open('svc201611.html')
filename = open('svc201701.html')
filename = open('svc201702.html')
doc = BeautifulSoup(filename, "html.parser")

# Prepare array to store data
entries = []

# Find all 'h2' tags
for section in doc.find_all('h2'):

  # Get header text
  header = section.find_all(text=True)[0].split('.')

  # Get paragraph content
  content = []

  # Find next tag
  for p in section.find_next_siblings():

    # ... if it's 'h2' tag - then stop, as we reached next header
    # print p.name, p.text
    if p.name == 'h2':
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
#    if "New Fundings" in e[0] or "New Funds" in e[0]:
#      # print "***", e[0]
#      for p in e[1]: print p

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

# ref:
# http://vstark.net/2012/10/02/html-processing-with-python-and-beautifulsoup/
