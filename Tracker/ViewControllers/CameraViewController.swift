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
    
    let camera = Camera()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        camera.orientation = .landscapeRight
        renderView.contentMode = .scaleAspectFill
        
        camera --> renderView
        
//        let resize = Resize()
//        resize.outputSize = MTLSize(width: 140, height: 100, depth: 1)
//        
//        let colorIsolator = ColorIsolator()
//        colorIsolator.color = UIColor.red
//        
//        camera --> colorIsolator --> renderView
    }

    
    
    @IBAction func handleTap(_ sender: UITapGestureRecognizer) {
        
        let location = sender.location(in: renderView) / renderView.bounds.size
        
        guard let snapshot = renderView.snapshotImage() else { return }
//        let snapshot = UIImage(view: snapshotView)
        currentSnapshot = snapshot
        
        guard let color = snapshot[Int(location.x * snapshot.size.width), Int(location.y * snapshot.size.height)] else {
            return
        }
        print(color)
//        colorMask.color = color
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
