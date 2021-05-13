#!/usr/bin/env bash

set -x

P="enjoy"

LV="11.3" # TODO take from conf.lua
LZ="https://github.com/love2d/love/releases/download/${LV}/love-${LV}-win32.zip"


### clean

if [ "$1" == "clean" ]; then
 rm -rf "target"
 exit;
fi



##### build #####

find . -iname "*.lua" | xargs luac -p || { echo 'luac parse test failed' ; exit 1; }

mkdir "target"


### .love

cp -r src target
cd target/src

# compile .ink story into lua table so the runtime will not need lpeg dep.
luarocks install --tree lua_modules lpeg
LUA_PATH='lua_modules/share/lua/5.1/?.lua;lua_modules/share/lua/5.1/?/init.lua;;' LUA_CPATH='lua_modules/lib/lua/5.1/?.so' lua lib/pink/pink/pink.lua parse game.ink > game.lua

zip -9 -r - . > "../${P}.love"
cd -

### .exe

if [ ! -f "target/love-win.zip" ]; then wget "$LZ" -O "target/love-win.zip"; fi
#cp ~/downloads/love-0.10.1-win32.zip "target/love-win.zip"
unzip -o "target/love-win.zip" -d "target"

tmp="target/tmp/"
mkdir -p "$tmp/$P"
cat "target/love-${LV}-win32/love.exe" "target/${P}.love" > "$tmp/${P}/${P}.exe"
cp  target/love-"${LV}"-win32/*dll target/love-"${LV}"-win32/license* "$tmp/$P"
cd "$tmp"
zip -9 -r - "$P" > "${P}-win.zip"
cd -
cp "$tmp/${P}-win.zip" "target/"
rm -r "$tmp"


### web

if [ "$1" == "web" ]; then

cd target
rm -rf love.js *-web*
npm i love.js
mem=$((`stat --printf="%s" "$P.love"` + 8000000)) # not sure about this, it just needs to be big enough
npx love.js --memory $mem --title "$P" "$P.love" "$P-web"
echo "footer, h1 {display:none} body{background:#222}" > "$P-web/theme/love.css"

zip -9 -r - "$P-web" > "${P}-web.zip"
# target/$P-web/ goes to webserver

  if [ "$2" == "run" ]; then
    cd "$P-web"
    python3 -m http.server
  fi
fi
