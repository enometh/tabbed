#!/bin/sh
#
#
# Local Variables:
# sh-indentation: 8
# sh-basic-offset: 8
# End:
#
# [Fri Jun 01 14:42:50 2018 +0530]
#   Time-stamp: <2014-05-02 23:26:29 IST>
#   Touched: Fri May 02 23:17:09 2014 +0530 <enometh@meer.net>
#   Bugs-To: enometh@meer.net
#   Status: Experimental.  Do not redistribute
#   Copyright (C) 2014 Madhu.  All Rights Reserved.
#
#set -e -x

APPNAME=${APPNAME:-$1}
if [ -z "$APPNAME" ]; then
	echo usage "$0 cmdname [args]"
	exit
fi

APPTITLE="tabbed-$(basename "$APPNAME")"

tabbed=${tabbed:-tabbed}
: ${xidfile:="$HOME/tmp/$APPTITLE.xid"}
echo "tabbed=$tabbed cmd=$APPNAME title=$APPTITLE"

function launch_tabbed ()
{
	echo 	$tabbed -dn "$APPTITLE" -s
	$tabbed $TABBED_ARGS -dn "$APPTITLE"  > "$xidfile"
}

if [ ! -r "$xidfile" ];  then
	launch_tabbed
fi

xid=$(tail -1 "$xidfile")
xprop -id "$xid" > /dev/null 2>&1

if [ $? -gt 0 ]; then
	launch_tabbed
	xid=$(tail -1 "$xidfile")
fi

export XEMBED="$xid"
echo "xidfile=$xidfile xid=$xid"
echo exec "$@"
exec "$@"
