'use strict'

{app, BrowserWindow, globalShortcut, session} = require 'electron'
{autoUpdater} = require 'electron-updater'
autoUpdater.on 'checking-for-update', ->
  console.log 'checking for update'
autoUpdater.on 'update-available', ->
  console.log 'update-available'
autoUpdater.on 'update-not-available', ->
  console.log 'update-not-available'
autoUpdater.on 'error', ->
  console.log 'error'
autoUpdater.on 'download-progress', ->
  console.log 'download-progress'
autoUpdater.on 'update-downloaded', ->
  console.log 'update-downloaded'


mainWindow = null
tests = [
  /pagead/
  /get_midroll_info/
  /moatads/
  /pubads/
  /amazon-adsystem/
  /video_ads/
]
createWindow = ->
  mode = 'youtube'
  ret = globalShortcut.register 'CommandOrControl+Shift+Q', ->
    app.quit()
  ret = globalShortcut.register 'CommandOrControl+Shift+R', ->
    if mode is 'youtube'
      mode = 'twitch'
      mainWindow.loadURL 'http://www.twitch.tv/'
    else
      mode = 'youtube'
      mainWindow.loadURL 'https://www.youtube.com/feed/subscriptions'
  session.defaultSession.webRequest.onBeforeRequest ['*://*./*'], (details, cb) ->
    result = false
    for test in tests
      if test.test details.url
        result = true
        break
    if result
      cb cancel: true
    else
      cb cancel: false
  mainWindow = new BrowserWindow
    width: 700
    height: 300
    alwaysOnTop: true
    autoHideMenuBar: true
  mainWindow.loadURL 'https://www.youtube.com/feed/subscriptions'
  mainWindow.on 'closed', ->
    mainWindow = null
  mainWindow.openDevTools()
  #mainWindow.webContents.on 'did-finish-load', (event) ->
  #  console.log 'hi', mainWindow.webContents.getURL()
app.on 'ready', createWindow
app.on 'window-all-closed', ->
  process.platform is 'darwin' or app.quit()
app.on 'will-quit', ->
  globalShortcut.unregisterAll()
app.on 'activate', ->
  mainWindow or createWindow()