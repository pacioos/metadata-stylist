#!/usr/local/bin/python

"""
Filename : get_metadata.py
Author   : John Maurer <jmaurer@hawaii.edu>
Created  : Fri 03 Aug 2012 11:39:12 AM HST
Modified : Fri 03 Aug 2012 01:12:03 PM HST

This is the main CGI program for accessing the metadata.py
Python module, which provides collection-level (i.e. dataset-level)
metadata in a variety of formats and styles for a specified dataset 
identifier. All parameters passed to this CGI are case-insensitive
and include the following:

1. Dataset identifier ('id'):

A dataset identifier must match the gmd:MD_Identifier > gmd:code >
gmd:CharacterString in our ISO metadata.

2. Metadata output format ('format'):

Choices: iso, fgdc
Default: iso 

The format parameter tells the program which geospatial metadata standard
to output the metadata in. "iso" for the International Organization for
Standardization (ISO) Geographic information -- Metadata (ISO 19115:2003).
"fgdc" is for U.S. Federal Geographic Data Committee (FGDC) Content Standard
for Digital Geospatial Metadata (CSDGM).

3. Output style ('style'):

Choices: html, text, xml
Default: html

The styles available for displaying these formats depends on the format 
selected, but in general each format at least allows an XML style ('xml') 
(Extensible Markup Language) and a plain-text style ('text'), while
some also allow an HTML styled ('html') web page output (notably
ISO and FGDC so far). 

EXAMPLES:

http://oos.soest.hawaii.edu/cgi-bin/get_metadata.py?id=NS01agg
http://oos.soest.hawaii.edu/cgi-bin/get_metadata.py?id=NS01agg&format=iso&style=text
http://oos.soest.hawaii.edu/cgi-bin/get_metadata.py?id=NS01agg&style=xml
"""
import cgi
import cgitb
import metadata
import re
import sys

######################
##                  ##
##  CONFIGURATION:  ##
##                  ##
######################

# Define the base directory for HTML files on the web server:

WEB_BASE_DIR = '/usr/local/apache/htdocs'

#########################
##                     ## 
##  END CONFIGURATION  ##
##                     ##
#########################

##################
##              ##
##  FUNCTIONS:  ##
##              ##
##################

def get_input_parameters():
    """
    Gets input parameters from URL and returns dictionary with values. 
    """

    input_dict = {}
    
    # Get input parameters:
    
    form = cgi.FieldStorage()
    
    # Make all keys lower-case so that our comparisons are case-insensitive:

    form = {param.lower(): form[param] for param in form}

    # Get the specified dataset identifier:

    if 'id' in form:
        id = form['id'].value
    else:
        display_help_page()

    # Strip anything after a slash (/) in the id; while TDS FMRC uses id's like
    # roms_hiig_forecast/ROMS_Hawaii_Regional_Ocean_Model_best.ncd, to simplify
    # things, we shorten this to roms_hiig_forecast:

    id = re.sub('\/.*', '', id)

    # Get the specified geospatial metadata format to display the metadata in
    # (e.g. fgdc or iso); default to ISO:

    if 'format' in form:
        format = form['format'].value
    else:
        if id == 'gmxCodelists':
            format = 'gmx'
        else: 
            format = 'iso'

    # Get the specified output style (e.g. text, HTML, or XML):

    if 'style' in form:
        style = form['style'].value
    else: 
        style = 'html'

    # Fill dictionary with input parameters:

    input_dict['format'] = format
    input_dict['id'] = id
    input_dict['style'] = style

    return input_dict


def print_output(id, format, style):
    """
    Prints metadata to browser for specified dataset identifier, metadata
    format (iso, fgdc), and output style (xml, text, html).    
    """

    # Get the metadata output using the user's input criteria: 

    metadata_styled_string = metadata.get_metadata_styled(id, format, style)

    # Print an HTTP header so that the web server recognizes the output as the 
    # appropriate MIME type (HTML, XML, or text):

    if style.lower() == 'xml':
        print 'Content-type: text/xml; charset=ISO-8859-1\n'

    # I print text out with an HTML content-type instead of a plain text 
    # content-type so that line breaks do not have any DOS vs. non-DOS issues. 
    # The "pre" tag will maintain all of the line breaks in the HTML output:

    elif style.lower() == 'text':
        print 'Content-type: text/html; charset=ISO-8859-1\n'
        print '<pre>'

    # Fill in any SSI include files in the HTML since the web server does not 
    # do this automatically:

    else:
        print 'Content-type: text/html; charset=ISO-8859-1\n'
        metadata_styled_string = fill_html_includes(metadata_styled_string)

    # Print the metadata:

    print metadata_styled_string

    # For text output close the "pre" tag:

    if style.lower() == 'text':
        print '</pre>'


def display_help_page(): 
    ''' 
    This subroutine display an HTML page with instructions on how to use
    this CGI program. 
    '''

    print 'Content-type: text/html\n'

    # Define the help page:

    help_page = ''' 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>get_metadata.py</title>
<link href="/pacioos/css/main_old.css" rel="stylesheet" type="text/css"/>
</head>

<body>
<!--#include virtual="/pacioos/ssi/pacioos_header.ssi"-->
<!--#include virtual="/pacioos/navigation/index.php"-->
<!--#include virtual="/pacioos/ssi/pacioos_header_b.ssi"-->
<ul id="nav-breadcrumb">
  <li><a style="margin-top:-12px;" href="/pacioos">Home</a></li>
  <li><a href="/pacioos/data_access/">Data Access</a></li>
  <li class="last"><a href="/pacioos/metadata/">Metadata</a></li>
</ul>

<div style="margin-left: 25px;">

<h2>get_metadata.py</h2>

<p>The <b>get_metadata.py</b> web service provides routines for retrieving 
  metadata for data sets at the Pacific Islands Ocean Observing System (PacIOOS). 
  By passing certain parameters to this utility, you can specify the data set, 
  metadata format, and output style that you wish to view.</p>

  <ul>
    <li><a href="#parameters">Parameters</a></li>
    <li><a href="#examples">Examples</a></li>
    <li><a href="#alias">Alias</a></li>
  </ul>

<hr/>
<a name="parameters"></a>
<h3>Parameters:</h3>

<ul>
  <li><a href="#id">id</a></li>
  <li><a href="#format">format</a></li>
  <li><a href="#style">style</a></li>
</ul>

<!--<hr style="border:dashed grey; border-width:1px 0 0 0; height:0;line-height:0px;font-size:0;margin:0;padding:0;"/>-->
<a name="id"></a>
<h4>id:</h4>
<p>Specify the data set identifier for the data set that you want to view metadata.
  Some examples include:</p>
<ul>
  <li><a href="/cgi-bin/get_metadata.py?id=PACN_FISH_TRANSECT" title="Pacific Island Network Marine Fish Monitoring Dataset">PACN_FISH_TRANSECT</a></li>
  <li><a href="/cgi-bin/get_metadata.py?id=NS01agg" title="PacIOOS Nearshore Sensor 01: Waikiki Yacht Club">NS01agg</a></li>
  <li><a href="/cgi-bin/get_metadata.py?id=WQBAWagg" title="PacIOOS Water Quality Buoy: Ala Wai">WQBAWagg</a></li>
  <li><a href="/cgi-bin/get_metadata.py?id=sg523_1_agg" title="PacIOOS Ocean Gliders: SeaGlider 523: Mission 1">sg523_1_agg</a></li>
  <li><a href="/cgi-bin/get_metadata.py?id=roms_hiig_forecast" title="Regional Ocean Modeling System (ROMS): Main Hawaiian Islands">roms_hiig_forecast</a></li>
  <li><a href="/cgi-bin/get_metadata.py?id=wrf_hi" title="Weather Research and Forecasting (WRF) Regional Atmospheric Model: Main Hawaiian Islands">wrf_hi</a></li>
  <li><a href="/cgi-bin/get_metadata.py?id=swan_oahu" title="Simulating WAves Nearshore (SWAN) Regional Wave Model: Oahu">swan_oahu</a></li>
  <li><a href="/cgi-bin/get_metadata.py?id=tide_mhi" title="Tide Model for the Hawaiian Islands: Main NW Islands">tide_mhi</a></li>
  <li><a href="/cgi-bin/get_metadata.py?id=kalagg" title="PacIOOS High Frequency Radio (HFR) Radial Velocity: Kalaeloa (Barbers Point), Oahu">kalagg</a></li>
  <li><a href="/cgi-bin/get_metadata.py?id=dhw" title="Archived Suite of NOAA Coral Reef Watch Operational Twice-Weekly Near-Real-Time Global 50km Satellite Coral Bleaching Monitoring Products">dhw</a></li>
</ul>
<p>If you do not know the data set identifier for your desired data set, <a href="/pacioos/metadata/">find a list here</a>.</p> 
<!--<hr style="border:dashed grey; border-width:1px 0 0 0; height:0;line-height:0px;font-size:0;margin:0;padding:0;"/>-->
<a name="format"></a>
<h4>format:</h4>
<p>Specify the format that you want to view the metadata in. This includes the 
  following geospatial metadata standards:</p>
<font color="#6e6e6e">
  <table class="graybox">
    <tr>
      <td><b>FGDC: </b></td>
      <td>U.S. Federal Geographic Data Committee (<a href="http://fgdc.gov/">FGDC</a>) 
        Content Standard for Digital Geospatial Metadata (<a href="http://www.fgdc.gov/metadata/csdgm/">CSDGM</a>)</td>
    </tr>
    <tr>
      <td><b>ISO: </b></td>
      <td>International Organization for Standardization (<a href="http://www.iso.org">ISO</a>) <a href="http://www.iso.org/iso/catalogue_detail.htm?csnumber=26020">19115:2003</a> Geographic Information Metadata</td>
    </tr>
  </table>
</font>
<p>If you do not specify a format parameter, the output will default to <b>ISO</b>.</p>
<!--<hr style="border:dashed grey; border-width:1px 0 0 0; height:0;line-height:0px;font-size:0;margin:0;padding:0;"/>-->
<a name="style"></a>
<h4>style:</h4>
<p>Specify the output style that you want to view the metadata in. This includes 
  one of the following options:</p>
<font color="#6e6e6e">
  <table class="graybox">
    <tr> 
      <td><strong>HTML: </strong></td>
      <td>Hypertext Markup Language: View metadata as a Web page.</td>
    </tr>
    <tr> 
      <td><strong>text: </strong></td>
      <td>View metadata as a plain text document.</td>
    </tr>
    <tr>
      <td><strong>XML: </strong></td>
      <td>Extensible Markup Language</td>
    </tr>
  </table>
</font>
<p>If you do not specify a style parameter, the output will default to <b>HTML</b>.</p>
<hr/>
<a name="examples"></a>
<h3>Examples:</h3>
<p>Here are some examples of how to call the <b>get_metadata.py</b> utility:</p>
<ul>
  <li><a href="/cgi-bin/get_metadata.py?id=NS01agg">http://oos.soest.hawaii.edu/cgi-bin/get_metadata.py?id=NS01agg</a></li>
  <li><a href="/cgi-bin/get_metadata.py?id=WQBAWagg&format=iso">http://oos.soest.hawaii.edu/cgi-bin/get_metadata.py?id=WQBAWagg&amp;format=iso</a></li>
  <li><a href="/cgi-bin/get_metadata.py?id=PACN_FISH_TRANSECT&format=fgdc">http://oos.soest.hawaii.edu/cgi-bin/get_metadata.py?id=PACN_FISH_TRANSECT&amp;format=fgdc</a></li>
  <li><a href="/cgi-bin/get_metadata.py?id=tide_mhi&style=text">http://oos.soest.hawaii.edu/cgi-bin/get_metadata.py?id=tide_mhi&amp;style=text</a></li>
  <li><a href="/cgi-bin/get_metadata.py?id=kalagg&format=fgdc&style=xml">http://oos.soest.hawaii.edu/cgi-bin/get_metadata.py?id=kalagg&amp;format=fgdc&amp;style=xml</a></li>
</ul>

<hr/>
<a name="alias"></a>
<h3>Alias:</h3>
<p>For convenience and to help avoid URL changes to this service in the future, <b>get_metadata.py</b> can also be accessed through the following preferred method. The dataset id becomes the page name (e.g. NS01agg), the style becomes the page name suffix (.html, .xml, .txt), and you can tack on the optional format parameter if you prefer to access FGDC rather than the default ISO output. The above examples are transformed as follows:</p>
<ul>
  <li><a href="http://pacioos.org/metadata/NS01agg.html">http://pacioos.org/metadata/NS01agg.html</a></li>
  <li><a href="http://pacioos.org/metadata/WQBAWagg.html">http://pacioos.org/metadata/WQBAWagg.html</a></li>
  <li><a href="http://pacioos.org/metadata/PACN_FISH_TRANSECT.html?format=fgdc">http://pacioos.org/metadata/PACN_FISH_TRANSECT.html?format=fgdc</a></li>
  <li><a href="http://pacioos.org/metadata/tide_mhi.txt">http://pacioos.org/metadata/tide_mhi.txt</a></li>
  <li><a href="http://pacioos.org/metadata/kalagg.xml?format=fgdc">http://pacioos.org/metadata/kalagg.xml?format=fgdc</a></li>
</ul>

<p><a href="javascript:void(0)" onClick="window.scrollTo( 0, 0 ); this.blur(); return false;">Back to Top</a></p>

<!--#include virtual="/pacioos/ssi/pacioos_footer.ssi"-->

</div>

</body>
</html>
    '''

    # Fill in any SSI include files in the HTML since the web server does not 
    # do this automatically:

    help_page = fill_html_includes(help_page)

    print help_page
    sys.exit()


def fill_html_includes(html):
    '''
    The web server doesn't fill in HTML include files when displaying HTML pages
    dynamically through a CGI interface such as this program. To ensure that
    HTML includes work, go out to each include file and print its contents into
    the provided HTML string and return the filled in string. Currently, this
    subroutine works only on SSI includes (Server Side Includes):

    http://en.wikipedia.org/wiki/Server_Side_Includes

    Arguments:
        html_string --- Any HTML contained in a Perl string variable.

    Example:
    >>> html_with_includes = fill_html_includes(html_string) 
    '''

    html_with_includes = ''

    # Go through the HTML line by line and fill in all includes:

    lines = html.split('\n')
  
    for line in lines: 

        # Insert any server side include (SSI) files:

        if re.search('<!--#include virtual="', line):

            # Determine the path to the SSI file; this uses a global variable:

            ssi_file = re.findall('<!--#include virtual="(.*)"', line)[0]
            ssi_file = WEB_BASE_DIR + ssi_file

            # Open the SSI file and dump contents into HTML string: 

            try:
                input = open(ssi_file)
            except:
                die_nice( "Could not open ssi file '%s': %s" % (ssi_file, str(sys.exc_info()[1])))

            ssi_lines = input.readlines()

            for ssi_line in ssi_lines:
                html_with_includes += ssi_line
        else:
            html_with_includes += line + '\n'

    return html_with_includes


def die_nice(error_message):
    '''
    Use to display a custom-made error page in the browser. 
    '''

    # Convert any newline characters to HTML "<br>" in the error message:

    error_message = re.sub('\n', '<br>', error_message)

    # Remove any information about the script line number from the error 
    # message, since this is irrelevant and potentially confusing to the end 
    # user:

    error_message = re.sub('at \/.*get_metadata.py line \d*', '', error_message)

    # Print an HTTP header so that the web server recognizes the MIME type:

    print 'Content-type: text/html\n'

    error_page = ''' 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Error</title>
<link href="/pacioos/css/main_old.css" rel="stylesheet" type="text/css"/>
</head>

<body>
<!--#include virtual="/pacioos/ssi/pacioos_header.ssi"-->
<!--#include virtual="/pacioos/navigation/index.php"-->
<!--#include virtual="/pacioos/ssi/pacioos_header_b.ssi"-->
<ul id="nav-breadcrumb">
  <li><a style="margin-top:-12px;" href="/pacioos">Home</a></li>
  <li><a href="/pacioos/data_access/">Data Access</a></li>
  <li class="last"><a href="/pacioos/metadata/">Metadata</a></li>
</ul>

<div style="margin-left: 25px; height: 270px;">

<h2><font color="red">Error</font></h2>
<p>%s</p>
<p>For help on using this utility, <a href="/cgi-bin/get_metadata.py">click here</a>.</p>

<!--#include virtual="/pacioos/ssi/pacioos_footer.ssi"-->

</div>

</body>
</html>
    ''' % (error_message)

    # Fill in any SSI include files in the HTML since the web server does not 
    # do this automatically:

    error_page = fill_html_includes(error_page)

    print error_page
    sys.exit()


#############
##         ##
##  MAIN:  ##
##         ##
#############

# Enable CGI tracebacks (error messages to screen): 

cgitb.enable()

# Gather input parameters:

input_dict = get_input_parameters()

# Gather and print output data:

try:
    print_output(input_dict['id'], input_dict['format'], input_dict['style'])
except:
    die_nice(str(sys.exc_info()[1]))
