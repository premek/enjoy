#!/usr/bin/env bash

set -x

P="enjoy"

LV="0.10.1"
LZ="https://bitbucket.org/rude/love/downloads/love-${LV}-win32.zip"


### clean

if [ "$1" == "clean" ]; then
 rm -rf "target"
 exit;
fi


### deploy

if [ "$1" == "deploy" ]; then
 # $2 = premek/forest

 cd "target/${P}-web"
 git init
 git config user.name "autodeploy"
 git config user.email "autodeploy"
 touch .
 git add .
 git commit -m "deploy to github pages"
 git push --force --quiet "https://${GH_TOKEN}@github.com/${2}.git" master:gh-pages

 exit;
fi



##### build #####

find . -iname "*.lua" | xargs luac -p || { echo 'luac parse test failed' ; exit 1; }

mkdir "target"


### .love

cd src
zip -9 -r - . > "../target/${P}.love"
cd ..

### .exe

wget "$LZ" -O "target/love-win.zip"
unzip -o "target/love-win.zip" -d "target"

tmp=`mktemp -p . -d 2>/dev/null || mktemp -p . -d -t 'mytmpdir'`
mkdir "$tmp/$P"
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
git clone https://github.com/TannerRogalsky/love.js.git
cd love.js
git checkout 6fa910c2a28936c3ec4eaafb014405a765382e08
git submodule update --init --recursive

cd release-compatibility
python ../emscripten/tools/file_packager.py game.data --preload ../../../src/@/ --js-output=game.js
python ../emscripten/tools/file_packager.py game.data --preload ../../../src/@/ --js-output=game.js
#yes, two times!
# python -m SimpleHTTPServer 8000
cd ../..
cp -r love.js/release-compatibility "$P-web"
zip -9 -r - "$P-web" > "${P}-web.zip"
# target/$P-web/ goes to webserver
fi
