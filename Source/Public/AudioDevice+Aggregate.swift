//
//  AudioDevice+Aggregate.swift
//
//  Created by Ryan Francesconi on 2/24/21.
//

import AudioToolbox.AudioServices
import os.log

// MARK: - Aggregate Device Functions

public extension AudioDevice {
    /// - Returns: `true` if this device is an aggregate one, `false` otherwise.
    var isAggregateDevice: Bool {
        guard let aggregateDevices = ownedAggregateDevices else { return false }
        return !aggregateDevices.isEmpty
    }

    /// All the subdevices of this aggregate device
    ///
    /// - Returns: An array of `AudioDevice` objects.
    var ownedAggregateDevices: [AudioDevice]? {
        guard let ownedObjectIDs = ownedObjectIDs else { return nil }

        let ownedDevices = ownedObjectIDs.compactMap { (id) -> AudioDevice? in
            AudioDevice.lookup(by: id)
        }
        // only aggregates have non nil owned UIDs. I think?
        return ownedDevices.filter { $0.uid != nil }
    }

    /// All the subdevices of this aggregate device that support input
    ///
    /// - Returns: An array of `AudioDevice` objects.
    var ownedAggregateInputDevices: [AudioDevice]? {
        ownedAggregateDevices?.filter {
            guard let channels = $0.layoutChannels(scope: .input) else { return false }
            return channels > 0
        }
    }

    /// All the subdevices of this aggregate device that support output
    ///
    /// - Returns: An array of `AudioDevice` objects.
    var ownedAggregateOutputDevices: [AudioDevice]? {
        ownedAggregateDevices?.filter {
            guard let channels = $0.layoutChannels(scope: .output) else { return false }
            return channels > 0
        }
    }
}