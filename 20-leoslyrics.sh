#!/bin/sh -e
#
#  (c) 2004-2008 The Music Player Daemon Project
#  http://www.musicpd.org/
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#

search="http://api.leoslyrics.com/api_search.php?auth=ncmpc"
lyrics="http://api.leoslyrics.com/api_lyrics.php?auth=ncmpc"
cache="$HOME/.lyrics/$1 - $2.txt"

hid=$(wget -q -O- "$search&artist=$1&songtitle=$2" |
	sed -n 's/.*hid="\([^"]*\)".*exactMatch="true".*/\1/p' |
	head -n 1)

test "$hid"

mkdir -p "$(dirname "$cache")"

wget -q -O- "$lyrics&hid=$hid" | awk '
	/<text>/   { go=1; sub(".*<text>", "")  };
	/<\/text>/ { go=0; sub("</text>.*", "") };
	go         { sub("&#xD;", ""); print    };
' | tee "$cache"
