//
//  Place.swift
//  Names_To_Places
//
//  Created by Angelina Tsuboi on 2/3/20.
//  Copyright © 2020 Angelina Tsuboi. All rights reserved.
//

import UIKit

class Place: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String){
        self.name = name
        self.image = image
    }
}
