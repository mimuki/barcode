#!/bin/bash
# run forever, ctrl-c to kill
until [[ 1 == 0 ]]; do
  # start scanning for a qr code
  # this shows the webcam view, and disabling that was causing problems. rip.
  zbarcam --raw -1 /dev/video0 | { 
    # if you're here, you scanned something
    # expected format of qr code:
    # /home/username/path/to/song.mp3
    # yes it's literally just a hard coded path, fight me
    read qr;
    # if mpv is running, stop it
    # overlapping songs hurt
    pid=$(pidof "mpv")
    if [[ "$pid" ]]; then
      kill "$pid"
    fi
    # & means you can interrupt a song by scanning a different one- otherwise
    # it'd wait for the song to end to restart zbarcam
    mpv "$qr" &
  } 
done
