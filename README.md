# Coronavirus Tracker
Coronavirus tracker app for iOS with Google News Feed.

![iOS](https://img.shields.io/badge/iOS-10%20-blue)
![Swift](https://img.shields.io/badge/Swift-5-orange?logo=Swift&logoColor=white)

![image](https://user-images.githubusercontent.com/16730661/77860923-90117200-721a-11ea-87bb-91012a2a99d6.png)

## Features
* __Live data__: Gets the most recent data from [JHU CRC](https://coronavirus.jhu.edu/map.html).
* __PieCharts__:
   * Total number of cases
   * Estimaded mortality rate
* __Country List__: Shows the countries with number of confirmed, deaths and recovered cases.
* __Map__: Shows recent case numbers for countries and US States.
* __News__: Shows the latest local news about COV-19 ([Google News](https://news.google.com/))
* __Localization__: Supports 17 non-English languages.

## How to Use
Build from source code
1. Clone/Download the repo.
2. `cd CoronavirusTracker`
3. Install the pods `pod install`
4. Open `CoronaTracker.xcworkspace` in Xcode.
5. Choose the target.
6. Build & run!

## Contribute
Please feel free to contribute pull requests or create issues for bugs and feature requests.

## License
The app is available for personal/non-commercial use. It's not allowed to publish, distribute, or use the app in a commercial way.

## Author
Okan Kocyigit (hasanokan@gmail.com)

## Credits
### Data
 * COV-19 Data is provided by [Johns Hopkins Coronavirus Resource Center](https://coronavirus.jhu.edu).
 * News is provided by [Google News](https://news.google.com/)

### Libraries
* [SnapKit](https://github.com/SnapKit/SnapKit): A Swift Autolayout DSL for iOS & OS X
* [Charts](https://github.com/danielgindi/Charts): Beautiful charts for iOS/tvOS/OSX!
* [OpenGraph](https://github.com/satoshi-takano/OpenGraph): A Swift wrapper for the Open Graph protocol (OGP).
* [HanekeSwift](https://github.com/Haneke/HanekeSwift): A lightweight generic cache for iOS written in Swift with extra love for images.
* [Localize-Swift](BTNavigationDropdownMenu): Swift friendly localization and i18n with in-app language switching
* [NVActivityIndicatorView](https://github.com/ninjaprox/NVActivityIndicatorView): A collection of awesome loading animations
* [BTNavigationDropdownMenu](https://github.com/PhamBaTho/BTNavigationDropdownMenu): The elegant dropdown menu, written in Swift,
