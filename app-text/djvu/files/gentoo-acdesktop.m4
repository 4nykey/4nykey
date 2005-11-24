dnl Copyright (c) 2002  Leon Bottou and Yann Le Cun.
dnl Copyright (c) 2001  AT&T
dnl
dnl Most of these macros are derived from macros listed
dnl at the GNU Autoconf Macro Archive
dnl http://www.gnu.org/software/ac-archive/
dnl
dnl This program is free software; you can redistribute it and/or modify
dnl it under the terms of the GNU General Public License as published by
dnl the Free Software Foundation; either version 2 of the License, or
dnl (at your option) any later version.
dnl
dnl This program is distributed in the hope that it will be useful,
dnl but WITHOUT ANY WARRANTY; without even the implied warranty of
dnl MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
dnl GNU General Public License for more details.
dnl
dnl You should have received a copy of the GNU General Public License
dnl along with this program; if not, write to the Free Software
dnl Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA02111 USA
dnl

dnl -------------------------------------------------------
dnl @synopsis AC_VARIFY(varname)
dnl Replace expansion of $libdir, $datadir, $bindir, $prefix
dnl by references to the variable.
dnl -------------------------------------------------------
AC_DEFUN([AC_VARIFY],[
    xdir="`eval echo \"$libdir\"`"
    $1=`echo [$]$1 | sed -e 's:^'"$xdir"'/:${libdir}/:'`
    xdir="`eval echo \"$datadir\"`"
    $1=`echo [$]$1 | sed -e 's:^'"$xdir"'/:${datadir}/:'`
    xdir="`eval echo \"$bindir\"`"
    $1=`echo [$]$1 | sed -e 's:^'"$xdir"'/:${bindir}/:'`
    xdir="`eval echo \"$prefix\"`"
    $1=`echo [$]$1 | sed -e 's:^'"$xdir"'/:${prefix}/:'`
])


dnl -------------------------------------------------------
dnl @synopsis AC_LOCATE_DESKTOP_DIRS
dnl Define installation paths for desktop config files
dnl (mime types, menu entries, icons, etc.)
dnl -------------------------------------------------------
AC_DEFUN([AC_FIND_DESKTOP_DIRS],[
   dtop_applications=/usr/share/applications          # XDG menu entries
   dtop_icons=/usr/share/icons                 # KDE-style icon directories
   dtop_mime_info=/usr/share/mime-info             # Gnome mime database
   dtop_application_registry=/usr/share/application-registry  # Gnome mime associations
   dtop_mimelnk=${kde_mimelnk}               # KDE mime database

   AC_SUBST(dtop_applications)
   AC_SUBST(dtop_icons)
   AC_SUBST(dtop_pixmaps)
   AC_SUBST(dtop_mime_info)
   AC_SUBST(dtop_application_registry)
   AC_SUBST(dtop_applnk)
   AC_SUBST(dtop_mimelnk)
   AC_SUBST(dtop_menu)
])


