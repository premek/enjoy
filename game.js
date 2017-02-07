
var Module;

if (typeof Module === 'undefined') Module = eval('(function() { try { return Module || {} } catch(e) { return {} } })()');

if (!Module.expectedDataFileDownloads) {
  Module.expectedDataFileDownloads = 0;
  Module.finishedDataFileDownloads = 0;
}
Module.expectedDataFileDownloads++;
(function() {
 var loadPackage = function(metadata) {

    var PACKAGE_PATH;
    if (typeof window === 'object') {
      PACKAGE_PATH = window['encodeURIComponent'](window.location.pathname.toString().substring(0, window.location.pathname.toString().lastIndexOf('/')) + '/');
    } else if (typeof location !== 'undefined') {
      // worker
      PACKAGE_PATH = encodeURIComponent(location.pathname.toString().substring(0, location.pathname.toString().lastIndexOf('/')) + '/');
    } else {
      throw 'using preloaded data can only be done on a web page or in a web worker';
    }
    var PACKAGE_NAME = 'game.data';
    var REMOTE_PACKAGE_BASE = 'game.data';
    if (typeof Module['locateFilePackage'] === 'function' && !Module['locateFile']) {
      Module['locateFile'] = Module['locateFilePackage'];
      Module.printErr('warning: you defined Module.locateFilePackage, that has been renamed to Module.locateFile (using your locateFilePackage for now)');
    }
    var REMOTE_PACKAGE_NAME = typeof Module['locateFile'] === 'function' ?
                              Module['locateFile'](REMOTE_PACKAGE_BASE) :
                              ((Module['filePackagePrefixURL'] || '') + REMOTE_PACKAGE_BASE);
  
    var REMOTE_PACKAGE_SIZE = metadata.remote_package_size;
    var PACKAGE_UUID = metadata.package_uuid;
  
    function fetchRemotePackage(packageName, packageSize, callback, errback) {
      var xhr = new XMLHttpRequest();
      xhr.open('GET', packageName, true);
      xhr.responseType = 'arraybuffer';
      xhr.onprogress = function(event) {
        var url = packageName;
        var size = packageSize;
        if (event.total) size = event.total;
        if (event.loaded) {
          if (!xhr.addedTotal) {
            xhr.addedTotal = true;
            if (!Module.dataFileDownloads) Module.dataFileDownloads = {};
            Module.dataFileDownloads[url] = {
              loaded: event.loaded,
              total: size
            };
          } else {
            Module.dataFileDownloads[url].loaded = event.loaded;
          }
          var total = 0;
          var loaded = 0;
          var num = 0;
          for (var download in Module.dataFileDownloads) {
          var data = Module.dataFileDownloads[download];
            total += data.total;
            loaded += data.loaded;
            num++;
          }
          total = Math.ceil(total * Module.expectedDataFileDownloads/num);
          if (Module['setStatus']) Module['setStatus']('Downloading data... (' + loaded + '/' + total + ')');
        } else if (!Module.dataFileDownloads) {
          if (Module['setStatus']) Module['setStatus']('Downloading data...');
        }
      };
      xhr.onload = function(event) {
        var packageData = xhr.response;
        callback(packageData);
      };
      xhr.send(null);
    };

    function handleError(error) {
      console.error('package error:', error);
    };
  
      var fetched = null, fetchedCallback = null;
      fetchRemotePackage(REMOTE_PACKAGE_NAME, REMOTE_PACKAGE_SIZE, function(data) {
        if (fetchedCallback) {
          fetchedCallback(data);
          fetchedCallback = null;
        } else {
          fetched = data;
        }
      }, handleError);
    
  function runWithFS() {

    function assert(check, msg) {
      if (!check) throw msg + new Error().stack;
    }
Module['FS_createPath']('/', 'font', true, true);
Module['FS_createPath']('/', 'gamestate', true, true);
Module['FS_createPath']('/', 'img', true, true);
Module['FS_createPath']('/', 'lib', true, true);
Module['FS_createPath']('/lib', 'hump', true, true);
Module['FS_createPath']('/lib/hump', 'docs', true, true);
Module['FS_createPath']('/lib/hump/docs', '_static', true, true);
Module['FS_createPath']('/lib/hump', 'spec', true, true);
Module['FS_createPath']('/lib', 'pink', true, true);
Module['FS_createPath']('/lib/pink', 'examples', true, true);
Module['FS_createPath']('/lib/pink/examples', 'love2d', true, true);
Module['FS_createPath']('/lib/pink', 'pink', true, true);
Module['FS_createPath']('/lib/pink', 'test', true, true);
Module['FS_createPath']('/lib', 'suit', true, true);
Module['FS_createPath']('/lib/suit', 'docs', true, true);
Module['FS_createPath']('/lib/suit/docs', '_static', true, true);
Module['FS_createPath']('/', 'music', true, true);
Module['FS_createPath']('/', 'rooms', true, true);
Module['FS_createPath']('/', 'sfx', true, true);

    function DataRequest(start, end, crunched, audio) {
      this.start = start;
      this.end = end;
      this.crunched = crunched;
      this.audio = audio;
    }
    DataRequest.prototype = {
      requests: {},
      open: function(mode, name) {
        this.name = name;
        this.requests[name] = this;
        Module['addRunDependency']('fp ' + this.name);
      },
      send: function() {},
      onload: function() {
        var byteArray = this.byteArray.subarray(this.start, this.end);

          this.finish(byteArray);

      },
      finish: function(byteArray) {
        var that = this;

        Module['FS_createDataFile'](this.name, null, byteArray, true, true, true); // canOwn this data in the filesystem, it is a slide into the heap that will never change
        Module['removeRunDependency']('fp ' + that.name);

        this.requests[this.name] = null;
      },
    };

        var files = metadata.files;
        for (i = 0; i < files.length; ++i) {
          new DataRequest(files[i].start, files[i].end, files[i].crunched, files[i].audio).open('GET', files[i].filename);
        }

  
    function processPackageData(arrayBuffer) {
      Module.finishedDataFileDownloads++;
      assert(arrayBuffer, 'Loading data file failed.');
      assert(arrayBuffer instanceof ArrayBuffer, 'bad input to processPackageData');
      var byteArray = new Uint8Array(arrayBuffer);
      var curr;
      
        // copy the entire loaded file into a spot in the heap. Files will refer to slices in that. They cannot be freed though
        // (we may be allocating before malloc is ready, during startup).
        if (Module['SPLIT_MEMORY']) Module.printErr('warning: you should run the file packager with --no-heap-copy when SPLIT_MEMORY is used, otherwise copying into the heap may fail due to the splitting');
        var ptr = Module['getMemory'](byteArray.length);
        Module['HEAPU8'].set(byteArray, ptr);
        DataRequest.prototype.byteArray = Module['HEAPU8'].subarray(ptr, ptr+byteArray.length);
  
          var files = metadata.files;
          for (i = 0; i < files.length; ++i) {
            DataRequest.prototype.requests[files[i].filename].onload();
          }
              Module['removeRunDependency']('datafile_game.data');

    };
    Module['addRunDependency']('datafile_game.data');
  
    if (!Module.preloadResults) Module.preloadResults = {};
  
      Module.preloadResults[PACKAGE_NAME] = {fromCache: false};
      if (fetched) {
        processPackageData(fetched);
        fetched = null;
      } else {
        fetchedCallback = processPackageData;
      }
    
  }
  if (Module['calledRun']) {
    runWithFS();
  } else {
    if (!Module['preRun']) Module['preRun'] = [];
    Module["preRun"].push(runWithFS); // FS is not initialized yet, wait for it
  }

 }
 loadPackage({"files": [{"audio": 0, "start": 0, "crunched": 0, "end": 7512, "filename": "/CRT.frag"}, {"audio": 0, "start": 7512, "crunched": 0, "end": 9647, "filename": "/assets.lua"}, {"audio": 0, "start": 9647, "crunched": 0, "end": 9953, "filename": "/conf.lua"}, {"audio": 0, "start": 9953, "crunched": 0, "end": 12622, "filename": "/game.ink"}, {"audio": 0, "start": 12622, "crunched": 0, "end": 12920, "filename": "/joystick.lua"}, {"audio": 0, "start": 12920, "crunched": 0, "end": 14702, "filename": "/main.lua"}, {"audio": 0, "start": 14702, "crunched": 0, "end": 19104, "filename": "/game.lua"}, {"audio": 0, "start": 19104, "crunched": 0, "end": 58156, "filename": "/font/FUTRFW.TTF"}, {"audio": 0, "start": 58156, "crunched": 0, "end": 78120, "filename": "/font/tom-thumb.bdf"}, {"audio": 0, "start": 78120, "crunched": 0, "end": 79250, "filename": "/gamestate/_menu.lua"}, {"audio": 0, "start": 79250, "crunched": 0, "end": 79964, "filename": "/gamestate/mainmenu.lua"}, {"audio": 0, "start": 79964, "crunched": 0, "end": 80583, "filename": "/gamestate/pause.lua"}, {"audio": 0, "start": 80583, "crunched": 0, "end": 87525, "filename": "/gamestate/playing.lua"}, {"audio": 0, "start": 87525, "crunched": 0, "end": 89161, "filename": "/img/basement.png"}, {"audio": 0, "start": 89161, "crunched": 0, "end": 90691, "filename": "/img/hallway-open.png"}, {"audio": 0, "start": 90691, "crunched": 0, "end": 92182, "filename": "/img/hallway.png"}, {"audio": 0, "start": 92182, "crunched": 0, "end": 94197, "filename": "/img/me.png"}, {"audio": 0, "start": 94197, "crunched": 0, "end": 95788, "filename": "/img/neighbour.png"}, {"audio": 0, "start": 95788, "crunched": 0, "end": 97069, "filename": "/img/neighbour2.png"}, {"audio": 0, "start": 97069, "crunched": 0, "end": 98453, "filename": "/img/palm.png"}, {"audio": 0, "start": 98453, "crunched": 0, "end": 99868, "filename": "/lib/require.lua"}, {"audio": 0, "start": 99868, "crunched": 0, "end": 101893, "filename": "/lib/util.lua"}, {"audio": 0, "start": 101893, "crunched": 0, "end": 101936, "filename": "/lib/hump/.git"}, {"audio": 0, "start": 101936, "crunched": 0, "end": 104155, "filename": "/lib/hump/README.md"}, {"audio": 0, "start": 104155, "crunched": 0, "end": 110222, "filename": "/lib/hump/camera.lua"}, {"audio": 0, "start": 110222, "crunched": 0, "end": 113288, "filename": "/lib/hump/class.lua"}, {"audio": 0, "start": 113288, "crunched": 0, "end": 116821, "filename": "/lib/hump/gamestate.lua"}, {"audio": 0, "start": 116821, "crunched": 0, "end": 119353, "filename": "/lib/hump/signal.lua"}, {"audio": 0, "start": 119353, "crunched": 0, "end": 125886, "filename": "/lib/hump/timer.lua"}, {"audio": 0, "start": 125886, "crunched": 0, "end": 129446, "filename": "/lib/hump/vector-light.lua"}, {"audio": 0, "start": 129446, "crunched": 0, "end": 134765, "filename": "/lib/hump/vector.lua"}, {"audio": 0, "start": 134765, "crunched": 0, "end": 142166, "filename": "/lib/hump/docs/Makefile"}, {"audio": 0, "start": 142166, "crunched": 0, "end": 156642, "filename": "/lib/hump/docs/camera.rst"}, {"audio": 0, "start": 156642, "crunched": 0, "end": 165729, "filename": "/lib/hump/docs/class.rst"}, {"audio": 0, "start": 165729, "crunched": 0, "end": 175065, "filename": "/lib/hump/docs/conf.py"}, {"audio": 0, "start": 175065, "crunched": 0, "end": 184188, "filename": "/lib/hump/docs/gamestate.rst"}, {"audio": 0, "start": 184188, "crunched": 0, "end": 185490, "filename": "/lib/hump/docs/index.rst"}, {"audio": 0, "start": 185490, "crunched": 0, "end": 186795, "filename": "/lib/hump/docs/license.rst"}, {"audio": 0, "start": 186795, "crunched": 0, "end": 191251, "filename": "/lib/hump/docs/signal.rst"}, {"audio": 0, "start": 191251, "crunched": 0, "end": 204071, "filename": "/lib/hump/docs/timer.rst"}, {"audio": 0, "start": 204071, "crunched": 0, "end": 213626, "filename": "/lib/hump/docs/vector-light.rst"}, {"audio": 0, "start": 213626, "crunched": 0, "end": 223776, "filename": "/lib/hump/docs/vector.rst"}, {"audio": 0, "start": 223776, "crunched": 0, "end": 230750, "filename": "/lib/hump/docs/_static/graph-tweens.js"}, {"audio": 0, "start": 230750, "crunched": 0, "end": 333586, "filename": "/lib/hump/docs/_static/in-out-interpolators.png"}, {"audio": 0, "start": 333586, "crunched": 0, "end": 430350, "filename": "/lib/hump/docs/_static/interpolators.png"}, {"audio": 0, "start": 430350, "crunched": 0, "end": 485826, "filename": "/lib/hump/docs/_static/inv-interpolators.png"}, {"audio": 0, "start": 485826, "crunched": 0, "end": 499251, "filename": "/lib/hump/docs/_static/vector-cross.png"}, {"audio": 0, "start": 499251, "crunched": 0, "end": 512357, "filename": "/lib/hump/docs/_static/vector-mirrorOn.png"}, {"audio": 0, "start": 512357, "crunched": 0, "end": 526125, "filename": "/lib/hump/docs/_static/vector-perpendicular.png"}, {"audio": 0, "start": 526125, "crunched": 0, "end": 556032, "filename": "/lib/hump/docs/_static/vector-projectOn.png"}, {"audio": 0, "start": 556032, "crunched": 0, "end": 568714, "filename": "/lib/hump/docs/_static/vector-rotated.png"}, {"audio": 0, "start": 568714, "crunched": 0, "end": 570343, "filename": "/lib/hump/spec/timer_spec.lua"}, {"audio": 0, "start": 570343, "crunched": 0, "end": 570386, "filename": "/lib/pink/.git"}, {"audio": 0, "start": 570386, "crunched": 0, "end": 570393, "filename": "/lib/pink/.gitignore"}, {"audio": 0, "start": 570393, "crunched": 0, "end": 571464, "filename": "/lib/pink/LICENSE"}, {"audio": 0, "start": 571464, "crunched": 0, "end": 574948, "filename": "/lib/pink/README.md"}, {"audio": 0, "start": 574948, "crunched": 0, "end": 674438, "filename": "/lib/pink/luaunit.lua"}, {"audio": 0, "start": 674438, "crunched": 0, "end": 676094, "filename": "/lib/pink/test.lua"}, {"audio": 0, "start": 676094, "crunched": 0, "end": 677648, "filename": "/lib/pink/util.lua"}, {"audio": 0, "start": 677648, "crunched": 0, "end": 678248, "filename": "/lib/pink/examples/game.ink"}, {"audio": 0, "start": 678248, "crunched": 0, "end": 678844, "filename": "/lib/pink/examples/game.lua"}, {"audio": 0, "start": 678844, "crunched": 0, "end": 679947, "filename": "/lib/pink/examples/love2d/main.lua"}, {"audio": 0, "start": 679947, "crunched": 0, "end": 682528, "filename": "/lib/pink/pink/parser.lua"}, {"audio": 0, "start": 682528, "crunched": 0, "end": 684594, "filename": "/lib/pink/pink/pink.lua"}, {"audio": 0, "start": 684594, "crunched": 0, "end": 687051, "filename": "/lib/pink/pink/runtime.lua"}, {"audio": 0, "start": 687051, "crunched": 0, "end": 687881, "filename": "/lib/pink/test/basic.lua"}, {"audio": 0, "start": 687881, "crunched": 0, "end": 689719, "filename": "/lib/pink/test/branching.lua"}, {"audio": 0, "start": 689719, "crunched": 0, "end": 690677, "filename": "/lib/pink/test/choices.lua"}, {"audio": 0, "start": 690677, "crunched": 0, "end": 691542, "filename": "/lib/pink/test/glue.lua"}, {"audio": 0, "start": 691542, "crunched": 0, "end": 692175, "filename": "/lib/pink/test/knot.lua"}, {"audio": 0, "start": 692175, "crunched": 0, "end": 692492, "filename": "/lib/pink/test/nested.lua"}, {"audio": 0, "start": 692492, "crunched": 0, "end": 693223, "filename": "/lib/pink/test/nested2.lua"}, {"audio": 0, "start": 693223, "crunched": 0, "end": 693266, "filename": "/lib/suit/.git"}, {"audio": 0, "start": 693266, "crunched": 0, "end": 693282, "filename": "/lib/suit/.gitignore"}, {"audio": 0, "start": 693282, "crunched": 0, "end": 694885, "filename": "/lib/suit/README.md"}, {"audio": 0, "start": 694885, "crunched": 0, "end": 695583, "filename": "/lib/suit/button.lua"}, {"audio": 0, "start": 695583, "crunched": 0, "end": 696406, "filename": "/lib/suit/checkbox.lua"}, {"audio": 0, "start": 696406, "crunched": 0, "end": 700403, "filename": "/lib/suit/core.lua"}, {"audio": 0, "start": 700403, "crunched": 0, "end": 701741, "filename": "/lib/suit/imagebutton.lua"}, {"audio": 0, "start": 701741, "crunched": 0, "end": 704202, "filename": "/lib/suit/init.lua"}, {"audio": 0, "start": 704202, "crunched": 0, "end": 707664, "filename": "/lib/suit/input.lua"}, {"audio": 0, "start": 707664, "crunched": 0, "end": 708361, "filename": "/lib/suit/label.lua"}, {"audio": 0, "start": 708361, "crunched": 0, "end": 717218, "filename": "/lib/suit/layout.lua"}, {"audio": 0, "start": 717218, "crunched": 0, "end": 718501, "filename": "/lib/suit/license.txt"}, {"audio": 0, "start": 718501, "crunched": 0, "end": 720109, "filename": "/lib/suit/slider.lua"}, {"audio": 0, "start": 720109, "crunched": 0, "end": 724068, "filename": "/lib/suit/theme.lua"}, {"audio": 0, "start": 724068, "crunched": 0, "end": 731469, "filename": "/lib/suit/docs/Makefile"}, {"audio": 0, "start": 731469, "crunched": 0, "end": 740805, "filename": "/lib/suit/docs/conf.py"}, {"audio": 0, "start": 740805, "crunched": 0, "end": 747027, "filename": "/lib/suit/docs/core.rst"}, {"audio": 0, "start": 747027, "crunched": 0, "end": 759002, "filename": "/lib/suit/docs/gettingstarted.rst"}, {"audio": 0, "start": 759002, "crunched": 0, "end": 767209, "filename": "/lib/suit/docs/index.rst"}, {"audio": 0, "start": 767209, "crunched": 0, "end": 773950, "filename": "/lib/suit/docs/layout.rst"}, {"audio": 0, "start": 773950, "crunched": 0, "end": 775250, "filename": "/lib/suit/docs/license.rst"}, {"audio": 0, "start": 775250, "crunched": 0, "end": 775302, "filename": "/lib/suit/docs/themes.rst"}, {"audio": 0, "start": 775302, "crunched": 0, "end": 781367, "filename": "/lib/suit/docs/widgets.rst"}, {"audio": 0, "start": 781367, "crunched": 0, "end": 2105721, "filename": "/lib/suit/docs/_static/demo.gif"}, {"audio": 0, "start": 2105721, "crunched": 0, "end": 2154250, "filename": "/lib/suit/docs/_static/hello-world.gif"}, {"audio": 0, "start": 2154250, "crunched": 0, "end": 2163543, "filename": "/lib/suit/docs/_static/keyboard.gif"}, {"audio": 0, "start": 2163543, "crunched": 0, "end": 2223893, "filename": "/lib/suit/docs/_static/layout.gif"}, {"audio": 0, "start": 2223893, "crunched": 0, "end": 2303495, "filename": "/lib/suit/docs/_static/mutable-state.gif"}, {"audio": 0, "start": 2303495, "crunched": 0, "end": 2355489, "filename": "/lib/suit/docs/_static/options.gif"}, {"audio": 1, "start": 2355489, "crunched": 0, "end": 14732257, "filename": "/music/Jonas K - Tonight (Original).mp3"}, {"audio": 1, "start": 14732257, "crunched": 0, "end": 15989781, "filename": "/music/song_002_r1_session.ogg"}, {"audio": 0, "start": 15989781, "crunched": 0, "end": 15990036, "filename": "/rooms/0-0-start.lua"}, {"audio": 0, "start": 15990036, "crunched": 0, "end": 15990475, "filename": "/rooms/0-1-b.lua"}, {"audio": 0, "start": 15990475, "crunched": 0, "end": 15990706, "filename": "/rooms/0-2-b.lua"}, {"audio": 0, "start": 15990706, "crunched": 0, "end": 15990894, "filename": "/rooms/0-3-h.lua"}, {"audio": 0, "start": 15990894, "crunched": 0, "end": 15991070, "filename": "/rooms/1-0-h.lua"}, {"audio": 0, "start": 15991070, "crunched": 0, "end": 15991246, "filename": "/rooms/1-1-b.lua"}, {"audio": 0, "start": 15991246, "crunched": 0, "end": 15991440, "filename": "/rooms/1-2-b.lua"}, {"audio": 0, "start": 15991440, "crunched": 0, "end": 15991628, "filename": "/rooms/1-3-h.lua"}, {"audio": 0, "start": 15991628, "crunched": 0, "end": 15991804, "filename": "/rooms/2-0-h.lua"}, {"audio": 0, "start": 15991804, "crunched": 0, "end": 15991980, "filename": "/rooms/2-1-b.lua"}, {"audio": 0, "start": 15991980, "crunched": 0, "end": 15992174, "filename": "/rooms/2-2-b.lua"}, {"audio": 0, "start": 15992174, "crunched": 0, "end": 15992362, "filename": "/rooms/2-3-h.lua"}, {"audio": 0, "start": 15992362, "crunched": 0, "end": 15992567, "filename": "/rooms/3-0-h.lua"}, {"audio": 0, "start": 15992567, "crunched": 0, "end": 15992743, "filename": "/rooms/3-1-b.lua"}, {"audio": 0, "start": 15992743, "crunched": 0, "end": 15992937, "filename": "/rooms/3-2-b.lua"}, {"audio": 0, "start": 15992937, "crunched": 0, "end": 15993125, "filename": "/rooms/3-3-h.lua"}, {"audio": 0, "start": 15993125, "crunched": 0, "end": 15993331, "filename": "/rooms/4-0-h.lua"}, {"audio": 0, "start": 15993331, "crunched": 0, "end": 15993507, "filename": "/rooms/4-1-b.lua"}, {"audio": 0, "start": 15993507, "crunched": 0, "end": 15993701, "filename": "/rooms/4-2-b.lua"}, {"audio": 0, "start": 15993701, "crunched": 0, "end": 15993889, "filename": "/rooms/4-3-h.lua"}, {"audio": 0, "start": 15993889, "crunched": 0, "end": 15994065, "filename": "/rooms/5-0-h.lua"}, {"audio": 0, "start": 15994065, "crunched": 0, "end": 15994274, "filename": "/rooms/5-1-b.lua"}, {"audio": 0, "start": 15994274, "crunched": 0, "end": 15994468, "filename": "/rooms/5-2-b.lua"}, {"audio": 0, "start": 15994468, "crunched": 0, "end": 15994656, "filename": "/rooms/5-3-h.lua"}, {"audio": 0, "start": 15994656, "crunched": 0, "end": 15994899, "filename": "/rooms/6-0-h.lua"}, {"audio": 0, "start": 15994899, "crunched": 0, "end": 15995275, "filename": "/rooms/6-1-b.lua"}, {"audio": 0, "start": 15995275, "crunched": 0, "end": 15995506, "filename": "/rooms/6-2-b.lua"}, {"audio": 0, "start": 15995506, "crunched": 0, "end": 15995784, "filename": "/rooms/6-3-h.lua"}, {"audio": 0, "start": 15995784, "crunched": 0, "end": 15996259, "filename": "/rooms/7-0-h.lua"}, {"audio": 0, "start": 15996259, "crunched": 0, "end": 15996417, "filename": "/rooms/7-1-b.lua"}, {"audio": 0, "start": 15996417, "crunched": 0, "end": 15996611, "filename": "/rooms/7-2-b.lua"}, {"audio": 0, "start": 15996611, "crunched": 0, "end": 15997524, "filename": "/rooms/7-3-h.lua"}, {"audio": 0, "start": 15997524, "crunched": 0, "end": 15997728, "filename": "/rooms/99-0-h.lua"}, {"audio": 0, "start": 15997728, "crunched": 0, "end": 15997929, "filename": "/rooms/99-1-b.lua"}, {"audio": 0, "start": 15997929, "crunched": 0, "end": 15998146, "filename": "/rooms/99-2-b.lua"}, {"audio": 0, "start": 15998146, "crunched": 0, "end": 15998357, "filename": "/rooms/99-3-h.lua"}, {"audio": 0, "start": 15998357, "crunched": 0, "end": 15998660, "filename": "/rooms/palms-h.lua"}, {"audio": 1, "start": 15998660, "crunched": 0, "end": 16008536, "filename": "/sfx/click.wav"}, {"audio": 1, "start": 16008536, "crunched": 0, "end": 16017112, "filename": "/sfx/click1.wav"}], "remote_package_size": 16017112, "package_uuid": "b72eaec4-f02f-4a9a-8942-b55b31745733"});

})();
