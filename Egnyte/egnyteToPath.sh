cpboard=$(xsel -b)
path=$(echo "$cpboard" | sed -e 's/\//\\/g' -e 's/%20/ /g' -e 's/https:\\\\oxo\.egnyte\.com\\app\\index\.do\#storage\\files\\1\\/Z:\\/g')
echo "$path" | xsel
