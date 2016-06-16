# General rules for Makefile(s) subsystem.
# In this file we will put everything that need to be
# shared betweek all the Makefile(s).
# This file must be included at the beginning of every Makefile
#
# Copyright (C) 1999-2002 Riccardo Facchetti <riccardo@master.oasi.gpa.it>

#
# package version
PACKAGE = apcupsd
DISTNAME = debian
DISTVER = 8.4
VERSION = 0.6.8

#
# programs needed by compilation
CP = /bin/cp
MV = /bin/mv
ECHO = /bin/echo
RM = /bin/rm
RMF = $(RM) -rf
LN = /bin/ln
SED = /bin/sed
MAKE = make
SHELL = /bin/bash
RANLIB = ranlib
AR = ar
STRP = strip
INSTALL = /usr/bin/install -c
INSTALL_PROGRAM = ${INSTALL}
INSTALL_DATA = ${INSTALL} -m 644
INSTALL_SCRIPT = ${INSTALL}
MKINSTALLDIRS = /home/wagner/workspace/apcupsd_brazil/autoconf/mkinstalldirs
CHKCONFIG = /sbin/chkconfig
RST2HTML := /usr/bin/rst2html
RST2PDF := /usr/bin/rst2pdf

# Files and directories (paths)
prefix = /usr
exec_prefix = ${prefix}
sysconfdir = /etc/apcupsd
cgibin = /etc/apcupsd
VPATH = /usr/lib:/usr/local/lib
srcdir = .
abstopdir = /home/wagner/workspace/apcupsd_brazil
sbindir = /sbin
piddir = /var/run
mandir=${prefix}/share/man
bindir = ${exec_prefix}/bin
datadir = ${prefix}/share
HALPOLICYDIR = /usr/share/hal/fdi/policy/20thirdparty
DISTDIR = debian
PWRFAILDIR = /etc/apcupsd
LOCKDIR = /var/lock
CROSSTOOLS = 
DEPKGS = 

# Compilation macros.
CC = gcc
CXX = g++ -x c++
OBJC = $(CC) -x objective-c++
NIB = ibtool
LD = gcc
RES = 
DEFS =  $(LOCALDEFS)
EXE = 

# Libraries
APCLIBS = $(topdir)/src/lib/libapc.a $(if $(WIN32),$(topdir)/src/win32/compat/libwin32compat.a)
APCDRVLIBS =  $(topdir)/src/drivers/libdrivers.a $(topdir)/src/drivers/apcsmart/libapcsmartdrv.a $(topdir)/src/drivers/dumb/libdumbdrv.a $(topdir)/src/drivers/net/libnetdrv.a $(topdir)/src/drivers/snmplite/libsnmplitedrv.a $(topdir)/src/drivers/brazil/libbrazildrv.a $(topdir)/src/drivers/pcnet/libpcnetdrv.a $(topdir)/src/drivers/modbus/libmodbusdrv.a
DRVLIBS = -lpthread 
X_LIBS = 
X_EXTRA_LIBS = 

CPPFLAGS =  -I/usr/local/include -I$(topdir)/include $(EXTRAINCS)
CFLAGS = $(CPPFLAGS) -g -Wall 
CXXFLAGS = $(CPPFLAGS) -g -fno-exceptions -fno-rtti -Wall 
OBJCFLAGS = $(CPPFLAGS) $(CFLAGS)
LDFLAGS =  -L/usr/local/lib64 -L/usr/local/lib
LIBS =  -lm -lsupc++
LIBGD = 
GAPCMON_CFLAGS =  -DHAVE_FUNC_GETHOSTBYNAME_R_6
GAPCMON_LIBS = 
LIBEXTRAOBJ = 
RST2HTMLOPTS = --field-name-limit=0 --generator --time --no-footnote-backlinks --record-dependencies=$(df).d
RST2PDFOPTS = --no-footnote-backlinks --real-footnotes
NIBFLAGS = 
BG = 

# Driver and package enable flags
SMARTDRV   := apcsmart
DUMBDRV    := dumb
USBDRV     := 
NETDRV     := net
PCNETDRV   := pcnet
MODBUSDRV  := modbus
MODBUSUSB  := 
SNMPDRV    := 
SNMPLTDRV  := snmplite
TESTDRV    := 
BRAZILDRV  := brazil
USBTYPE    := 
CGIDIR     := 
USBHIDDIR  := 
GAPCMON    := 
APCAGENT   := 
WIN32      := 

OBJDIR = .obj
DEPDIR = .deps
df = $(DEPDIR)/$(*F)
DEVNULL := >/dev/null 2>&1
