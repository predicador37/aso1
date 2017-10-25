#!/usr/bin/env bash

# iteracion en todos los archivos y subdirectorios del directorio actual
for file in .* *;
do

# bloque para directorios
if [[ -d $file ]]; then
    # se cuentan las entradas en un subdirectorio dado con wordcount aplicado mediante una tuberia al resultado de ls
    number="$(ls -1 $file | wc -l)"
    echo "$file" "(""$number" "entradas)";
# bloque para archivos
else
    # se calcula el tamaño en kilobytes para cada archivo con du
    size="$(du -kb "$file" | cut -f1)"
    # en función de su tamaño, se utilizan unos u otros multiplicadores de tamaño
    # bash no soporta division en coma flotante, con lo que es necesario llamar a una utilidad del sistema
    # awk esta presente por defecto en la mayor parte de las distribuciones Linux.
    # con awk se calcula la division entre el multiplicador y se almacena el resultado devuelto por print en una
    # variable. No se considera necesario especificar el numero de decimales a mostrar, dado que no se especifica.

    if [ $(($size)) -gt $(( 2**30 ))  ]; then
        value=$(awk -v size=$size 'BEGIN { print size / 1073741824 }')
        echo "$file" "($value" "GiB)"
    elif [ $(($size)) -gt $(( 2**20 ))  ]; then
        value=$(awk -v size=$size 'BEGIN { print size / 1048576 }')
        echo "$file" "($value" "MiB)"
    else
        if [ $(($size/1024)) -eq 0 ]; then
            echo "$file" "(0.$(($size))" "KiB)"
        else
            value=$(awk -v size=$size 'BEGIN { print size / 1024 }')
            echo "$file" "($value" "KiB)"
        fi
    fi
fi
done