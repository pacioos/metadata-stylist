#!/usr/local/bin/python

"""
Filename : metadata.py
Author   : John Maurer <jmaurer@hawaii.edu>
Created  : Fri 03 Aug 2012 08:55:01 AM HST
Modified : Fri 03 Aug 2012 11:08:11 AM HST

This Python module provides routines for retrieving "collection-level"
(a.k.a. "dataset-level") metadata for datasets at the Pacific Islands
Ocean Observing System (PacIOOS). Please see the documentation for each
subroutine below for further details.

NOTE: the libxslt system library (which Python leverages) does not work with
XSLT 2.0.

Example usage:

use metadata;
metadata_styled = get_metadata_styled('NS01agg', 'iso', 'html');
"""

#########################
##                     ##
##  GLOBAL VARIABLES:  ##
##                     ##
#########################

# Location of metadata directory on our web server:

METADATA_DIR = '/usr/local/apache/htdocs/pacioos/metadata'

# Location of XSLT files:

XSLT_DIR = METADATA_DIR + '/xslt'

##################
##              ##
##  FUNCTIONS:  ##
##              ##
##################

def get_metadata_styled(id, format='iso', style='html'):
    '''
    This subroutine returns a string with all collection-level metadata 
    for the specified dataset identifer, metadata format (e.g. 
    'iso', 'dif', 'fgdc', etc.), and style (e.g. 'html', 'text', or 'xml'). 
    The dataset identifer, metadata format, and style are all case-insensitive.

    This subroutine operates by first retrieving an XML string of the metadata
    using get_metadata_xml(). It then uses the libxslt Python module to render
    this XML according to the XSLT rules in the XSLT file for the specified
    style.

    Arguments:
        id     -- the dataset ID to obtain metadata for. Must match ISO entry.
        format -- the geospatial metadata format that you want.
        style  -- the style that you want to render the underlying XML into:
            'html', 'text', or 'xml'.

    Examples:
    >>> metadata = get_metadata_styled('NS01agg', 'iso')
    >>> metadata = get_metadata_styled('PACN_FISH_TRANSECT', 'iso', 'text')
    >>> metadata = get_metadata_styled('scud_pac', 'iso', 'xml')

    NOTE: Specifying 'xml' as the style will return the results of 
    without applying any style sheet if an 'xml' stylesheet is not already
    defined for the format you have specified. The reason for using an XML
    stylesheet would be to enforce a certain ordering of the XML elements
    or to modify the contents in some way outside of the default output.
    '''
    import libxml2
    import libxslt
    import re

    # Get the XML string of the metadata for the specified dataset identifier:

    metadata_xml_string = get_metadata_xml(id, format)

    # If output format is XML, return metadata unchanged:

    if style.lower() == 'xml':
        return metadata_xml_string

    # Make sure FGDC XML contains datsetid (RSE extension); otherwise, we have
    # no way of identifying this dataset from one format to another in
    # "metadata views" URLs:

    elif format.lower() == 'fgdc':
        if not re.search('\<datsetid\>', metadata_xml_string):
            regexp = re.compile('<idinfo>\n<datsetid>' + id + '<\/datsetid>')
            metadata_xml_string = re.sub('\<idinfo\>', regexp, metadata_xml_string)

    # Determine the XSLT file location from the specified format and style:

    xslfile = XSLT_DIR + '/pacioos-' + format.lower() + '-' + style.lower() + '.xsl'

    # Render the XML into the specified style using its XSLT stylesheet:
    # NOTE: The return object from the parser is an XML DOM object data 
    # structure (DOM = Document Object Model):

    metadata_xml_dom       = libxml2.parseDoc(metadata_xml_string)
    xsl_dom                = libxml2.parseFile(xslfile)
    stylesheet             = libxslt.parseStylesheetDoc(xsl_dom)
    metadata_styled_dom    = stylesheet.applyStylesheet(metadata_xml_dom, None)
    metadata_styled_string = stylesheet.saveResultToString(metadata_styled_dom) 

    return metadata_styled_string


def get_metadata_xml(id, format='iso'):
    """
    This subroutine returns an XML document with all collection-level metadata 
    for the specified dataset identifer and metadata format. It looks for a
    pre-existing XML file on our web server. 

    Arguments:
        id     -- the dataset ID to obtain metadata for.
        format -- the geospatial metadata format that you want.

    Examples:
    >>> metadata = get_metadata_xml('NS01agg', 'iso')
    >>> metadata = get_metadata_xml('scud_pac', 'fgdc')
    """

    xml_file = METADATA_DIR + '/' + format.lower() + '/' + id + '.xml'

    input = open(xml_file)
    metadata_xml = input.read()

    return metadata_xml


def run_xslt(xml_file, xslt_file, out_file=None):
    """
    Transforms the specified XML file using the specified XSLT stylesheet. If
    optional out_file specified, writes output to file; otherwise, returns
    styled metadata as a string.

    Examples:
    >>> run_xslt('/usr/local/apache/htdocs/pacioos/metadata/iso/NS01agg.xml', '/usr/local/apache/htdocs/pacioos/metadata/xslt/iso2fgdc.xsl', '/usr/local/apache/htdocs/pacioos/metadata/fgdc/NS01agg.xml')
    >>> metadata_styled_string = run_xslt('/usr/local/apache/htdocs/pacioos/metadata/iso/NS01agg.xml', '/usr/local/apache/htdocs/pacioos/metadata/xslt/iso2fgdc.xsl')
    """
    import libxml2
    import libxslt

    # Render the XML into the specified style using its XSLT stylesheet:
    # NOTE: The return object from the parser is an XML DOM object data 
    # structure (DOM = Document Object Model):

    metadata_xml_dom       = libxml2.parseFile(xml_file)
    xsl_dom                = libxml2.parseFile(xslt_file)
    stylesheet             = libxslt.parseStylesheetDoc(xsl_dom)
    metadata_styled_dom    = stylesheet.applyStylesheet(metadata_xml_dom, None)

    if out_file:
        stylesheet.saveResultToFilename(out_file, metadata_styled_dom, 0)
    else:
        metadata_styled_string = stylesheet.saveResultToString(metadata_styled_dom)
        return metadata_styled_string
  
    
##########################
##                      ##
##  SCRIPT OPERATIONS:  ##
##                      ##
##########################
# Commands to run if calling as a command-line script rather than importing
# elsewhere as a module:

if __name__ == '__main__':

    import argparse

    # Parse command-line options:

    parser = argparse.ArgumentParser(description='Utility for tranforming an XML document using an XSLT stylesheet.')
    parser.add_argument('id', nargs=1, help='Dataset identifier.')
    parser.add_argument('--format', nargs=1, help='Output format: iso (default) or fgdc.')
    parser.add_argument('--style', nargs=1, help='Output style: xml (default), text, or html.') 
    args = parser.parse_args()

    id = args.id[0]

    if args.format:
        format = args.format[0]
    else:
        format = 'iso'

    if args.style:
        style = args.style[0]
    else:
        style = 'xml'

    metadata = get_metadata_styled(id, format, style)
   
    print metadata 
