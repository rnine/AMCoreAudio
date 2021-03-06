import XCTest
@testable import SimplyCoreAudio

class AudioStreamTests: SCATestCase {
    func testProperties() throws {
        let device = try getNullDevice()
        let outputStreams = try XCTUnwrap(device.streams(scope: .output))
        let inputStreams = try XCTUnwrap(device.streams(scope: .input))

        XCTAssertEqual(outputStreams.count, 1)
        XCTAssertEqual(inputStreams.count, 1)

        let outputStream = try XCTUnwrap(outputStreams.first)
        XCTAssertTrue(outputStream.active)
        XCTAssertNotNil(outputStream.startingChannel)
        XCTAssertEqual(outputStream.scope, .output)
        XCTAssertEqual(outputStream.terminalType, .speaker)
        XCTAssertEqual(outputStream.latency, 0)
        XCTAssertNotNil(outputStream.availableVirtualFormats)
        XCTAssertNotNil(outputStream.availableVirtualFormatsMatchingCurrentNominalSampleRate())
        XCTAssertNotNil(outputStream.availableVirtualFormatsMatchingCurrentNominalSampleRate(true))
        XCTAssertNotNil(outputStream.availableVirtualFormatsMatchingCurrentNominalSampleRate(false))
        XCTAssertNotNil(outputStream.availablePhysicalFormats)
        XCTAssertNotNil(outputStream.availablePhysicalFormatsMatchingCurrentNominalSampleRate())
        XCTAssertNotNil(outputStream.availablePhysicalFormatsMatchingCurrentNominalSampleRate(true))
        XCTAssertNotNil(outputStream.availablePhysicalFormatsMatchingCurrentNominalSampleRate(false))

        outputStream.virtualFormat = nil
        XCTAssertNotNil(outputStream.virtualFormat)

        outputStream.physicalFormat = nil
        XCTAssertNotNil(outputStream.physicalFormat)

        let inputStream = try XCTUnwrap(inputStreams.first)
        XCTAssertTrue(inputStream.active)
        XCTAssertNotNil(inputStream.startingChannel)
        XCTAssertEqual(inputStream.scope, .input)
        XCTAssertEqual(inputStream.terminalType, .microphone)
        XCTAssertEqual(inputStream.latency, 0)
        XCTAssertNotNil(inputStream.availableVirtualFormats)
        XCTAssertNotNil(inputStream.availableVirtualFormatsMatchingCurrentNominalSampleRate())
        XCTAssertNotNil(inputStream.availableVirtualFormatsMatchingCurrentNominalSampleRate(true))
        XCTAssertNotNil(inputStream.availableVirtualFormatsMatchingCurrentNominalSampleRate(false))
        XCTAssertNotNil(inputStream.availablePhysicalFormats)
        XCTAssertNotNil(inputStream.availablePhysicalFormatsMatchingCurrentNominalSampleRate())
        XCTAssertNotNil(inputStream.availablePhysicalFormatsMatchingCurrentNominalSampleRate(true))
        XCTAssertNotNil(inputStream.availablePhysicalFormatsMatchingCurrentNominalSampleRate(false))

        inputStream.virtualFormat = nil
        XCTAssertNotNil(inputStream.virtualFormat)

        inputStream.physicalFormat = nil
        XCTAssertNotNil(inputStream.physicalFormat)
    }
}
