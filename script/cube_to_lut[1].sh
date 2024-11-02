#!/bin/bash
# run this script in the directory containing your luts

for file in *
do
  gmic -input_cube "$file" -r 64,64,64,3,3 -r 512,512,1,3,-1 -o "$file".png
done
