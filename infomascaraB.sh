#!/usr/bin/env bash

# Comprobación de que el número de argumento de entradas es 2

if [ "$#" -ne 2 ]; then
  echo "Error: El número de argumentos es distinto de 2." >&2
  exit 1
fi

# Asignación de parámetros de entrada a variables

nombre=$1
mascara=$2

# Comprobación de que el archivo existe en el directorio actual

if ! [ -e ./"$nombre" ]; then
  echo "Error: El archivo no existe en el directorio actual."
  exit 1
fi

# Comprobación de que la máscara no tiene 9 caracteres

if [ ${#mascara} != 9 ]; then
  echo "Error: La máscara no tiene 9 caracteres."
  exit 1
fi

# Comprobación de que la máscara contiene caracteres erroneos
# Se considerara erroneo un caracter valido en la mascara pero que no lo es en
# la posicion actual (por ejemplo, w en el permiso de lectura

if ! [[ "$mascara" =~ [r-][w-][-xSs][r-][w-][-xSs][-r][w-][-xTt] ]]; then
  echo "Error: La máscara posee caracteres no válidos."
  exit 1
fi

# Estructura de condicionales que genera la máscara binaria a partir de la simbólica
# siguiendo lo indicado en las páginas 29-30 del libro

if [ ${mascara:0:1} = "r"  ];
then
   B8=1
elif [ ${mascara:0:1} = "-"  ];
then
   B8=0
fi

if [ ${mascara:1:1} = "w"  ];
then
   B7=1
elif [ ${mascara:1:1} = "-"  ];
then
   B7=0
fi

if [ ${mascara:2:1} = "-"  ];
then
   B6=0
   B11=0
elif [ ${mascara:2:1} = "x"  ];
then
   B6=1
   B11=0
elif [ ${mascara:2:1} = "S"  ];
then
   B6=0
   B11=1
elif [ ${mascara:2:1} = "s"  ];
then
   B6=1
   B11=1
fi

if [ ${mascara:3:1} = "r"  ];
then
   B5=1
elif [ ${mascara:3:1} = "-"  ];
then
   B5=0
fi

if [ ${mascara:4:1} = "w"  ];
then
   B4=1
elif [ ${mascara:4:1} = "-"  ];
then
   B4=0
fi

if [ ${mascara:5:1} = "-"  ];
then
   B3=0
   B10=0
elif [ ${mascara:5:1} = "x"  ];
then
   B3=1
   B10=0
elif [ ${mascara:5:1} = "S"  ];
then
   B3=0
   B10=1
elif [ ${mascara:5:1} = "s"  ];
then
   B3=1
   B11=1
fi

if [ ${mascara:6:1} = "r"  ];
then
   B2=1
elif [ ${mascara:6:1} = "-"  ];
then
   B2=0
fi

if [ ${mascara:7:1} = "w"  ];
then
   B1=1
elif [ ${mascara:7:1} = "-"  ];
then
   B1=0
fi

if [ ${mascara:8:1} = "-"  ];
then
   B0=0
   B9=0
elif [ ${mascara:8:1} = "x"  ];
then
   B0=1
   B9=0
elif [ ${mascara:8:1} = "T"  ];
then
   B0=0
   B9=1
elif [ ${mascara:8:1} = "t"  ];
then
   B0=1
   B9=1
fi

# Composición de máscara binaria a través de concatenación directa de bits obtenidos anteriormente

binary="$B11$B10$B9$B8$B7$B6$B5$B4$B3$B2$B1$B0"

# Composición de máscara octal transformando cada grupo de 3 bits en decimal (cuya representación equivale a octal)

octal="$((2#$B11$B10$B9))$((2#$B8$B7$B6))$((2#$B5$B4$B3))$((2#$B2$B1$B0))"

# Salida solicitada

echo "$binary"
echo "$octal"

# Cambio de permisos con chmod y redirección de salida estándar y error al vacío (/dev/null)

chmod "$octal" "$nombre" > /dev/null 2>&1

# Tratamiento personalizado del error

if [ "$?" -ne "0" ]; then
  echo "Error: no se pueden cambiar los permisos"
  exit 1
fi

# Salida en caso de que todo vaya bien

echo "Permisos cambiados"