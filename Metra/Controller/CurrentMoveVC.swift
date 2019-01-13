//
//  CurrentMoveVC.swift
//  Metra
//
//  Created by Zelal-Ezaldeen on 1/13/19.
//  Copyright © 2019 Metra Company. All rights reserved.
//

import UIKit

class CurrentMoveVC: LocationVC {
    
    //Outlets
    @IBOutlet weak var swipBGImgView: UIImageView!
    @IBOutlet weak var sliderImgView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeGuesture = UIPanGestureRecognizer(target: self, action: #selector(endRunSwiped(sender:)))
        sliderImgView.addGestureRecognizer(swipeGuesture)
        sliderImgView.isUserInteractionEnabled = true
        swipeGuesture.delegate = self as? UIGestureRecognizerDelegate

     
    }
    
    @objc func endRunSwiped(sender: UIPanGestureRecognizer) {
        let minAdjust: CGFloat = 80
        let maxAdjust: CGFloat = 128
        if let sliderView = sender.view {
            if sender.state == UIGestureRecognizer.State.began || sender.state == UIGestureRecognizer.State.changed {
               let translation =  sender.translation(in: self.view)
                if sliderView.center.x >= (swipBGImgView.center.x - minAdjust) && sliderView.center.x <= (swipBGImgView.center.x + maxAdjust) {
                    sliderView.center.x = sliderView.center.x + translation.x
                } else if sliderView.center.x >= (swipBGImgView.center.x + maxAdjust) {
                    sliderView.center.x = swipBGImgView.center.x + maxAdjust
                    //End Move here
                    dismiss(animated: true, completion: nil)
                } else {
                    sliderView.center.x = swipBGImgView.center.x - minAdjust
                }
                sender.setTranslation(CGPoint.zero, in: self.view)
            } else if sender.state == UIGestureRecognizer.State.ended {
                UIView.animate(withDuration: 0.1, animations: {
                    sliderView.center.x = self.swipBGImgView.center.x - minAdjust
                })
            }
        }
    }
    

   

}
