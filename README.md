# <img src="https://flutter.io/images/flutter-mark-square-100.png" alt="Flutter" width="40" height="40" /> Decide For Me ![license](https://img.shields.io/github/license/mashape/apistatus.svg?style=plastic) ![size](https://img.shields.io/badge/size-160KB-green.svg?longCache=true&style=plastic)

## Description

Headache about what to eat, where to go and more? Get the app and check nearby places or get some random suggestions.

This is a flutter app integrated with Google Place API to retreive nearby places.

## How to use

1. Setup flutter project.
   For help getting started with Flutter, view 
[![Read the Docs](https://img.shields.io/readthedocs/pip.svg?style=plastic)](https://flutter.io/get-started/install/)
2. Download the code and replace the files in your flutter project. The app uses [location plugin](https://pub.dartlang.org/packages/location), make sure to:

	- add 
	  ```
      NSLocationWhenInUseUsageDescription
	  NSLocationAlwaysUsageDescription
      ```
      in [Info.plist](https://github.com/RogerShenAU/Decide-For-Me/blob/master/ios/Runner/Info.plist)
      
    - and add
      ```
      <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
      ```
      in [AndroidManifest.xml](https://github.com/RogerShenAU/Decide-For-Me/blob/master/android/app/src/main/AndroidManifest.xml)
      
3. Change ```YOUR_API_KEY``` in [services.dart](/lib/services.dart) to your google API key. Then you are good to go. 
4. For more Google Place API documentation, view [![Read the Docs](https://img.shields.io/readthedocs/pip.svg?style=plastic)](https://developers.google.com/places/)


## Screenshot 

App screenshot for iPhone X

![screeenshot](flutter_01.png)



