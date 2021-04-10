import CoreAudio
@testable import SimplyCoreAudio
import XCTest

final class AudioDeviceTests: SCATestCase {
    func testDeviceLookUp() throws {
        let device = try getNullDevice()
        let deviceUID = try XCTUnwrap(device.uid)

        XCTAssertEqual(AudioDevice.lookup(by: device.id), device)
        XCTAssertEqual(AudioDevice.lookup(by: deviceUID), device)
    }

    func testSettingDefaultDevice() throws {
        let device = try getNullDevice()

        device.isDefaultInputDevice = true

        XCTAssertTrue(device.isDefaultInputDevice)
        XCTAssertEqual(simplyCA.defaultInputDevice, device)

        device.isDefaultOutputDevice = true

        XCTAssertTrue(device.isDefaultOutputDevice)
        XCTAssertEqual(simplyCA.defaultOutputDevice, device)

        device.isDefaultSystemOutputDevice = true

        XCTAssertTrue(device.isDefaultSystemOutputDevice)
        XCTAssertEqual(simplyCA.defaultSystemOutputDevice, device)
    }

    func testGeneralDeviceInformation() throws {
        let device = try getNullDevice()

        XCTAssertEqual(device.name, "Null Audio Device")
        XCTAssertEqual(device.manufacturer, "Apple Inc.")
        XCTAssertEqual(device.uid, "NullAudioDevice_UID")
        XCTAssertEqual(device.modelUID, "NullAudioDevice_ModelUID")
        XCTAssertEqual(device.configurationApplication, "com.apple.audio.AudioMIDISetup")
        XCTAssertEqual(device.transportType, .virtual)

        XCTAssertFalse(device.isInputOnlyDevice)
        XCTAssertFalse(device.isOutputOnlyDevice)
        XCTAssertFalse(device.isHidden)

        XCTAssertNil(device.isJackConnected(scope: .output))
        XCTAssertNil(device.isJackConnected(scope: .input))

        XCTAssertTrue(device.isAlive)
        XCTAssertFalse(device.isRunning)
        XCTAssertFalse(device.isRunningSomewhere)

        XCTAssertNil(device.name(channel: 0, scope: .output))
        XCTAssertNil(device.name(channel: 1, scope: .output))
        XCTAssertNil(device.name(channel: 2, scope: .output))
        XCTAssertNil(device.name(channel: 0, scope: .input))
        XCTAssertNil(device.name(channel: 1, scope: .input))
        XCTAssertNil(device.name(channel: 2, scope: .input))

        XCTAssertNotNil(device.ownedObjectIDs)
        XCTAssertNotNil(device.controlList)
        XCTAssertNotNil(device.relatedDevices)
    }

    func testLFE() throws {
        let device = try getNullDevice()

        XCTAssertNil(device.shouldOwniSub)
        device.shouldOwniSub = true
        XCTAssertNil(device.shouldOwniSub)

        XCTAssertNil(device.lfeMute)
        device.lfeMute = true
        XCTAssertNil(device.lfeMute)

        XCTAssertNil(device.lfeVolume)
        device.lfeVolume = 1.0
        XCTAssertNil(device.lfeVolume)

        XCTAssertNil(device.lfeVolumeDecibels)
        device.lfeVolumeDecibels = 6.0
        XCTAssertNil(device.lfeVolumeDecibels)
    }

    func testInputOutputLayout() throws {
        let device = try getNullDevice()

        XCTAssertEqual(device.layoutChannels(scope: .output), 2)
        XCTAssertEqual(device.layoutChannels(scope: .input), 2)

        XCTAssertEqual(device.channels(scope: .output), 2)
        XCTAssertEqual(device.channels(scope: .input), 2)

        XCTAssertFalse(device.isInputOnlyDevice)
        XCTAssertFalse(device.isOutputOnlyDevice)
    }

    func testVolumeInfo() throws {
        let device = try getNullDevice()
        var volumeInfo: VolumeInfo!

        XCTAssertTrue(device.setMute(false, channel: 0, scope: .output))

        volumeInfo = try XCTUnwrap(device.volumeInfo(channel: 0, scope: .output))
        XCTAssertEqual(volumeInfo.hasVolume, true)
        XCTAssertEqual(volumeInfo.canSetVolume, true)
        XCTAssertEqual(volumeInfo.canMute, true)
        XCTAssertEqual(volumeInfo.isMuted, false)
        XCTAssertEqual(volumeInfo.canPlayThru, false)
        XCTAssertEqual(volumeInfo.isPlayThruSet, false)

        XCTAssertTrue(device.setVolume(0, channel: 0, scope: .output))
        volumeInfo = try XCTUnwrap(device.volumeInfo(channel: 0, scope: .output))
        XCTAssertEqual(volumeInfo.volume, 0)

        XCTAssertTrue(device.setVolume(0.5, channel: 0, scope: .output))
        volumeInfo = try XCTUnwrap(device.volumeInfo(channel: 0, scope: .output))
        XCTAssertEqual(volumeInfo.volume, 0.5)

        XCTAssertNil(device.volumeInfo(channel: 1, scope: .output))
        XCTAssertNil(device.volumeInfo(channel: 2, scope: .output))
        XCTAssertNil(device.volumeInfo(channel: 3, scope: .output))
        XCTAssertNil(device.volumeInfo(channel: 4, scope: .output))

        XCTAssertNotNil(device.volumeInfo(channel: 0, scope: .input))

        XCTAssertNil(device.volumeInfo(channel: 1, scope: .input))
        XCTAssertNil(device.volumeInfo(channel: 2, scope: .input))
        XCTAssertNil(device.volumeInfo(channel: 3, scope: .input))
        XCTAssertNil(device.volumeInfo(channel: 4, scope: .input))
    }

    func testVolume() throws {
        let device = try getNullDevice()

        // Output scope
        XCTAssertTrue(device.setVolume(0, channel: 0, scope: .output))
        XCTAssertEqual(device.volume(channel: 0, scope: .output), 0)

        XCTAssertTrue(device.setVolume(0.5, channel: 0, scope: .output))
        XCTAssertEqual(device.volume(channel: 0, scope: .output), 0.5)

        XCTAssertFalse(device.setVolume(0.5, channel: 1, scope: .output))
        XCTAssertNil(device.volume(channel: 1, scope: .output))

        XCTAssertFalse(device.setVolume(0.5, channel: 2, scope: .output))
        XCTAssertNil(device.volume(channel: 2, scope: .output))

        // Input scope
        XCTAssertTrue(device.setVolume(0, channel: 0, scope: .input))
        XCTAssertEqual(device.volume(channel: 0, scope: .input), 0)

        XCTAssertTrue(device.setVolume(0.5, channel: 0, scope: .input))
        XCTAssertEqual(device.volume(channel: 0, scope: .input), 0.5)

        XCTAssertFalse(device.setVolume(0.5, channel: 1, scope: .input))
        XCTAssertNil(device.volume(channel: 1, scope: .input))

        XCTAssertFalse(device.setVolume(0.5, channel: 2, scope: .input))
        XCTAssertNil(device.volume(channel: 2, scope: .input))
    }

    func testVolumeInDecibels() throws {
        let device = try getNullDevice()

        // Output scope
        XCTAssertTrue(device.canSetVolume(channel: 0, scope: .output))
        XCTAssertTrue(device.setVolume(0, channel: 0, scope: .output))
        XCTAssertEqual(device.volumeInDecibels(channel: 0, scope: .output), -96)
        XCTAssertTrue(device.setVolume(0.5, channel: 0, scope: .output))
        XCTAssertEqual(device.volumeInDecibels(channel: 0, scope: .output), -70.5)

        XCTAssertFalse(device.canSetVolume(channel: 1, scope: .output))
        XCTAssertFalse(device.setVolume(0.5, channel: 1, scope: .output))
        XCTAssertNil(device.volumeInDecibels(channel: 1, scope: .output))

        XCTAssertFalse(device.canSetVolume(channel: 2, scope: .output))
        XCTAssertFalse(device.setVolume(0.5, channel: 2, scope: .output))
        XCTAssertNil(device.volumeInDecibels(channel: 2, scope: .output))

        // Input scope
        XCTAssertTrue(device.canSetVolume(channel: 0, scope: .input))
        XCTAssertTrue(device.setVolume(0, channel: 0, scope: .input))
        XCTAssertEqual(device.volumeInDecibels(channel: 0, scope: .input), -96)
        XCTAssertTrue(device.setVolume(0.5, channel: 0, scope: .input))
        XCTAssertEqual(device.volumeInDecibels(channel: 0, scope: .input), -70.5)

        XCTAssertFalse(device.canSetVolume(channel: 1, scope: .input))
        XCTAssertFalse(device.setVolume(0.5, channel: 1, scope: .input))
        XCTAssertNil(device.volumeInDecibels(channel: 1, scope: .input))

        XCTAssertFalse(device.canSetVolume(channel: 2, scope: .input))
        XCTAssertFalse(device.setVolume(0.5, channel: 2, scope: .input))
        XCTAssertNil(device.volumeInDecibels(channel: 2, scope: .input))
    }

    func testMute() throws {
        let device = try getNullDevice()

        // Output scope
        XCTAssertTrue(device.canMute(channel: 0, scope: .output))
        XCTAssertTrue(device.setMute(true, channel: 0, scope: .output))
        XCTAssertEqual(device.isMuted(channel: 0, scope: .output), true)
        XCTAssertTrue(device.setMute(false, channel: 0, scope: .output))
        XCTAssertEqual(device.isMuted(channel: 0, scope: .output), false)

        XCTAssertFalse(device.canMute(channel: 1, scope: .output))
        XCTAssertFalse(device.setMute(true, channel: 1, scope: .output))
        XCTAssertNil(device.isMuted(channel: 1, scope: .output))

        XCTAssertFalse(device.canMute(channel: 2, scope: .output))
        XCTAssertFalse(device.setMute(true, channel: 2, scope: .output))
        XCTAssertNil(device.isMuted(channel: 2, scope: .output))

        // Input scope
        XCTAssertTrue(device.canMute(channel: 0, scope: .input))
        XCTAssertTrue(device.setMute(true, channel: 0, scope: .input))
        XCTAssertEqual(device.isMuted(channel: 0, scope: .input), true)
        XCTAssertTrue(device.setMute(false, channel: 0, scope: .input))
        XCTAssertEqual(device.isMuted(channel: 0, scope: .input), false)

        XCTAssertFalse(device.canMute(channel: 1, scope: .input))
        XCTAssertFalse(device.setMute(true, channel: 1, scope: .input))
        XCTAssertNil(device.isMuted(channel: 1, scope: .input))

        XCTAssertFalse(device.canMute(channel: 2, scope: .input))
        XCTAssertFalse(device.setMute(true, channel: 2, scope: .input))
        XCTAssertNil(device.isMuted(channel: 2, scope: .input))
    }

    func testMasterChannelMute() throws {
        let device = try getNullDevice()

        XCTAssertEqual(device.canMuteMasterChannel(scope: .output), true)
        XCTAssertTrue(device.setMute(false, channel: 0, scope: .output))
        XCTAssertEqual(device.isMasterChannelMuted(scope: .output), false)
        XCTAssertTrue(device.setMute(true, channel: 0, scope: .output))
        XCTAssertEqual(device.isMasterChannelMuted(scope: .output), true)

        XCTAssertEqual(device.canMuteMasterChannel(scope: .input), true)
        XCTAssertTrue(device.setMute(false, channel: 0, scope: .input))
        XCTAssertEqual(device.isMasterChannelMuted(scope: .input), false)
        XCTAssertTrue(device.setMute(true, channel: 0, scope: .input))
        XCTAssertEqual(device.isMasterChannelMuted(scope: .input), true)
    }

    func testPreferredChannelsForStereo() throws {
        let device = try getNullDevice()
        var preferredChannels = try XCTUnwrap(device.preferredChannelsForStereo(scope: .output))

        XCTAssertEqual(preferredChannels.left, 1)
        XCTAssertEqual(preferredChannels.right, 2)

        XCTAssertTrue(device.setPreferredChannelsForStereo(channels: StereoPair(left: 1, right: 1), scope: .output))
        preferredChannels = try XCTUnwrap(device.preferredChannelsForStereo(scope: .output))
        XCTAssertEqual(preferredChannels.left, 1)
        XCTAssertEqual(preferredChannels.right, 1)

        XCTAssertTrue(device.setPreferredChannelsForStereo(channels: StereoPair(left: 2, right: 2), scope: .output))
        preferredChannels = try XCTUnwrap(device.preferredChannelsForStereo(scope: .output))
        XCTAssertEqual(preferredChannels.left, 2)
        XCTAssertEqual(preferredChannels.right, 2)

        XCTAssertTrue(device.setPreferredChannelsForStereo(channels: StereoPair(left: 1, right: 2), scope: .output))
        preferredChannels = try XCTUnwrap(device.preferredChannelsForStereo(scope: .output))
        XCTAssertEqual(preferredChannels.left, 1)
        XCTAssertEqual(preferredChannels.right, 2)
    }

    func testVirtualMasterChannels() throws {
        let device = try getNullDevice()

        XCTAssertTrue(device.canSetVirtualMasterVolume(scope: .output))
        XCTAssertTrue(device.canSetVirtualMasterVolume(scope: .input))

        XCTAssertTrue(device.setVirtualMasterVolume(0.0, scope: .output))
        XCTAssertEqual(device.virtualMasterVolume(scope: .output), 0.0)
        // XCTAssertEqual(device.virtualMasterVolumeInDecibels(scope: .output), -96.0)
        XCTAssertTrue(device.setVirtualMasterVolume(0.5, scope: .output))
        XCTAssertEqual(device.virtualMasterVolume(scope: .output), 0.5)
        // XCTAssertEqual(device.virtualMasterVolumeInDecibels(scope: .output), -70.5)

        XCTAssertTrue(device.setVirtualMasterVolume(0.0, scope: .input))
        XCTAssertEqual(device.virtualMasterVolume(scope: .input), 0.0)
        // XCTAssertEqual(device.virtualMasterVolumeInDecibels(scope: .input), -96.0)
        XCTAssertTrue(device.setVirtualMasterVolume(0.5, scope: .input))
        XCTAssertEqual(device.virtualMasterVolume(scope: .input), 0.5)
        // XCTAssertEqual(device.virtualMasterVolumeInDecibels(scope: .input), -70.5)
    }

    func testVirtualMasterBalance() throws {
        let device = try getNullDevice()

        XCTAssertFalse(device.setVirtualMasterBalance(0.0, scope: .output))
        XCTAssertNil(device.virtualMasterBalance(scope: .output))

        XCTAssertFalse(device.setVirtualMasterBalance(0.0, scope: .input))
        XCTAssertNil(device.virtualMasterBalance(scope: .input))
    }

    func testSampleRate() throws {
        let device = try getNullDevice()

        XCTAssertEqual(device.nominalSampleRates, [44100, 48000])

        XCTAssertTrue(device.setNominalSampleRate(44100))
        sleep(1)
        XCTAssertEqual(device.nominalSampleRate, 44100)
        XCTAssertEqual(device.actualSampleRate, 44100)

        XCTAssertTrue(device.setNominalSampleRate(48000))
        sleep(1)
        XCTAssertEqual(device.nominalSampleRate, 48000)
        XCTAssertEqual(device.actualSampleRate, 48000)
    }

    func testDataSource() throws {
        let device = try getNullDevice()

        XCTAssertNotNil(device.dataSource(scope: .output))
        XCTAssertNotNil(device.dataSource(scope: .input))
    }

    func testDataSources() throws {
        let device = try getNullDevice()

        XCTAssertNotNil(device.dataSources(scope: .output))
        XCTAssertNotNil(device.dataSources(scope: .input))
    }

    func testDataSourceName() throws {
        let device = try getNullDevice()

        XCTAssertEqual(device.dataSourceName(dataSourceID: 0, scope: .output), "Data Source Item 0")
        XCTAssertEqual(device.dataSourceName(dataSourceID: 1, scope: .output), "Data Source Item 1")
        XCTAssertEqual(device.dataSourceName(dataSourceID: 2, scope: .output), "Data Source Item 2")
        XCTAssertEqual(device.dataSourceName(dataSourceID: 3, scope: .output), "Data Source Item 3")
        XCTAssertNil(device.dataSourceName(dataSourceID: 4, scope: .output))

        XCTAssertEqual(device.dataSourceName(dataSourceID: 0, scope: .input), "Data Source Item 0")
        XCTAssertEqual(device.dataSourceName(dataSourceID: 1, scope: .input), "Data Source Item 1")
        XCTAssertEqual(device.dataSourceName(dataSourceID: 2, scope: .input), "Data Source Item 2")
        XCTAssertEqual(device.dataSourceName(dataSourceID: 3, scope: .input), "Data Source Item 3")
        XCTAssertNil(device.dataSourceName(dataSourceID: 4, scope: .input))
    }

    func testClockSource() throws {
        let device = try getNullDevice()

        XCTAssertNil(device.clockSourceID)
        XCTAssertNil(device.clockSourceIDs)
        XCTAssertNil(device.clockSourceName)
        XCTAssertNil(device.clockSourceNames)
        XCTAssertNil(device.clockSourceName(clockSourceID: 0))
        XCTAssertFalse(device.setClockSourceID(0))
    }

    func testLatency() throws {
        let device = try getNullDevice()

        XCTAssertEqual(device.latency(scope: .output), 0)
        XCTAssertEqual(device.latency(scope: .input), 0)
    }

    func testSafetyOffset() throws {
        let device = try getNullDevice()

        XCTAssertEqual(device.safetyOffset(scope: .output), 0)
        XCTAssertEqual(device.safetyOffset(scope: .input), 0)
    }

    func testHogMode() throws {
        let device = try getNullDevice()

        XCTAssertEqual(device.hogModePID, -1)
        XCTAssertTrue(device.setHogMode())
        XCTAssertEqual(device.hogModePID, pid_t(ProcessInfo.processInfo.processIdentifier))
        XCTAssertTrue(device.unsetHogMode())
        XCTAssertEqual(device.hogModePID, -1)
    }

//    func testVolumeConversion() throws {
//        let device = try GetDevice()
//
//        XCTAssertEqual(device.scalarToDecibels(volume: 0, channel: 0, scope: .output), -96.0)
//        XCTAssertEqual(device.scalarToDecibels(volume: 1, channel: 0, scope: .output), 6.0)
//
//        XCTAssertEqual(device.decibelsToScalar(volume: -96.0, channel: 0, scope: .output), 0)
//        XCTAssertEqual(device.decibelsToScalar(volume: 6.0, channel: 0, scope: .output), 1)
//    }

    func testStreams() throws {
        let device = try getNullDevice()

        XCTAssertNotNil(device.streams(scope: .output))
        XCTAssertNotNil(device.streams(scope: .input))
    }

    func testCreateAndDestroyAggregateDevice() throws {
        let nullDevice = try getNullDevice()

        guard let device = simplyCA.createAggregateDevice(masterDevice: nullDevice,
                                                          secondDevice: nil,
                                                          named: "testCreateAggregateAudioDevice",
                                                          uid: "testCreateAggregateAudioDevice-12345")
        else {
            XCTFail("Failed creating device")
            return
        }

        XCTAssertTrue(device.isAggregateDevice)
        XCTAssertTrue(device.ownedAggregateDevices?.count == 1)

        wait(for: 2)

        let error = simplyCA.removeAggregateDevice(id: device.id)
        XCTAssertTrue(error == noErr, "Failed removing device")

        wait(for: 2)
    }

    func testInvalidDeviceProperties() throws {
        let device = try getNullDevice()

        // 0 seems like a safe bet for an invalid property
        let address = AudioObjectPropertyAddress(
            mSelector: AudioObjectPropertySelector(0),
            mScope: AudioObjectPropertyScope(0),
            mElement: AudioObjectPropertyScope(0)
        )

        // Just testing these fail gracefully and spit out a friendly error message
        let result1: UInt32? = device.getProperty(address: address)
        let result2: Float32? = device.getProperty(address: address)
        let result3: Float64? = device.getProperty(address: address)
        let result4: String? = device.getProperty(address: address)
        let result5: Bool? = device.getProperty(address: address)
        
        // all should be nil
        XCTAssertNil(result1)
        XCTAssertNil(result2)
        XCTAssertNil(result3)
        XCTAssertNil(result4)
        XCTAssertNil(result5)
    }
}
