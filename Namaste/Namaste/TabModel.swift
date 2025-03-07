//
//  TabModel.swift
//  Namaste
//
//  Created by 陳憶婷 on 2025/3/7.
//

import UIKit

struct TabModel {
    var id: String { title }
    let title: String
    let curations: [CurationModel]
    
    init(title: String, curations: [CurationModel]) {
        self.title = title
        self.curations = curations
    }
}

struct CurationModel {
    let title: String
    let items: [ItemModel]
    
    init(title: String, items: [ItemModel]) {
        self.title = title
        self.items = items
    }
}

struct ItemModel {
    let title: String
    let image: UIImage?
    
    init(title: String, image: UIImage?) {
        self.title = title
        self.image = image
    }
}
