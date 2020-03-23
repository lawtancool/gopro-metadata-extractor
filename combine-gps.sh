if [ ! -f output.csv ]; then
    echo "output.csv does not exist, creating"
    echo "Milliseconds,Latitude,Longitude,Altitude,Speed,Speed3D,TS,GpsAccuracy,GpsFix,Name" > output.csv
else
    echo "output.csv already exists, appending results to it"
fi
find . -iname '*-gps.csv' | while read -r line
do
    if [[ $(wc -l <$line) -ge 2 ]]; then
        echo "Processing $line"
        sed -n -e 2p $line >> output.csv
        extracted_filename=$(echo "$line" | sed 's|^[^/]*\(/[^/]*/\).*$|\1|' | cut -d "/" -f 2)
        sed -i -e '$s','$',"\,$extracted_filename", output.csv
    else
        echo "$line has no data, skipping"
    fi
done
