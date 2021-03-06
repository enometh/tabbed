# tabbed version
VERSION = 0.6

# Customize below to fit your system

# paths
PREFIX = /usr/local
MANPREFIX = ${PREFIX}/share/man

X11INC = /usr/X11R6/include
X11LIB = /usr/X11R6/lib

# freetype
FREETYPELIBS = -lfontconfig -lXft -lXrender
FREETYPEINC = /usr/include/freetype2
# OpenBSD (uncomment)
#FREETYPEINC = ${X11INC}/freetype2

# includes and libs
INCS = -I. -I/usr/include -I$(X11INC) -I${FREETYPEINC}
LIBS = -L/usr/lib -L${X11LIB} -lX11 ${FREETYPELIBS}

INCS += $(shell pkg-config gtk+-3.0 gtk+-x11-3.0 gdk-pixbuf-xlib-2.0 --cflags)
LIBS += $(shell pkg-config gtk+-3.0 gtk+-x11-3.0 gdk-pixbuf-xlib-2.0 --libs)

# flags
CPPFLAGS = -DVERSION=\"${VERSION}\" -D_DEFAULT_SOURCE
CFLAGS = -std=c99 -pedantic -Wall -ggdb ${INCS} ${CPPFLAGS}
LDFLAGS = ${LIBS}

# Solaris
#CFLAGS = -fast ${INCS} -DVERSION=\"${VERSION}\"
#LDFLAGS = ${LIBS}

# compiler and linker
CC = cc
