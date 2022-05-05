# HomeConMenu
<img src="https://user-images.githubusercontent.com/33768/166890209-77ae667c-def4-48f0-a1e4-5e68fb73888a.png" width="128px"/>
App to control HomeKit Devices from macOS system

## Binary

HomeConMenu is published at [Mac App Store](https://apps.apple.com/us/app/homeconmenu/id1615397537) only, because Apple does not enable us to sign and notraize binaries that use HomeKit framework.
To tell the truth, I don't want to publish on the [Mac App Store](https://apps.apple.com/us/app/homeconmenu/id1615397537) because it would be too much trouble.
If you want to use HomeConMenu for free, please build it yourself.

<a href="https://apps.apple.com/us/app/homeconmenu/id1615397537"><img src="https://user-images.githubusercontent.com/33768/166904216-9d43af7d-fc6e-4d36-9f97-a87356b8b402.svg"/></a>

## Privacy control

For testing, you can reset the status of privacy control to access HomeKit.


```
tccutil reset Willow com.sonson.HomeConMenu.macOS
```
