//
//  Cell.swift
//  SeeWorld
//
//  Created by Tomas Galvan-Huerta on 1/18/20.
//  Copyright © 2020 Somat. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell{
    
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    override func prepareForReuse() {
        label.text = "done"
        distanceLabel.text = ""
    }
    
}
