#!/usr/bin/python

# Author: Rob Cakebread - pythonhead \@ gentoo.org
# Distributed under the terms of the GNU General Public License v2


"""
 This utility lists versions of wxPython you have installed.
 It also lets you set the default wxPython version apps will use.
 The naming convention used is:

     wx-{WX_GTK_VER}-{ENCODING}

 Examples:

    wx-2.4-gtk2-ansi
    wx-2.4-gtk2-unicode
    wx-2.6-gtk

 It is strongly suggested you use a 2.4* version as the system default
 because most stable wxPython applications are known to work with it.
 Applications that only work with 2.6* can use this code to
 select 2.6*

     import wxversion
     wxversion.select("2.6")
     import wx

 See this documentation for more info if you're a wxPython developer:
 http://wiki.wxpython.org/index.cgi/MultiVersionInstalls

""" 

import os
import sys
import optparse


PYVER = sys.version[0:3]
SITE_PKGS = "/usr/lib/python%s/site-packages" % PYVER

ENCODINGS = ["gtk2-ansi", "gtk2-unicode", "gtk-ansi"]
WX_VERSIONS = ["2.4", "2.6", "2.8"]


def versions_installed():
    """Return list of installed wxPython versions"""

    installed = []
    for v in WX_VERSIONS:
        i = 0
        for e in ENCODINGS:
            ver = "wx-%s-%s" % (v, ENCODINGS[i])
            if version_exists(ver):
                installed.append(ver)
            i += 1
    return installed

def get_default():
    """Return version of system default wxPython"""
    wxpath = "%s/wx.pth" % SITE_PKGS
    if not os.path.exists(wxpath):
        return None
    try:
        return open(wxpath, "r").read().strip()    
    except:
        return None


def print_installed():
    """Print list of wxPython versions installed"""
    default = get_default()
    all = versions_installed()
    print "\nYou have these versions of wxPython installed:\n"
    for v in all:
        if v == default:
            print v, "(System default)"
        else:
            print v

def version_exists(version):
    """Returns True if version of wxPython is installed"""
    if os.path.exists(os.path.join(SITE_PKGS, version)):
        return True

def set_default(version):
    """Sets default wxPython version"""

    if os.getuid() != 0:
        print "!!! ERROR - You must be root to change the default wxPython version."
        sys.exit(1)

    if version_exists(version):
        try:
            open(os.path.join(SITE_PKGS, "wx.pth"), "w").write(version)
        except:
            print "!!! ERROR - Failed to set %s as default wxPython version" % version
            sys.exit(1)
    else:
            print "!!! ERROR - Version %s is not installed." % version
            sys.exit(1)


if __name__ == "__main__":

    optParser = optparse.OptionParser()

    optParser.add_option( "-s", action="store", dest="version", type="string",
                            help="Set default wxPython version")

    optParser.add_option( "-l", action="store_true", dest="list",
                            help="List all wxPython versions installed.")

    (options, remainingArgs) = optParser.parse_args()

    if len(sys.argv) == 1:
        optParser.print_help()
        sys.exit(1)

    if options.list:
        print_installed()
        sys.exit()

    if options.version:
        set_default(options.version)
