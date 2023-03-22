#!/bin/bash

#Downloading the epsg file for HEALPix projection.
curl -s -L -o /tmp/proj-5.2.0.zip https://github.com/OSGeo/PROJ/releases/download/5.2.0/proj-5.2.0.zip

#Downloading the natural earth dataset
curl -s -L -o /tmp/NE1_HR_LC_SR_W_DR.zip https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/raster/NE1_HR_LC_SR_W_DR.zip

mkdir -p /storage/mapserver-datasets/earth/naturalearth 

#Unzip the epsg file and copy it to our workdir
unzip /tmp/proj-5.2.0.zip
cp /tmp/proj-5.2.0/nad/epsg /storage/mapserver-datasets

#Unzip the dataset and copy it to our workdir
unzip /tmp/NE1_HR_LC_SR_W_DR.zip 
cp /tmp/NE1_HR_LC_SR_W_DR.tif /storage/mapserver-datasets/earth/naturalearth/NE1_HR_LC_SR_W_DR.tif ;\

#Optimizing the dataset
gdal_translate -co tiled=yes -co compress=deflate /storage/mapserver-datasets/earth/naturalearth/NE1_HR_LC_SR_W_DR.tif /storage/mapserver-datasets/earth/naturalearth/NE1_HR_LC_SR_W_DR.tif
gdaladdo -r cubic /storage/mapserver-datasets/earth/naturalearth/NE1_HR_LC_SR_W_DR.tif 2 4 8 16 

#Adding HEALPix projection to the epsg file
sh -c "$(/bin/echo -e "cat >> /storage/mapserver-datasets/epsg <<EOF
\nScriptAlias /cgi-bin/ /usr/lib/cgi-bin/
\n# custom rotated and scaled HEALPix, magic number is sqrt(2) * 2/pi
\n<900914> +proj=healpix +lon_0=0 +x_0=2.5 +y_0=2.5 +a=0.900316316157106 +rot_xy=45 +no_defs <>
\n# standard HEALPix on unit sphere
\n<900915> +proj=healpix +a=1 +b=1 <>
\nEOF\n")" 

#Creating naturalearth.map file
sh -c "$(/bin/echo -e "cat > /storage/mapserver-datasets/earth/naturalearth/naturalearth.map <<EOF
\nLAYER
\n  NAME \"earth.naturalearth.rgb\"
\n  STATUS ON
\n  TYPE RASTER
\n  DATA \"earth/naturalearth/NE1_HR_LC_SR_W_DR.tif\"
\n
\n  # Decreasing the oversampling factor will increase performance but reduce quality.
\n  PROCESSING \"OVERSAMPLE_RATIO=10\"
\n  PROCESSING \"RESAMPLE=BILINEAR\"
\n
\n  # The GeoTiff is fully geo-referenced, so we can just use AUTO projection here.
\n  PROJECTION
\n    AUTO
\n  END
\n
\n  METADATA
\n    WMS_TITLE \"earth.naturalearth.rgb\"
\n  END
\n  END
\nEOF\n")"

