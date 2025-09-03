# -*- mode: sh -*-

#———————————————————————————————————————————————————————————————————————————————
# sistemspecifaj variabloj

linux_pc_test && {
  BROWSER=qb
  IMAGE_BROWSER=b
  IMAGE_VIEWER=b
  FIND=find
  GREP=rg
  XARGS=xargs
}

darwin_test && {
  BROWSER=open
  IMAGE_BROWSER=geeqie
  IMAGE_VIEWER=gpicview
  FIND=find
  GREP=egrep
  XARGS=xargs

  path=(
    /usr/local/opt/make/libexec/gnubin
    /usr/local/opt/gnu-getopt/bin
    /usr/local/bin
    $path
  )
}

freebsd_test && {
  BROWSER=firefox
  IMAGE_BROWSER=geeqie
  IMAGE_VIEWER=gpicview
  FIND=find
  GREP=egrep
  XARGS=xargs
}
