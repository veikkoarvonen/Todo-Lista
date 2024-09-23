//
//  Constants.swift
//  Todo Lista
//
//  Created by Veikko Arvonen on 18.9.2024.
//

import Foundation

struct C {
    struct Colors {
        static let brandColor = "brandColor"
    }
    
    struct Segues {
        static let mainToAdd = "mainToAdd"
    }
    
    struct TableView {
        static let cellID = "tableViewCell"
        static let cellName = "TableViewCell"
    }
}

protocol ReloadDelegate: AnyObject {
    func reloadData()
}
