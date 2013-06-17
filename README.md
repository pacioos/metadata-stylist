metadata-stylist
================

Provides a web service (Python CGI) for dynamically presenting FGDC or ISO geospatial metadata from an XML file into HTML or plain text using XSLT transformations.

###Dependencies:

* Python
* Python libxml2 and libxslt modules: http://xmlsoft.org/xslt/python.html (e.g. ftp://xmlsoft.org/libxml2/python/libxml2-python-2.6.9.tar.gz)

###Set-Up Instructions:

* Copy get_metadata.py to your cgi-bin directory: e.g. /usr/local/apache/cgi-bin/
* Make sure get_metadata.py is executable: chmod 755 get_metadata.py
* Copy metadata.py to your Python module directory: e.g. /usr/local/lib/python2.7/site-packages/
* Configure get_metadata.py for your environment:
  * WEB_BASE_DIR = '/usr/local/apache/htdocs' 
  * display_help_page() and die_nice(): modify HTML for your environment,
    replacing PacIOOS CSS stylesheet and SSI header/footer files with your own.
* Configure metadata.py for your environment. Assumes FGDC and ISO XML files
  stored in "fgdc" and "iso" subdirectories of METADATA_DIR with filenames
  equal to the dataset identifier (e.g. <datsetid>.xml):
  * METADATA_DIR = '/usr/local/apache/htdocs/pacioos/metadata'
  * XSLT_DIR = METADATA_DIR + '/xslt' 
* Replace PacIOOS XSLT files with your own or modify ours for your environment,
  replacing PacIOOS CSS stylesheet and SSI files with your own.
  * pacioos-iso-html.xsl
  * pacioos-fgdc-html.xsl
* Configure .htaccess for your environment. This allows the CGI script to be
  called from an alternative URL pattern such as (in our usage):
  http://pacioos/metadata/[datasetid].[html|xml|txt]. This file must reside
  in the top folder (e.g. "metadata" in the above example).
