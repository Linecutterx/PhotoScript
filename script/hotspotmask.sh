#! /bin/bash
echo -n "0. X size in pixels? = "
read x
case $x in
    ''|*[!0-9]*) echo "not an integer"
    exit 1;;
    *) arr=($x) ;;
esac
echo -n "1. Y size in pixels? = "
read x
case $x in
    ''|*[!0-9]*) echo "not an integer"
    exit 1;;
    *) arr+=($x) ;;
esac
echo -n "2. Gray level (1-255)? = "
read x
case $x in
    ''|*[!0-9]*) echo "not an integer"
    exit 1;;
    *) arr+=($x) ;;
esac
echo -n "3-4. % transparency for gray mask? = "
read x
case $x in
    ''|*[!0-9]*) echo "not an integer"
    exit 1;;
    *) arr+=($x)
       arr+=("0."$x) ;;
esac
echo -n "5. Sigmoid intensity (3 is typical, 20 is lots)? = "
read x
case $x in
    ''|*[!0-9]*) echo "not an integer"
    exit 1;;
    *) arr+=($x) ;;
esac
echo -n "6. % where sigmoid intensity is half way? = "
read x
case $x in
    ''|*[!0-9]*) echo "not an integer"
    exit 1;;
    *) arr+=($x) ;;
esac

if [[ "${arr[1]}" -lt "${arr[0]}" ]] ; then
  magick -size "${arr[1]}"x"${arr[1]}" radial-gradient:graya\("${arr[2]}","${arr[4]}"\)-none -sigmoidal-contrast "${arr[5]}","${arr[6]}"% -background white -gravity center -extent "${arr[0]}"x"${arr[1]}" \) -compose Copy gradient"${arr[1]}"_"${arr[2]}"-"${arr[3]}"_sigmoid_"${arr[5]}"-"${arr[6]}".png
  echo "gradient"${arr[1]}"_"${arr[2]}"-"${arr[3]}"_sigmoid_"${arr[5]}"-"${arr[6]}".png"
else
  magick -size "${arr[0]}"x"${arr[0]}" radial-gradient:graya\("${arr[2]}","${arr[4]}"\)-none -sigmoidal-contrast "${arr[5]}","${arr[6]}"% -background white -gravity center -extent "${arr[0]}"x"${arr[1]}" \) -compose Copy gradient"${arr[0]}"_"${arr[2]}"-"${arr[3]}"_sigmoid_"${arr[5]}"-"${arr[6]}".png
  echo "gradient"${arr[0]}"_"${arr[2]}"-"${arr[3]}"_sigmoid_"${arr[5]}"-"${arr[6]}".png"
fi
sleep 1
exit 0
