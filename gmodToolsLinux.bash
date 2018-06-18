#!/bin/bash
# Create the gmod gma addon file and publish it to steam
#
# Copyright 2018 Christian Luca Lützenkirchen
# This file is part of the "Trouble in Terrorist Town" AddOn "Advanced Player Model Pool" (TTT_APMP).
#
#    TTT_APMP is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or any later version.
#
#    TTT_APMP is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with TTT_APMP.  If not, see <http://www.gnu.org/licenses/>.

#do_create(){
#  ../../.steam/steam/steamapps/common/GarrysMod/bin/gmad_linux create -folder TTT_APMP/ -out ./ttt_apmp.gma
#}
#do_publish(){
#  cd ~/.steam/steam/steamapps/common/GarrysMod/bin
#  LD_LIBRARY_PATH=~/.steam/steam/steamapps/common/GarrysMod/bin/ ./gmpublish_linux create -addon ~/Documents/prog/ttt_apmp.gma -icon ~/Documents/prog/picture.jpg  
#}

$GMOD_TOOLS_DIR="~/.steam/steam/steamapps/common/GarrysMod/bin"

case "$1" in
create)   $GMOD_TOOLS_DIR/gmad_linux create -folder addon/ -out ./ttt_apmp.gma;   exit $? ;;  # not sure if this exit code suits...
publish)  LD_LIBRARY_PATH=$GMOD_TOOLS_DIR $GMOD_TOOLS_DIR/gmpublish_linux create -addon ttt_apmp.gma -icon picture.jpg;    exit $? ;; # not sure if exit code suits...
*)       echo "arguments: create | publish";   exit  1 ;;
esac
