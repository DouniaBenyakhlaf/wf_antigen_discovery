#!/bin/bash

# ==============================================================================
# FragPipe 22.0 Dependencies Downloader
# ==============================================================================
# By running this script you confirm that:
#   1. You have read and agree to the MSFragger license:
#      https://msfragger-upgrader.nesvilab.org/upgrader/
#   2. You have read and agree to the IonQuant license:
#      https://msfragger.arsci.com/ionquant/
#   3. You have read and agree to the DIA-Tracer license:
#      https://msfragger-upgrader.nesvilab.org/diatracer/
#   4. Your use is academic/non-commercial
# ==============================================================================
# USAGE: ./fragpipe22.0.dependencies.bash <path_to_folder_for_fragpipe_dependencies>

FILE_PATH="$1"

if [[ -z "$FILE_PATH" ]]; then
  echo "Usage: $0 /path/to/dependencies/folder"
  exit 1
fi

mkdir -p "$FILE_PATH"

# --- User details (used to register for downloads) ---
read -p "Full name: "         NAME
read -p "Email: "             EMAIL
read -p "Institution/Org: "   ORG

# --- MSFragger 4.1 ---
echo "Downloading MSFragger 4.1..."
curl -v 'http://msfragger-upgrader.nesvilab.org/upgrader/upgrade_download.php' \
  -X POST \
  -H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:134.0) Gecko/20100101 Firefox/134.0' \
  -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
  -H 'Accept-Language: en-US,en;q=0.5' \
  -H 'Accept-Encoding: gzip, deflate' \
  -H 'Content-Type: multipart/form-data; boundary=---------------------------291258855610030786962785899' \
  -H 'Origin: http://msfragger-upgrader.nesvilab.org' \
  -H 'Referer: http://msfragger-upgrader.nesvilab.org/upgrader/' \
  -H 'Upgrade-Insecure-Requests: 1' \
  --data-binary $'-----------------------------291258855610030786962785899\r\nContent-Disposition: form-data; name="download"\r\n\r\nRelease 4.1.zip\r\n-----------------------------291258855610030786962785899\r\nContent-Disposition: form-data; name="name"\r\n\r\n'"$NAME"$'\r\n-----------------------------291258855610030786962785899\r\nContent-Disposition: form-data; name="email"\r\n\r\n'"$EMAIL"$'\r\n-----------------------------291258855610030786962785899\r\nContent-Disposition: form-data; name="organization"\r\n\r\n'"$ORG"$'\r\n-----------------------------291258855610030786962785899\r\nContent-Disposition: form-data; name="transfer"\r\n\r\nacademic\r\n-----------------------------291258855610030786962785899\r\nContent-Disposition: form-data; name="agreement2"\r\n\r\non\r\n-----------------------------291258855610030786962785899\r\nContent-Disposition: form-data; name="agreement3"\r\n\r\non\r\n-----------------------------291258855610030786962785899\r\nContent-Disposition: form-data; name="submit"\r\n\r\nDownload\r\n-----------------------------291258855610030786962785899--\r\n' \
  -o "$FILE_PATH/msfragger41.zip" || { echo "MSFragger download failed"; exit 1; }
unzip "$FILE_PATH/msfragger41.zip" -d "$FILE_PATH/"

# --- IonQuant 1.10.27 ---
echo "Downloading IonQuant 1.10.27..."
curl -v 'https://msfragger.arsci.com/ionquant/upgrade_download.php' \
  -X POST \
  -H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:134.0) Gecko/20100101 Firefox/134.0' \
  -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
  -H 'Accept-Language: en-US,en;q=0.5' \
  -H 'Accept-Encoding: gzip, deflate, br, zstd' \
  -H 'Content-Type: multipart/form-data; boundary=---------------------------159956484533540520834165895611' \
  -H 'Origin: https://msfragger.arsci.com' \
  -H 'Connection: keep-alive' \
  -H 'Referer: https://msfragger.arsci.com/ionquant/' \
  -H 'Upgrade-Insecure-Requests: 1' \
  --data-binary $'-----------------------------159956484533540520834165895611\r\nContent-Disposition: form-data; name="download"\r\n\r\n1.10.27.zip\r\n-----------------------------159956484533540520834165895611\r\nContent-Disposition: form-data; name="name"\r\n\r\n'"$NAME"$'\r\n-----------------------------159956484533540520834165895611\r\nContent-Disposition: form-data; name="email"\r\n\r\n'"$EMAIL"$'\r\n-----------------------------159956484533540520834165895611\r\nContent-Disposition: form-data; name="organization"\r\n\r\n'"$ORG"$'\r\n-----------------------------159956484533540520834165895611\r\nContent-Disposition: form-data; name="transfer"\r\n\r\nacademic\r\n-----------------------------159956484533540520834165895611\r\nContent-Disposition: form-data; name="receive_email"\r\n\r\non\r\n-----------------------------159956484533540520834165895611\r\nContent-Disposition: form-data; name="submit"\r\n\r\nDownload\r\n-----------------------------159956484533540520834165895611--\r\n' \
  -o "$FILE_PATH/ionquant11027.zip" || { echo "IonQuant download failed"; exit 1; }
unzip "$FILE_PATH/ionquant11027.zip" -d "$FILE_PATH/"

# --- DIA-Tracer 1.1.5 ---
echo "Downloading DIA-Tracer 1.1.5..."
curl -v 'https://msfragger-upgrader.nesvilab.org/diatracer/upgrade_download.php' \
  -X POST \
  -H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:134.0) Gecko/20100101 Firefox/134.0' \
  -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
  -H 'Accept-Language: en-US,en;q=0.5' \
  -H 'Accept-Encoding: gzip, deflate, br, zstd' \
  -H 'Content-Type: multipart/form-data; boundary=---------------------------278669133717167389084092119486' \
  -H 'Origin: https://msfragger-upgrader.nesvilab.org' \
  -H 'Connection: keep-alive' \
  -H 'Referer: https://msfragger-upgrader.nesvilab.org/diatracer/' \
  -H 'Upgrade-Insecure-Requests: 1' \
  --data-binary $'-----------------------------278669133717167389084092119486\r\nContent-Disposition: form-data; name="download"\r\n\r\n1.1.5.zip\r\n-----------------------------278669133717167389084092119486\r\nContent-Disposition: form-data; name="name"\r\n\r\n'"$NAME"$'\r\n-----------------------------278669133717167389084092119486\r\nContent-Disposition: form-data; name="email"\r\n\r\n'"$EMAIL"$'\r\n-----------------------------278669133717167389084092119486\r\nContent-Disposition: form-data; name="organization"\r\n\r\n'"$ORG"$'\r\n-----------------------------278669133717167389084092119486\r\nContent-Disposition: form-data; name="transfer"\r\n\r\nacademic\r\n-----------------------------278669133717167389084092119486\r\nContent-Disposition: form-data; name="receive_email"\r\n\r\non\r\n-----------------------------278669133717167389084092119486\r\nContent-Disposition: form-data; name="submit"\r\n\r\nDownload\r\n-----------------------------278669133717167389084092119486--\r\n' \
  -o "$FILE_PATH/diatracer115.zip" || { echo "DIA-Tracer download failed"; exit 1; }
unzip "$FILE_PATH/diatracer115.zip" -d "$FILE_PATH/"

echo "All done! Dependencies in $FILE_PATH"