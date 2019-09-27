for i in *.v; do
    NAME=`echo "$i" | cut -d'.' -f1`
    echo "$i"
    yosys -o "$NAME.blif" -S "$i" 
done
