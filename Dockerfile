ARG TAG="20190801"
ARG CONTENTIMAGE1="huggla/pyinstaller-alpine:$TAG"
ARG BUILDDEPS="dash"
ARG BUILDCMDS=\
"   head -39 /src/proxy.py.org > /src/proxy.py "\
"&& tail -26 /src/proxy.py.add >> /src/proxy.py "\
"&& sed -i 's/# Copyright 2018, Sourcepole AG/# Copyright 2018, Sourcepole AG, Henrik Uggla/' /src/proxy.py "\
"&& cp /src/requirements.txt /src/ "\
"&& cp -a /usr/bin/dash /usr/local/bin/ "\
"&& sed -i 's|shell=True,|shell=True, executable=\"/usr/local/bin/dash\",|g' /usr/local/lib/python2.7/ctypes/util.py "\
"&& cd /src "\
"&& /pyinstaller/pyinstaller.sh --onefile --noconfirm --clean --exclude-module Werkzeug --distpath /finalfs/usr/local/bin proxy.py"
ARG EXECUTABLES="/usr/local/bin/proxy"
ARG REMOVEFILES="/sbin /usr/include /usr/share /usr/sbin" 

#--------Generic template (don't edit)--------
FROM ${CONTENTIMAGE1:-scratch} as content1
FROM ${CONTENTIMAGE2:-scratch} as content2
FROM ${CONTENTIMAGE3:-scratch} as content3
FROM ${INITIMAGE:-${BASEIMAGE:-huggla/base:$TAG}} as init
FROM ${BUILDIMAGE:-huggla/build} as build
FROM ${BASEIMAGE:-huggla/base:$TAG} as final
ARG CONTENTSOURCE1
ARG CONTENTSOURCE1="${CONTENTSOURCE1:-/}"
ARG CONTENTDESTINATION1
ARG CONTENTDESTINATION1="${CONTENTDESTINATION1:-/}"
ARG CONTENTSOURCE2
ARG CONTENTSOURCE2="${CONTENTSOURCE2:-/}"
ARG CONTENTDESTINATION2
ARG CONTENTDESTINATION2="${CONTENTDESTINATION2:-/}"
ARG CONTENTSOURCE3
ARG CONTENTSOURCE3="${CONTENTSOURCE3:-/}"
ARG CONTENTDESTINATION3
ARG CONTENTDESTINATION3="${CONTENTDESTINATION3:-/}"
ARG CLONEGITSDIR
ARG DOWNLOADSDIR
ARG MAKEDIRS
ARG MAKEFILES
ARG EXECUTABLES
ARG STARTUPEXECUTABLES
ARG EXPOSEFUNCTIONS
ARG GID0WRITABLES
ARG GID0WRITABLESRECURSIVE
ARG LINUXUSEROWNED
ARG LINUXUSEROWNEDRECURSIVE
COPY --from=build /finalfs /
#---------------------------------------------

ENV VAR_LINUX_USER="proxy" \
    VAR_GUNICORN_PARAMS="bind=0.0.0.0:5000" \
    VAR_FINAL_COMMAND="proxy \$VAR_GUNICORN_PARAMS"

#--------Generic template (don't edit)--------
USER starter
ONBUILD USER root
#---------------------------------------------
