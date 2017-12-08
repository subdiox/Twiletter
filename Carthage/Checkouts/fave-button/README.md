# FaveButton
Favorite Animated Button written in Swift  
(Forked from [fave-button](https://github.com/xhamr/yosei-yamagishi/fave-button) and [DOFavoriteButton](https://github.com/okmr-d/DOFavoriteButton))

![star](https://raw.githubusercontent.com/okmr-d/okmr-d.github.io/master/img/DOFavoriteButton/demo.gif)
![heart](https://github.com/xhamr/fave-button/blob/master/fave-button1.gif)


## Requirements

- iOS 8.0+
- Xcode 7.3

## Installation

For manual instalation, drag Source folder into your project.

os use [CocoaPod](https://cocoapods.org) adding this line to you `Podfile`:

```ruby
pod 'FaveButton', '~> 1.2.1' swift 2.2

pod 'FaveButton', '~> 2.0.3' swift 3

pod 'FaveButton', '~> 3.0' swift 4
```

for [Carthage](https://github.com/Carthage/Carthage) users, add this line to you `Cartfile`

```ruby
github "subdiox/fave-button"
```

## How to use
#### 1. Add a flat icon image
![Flat Icon Image](https://raw.githubusercontent.com/okmr-d/okmr-d.github.io/master/img/DOFavoriteButton/flatIconImage.png)

#### 2. Create a button
##### ・By coding
```swift
let starButton = StarButton(frame: CGRectMake(0, 0, 44, 44), image: UIImage(named: "star.png"))
self.view.addSubview(starButton)

let heartButton = HeartButton(frame: CGRectMake(0, 0, 44, 44), image: UIImage(named: "heart.png"))
self.view.addSubview(heartButton)
```

##### ・By using Storyboard or XIB
1. Add Button object and set Custom Class `StarButton` or `HeartButton`  
![via Storyboard](https://raw.githubusercontent.com/okmr-d/okmr-d.github.io/master/img/DOFavoriteButton/storyboard.png)

2. Connect Outlet  
![connect outlet](https://raw.githubusercontent.com/okmr-d/okmr-d.github.io/master/img/DOFavoriteButton/connect.png)

#### 3. Add tapped function
```swift
starButton.addTarget(self, action: Selector("starTapped:"), forControlEvents: .TouchUpInside)
heartButton.addTarget(self, action: Selector("heartTapped:"), forControlEvents: .TouchUpInside)
```
```swift
func starTapped(sender: StarButton) {
    sender.toggle()
    
    /* Write here anything you want to do after the button is tapped */
}

func heartTapped(sender: HeartButton) {
    sender.toggle()
    
    /* Write here anything you want to do after the button is tapped */
}
```

## Customize
You can change button color & animation duration:
```swift
button.normalColor = UIColor.brownColor()
button.selectedColor = UIColor.redColor()
button.circleColor = UIColor.greenColor()
button.lineColor = UIColor.blueColor()
```
Result:  
![Customize](https://raw.githubusercontent.com/okmr-d/okmr-d.github.io/master/img/DOFavoriteButton/changeColor.gif)

## DEMO
There is a demo project added to this repository, so you can see how it works.

## Credits
FaveButton was inspired by Twitter’s Like Heart Animation within their [App](https://itunes.apple.com/us/app/twitter/id333903271)

## Licence
FaveButton is released under the MIT license.
