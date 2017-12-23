#!/bin/bash

rsync -r -t -o -v --progress --modify-window=2 -s /home/anoop/Scripts $1
rsync -r -t -o -v --progress --modify-window=2 -s /home/anoop/Projects $1

rsync -r -t -o -v --progress --modify-window=2 -s /home/anoop/.local $1
rsync -r -t -o -v --progress --modify-window=2 -s /home/anoop/.config $1
rsync -r -t -o -v --progress --modify-window=2 -s /home/anoop/.settings $1
rsync -r -t -o -v --progress --modify-window=2 -s /home/anoop/.ssh $1
rsync -r -t -o -v --progress --modify-window=2 -s /home/anoop/.kde $1
rsync -r -t -o -v --progress --modify-window=2 -s /home/anoop/.Wallpapers $1
rsync -r -t -o -v --progress --modify-window=2 -s /home/anoop/.jupyter $1

# Config Files
rsync -r -t -o -v --progress --modify-window=2 -s /home/anoop/.bashrc $1
rsync -r -t -o -v --progress --modify-window=2 -s /home/anoop/.bash_history $1
rsync -r -t -o -v --progress --modify-window=2 -s /home/anoop/.Renviron $1
rsync -r -t -o -v --progress --modify-window=2 -s /home/anoop/.wgetrc $1
rsync -r -t -o -v --progress --modify-window=2 -s /home/anoop/.octaverc $1
rsync -r -t -o -v --progress --modify-window=2 -s /home/anoop/.npmrc $1
rsync -r -t -o -v --progress --modify-window=2 -s /home/anoop/.gitconfig $1
