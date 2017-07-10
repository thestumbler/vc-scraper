#!/bin/bash

# ========================================================================
# First problem, section "headers" are formatted as simple paragraphs, 
# not as HTML headers as in later versions of the newsletter
# this effected newsletters from the first of 2016 through to 4 Nov 2016
#
# These section names found without header tags,
# found thusly:
#   grep -h "</strong></p>" *.html | sort | uniq -c | sort -n#
#
# New Funding
# Data
# IPOs
# Jobs
# New Funds
# Exits
# New Fundings
# People
# Retail Therapy
# Top News in the A.M.
# Detours Essential Reads

# Convert these to H2 headers
# sed -i "" "s!<p><strong>New Funding</strong></p>!<h2><strong>New Funding</strong></h2>!" *.html
# sed -i "" "s!<p><strong>Data</strong></p>!<h2><strong>Data</strong></h2>!" *.html
# sed -i "" "s!<p><strong>IPOs</strong></p>!<h2><strong>IPOs</strong></h2>!" *.html
# sed -i "" "s!<p><strong>Jobs</strong></p>!<h2><strong>Jobs</strong></h2>!" *.html
# sed -i "" "s!<p><strong>New Funds</strong></p>!<h2><strong>New Funds</strong></h2>!" *.html
# sed -i "" "s!<p><strong>Exits</strong></p>!<h2><strong>Exits</strong></h2>!" *.html
# sed -i "" "s!<p><strong>New Fundings</strong></p>!<h2><strong>New Fundings</strong></h2>!" *.html
# sed -i "" "s!<p><strong>People</strong></p>!<h2><strong>People</strong></h2>!" *.html
# sed -i "" "s!<p><strong>Retail Therapy</strong></p>!<h2><strong>Retail Therapy</strong></h2>!" *.html
# sed -i "" "s!<p><strong>Top News in the A.M.</strong></p>!<h2><strong>Top News in the A.M.</strong></h2>!" *.html
# sed -i "" "s!<p><strong>Detours</strong></p>!<h2><strong>Detours</strong></h2>!" *.html
# sed -i "" "s!<p><strong>Essential Reads</strong></p>!<h2><strong>Essential Reads</strong></h2>!" *.html
#

# ========================================================================
# Another batch of files had a similar no header problem, 
# they had a header end-tag, just not a begin tag
#    just a tab, the header text, and </h2> tag
#
# Convert these to H2 headers
# sed -i "" $'s!^\tNew Funding</h2>!<h2><strong>New Funding</strong></h2>!' *.html
# sed -i "" $'s!^\tData</h2>!<h2><strong>Data</strong></h2>!' *.html
# sed -i "" $'s!^\tIPOs</h2>!<h2><strong>IPOs</strong></h2>!' *.html
# sed -i "" $'s!^\tJobs</h2>!<h2><strong>Jobs</strong></h2>!' *.html
# sed -i "" $'s!^\tNew Funds</h2>!<h2><strong>New Funds</strong></h2>!' *.html
# sed -i "" $'s!^\tExits</h2>!<h2><strong>Exits</strong></h2>!' *.html
# sed -i "" $'s!^\tNew Fundings</h2>!<h2><strong>New Fundings</strong></h2>!' *.html
# sed -i "" $'s!^\tPeople</h2>!<h2><strong>People</strong></h2>!' *.html
# sed -i "" $'s!^\tRetail Therapy</h2>!<h2><strong>Retail Therapy</strong></h2>!' *.html
# sed -i "" $'s!^\tTop News in the A.M.</h2>!<h2><strong>Top News in the A.M.</strong></h2>!' *.html
# sed -i "" $'s!^\tDetours</h2>!<h2><strong>Detours</strong></h2>!' *.html
# sed -i "" $'s!^\tEssential Reads</h2>!<h2><strong>Essential Reads</strong></h2>!' *.html

sed -i "" $'s!^\tMay !<h2>May !' *.html

# ========================================================================
# These files had extraneous <div> sections smack in the middle of the
# posts section which messed up the html parsing.
# There were a few of these in the 2017 "modern" formatted newsletters, too.
# Most of these <div> had a closing </div> tag, but a few did not
# deleted these manually, seemed easier than making an algorithm to do it
# 2016-02-19-index.html:<div>
# 2016-02-23-index.html:<div>
# 2016-02-24-index.html:<div>
# 2016-02-29-index.html:<div>
# 2016-03-07-index.html:<div>
# 2016-03-09-index.html:<div>
# 2016-03-15-index.html:<div>
# 2016-03-22-index.html:<div>
# 2016-04-07-index.html:<div>
# 2016-04-26-index.html:<div>
# 2016-06-06-index.html:<div>
# 2016-06-15-index.html:<div>
# 2016-06-22-index.html:<div>
# 2016-08-09-index.html:<div>
# 2016-08-18-index.html:<div>
# 2016-08-25-index.html:<div>
# 2016-08-31-index.html:<div>
# 2016-09-01-index.html:<div>
# 2016-09-12-index.html:<div>
# 2016-09-19-index.html:<div>
# 2016-10-03-index.html:<div>
# 2016-11-01-index.html:<div>
# 2016-11-02-index.html:<div>
# 2016-11-03-index.html:<div>


# ========================================================================
# Next, lots of these "paragraphs" 
#    <p>&#8212;&#8211;</p>
#    <p>&#8212;&#8212;</p>
#    &#8212;&#8211;</p>
#    <p>&#8212;-</p>
# which are actually dashes, em, en, or hyphens

# sed -i ''  '/^<p>\&#8212;\&#8211;<\/p>/d'  *.html
# sed -i ''  '/^\&#8212;\&#8211;<\/p>/d'  *.html
# sed -i ''  '/^<p>\&#8212;-<\/p>/d'  *.html
# sed -i ''  '/^<p>\&#8212;\&#8212;<\/p>/d'  *.html
