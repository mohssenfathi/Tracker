//
//  CameraViewController.swift
//  Tracker
//
//  Created by Mohssen Fathi on 1/4/18.
//  Copyright © 2018 mohssenfathi. All rights reserved.
//

import UIKit
import MTLImage
import AVFoundation

class CameraViewController: UIViewController {

    @IBOutlet weak var renderView: View!
    @IBOutlet weak var colorIndicator: UIView!
    @IBOutlet weak var toolbar: UIView!
    
    let camera = Camera()
    
    /// Filters
    let filterGroup = FilterGroup()
    let colorIsolator = ColorIsolator()
    let colorPosition = ColorPosition()
    let rectRenderer = RectRenderer()
    let rectView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        camera.orientation = .landscapeRight
        renderView.contentMode = .scaleAspectFill
        
        filterGroup += colorIsolator
        filterGroup += colorPosition
//        filterGroup += rectRenderer
        
        camera --> filterGroup --> renderView
        
        colorPosition.newRectAvailable = { colorPosition in
            self.rectView.isHidden = colorPosition.normalizedRect == .zero
            self.rectView.frame = colorPosition.normalizedRect * self.renderView.bounds.size
        }
        
        rectView.backgroundColor = .clear
        rectView.layer.borderColor = UIColor.red.cgColor
        rectView.layer.borderWidth = 2.0
        rectView.isUserInteractionEnabled = false
        rectView.isHidden = true
        view.addSubview(rectView)
        
        /// Color Indicator
        colorIndicator.layer.masksToBounds = true
        colorIndicator.layer.cornerRadius = colorIndicator.bounds.width/2.0
        colorIndicator.layer.borderColor = UIColor.black.cgColor
        colorIndicator.layer.borderWidth = 2.0
        colorIndicator.backgroundColor = .clear
        
        
//        let resize = Resize()
//        resize.outputSize = MTLSize(width: 140, height: 100, depth: 1)
//        
//        let colorIsolator = ColorIsolator()
//        colorIsolator.color = UIColor.red
//        
//        camera --> colorIsolator --> renderView
    }

    @IBAction func sliderValueChanged(_ sender: UISlider) {
        colorIsolator.threshold = sender.value
    }
    
    @IBAction func handleTap(_ sender: UITapGestureRecognizer) {
        
        let location = sender.location(in: renderView)
        
        guard !toolbar.frame.contains(location) else {
            return
        }
        
        guard let snapshot = renderView.snapshotImage() else { return }
        currentSnapshot = snapshot
        
        guard let color = snapshot.pixelColor(at: location) else {
            return
        }
        
        colorIndicator.backgroundColor = color
        colorIsolator.color = color
        colorPosition.color = color
    }
    
    private var currentSnapshot: UIImage?
}

func /(lhs: CGRect, rhs: CGRect) -> CGRect {
    return CGRect(
        x: lhs.origin.x / rhs.origin.x,
        y: lhs.origin.y / rhs.origin.y,
        width: lhs.size.width / rhs.size.width,
        height: lhs.size.height / rhs.size.height
    )
}

func *(lhs: CGRect, rhs: CGSize) -> CGRect {
    return CGRect(
        x: lhs.origin.x * rhs.width,
        y: lhs.origin.y * rhs.height,
        width: lhs.size.width * rhs.width,
        height: lhs.size.height * rhs.height
    )
}

