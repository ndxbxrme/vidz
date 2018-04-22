(function() {
  'use strict';
  var BrowserWindow, app, createWindow, globalShortcut, mainWindow, session, tests;

  ({app, BrowserWindow, globalShortcut, session} = require('electron'));

  mainWindow = null;

  tests = [/pagead/, /get_midroll_info/, /moatads/, /pubads/, /amazon-adsystem/, /video_ads/];

  createWindow = function() {
    var mode, ret;
    mode = 'youtube';
    ret = globalShortcut.register('CommandOrControl+Shift+Q', function() {
      return app.quit();
    });
    ret = globalShortcut.register('CommandOrControl+Shift+R', function() {
      if (mode === 'youtube') {
        mode = 'twitch';
        return mainWindow.loadURL('http://www.twitch.tv/');
      } else {
        mode = 'youtube';
        return mainWindow.loadURL('https://www.youtube.com/feed/subscriptions');
      }
    });
    session.defaultSession.webRequest.onBeforeRequest(['*://*./*'], function(details, cb) {
      var i, len, result, test;
      result = false;
      for (i = 0, len = tests.length; i < len; i++) {
        test = tests[i];
        if (test.test(details.url)) {
          result = true;
          break;
        }
      }
      if (result) {
        return cb({
          cancel: true
        });
      } else {
        return cb({
          cancel: false
        });
      }
    });
    mainWindow = new BrowserWindow({
      width: 700,
      height: 300,
      alwaysOnTop: true,
      autoHideMenuBar: true
    });
    mainWindow.loadURL('https://www.youtube.com/feed/subscriptions');
    return mainWindow.on('closed', function() {
      return mainWindow = null;
    });
  };

  //mainWindow.webContents.on 'did-finish-load', (event) ->
  //  console.log 'hi', mainWindow.webContents.getURL()
  app.on('ready', createWindow);

  app.on('window-all-closed', function() {
    return process.platform === 'darwin' || app.quit();
  });

  app.on('will-quit', function() {
    return globalShortcut.unregisterAll();
  });

  app.on('activate', function() {
    return mainWindow || createWindow();
  });

}).call(this);

//# sourceMappingURL=main.js.map
