#!/bin/bash

# ========================================================================
# Newsletters since March 2017 have strange tables with zero content
# that completely messes up any attempt to parse.
#
# There are three versions of these null tables:
# (ignoring various color variations of border-top-color, which is solved by wild-card character in the match string
#
# </div></td></tr></tbody></table></td></tr></tbody></table></div><div><table style="border-collapse:separate;border-spacing:0px;table-layout:fixed;" cellpadding="5" cellspacing="5"><tbody><tr><td></td></tr></tbody></table><table style="width:100%;border-collapse:separate;table-layout:fixed;" cellspacing="0" cellpadding="0"><tbody><tr><td style="background:#FFFFFF;"><table width="100%" cellspacing="0" cellpadding="0" style="border-collapse:separate;border-spacing:0px;table-layout:fixed;"><tbody><tr><td width="100%" style="width:100%;border-top-color:#8fa1d9;border-top-style:solid;border-top-width:2px;" ></td></tr></tbody></table></td></tr></tbody></table></div><div><table style="border-collapse:separate;border-spacing:0px;table-layout:fixed;" cellpadding="5" cellspacing="5"><tbody><tr><td></td></tr></tbody></table><table style="width:100%;border-collapse:separate;table-layout:fixed;background:#FFFFFF;" cellspacing="15" cellpadding="0"><tbody><tr><td style="background:#FFFFFF;"><table width="100%" cellspacing="0" cellpadding="0" style="border-collapse:separate;border-spacing:0px;table-layout:fixed;"><tbody><tr><td style="vertical-align:top;"><div style="word-wrap:break-word;line-height:140%;text-align:left;"><h2 align="left" style="line-height: 1.2em; color: rgb(0, 0, 139); font-family: Georgia, Times, &quot;Times New Roman&quot;, serif; font-size: 29px; margin: 10px 0px; padding: 0px; background-color: rgb(255, 255, 255);">
# </div></td></tr></tbody></table></td></tr></tbody></table></div><div><table style="border-collapse:separate;border-spacing:0px;table-layout:fixed;" cellpadding="5" cellspacing="5"><tbody><tr><td></td></tr></tbody></table><table style="width:100%;border-collapse:separate;table-layout:fixed;" cellspacing="0" cellpadding="0"><tbody><tr><td style="background:#FFFFFF;"><table width="100%" cellspacing="0" cellpadding="0" style="border-collapse:separate;border-spacing:0px;table-layout:fixed;"><tbody><tr><td width="100%" style="width:100%;border-top-color:#a7ced9;border-top-style:solid;border-top-width:2px;" ></td></tr></tbody></table></td></tr></tbody></table></div><div><table style="border-collapse:separate;border-spacing:0px;table-layout:fixed;" cellpadding="5" cellspacing="5"><tbody><tr><td></td></tr></tbody></table><table style="width:100%;border-collapse:separate;table-layout:fixed;background:#FFFFFF;" cellspacing="15" cellpadding="0"><tbody><tr><td style="background:#FFFFFF;"><table width="100%" cellspacing="0" cellpadding="0" style="border-collapse:separate;border-spacing:0px;table-layout:fixed;"><tbody><tr><td style="vertical-align:top;"><div style="word-wrap:break-word;line-height:140%;text-align:left;"><h2 align="left" style="line-height: 1.2em; color: rgb(0, 0, 139); font-family: Georgia, Times, 'Times New Roman', serif; font-size: 29px; margin: 10px 0px; padding: 0px; background-color: rgb(255, 255, 255);">
# </div></td></tr></tbody></table></td></tr></tbody></table></div><div><table style="border-collapse:separate;border-spacing:0px;table-layout:fixed;" cellpadding="5" cellspacing="5"><tbody><tr><td></td></tr></tbody></table><table style="width:100%;border-collapse:separate;table-layout:fixed;background:#FFFFFF;" cellspacing="15" cellpadding="0"><tbody><tr><td style="background:#FFFFFF;"><table width="100%" cellspacing="0" cellpadding="0" style="border-collapse:separate;border-spacing:0px;table-layout:fixed;"><tbody><tr><td style="vertical-align:top;"><div style="word-wrap:break-word;line-height:140%;text-align:left;">

crazy1=$'</div></td></tr></tbody></table></td></tr></tbody></table></div><div><table style="border-collapse:separate;border-spacing:0px;table-layout:fixed;" cellpadding="5" cellspacing="5"><tbody><tr><td></td></tr></tbody></table><table style="width:100%;border-collapse:separate;table-layout:fixed;" cellspacing="0" cellpadding="0"><tbody><tr><td style="background:#FFFFFF;"><table width="100%" cellspacing="0" cellpadding="0" style="border-collapse:separate;border-spacing:0px;table-layout:fixed;"><tbody><tr><td width="100%" style="width:100%;border-top-color:#......;border-top-style:solid;border-top-width:2px;" ></td></tr></tbody></table></td></tr></tbody></table></div><div><table style="border-collapse:separate;border-spacing:0px;table-layout:fixed;" cellpadding="5" cellspacing="5"><tbody><tr><td></td></tr></tbody></table><table style="width:100%;border-collapse:separate;table-layout:fixed;background:#FFFFFF;" cellspacing="15" cellpadding="0"><tbody><tr><td style="background:#FFFFFF;"><table width="100%" cellspacing="0" cellpadding="0" style="border-collapse:separate;border-spacing:0px;table-layout:fixed;"><tbody><tr><td style="vertical-align:top;"><div style="word-wrap:break-word;line-height:140%;text-align:left;"><h2 align="left" style="line-height: 1.2em; color: rgb(0, 0, 139); font-family: Georgia, Times, &quot;Times New Roman&quot;, serif; font-size: 29px; margin: 10px 0px; padding: 0px; background-color: rgb(255, 255, 255);">'
crazy2=$'</div></td></tr></tbody></table></td></tr></tbody></table></div><div><table style="border-collapse:separate;border-spacing:0px;table-layout:fixed;" cellpadding="5" cellspacing="5"><tbody><tr><td></td></tr></tbody></table><table style="width:100%;border-collapse:separate;table-layout:fixed;" cellspacing="0" cellpadding="0"><tbody><tr><td style="background:#FFFFFF;"><table width="100%" cellspacing="0" cellpadding="0" style="border-collapse:separate;border-spacing:0px;table-layout:fixed;"><tbody><tr><td width="100%" style="width:100%;border-top-color:#......;border-top-style:solid;border-top-width:2px;" ></td></tr></tbody></table></td></tr></tbody></table></div><div><table style="border-collapse:separate;border-spacing:0px;table-layout:fixed;" cellpadding="5" cellspacing="5"><tbody><tr><td></td></tr></tbody></table><table style="width:100%;border-collapse:separate;table-layout:fixed;background:#FFFFFF;" cellspacing="15" cellpadding="0"><tbody><tr><td style="background:#FFFFFF;"><table width="100%" cellspacing="0" cellpadding="0" style="border-collapse:separate;border-spacing:0px;table-layout:fixed;"><tbody><tr><td style="vertical-align:top;"><div style="word-wrap:break-word;line-height:140%;text-align:left;"><h2 align="left" style="line-height: 1.2em; color: rgb(0, 0, 139); font-family: Georgia, Times, \'Times New Roman\', serif; font-size: 29px; margin: 10px 0px; padding: 0px; background-color: rgb(255, 255, 255);">'
crazy3=$'</div></td></tr></tbody></table></td></tr></tbody></table></div><div><table style="border-collapse:separate;border-spacing:0px;table-layout:fixed;" cellpadding="5" cellspacing="5"><tbody><tr><td></td></tr></tbody></table><table style="width:100%;border-collapse:separate;table-layout:fixed;background:#FFFFFF;" cellspacing="15" cellpadding="0"><tbody><tr><td style="background:#FFFFFF;"><table width="100%" cellspacing="0" cellpadding="0" style="border-collapse:separate;border-spacing:0px;table-layout:fixed;"><tbody><tr><td style="vertical-align:top;"><div style="word-wrap:break-word;line-height:140%;text-align:left;">'

# In addition, all sorts of extraneous <div> and other markup that kills the scraping process.

divbeg1=$'^\t*<div>$'
divend1=$'^\t*&nbsp;</div>$'
divend2=$'</div>$'

nobreak=$'<br [^/]*/>'

spanbeg=$'<span[^>]*>'
spanend=$'</span>'

fontbeg=$'<font[^>]*>'
fontend=$'</font>'

paraneed=$'^\t*<strong>\\(.*\\)$'
paramake=$'<p><strong>\\1</p>'

noblanks=$'^\t*$'

lastone=$'^<p style="color: rgb(0, 0, 0); line-height: 140%; margin: 0px; text-align: left;">$'
lasttwo=$'<div style="font-size: 12px;">'

# grep -n "$crazy1" $1
# grep -n "$crazy2" $1
# grep -n "$crazy3" $1
# grep -n "$divbeg1" $1
# grep -n "$divend1" $1
# grep -n "$nobreak" $1
# grep -n "$lastone" $1

output='./out/'
for file in `find . -type f -name "*.html"`;
  do
    cat $file \
      | sed "s!$crazy1!!" \
      | sed "s!$crazy2!!" \
      | sed "s!$crazy3!!" \
      | grep -v "$divbeg1" \
      | grep -v "$divend1" \
      | sed "s!$divend2!!" \
      | sed "s!$nobreak!!" \
      | sed "s!$spanbeg!!g" \
      | sed "s!$spanend!!g" \
      | sed "s!$fontbeg!!g" \
      | sed "s!$fontend!!g" \
      | grep -v "$noblanks" \
      | sed "s!$paraneed!$paramake!" \
      > $output$file
  done

# After all the above, a few files still had one-off issues, manually edited them
# 2017-03-10-index.html
# 2017-03-23-index.html
# 2017-03-27-index.html
# 2017-03-28-index.html

# last problematic string that can be automatically removed
for file in `find . -type f -name "*.html"`;
  do
    sed -i "" "s!$lastone!!" $file
    sed -i "" "s!$lasttwo!!" $file
  done

# finally, observed that 11 Apr through 19 May 2017 has the no-header problem.
# run fix-noheaders script on these files

