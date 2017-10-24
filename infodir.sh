#!/usr/bin/env bash

# iteracion en todos los archivos y subdirectorios del directorio actual
for file in .* *;
do

# bloque para directorios
if [[ -d $file ]]; then
    # se cuentan las entradas en un subdirectorio dado con wordcount
    number="$(ls -1 $file | wc -l)"
    echo "$file" "(""$number" "entradas)";
# bloque para archivos
else
    # se calcula el tamaño en kilobytes para cada archivo con du
    size="$(du -k "$file" | cut -f1)"
    # en función de su tamaño, se utilizan unos u otros multiplicadores de tamaño
    if [ $(($size * 1000)) -gt $(( 2**30 ))  ]; then
        echo "$file" "($(($size/1048576))" "GiB)"
    elif [ $(($size * 1000)) -gt $(( 2**20 ))  ]; then
        echo "$file" "($(($size/1024))" "MiB)"
    else
        echo "$file" "($(($size))" "KiB)"
    fi
fi
done