#!/bin/sh
# this make file is obsolete. Use `cons smime' instead.
cc -c -g keygen.c    -I/usr/local/ssl/include -o keygen.o
cc -c -g pkcs12.c    -I/usr/local/ssl/include -o pkcs12.o
cc -c -g smime-qry.c -I/usr/local/ssl/include -o smime-qry.o
cc -c -g smime-enc.c -I/usr/local/ssl/include -o smime-enc.o
cc -c -g smime-vfy.c -I/usr/local/ssl/include -o smime-vfy.o
cc -c -g smimemime.c -I/usr/local/ssl/include -o smimemime.o
cc -c -g smimeutil.c -I/usr/local/ssl/include -o smimeutil.o
cc -c -g smime.c     -I/usr/local/ssl/include -o smime.o
cc -g smime.o keygen.o pkcs12.o smime-qry.o smime-enc.o smime-vfy.o smimemime.o smimeutil.o -L/usr/local/ssl/lib -lcrypto -o smime
#EOF