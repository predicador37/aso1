#!/usr/bin/env bash

# la variable IFS vacía preserva los espacios en blanco en la entrada de datos. Si no, bash los elimina
# y el resultado se puede adulterar. Ojo con la cadena vacía, que también puede devolver resultado incorrecto.

IFS=''

while [ 1 ]; do

echo -n "Introduzca entrada: "
read input

if [[ "$input" =~ [^0-9A-Za-z] ]] || [[ -z "$input" ]];
then
    echo "Error: entrada no válida, solo se admiten letras y números"

else
    echo "Entrada válida"
fi

test $? -gt 128 && break; done
