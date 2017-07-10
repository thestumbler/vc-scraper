#!/bin/bash

# ========================================================================
# Some newsletters in 2017, section "headers" are formatted with only
# the trailing </H2> tag.
#
# These section names found without header tags,
# found thusly:
#   grep  "</h2>" *.html
#
# These lines all appear to begin with a tab
#
# Convert these to proper H2 headers
sed -i "" $'s!\tNew Funding</h2>!<h2><strong>New Funding</strong></h2>!' *.html
sed -i "" $'s!\tData</h2>!<h2><strong>Data</strong></h2>!' *.html
sed -i "" $'s!\tIPOs</h2>!<h2><strong>IPOs</strong></h2>!' *.html
sed -i "" $'s!\tJobs</h2>!<h2><strong>Jobs</strong></h2>!' *.html
sed -i "" $'s!\tNew Funds</h2>!<h2><strong>New Funds</strong></h2>!' *.html
sed -i "" $'s!\tExits</h2>!<h2><strong>Exits</strong></h2>!' *.html
sed -i "" $'s!\tNew Fundings</h2>!<h2><strong>New Fundings</strong></h2>!' *.html
sed -i "" $'s!\tPeople</h2>!<h2><strong>People</strong></h2>!' *.html
sed -i "" $'s!\tRetail Therapy</h2>!<h2><strong>Retail Therapy</strong></h2>!' *.html
sed -i "" $'s!\tTop News in the A.M.</h2>!<h2><strong>Top News in the A.M.</strong></h2>!' *.html
sed -i "" $'s!\tDetours</h2>!<h2><strong>Detours</strong></h2>!' *.html
sed -i "" $'s!\tEssential Reads</h2>!<h2><strong>Essential Reads</strong></h2>!' *.html



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
