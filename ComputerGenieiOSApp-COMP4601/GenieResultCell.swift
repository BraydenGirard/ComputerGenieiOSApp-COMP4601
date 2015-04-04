//
//  BasicCell.swift
//  ComputerGenieiOSApp-COMP4601
//
//  Created by Brayden Girard on 2015-03-31.
//  Copyright (c) 2015 Brayden Girard. All rights reserved.
//

import UIKit

class GenieResultCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var retailerLabel: UILabel!
    @IBOutlet var imageViewCell: UIImageView!
    
    private var genie: GenieResponse!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func getGenie() -> GenieResponse {
        return self.genie
    }
    
    func setGenie(response: GenieResponse) {
        self.genie = response
        
        setTitle(response.getName())
        setPrice(response.getPrice())
        setRetailer(response.getRetailer())
    }
    
    func setThumbnailImage(image: UIImage) {
        self.imageViewCell.image = image
    }
    
    private func setPrice(value: Float) {
        var print = NSString(format: "$ %.2f", value)
        self.titleLabel?.text = print
    }
    
    private func setTitle(value: String) {
        self.priceLabel?.text = value
    }
    
    private func setRetailer(value: String) {
        self.retailerLabel?.text = value
    }
    
}