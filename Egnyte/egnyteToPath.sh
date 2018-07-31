cpboard=$(xsel -b)
cpboard=$(echo "$cpboard" | sed -e 's/\//\\/g' -e 's/https:\/\/oxo.egnyte.com\/app\/index.do#storage\/files\/1\//Z:\//')
echo "$cpboard" | xsel
