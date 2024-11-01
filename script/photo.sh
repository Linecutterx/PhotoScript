#!/data/data/com.termux/files/usr/bin/bash

#Image locations
rawdir="/storage/emulated/0/DCIM/IR"
batchdir="/storage/emulated/0/DCIM/IR/batch"
outdir="/storage/emulated/0/Pictures/IR"

#Config locations
WBdir="/storage/emulated/0/IR/IR-WB"
SWAPdir="/storage/emulated/0/IR/IR-SWAP"
OPTdir="/storage/emulated/0/IR/IR-OPTS"
IMOPTdir="/storage/emulated/0/IR/MOPTS"
HOTSPOTdir="/storage/emulated/0/IR/IR-HS"
LENSdir="/storage/emulated/0/IR/Lens"
CLUTdir="/storage/emulated/0/IR/CLUT"

#File types/Extensions
rawext="dng"
outext="jpg"

#Script name (arguments)
script_name=$(basename $0)

#This lens has hotspot issues
hotspotlens="6.3 mm"

######################################
### Don't edit anything below here. ##
######################################

#Set Up
rawf=$rawdir"/temp."$rawext
WB=$WBdir"/WB"
SWAP=$SWAPdir"/SWAP"
OPT=$OPTdir"/OPTS"
IMOPT=$IMOPTdir"/OPTS"
HS=$HOTSPOTdir"/HS"
LENS=$LENSdir"/LENS"
CLUT=$CLUTdir"/CLUT"
out=""
echo > $rawf

#############################################
## See if this is batch processing request ##
## batch must be the first argument passed ##
## If not batch: get the file to process   ##
#############################################
case $script_name in
  "batch"* )
    # This is a batch request
    # To be handled here, when I've got time!
    # Will use files=(batchdir/*), default processing settings
    # & will move processed RAW files to the /done folder
    echo "$batchdir"
    mkdir -p $batchdir"/done"
    ;;
  * )
    # Request RAW file for processing
    rawfMDSUM=`stat -c %Y $rawf`
    echo "Choose the raw file you want to process."
    sleep 2
    termux-storage-get $rawf
    while [ `stat -c %Y $rawf` -eq $rawfMDSUM ]; do
      sleep 1
   done
   ;;
esac

##############################################
## See if this is an option setting request ##
## set must be the first argument passed    ##
##############################################

case $script_name in
 "set"* )
    case $script_name in
      *"IR"* )
        echo "IR settimgs"
        case $script_name in
          *"WB"* )
            echo > $WB
            WBMDSUM=`stat -c %Y $WB`
            echo "Choose the white balance file to use."
            sleep 2
            termux-storage-get $WB
            while [ `stat -c %Y $WB` -eq $WBMDSUM ]; do
              sleep 1
            done
            ;;
        esac
        case $script_name in
          *"SWAP"* )
            echo > $SWAP
            SWAPMDSUM=`stat -c %Y $SWAP`
            echo "Choose the colour channel swap file to use."
            sleep 2
            termux-storage-get $SWAP
            while [ `stat -c %Y $SWAP` -eq $SWAPMDSUM ]; do
              sleep 1
            done
            ;;
        esac
        case $script_name in
          *"OPTS"* )
            echo > $OPT
            OPTMDSUM=`stat -c %Y $OPT`
            echo "Choose the imagemagick options file to use for IR."
            sleep 2
            termux-storage-get $OPT
            while [ `stat -c %Y $OPT` -eq $OPTMDSUM ]; do
              sleep 1
            done
            ;;
        esac
        case $script_name in
          *"HOTSPOT"* )
            echo > $HS
            HSMDSUM=`stat -c %Y $HS`
            echo "Choose the hotspot correction to use."
            sleep 2
            termux-storage-get $HS
            while [ `stat -c %Y $HS` -eq $HSMDSUM ]; do
              sleep 1
            done
            ;;
        esac
        case $script_name in
          *"lens"* )
            echo > $LENS
            LENSMDSUM=`stat -c %Y $LENS`
            echo "Choose the lens to use."
            sleep 2
            termux-storage-get $LENS
            while [ `stat -c %Y $LENS` -eq $LENSMDSUM ]; do
              sleep 1
            done
            ;;
        esac
        case $script_name in
          *"clut"* )
            echo > $CLUT
            CLUTMDSUM=`stat -c %Y $CLUT`
            echo "Choose the haldCLUT file to use."
            sleep 2
            termux-storage-get $CLUT
            while [ `stat -c %Y $CLUT` -eq $CLUTMDSUM ]; do
              sleep 1
            done
            ;;
        esac
        ;;
      * )
        echo "Using NonIR  settings"
        # Settings for photos that aren't IR
        case $script_name in
          *"opts"* )
            echo > $IMOPT
            IMOPTMDSUM=`stat -c %Y $IMOPT`
            echo "Choose the imagemagick options file to use."
            sleep 2
            termux-storage-get $IMOPT
            while [ `stat -c %Y $IMOPT` -eq $IMOPTMDSUM ]; do
              sleep 1
            done
            ;;
        esac
        case $script_name in
          *"lens"* )
            echo > $LENS
            LENSMDSUM=`stat -c %Y $LENS`
            echo "Choose the lens to use."
            sleep 2
            termux-storage-get $LENS
            while [ `stat -c %Y $LENS` -eq $LENSMDSUM ]; do
              sleep 1
            done
            ;;
        esac
        case $script_name in
          *"clut"* )
            echo > $CLUT
            CLUTMDSUM=`stat -c %Y $CLUT`
            echo "Choose the haldCLUT file to use."
            sleep 2
            termux-storage-get $CLUT
            while [ `stat -c %Y $CLUT` -eq $CLUTMDSUM ]; do
              sleep 1
            done
         ;;
         esac
        ;;
  esac
  ;;
 *)
   echo "Usimg previous settimgs"
  ;;
esac

echo "settings set"

#######################################
## Read (pre-) selected parameters   ##
## Some are IR specific & some could ##
## apply to either type              ##
#######################################

case $script_name in
      *"IR"* )
        IFS=' ' read -a whitebalance <"$WB"
        IFS='"' read -a mopts <"$SWAP"
        IFS=' ' read -a opts <"$OPT"
        ;;
      * )
        # Not an IR photo
        IFS=' ' read -a opts <"$IMOPT"
        ;;
esac

case $script_name in
      *"lens"* )
        IFS=' ' read -a lens <"$LENS"
        ;;
esac

#Filename for the processed image
echo "Choose the name for the output file"
out=`termux-dialog -t "Output image file" -i "."$outext" added automatically"`
outf=$(echo $out|sed "s/.*text\": \"//g"|sed "s/\" }//g")

out=$outdir"/"$outf"."$outext
echo "Processing"$out". Please be patient...."


#########################
## Collect the options ##
#########################
tweak=()
hotspot=$(dcraw -i -v  $rawf)

case $hotspot in
  *"$hotspotlens"* )
#    IFS=' ' read -a flare <"$HS"
    tweak+=(  "( +clone " "$HS" "-gravity" "center" "-compose" "linear_burn" "-composite ) -flatten "  )
    echo "needs hotspot fix (hotspotlens)" ;;
  *"6.3 mm"* )
    tweak+=(  "( +clone " "$HS" "-gravity" "center" "-compose" "linear_burn" "-composite ) -flatten "  )
#    tweak+=( "$HS" "-gravity" "center" "-compose" "linear_burn" "-composite"  )
    echo "needs hotspot fix (6.3 mm)" ;;
  * )
    echo "Not the 1.0 lens" ;;
esac

#####################
## Lens distortion ##
#####################
case $script_name in
  *"lens"* )
    tweak+=( "-distort" "${lens[@]}" )
    ;;
esac

######################
### Apply hald-CLUT ##
######################
case $script_name in
  *"clut"* )
    tweak+=( "$CLUT" "-hald-clut"  )
    ;;
esac

#############################
## Actually make the image ##
#############################
case $script_name in
  *"IR"* )
    # Uses whitebalance in dcraw, with opts for the colour change & mopts for the channel swaps
    # If the lens is sensitive to hotspots then use correction & then the lens change params & CLUT as usual
      echo "dcraw -c -r" ${whitebalance[@]} $rawf "| magick - " ${opts[@]} ${mopts[@]} ${tweak[@]} $out
      dcraw -c -r ${whitebalance[@]} $rawf | magick - ${opts[@]} ${mopts[@]} ${tweak[@]} $out
    ;;
  * )
    # Non-IR, so uses non-IR opts & lens distortion/haldCLUT if specified
    # Could use a case switch here to use imagemagick on non-RAW files, maybe ...
      echo "dcraw -c" $rawf" | magick - " ${opts[@]} ${tweak[@]} $out 
      dcraw -c $rawf | magick - ${opts[@]} ${tweak[@]} $out 
    ;;
esac
#
##Copy the EXIF data to the processed image
exiftool -TagsFromFile $rawf $out
rm $out"_original"
#
##Make the new image visible to the android gallery
termux-media-scan $out

echo "done"
rm $rawf

exit 0
