#!/bin/bash
set -o igncr # ignore CR
p=plugin-container.exe

attrget(){
  : "${1#*$2=\"}" # Remove front
  echo "${_%%\"*}" # Remove back
}

die(){
  echo -e "\e[1;31m$1\e[m"
  exit
}

warn(){
  echo -e "\e[1;35m$1\e[m"
}

pidof(){
  ps -W | grep $1 | cut -c-9
}

pidof $p | xargs /bin/kill -f
echo ProtectedMode=0 > \\windows/system32/macromed/flash/mms.cfg
warn 'Killed flash player for clean dump.
Restart video then press enter here'; read
read < <(pidof $p) || die "$p not found!"
timeout 1 dumper p $REPLY

# Create array
mapfile vids < <(grep -az "video server" p.core | tr "\0" "\n")

# Choose video
for i in "${!vids[@]}"; do
  vid="${vids[i]}"
  read file_type < <(attrget "$vid" "file-type")
  read cdn < <(attrget "$vid" "cdn")
  printf "%2d\t%9s\t%s\n" "$i" "$file_type" "$cdn"
done

warn 'Make choice. Avoid level3.'; read
vid="${vids[REPLY]}"
read server < <(attrget "$vid" "server")
read stream < <(attrget "$vid" "stream")
read token < <(attrget "$vid" "token")
app="${server#*//*/}"

set -x
rtmpdump \
-W "http://download.hulu.com/huludesktop.swf" \
-a "$app?${token//&amp;/&}" \
-o "out.flv" \
-r "$server" \
-y "$stream"
