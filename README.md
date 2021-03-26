## 🔊 SimplyCoreAudio

[![Platform](https://img.shields.io/badge/Platforms-macOS%20-4E4E4E.svg?colorA=28a745)](https://github.com/rnine/SimplyCoreAudio)
[![Swift support](https://img.shields.io/badge/Swift-4.0%20%7C%204.2%20%7C%205.0%20%7C%205.1%20-lightgrey.svg?colorA=28a745&colorB=4E4E4E)](https://github.com/rnine/SimplyCoreAudio)
[![Swift Package Manager compatible](https://img.shields.io/badge/SPM-compatible-brightgreen.svg?style=flat&colorA=28a745&&colorB=4E4E4E)](https://github.com/apple/swift-package-manager)
[![GitHub tag](https://img.shields.io/github/tag/rnine/SimplyCoreAudio.svg)](https://github.com/rnine/SimplyCoreAudio)
[![License](https://img.shields.io/github/license/mashape/apistatus.svg)](https://github.com/rnine/SimplyCoreAudio/blob/develop/LICENSE.md)

`SimplyCoreAudio` (formerly known as `AMCoreAudio`) is a Swift framework that aims to make [Core Audio](https://developer.apple.com/library/mac/documentation/MusicAudio/Conceptual/CoreAudioOverview/) use less tedious in macOS.

Here's some of the supported features:

- Simplifies audio device enumeration
- Provides accessors for the most relevant audio device properties (i.e., device name, device manufacturer, device UID, volume, mute, sample rate, clock source, etc.)
- Manages (physical and virtual) audio streams associated to an audio device
- Creates and destroyes aggregate devices
- Allows subscribing to audio hardware, audio device, and audio stream notifications

### Requirements

- Xcode 12+
- Swift 4.0+
- macOS 10.12+

### Installation

To install our Swift Package, please follow the steps below:

- Add https://github.com/rnine/SimplyCoreAudio.git as a [Swift Package Manager](https://swift.org/package-manager/) dependency to your project.
- When asked to **Choose Package Options**, use the default settings provided by Xcode.
- When asked to **Add Package**, add `SimplyCoreAudio` to your desired target(s).

### Usage

1. Import `SimplyCoreAudio`
	```swift
	import SimplyCoreAudio
	````
2. Instantiate `SimplyCoreAudio`
	```swift
	let simplyCA = SimplyCoreAudio()
	```

3. Interact with `SimplyCoreAudio`
	```swift
	// Get the default output device
	let device = simplyCA.defaultOutputDevice

	// Get preferred output channels
	if let stereoPair = device.preferredChannelsForStereo(scope: .output) {
		let leftChannel = stereoPair.left
		let rightChannel = stereoPair.right
		// Use channels...
	}

	// Get device samplerate
	if let sampleRate = device.nominalSampleRate {
		// Use samplerate...
	}

	// Get device virtual master volume
	if let outVolume = device.virtualMasterVolume(scope: .output) {
		// Use output volume...
	}
	```
4. Subscribe to hardware-related notifications
	```swift
	// e.g., subscribing to `deviceListChanged` notification.
	var observer = NotificationCenter.default.addObserver(
		forName: .deviceListChanged,
		object: nil,
		queue: .main) { (notification) in
		// Get added devices.
		guard let addedDevices = notification.userInfo?["addedDevices"] as? [AudioDevice] else { return }

		// Get removed devices.
		guard let removedDevices = notification.userInfo?["removedDevices"] as? [AudioDevice] else { return }
	}

	// Once done observing, remove observer and nil it.
	NotificationCenter.default.removeObserver(observer)
	observer = nil
	```
5. Subscribe to specific audio device notifications
	```swift
	// Get the default output device
	let device = simplyCA.defaultOutputDevice

	// e.g., subscribing to `deviceNominalSampleRateDidChange` notification.
	var observer = NotificationCenter.default.addObserver(
		forName: .deviceNominalSampleRateDidChange,
		object: device,
		queue: .main) { (notification) in
		// Handle notification.
	}

	// Once done observing, remove observer and nil it.
	NotificationCenter.default.removeObserver(observer)
	observer = nil
	```

### Documentation

- [API Documentation](https://rnine.github.io/SimplyCoreAudio)

### Supported Notifications

#### Audio Hardware Notifications

| Name | Purpose | User Info |
|---|----|----|
| `defaultInputDeviceChanged` | Called whenever the default input device changes. | N/A |
| `defaultOutputDeviceChanged` | Called whenever the default output device changes. | N/A |
| `defaultSystemOutputDeviceChanged` | Called whenever the default system output device changes. | N/A |
| `deviceListChanged` | Called whenever the list of hardware devices and device subdevices changes. | `addedDevices: [AudioDevice]`, `removedDevices: [AudioDevice]` |

#### Audio Device Notifications

| Name | Purpose | User Info |
|---|----|----|
| `deviceNominalSampleRateDidChange` | Called whenever the audio device's sample rate changes. | N/A |
| `deviceAvailableNominalSampleRatesDidChange` | Called whenever the audio device's list of nominal sample rates changes. | N/A |
| `deviceClockSourceDidChange` | Called whenever the audio device's clock source changes. | N/A |
| `deviceNameDidChange` | Called whenever the audio device's name changes. |
| `deviceOwnedObjectsDidChange` | Called whenever the list of owned audio devices on this audio device changes. | N/A |
| `deviceVolumeDidChange` | Called whenever the audio device's volume for a given channel and scope changes. | `channel: UInt32`, `scope: Scope` |
| `deviceMuteDidChange` | Called whenever the audio device's mute state for a given channel and scope changes. | `channel: UInt32`, `scope: Scope` |
| `deviceIsAliveDidChange` | Called whenever the audio device's list of nominal sample rates changes. | N/A |
| `deviceIsRunningDidChange` | Called whenever the audio device's *is running* property changes. | N/A |
| `deviceIsRunningSomewhereDidChange` | Called whenever the audio device's *is running somewhere* property changes. | N/A |
| `deviceIsJackConnectedDidChange` | Called whenever the audio device's *is jack connected* property changes. | N/A |
| `devicePreferredChannelsForStereoDidChange` | Called whenever the audio device's *preferred channels for stereo* property changes. | N/A |
| `deviceHogModeDidChange` | Called whenever the audio device's *hog mode* property changes. | N/A |

#### Audio Stream Notifications

| Name | Purpose | User Info |
|---|----|---|
| `streamIsActiveDidChange` | Called whenever the audio stream `isActive` flag changes state. | N/A |
| `streamPhysicalFormatDidChange` | Called whenever the audio stream physical format changes. | N/A |

### Further Development & Patches

Do you want to contribute to the project? Please fork, patch, and then submit a pull request!

### Running Tests

Please make sure to install `NullAudio.driver` before attempting to run tests:

###  Installing `NullAudio.driver`

1. Unzip `NullAudio.driver.zip` included in `Tests/Extras`.
2. Copy `NullAudio.driver` to `/Library/Audio/Plug-Ins/HAL`.
3. Restart `macOS`.

### License

`SimplyCoreAudio` was written by Ruben Nine ([@rnine](https://github.com/rnine)) in 2013-2014 (open-sourced in March 2014) and is licensed under the [MIT](https://opensource.org/licenses/MIT) license. See [LICENSE.md](LICENSE.md).
