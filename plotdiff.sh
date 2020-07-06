#!/bin/bash

#simple script using ImageMagick to create cross-correlations between plotimages

#takes no arguments, and results in n^2 images from the /files directory
#requires PNG input files and ignores other files

#note: as of v6.9.7, imagemagick blacklists ghostscript due to a security bug which
# has been resolved as of 9.26 (default for 18.04) but still needs to be enabled in
# imagemagick settings (located at /etc/ImageMagick-6/policy.yml in 18.04)

# ==== Mechanism ====

# For each image in the /files directory, compare it to every other file in the
# files directory by taking the sum of the differences between the plots (for
# each pixel, output is (a-b) + (b-a) for images a, b

# ==== Dependencies ====

# ghostscript >= v9.24
# imagemagick >= v6

# ==== Settings ====

# input files
FILES="files"
OUTPUT="outfiles"

TEMP="temp"

# ==== End of Settings ====

for f in *.png; do
    for g in *.png; do
        echo $f
        echo $g
        outfile=${OUTPUT}/${f}${g}
        echo ${OUTPUT}
        #imagemagick convert file with blur 0x(blursize) and divide with the blur
        convert $f $g -compose Minus -composite temp/temp1.png
        convert $g $f -compose Minus -composite temp/temp2.png
        convert temp/temp1.png temp/temp2.png -compose Plus -composite $outfile
    done
done
