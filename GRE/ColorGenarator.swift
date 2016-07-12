//
//  ColorGenarator.swift
//  colorGenTor
//
//  Created by Do Ngoc Trinh on 7/12/16.
//  Copyright © 2016 Do Ngoc Trinh. All rights reserved.
//

import Foundation
import UIKit
class ColorGenarator {
    /////////
    static let rangeColor:Float = 3.0
    
    static let seedColors = [
        UIColor.init(hue: 4.1/360.0, saturation: 89.6/100.0, brightness: 58.4/100.0, alpha: 1),
        UIColor.init(hue: 291.2/360.0, saturation: 63.7/100.0, brightness: 42.2/100.0, alpha: 1),
        UIColor.init(hue: 230.8/360.0, saturation: 48.4/100.0, brightness: 47.8/100.0, alpha: 1),
        UIColor.init(hue: 208/360.0, saturation: 79.3/100.0, brightness: 50.8/100.0, alpha: 1),
        UIColor.init(hue: 185/360.0, saturation: 100/100.0, brightness: 28/100.0, alpha: 1),
        UIColor.init(hue: 173.9/360.0, saturation: 100/100.0, brightness: 26.9/100.0, alpha: 1),
        UIColor.init(hue: 95.2/360.0, saturation: 49.5/100.0, brightness: 36.5/100.0, alpha: 1),
        UIColor.init(hue: 59.5/360.0, saturation: 62.9/100.0, brightness: 38/100.0, alpha: 1),
        UIColor.init(hue: 21.1/360.0, saturation: 100/100.0, brightness: 45.1/100.0, alpha: 1),
        UIColor.init(hue: 13.9/360.0, saturation: 65.4/100.0, brightness: 37.8/100.0, alpha: 1),
        UIColor.init(hue: 4.1/360.0, saturation: 89.6/100.0, brightness: 58.4/100.0, alpha: 1)
    ]
    
    static func getColor(index: Int) -> UIColor{
        return mixByStep(index);
    }
    
    static func mixByStep(index:Int) -> UIColor{
        let grandPercentage = Float(index)*rangeColor*1.618033988749895%100;
        let rangeStep = 100/Float(seedColors.count-1);
        var colors = getColorsFromSeed(Int(floor(grandPercentage/rangeStep)));
        let percentage = (grandPercentage%rangeStep)*Float(seedColors.count-1)/100.0;
    
        var hsl1 : (hue:CGFloat, sat: CGFloat, light: CGFloat) = (0,0,0);
        var hsl2 : (hue:CGFloat, sat: CGFloat, light: CGFloat) = (0,0,0);
        
        colors[0].getHue(&hsl1.hue, saturation: &hsl1.sat, brightness: &hsl1.light, alpha: nil);
        colors[1].getHue(&hsl2.hue, saturation: &hsl2.sat, brightness: &hsl2.light, alpha: nil);
        
        var sum: CGFloat;
        if(hsl2.hue - hsl1.hue > 0){
           // print("\(hsl1.hue) , \(hsl2.hue)");
            sum = (hsl1.hue+1)*CGFloat(1-percentage) + hsl2.hue*CGFloat(percentage);
        }
        else{
            sum = hsl1.hue*CGFloat(1-percentage) + hsl2.hue*CGFloat(percentage);
        }
        
        let newHue = sum % 1;
        let newSat = hsl1.sat*CGFloat(1-percentage) + hsl2.sat*CGFloat(percentage);
        let newLight = hsl1.light*CGFloat(1-percentage) + hsl2.light*CGFloat(percentage);
        //print("\(newHue) , \(newSat) ,\( newLight)");
        return UIColor.init(hue: newHue, saturation: newSat, brightness: newLight, alpha: 1);
    }
    
    static func getColorsFromSeed(point: Int) -> [UIColor]{
        return [
            seedColors[point],
            seedColors[point+1]
        ]
    }

}