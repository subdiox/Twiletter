//
//  ViewController.swift
//  HeartButtonDemo
//
//  Created by Jansel Valentin on 6/12/16.
//  Copyright © 2016 Jansel Valentin. All rights reserved.
//

import UIKit
import FaveButton

func color(_ rgbColor: Int) -> UIColor{
    return UIColor(
        red:   CGFloat((rgbColor & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbColor & 0x00FF00) >> 8 ) / 255.0,
        blue:  CGFloat((rgbColor & 0x0000FF) >> 0 ) / 255.0,
        alpha: CGFloat(1.0)
    )
}

class ViewController: UIViewController {
    
    @IBOutlet var heartButton: HeartButton?
    @IBOutlet var loveButton : HeartButton?
    
    let colors = [
        DotColors(first: color(0x7DC2F4), second: color(0xE2264D)),
        DotColors(first: color(0xF8CC61), second: color(0x9BDFBA)),
        DotColors(first: color(0xAF90F4), second: color(0x90D1F9)),
        DotColors(first: color(0xE9A966), second: color(0xF8C852)),        
        DotColors(first: color(0xF68FA7), second: color(0xF6A2B8))
    ]
    
    func heartButton(_ heartButton: HeartButton, didSelected selected: Bool){
    }
    
    func heartButtonDotColors(_ heartButton: HeartButton) -> [DotColors]?{
        if( heartButton === heartButton || heartButton === loveButton){
            return colors
        }
        return nil
    }
    
    @IBAction func tappedStarButton(sender: StarButton) {
        sender.toggle()
    }
    
    @IBAction func tappedHeartButton(sender: HeartButton) {
        sender.toggle()
    }
    
    
}




