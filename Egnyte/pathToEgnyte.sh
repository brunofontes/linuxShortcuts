cpboard=$(xsel -b)
cpboard=$(echo "$cpboard" | sed -e 's/\\/\//g' -e 's/Z:\//https:\/\/oxo.egnyte.com\/app\/index.do#storage\/files\/1\//')
chromium "$cpboard"
