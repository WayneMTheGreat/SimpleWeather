//
//  SearchResultTableViewCell.swift
//  TheWeather
//
//  Created by Wayne Mosley on 7/2/19.
//  Copyright © 2019 Wayne Mosley. All rights reserved.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {

    
    static let tableCellIdentifier: String = "SearchCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textLabel!.text = ""
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
