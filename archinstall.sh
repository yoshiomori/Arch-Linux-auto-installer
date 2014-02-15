#!/bin/sh
# This is a arch linux installer.

# Supondo que o teclado é do formato abnt2, o idioma é português brasileiro
# e que a versão do arch é 2014.02.01
loadkeys br-abnt2
if [ -f locale.gen.aux ]; then
        rm locale.gen.aux
fi
while read line;
do
if [ "$line" == "#pt_BR.UTF-8 UTF-8" ]; then
        echo "pt_BR.UTF-8 UTF-8" >> locale.gen.aux
else
        echo "$line" >> locale.gen.aux
fi
done < /etc/locale.gen
mv -f locale.gen.aux /etc/locale.gen
locale-gen
export LANG=pt_BR.UTF-8
