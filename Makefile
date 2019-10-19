.POSIX:

NAME = tabbed
VERSION = 0.8

# paths
PREFIX = /usr/local
MANPREFIX = ${PREFIX}/share/man
DOCPREFIX = ${PREFIX}/share/doc/${NAME}

# use system flags.
TABBED_CFLAGS = -I/usr/X11R6/include -I/usr/include/freetype2 ${CFLAGS}
TABBED_LDFLAGS = -L/usr/X11R6/lib -lX11 -lfontconfig -lXft -lXrender ${LDFLAGS}
TABBED_CPPFLAGS = -DVERSION=\"${VERSION}\" -D_DEFAULT_SOURCE -D_XOPEN_SOURCE=700L

TABBED_CFLAGS += $(shell pkg-config gtk+-3.0 gtk+-x11-3.0 gdk-pixbuf-xlib-2.0 --cflags)
TABBED_LDFLAGS += $(shell pkg-config gtk+-3.0 gtk+-x11-3.0 gdk-pixbuf-xlib-2.0 --libs)

# OpenBSD (uncomment)
#TABBED_CFLAGS = -I/usr/X11R6/include -I/usr/X11R6/include/freetype2 ${CFLAGS}

SRC = tabbed.c xembed.c
OBJ = ${SRC:.c=.o}
BIN = ${OBJ:.o=}
MAN1 = ${BIN:=.1}
HDR = arg.h config.def.h
DOC = LICENSE README

all: ${BIN}

.c.o:
	${CC} -o $@ -c $< ${TABBED_CFLAGS} ${TABBED_CPPFLAGS}

${OBJ}: config.h

config.h: config.def.h
	cp -apfv config.def.h $@

.o:
	${CC} -o $@ $< ${TABBED_LDFLAGS}

clean:
	rm -f ${BIN} ${OBJ} "${NAME}-${VERSION}.tar.gz"

dist: clean
	mkdir -p "${NAME}-${VERSION}"
	cp -fR Makefile ${MAN1} ${DOC} ${HDR} ${SRC} "${NAME}-${VERSION}"
	tar -cf - "${NAME}-${VERSION}" | gzip -c > "${NAME}-${VERSION}.tar.gz"
	rm -rf ${NAME}-${VERSION}

install: all
	# installing executable files.
	mkdir -p "${DESTDIR}${PREFIX}/bin"
	cp -f ${BIN} "${DESTDIR}${PREFIX}/bin"
	for f in ${BIN}; do chmod 755 "${DESTDIR}${PREFIX}/bin/$$f"; done
	# installing doc files.
	mkdir -p "${DESTDIR}${DOCPREFIX}"
	cp -f README "${DESTDIR}${DOCPREFIX}"
	# installing manual pages for general commands: section 1.
	mkdir -p "${DESTDIR}${MANPREFIX}/man1"
	for m in ${MAN1}; do sed "s/VERSION/${VERSION}/g" < $$m > "${DESTDIR}${MANPREFIX}/man1/$$m"; done
	mkdir -pv ${DESTDIR}/usr/share/pixmaps
	cp -apiv tabbed.png ${DESTDIR}/usr/share/pixmaps

uninstall:
	# removing executable files.
	for f in ${BIN}; do rm -f "${DESTDIR}${PREFIX}/bin/$$f"; done
	# removing doc files.
	rm -f "${DESTDIR}${DOCPREFIX}/README"
	# removing manual pages.
	for m in ${MAN1}; do rm -f "${DESTDIR}${MANPREFIX}/man1/$$m"; done
	-rmdir "${DESTDIR}${DOCPREFIX}"

.PHONY: all clean dist install uninstall
