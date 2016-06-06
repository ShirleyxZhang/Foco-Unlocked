//
//  PhotoGalleryCropping.swift
//  NewCamera
//
//  Created by Sudikoff Lab iMac on 3/27/16.
//  Copyright © 2016 Sudikoff Lab iMac. All rights reserved.
//

import Foundation
import UIKit

class PhotoGalleryCropping : NSObject {
    
    func cropToSquare(image: UIImage) -> UIImage {
        var positionX: CGFloat = 0.0
        var positionY: CGFloat = 0.0
        var width: CGFloat = image.size.width
        var height: CGFloat = image.size.height
        
        if width > height {
            //Landscape
            positionX = -((height - width) / 2.0)
            width = height
        }
        else if width < height {
            //Portrait
            positionY = ((height - width) / 2.0)
            height = width
        }
        else{
            //Already Square
        }
        
        let cropSquare = CGRectMake(positionX, positionY, width, height)
        let imageRef = CGImageCreateWithImageInRect(image.CGImage, cropSquare)
        return UIImage(CGImage: imageRef!, scale: UIScreen.mainScreen().scale, orientation: image.imageOrientation)
    }
    
}
