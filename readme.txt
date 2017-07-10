= Scraping and Parsing of Strictly VC Newsletters =

= Goals =

Scrape text from the New Funds and New Funding sections of the
daily Strictly VC newsletters ( http://www.strictlyvc.com )

Parse the extracted text for certain key pieces of information,
taking advantage of the regular structure of the announcements.

= Approach =

Because this is a one-off task, my approach was to get it done 
as quickly as possible, using existing tools that I know, minimizing time
spent learning new software and libraries.  Therefore, the result isn't
pretty, but it works.

= Fetching the Files =

There are three possible ways to get the newsletters:
  1.  groups of newsletters in a single file
  2.  individual newsletter files scraped from the website
  3.  individual newsletter files saved from email

The filenames contain the date, but 
  - they are in reverse order needed for sorting
  - months are spelled out instead of numerical.  

The filenames are different depending on whether you save them from the email 
links or fetch them from the site's archives.
    
1.  Some newsletters show up in the archives grouped together, with
    multiple days in a single html file.  These files require a bit more
    care to extract the correct date for each item, because it changes
    within the file.  These can be found in the archive section of the
    website
    
2.  When you scrape individual newsletters from the website, files are in this format:
      `.../strictlyvc-april-5-2017/index.html`

    The directory structure for storing archived newsletters on the 
    website isn't clear, other then the division by year.  So we just
    grab all the index.html files and toss them into one directory.
    
    - Fetch a year's worth of newsletters using a wget command 
      such as these:
      
      `$ wget -r --no-parent https://www.strictlyvc.com/2016/`
      `$ wget -r --no-parent https://www.strictlyvc.com/2017/`

    - Rename all the index.html files to be the name of their parent
      directory (see script file fix-parents-names.sh )
      
      `$ fix-parents-names.sh`

      For example, this file 
      `./www.strictlyvc.com/......./strictlyvc-april-5-2017/index.html`
      will become
      `./data/strictlyvc-april-5-2017-index.html`
   
    - remove those filenames NOT beginning with "strictlyvc-"
      these are summary files containing multiple newsletters, such as:
        `2-index.html`
        `2017-index.html`

    - Then clean up the filenames using script fix-names-website.sh
        `$ fix-names-website.sh`   
  
      Files of this form:
        `./data/strictlyvc-april-5-2017-index.html`
      become of this form:
        `./data/2017-04-05-index.html`
   

3.  When you save the newsletter from an email, the files are in this
    format: 
      `StrictlyVC - April 5, 2017.html`
      
    On my Mac using Apple's mail, the only way I could find to save them
    as HTML files was as follows:
      * click on the "View it in your browser" link at the top of each
        email
      * From the Safari window thus opened, do File -> Save As (CMD-S)
    
    After "saving" a group of newsletters, clean up the filenames using 
    the script fix-names-email.sh
        `$ fix-names-email.sh`   
  
      
= Scraping the Files =
      
After an aborted attempt using R, (see mytest.r), ended up using Python
and Beautiful Soup.  Result is in scrape.py.

== Notes on the HTML Layout ==

  * The posts we want are inside a division called post-entry:
			`<div class="post-entry">`

  * Posts are grouped into these sections, and we're interested in New Funds
    and New Funding:
    - Data
    - Detours Essential Reads
    - Exits
    - IPOs
    - Jobs
    - *New Funds*
    - *New Funding*
    - *New Fundings*
    - People
    - Retail Therapy
    - Top News in the A.M.

  * These section headers are identified in HTML as either H2 or H3
    level headers.  It changes from day to day, but so far it's always
    consistent within a single newsletter.  I've only seen H2 and H3.
    Never H1, H4, H5, ...

  * Each desired entry is *usually* flagged as a separate paragraph with
    <p> and </p> tags.

  * Sometimes, one or both paragraph tags are missing, thwarting the
    efforts of the HTML parsing algorithm of Beautiful Soup.  These have
    to be fixed manually

  * Sometimes, spurious <div> </div> tags are inserted randomly in the
    sections of interest, often as a pair, sometimes just a single
    unbalanced tag.  These *really* thwart the efforts of the HTML 
    parsing algorithm of Beautiful Soup and have to be fixed manually.
    Used sed script to aid finding them.  See script fix-noheaders.sh

  * Quite a few newslettes have this combination of em's en's and
    hyphens that also cause havock with the BS HTML parser.  Deleted
    most of them by sed, see script fix-noheaders.sh
      `<p>\&#8212;\&#8211;</p>`
      `\&#8212;\&#8211;</p>`
      `<p>\&#8212;-</p>`
      `<p>\&#8212;\&#8212;</p>`

  * In newsletters from the first of 2016 through to 4 Nov 2016, the
    section headers were NOT identified as HTML headers.  They were
    instead formatted as simple paragraphs.  After identifying all the
    section headers using grep, made a script file to change these into
    H2 headers like used in the "modern" layout.  See script file
    fix-noheaders.sh.  For example:

       WAS:  <p><strong>New Funding</strong></p>
        IS:  <h2><strong>New Funding</strong></h2>

  * There is a Python package to clean up html, presumably it could
    eliminate some of these issues, but I couldn't get it to work
    quickly.  See "lxml" and "PyTidyLib".

  * I don't think the author(s) of the Strictly VC newsletters inserted
    these formatting variations and anamolies to counter scraping
    efforts.  I think they are a side-effect of the newsletter
    preparation workflow.


== Perform the Scraping ==

  * Run the program scrape.py, which will loop over all the html files
    and generate a summary line of text for each "report" from the
    desired two sections.  Format is as follows:
    
  * For now, the directory containing the html files is hard-coded in
    the python script
    
  * The output file is formatted as follows:

{{{
     ITEM     DATE      NEW   FREE-FORM-TEXT-DESCRIPTION
     ====  ===========  ===   ============================================
       1   2016-Jan-06   ng   Aver, a 5.5-year-old, Columbus, Oh.-based....
       2   2016-Jan-06   ng   Entac Medical, a 4.5-year-old, Memphis,...
       3   2016-Jan-06   ng   Flatiron Health, a three-year-old, New York...
}}}

  * Iteratively observe the output, and edit the html files as necessary
    to clean up the kinds of html formatting issues mentioned above,
    repeating until the output is "clean"
    
= Parsing the Files =

The parser script file parse.sh reads through the free-form descriptive
text and attempts to identify the company name, age, location, type of
and amount of funding.  These descriptions are written in a regular,
almost formulatic style making this crude parsing attempt reasonably
effective, well over 50% succcess.

The parser also might have to be run iteratively (along with the
scraper) while cleaning up the index.html files.  Repeat until parser
output looks "clean".

Note:  It's pretty important to get the company name correct, so this is
one parser output file which MUST be manually edited.  It also must have
an equal number of entries as the scraped data (where as the other
parsed entries may skip entries on which it fails).

If the scraped output file is called out.dat, then parsing proceeds like
this (to parse all fields):

  `$ parse.sh out.dat`
  
or 

  `$ parse.sh out.dat [name|age|base|series|bucks]`

to parse any one specific field.

after editing the name file parsed_names_raw, save it as parsed_names,
and run the parser one final time to merge everything:

  `$ parse.sh out.dat merge`
  
The result will be a monster tab-separated file containing all the
parsed fields, plus the original descriptive text, suitable for
importing into a spreadsheet program.


= Selecting a Topic - Internet of Things and Artificial Intelligence =

The script file filter.sh searches the merged file from the above
parsing process, and extracts two files containing all companies where
the desired search terms are located:
  - grep-ai.txt
  - grep-iot.txt




