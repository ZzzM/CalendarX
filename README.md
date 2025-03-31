<h1 >
<img src=CalendarX/Assets.xcassets/AppIcon.appiconset/icon_512x512.png width=80>
<p>CalendarX</p>
<a href="https://github.com/ZzzM/CalendarX/releases/latest"><img src="https://img.shields.io/github/v/release/ZzzM/CalendarX"></a>
<a href="https://github.com/ZzzM/CalendarX/releases/latest"><img src="https://img.shields.io/github/release-date/ZzzM/CalendarX"></a>
<a href="https://raw.githubusercontent.com/ZzzM/CalendarX/master/LICENSE"><img src="https://img.shields.io/github/license/ZzzM/CalendarX"></a>
<a href="https://zzzm.github.io/2022/04/29/calendarx/">
<img src="https://img.shields.io/badge/docs-%E4%B8%AD%E6%96%87-red">
</a>
</h1>

A lightweight macOS app for displaying calendar and time 

## Features
- [x] Chinese statutory holidays and other festivals
- [x] Custom menubar styles (icon, date & time）
- [x] Dark mode
- [x] Localization (简体中文、English)
- [x] Widget / Interactive Widget / KeyboardShortcut
- [x] SwiftUI / Async / Await

## Compatibility
- Requires **macOS 11.0** or later

## Changelogs
- [简体中文](changelogs/CHANGELOG_SC.md)
- [English](changelogs/CHANGELOG.md)

## Snapshots

### Calendar 

> [!NOTE]
> Left click the menubar item to open it

<img src="assets/001.png" width=250> <img src="assets/002.png" width=250>

### Settings

> [!NOTE]
> Right click the menubar item to open it
    
<img src="assets/003.png" width=250> <img src="assets/003a.png" width=250> 

<img src="assets/003b.png" width=250> <img src="assets/003e.png" width=250> 

> [!TIP]
> Drag and drop to edit `Date & Time Style`

<img src="assets/003c.png" width=250> <img src="assets/003d.png" width=250> 

### Widget / Interactive Widget ( *macOS 14.0 +* )

<img src="assets/010.png" width=250> <img src="assets/010a.png" width=250>
    
## FAQ

1. **"CalendarX.dmg" can't be opened.**
    
    <img src="assets/101.png" width=300> 

1. **"CalendarX" can't be opened.**
    
    <img src="assets/102.png" width=300> 

    **Or**
   
   open `Terminal` and run
    
    ``` shell
    sudo xattr -r -d com.apple.quarantine /Applications/CalendarX.app
    ```
## Dependencies

- [Sparkle](https://github.com/sparkle-project/Sparkle)
- [LaunchAtLogin](https://github.com/sindresorhus/LaunchAtLogin)
- [Schedule](https://github.com/luoxiu/Schedule)  
- [Swift Algorithms](https://github.com/apple/swift-algorithms)
