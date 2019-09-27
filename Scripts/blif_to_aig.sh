for i in *.blif; do
    NAME=`echo "$i" | cut -d'.' -f1`
    echo "$i"
    bliftoaig "$i" "$NAME.aig"
done
