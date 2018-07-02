//
//  AVCaptureDevice.swift
//  Tracker
//
//  Created by Mohssen Fathi on 1/4/18.
//  Copyright © 2018 mohssenfathi. All rights reserved.
//

import Foundation
import AVFoundation

extension AVCaptureDevice {
    
    func configureForHighestFrameRate(max: Double = 240.0) {
        
        guard let format = formats.filter({
            $0.maxFrameRateRange?.maxFrameRate ?? Double.greatestFiniteMagnitude <= max
        }).sorted(by: { format1, format2 in
            let fr1 = format1.maxFrameRateRange?.maxFrameRate ?? 0
            let fr2 = format2.maxFrameRateRange?.maxFrameRate ?? 0
            
            if fr1 == fr2 {
                return format1.highResolutionStillImageDimensions.width > format2.highResolutionStillImageDimensions.width
            }
            
            return fr1 > fr2
        }).first else {
            return
        }
        
        print("Max Format: \(format.maxFrameRateRange?.maxFrameRate ?? 0) FPS")
        
        do {
            try lockForConfiguration()
            activeFormat = format
            activeVideoMinFrameDuration = format.maxFrameRateRange!.minFrameDuration
            activeVideoMaxFrameDuration = format.maxFrameRateRange!.minFrameDuration
            unlockForConfiguration()
        }
        catch {
            print(error.localizedDescription)
        }
    }
}


extension AVCaptureDevice.Format {
    
    var maxFrameRateRange: AVFrameRateRange? {
        return videoSupportedFrameRateRanges.sorted { return $0.maxFrameRate > $1.maxFrameRate }.first
    }
}
