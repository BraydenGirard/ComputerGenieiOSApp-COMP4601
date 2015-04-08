//
//  ReviewCell.swift
//  ComputerGenieiOSApp-COMP4601
//
//  Created by Ben Sweett on 2015-04-03.
//  Copyright (c) 2015 Brayden Girard. All rights reserved.
//

import UIKit

class ReviewCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var opinionImageView: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    private var review: Review!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setReview(rev: Review) {
        self.review = rev
        
        setContent(rev.getContent())
        setUserName(rev.getUserName())
        setImage(rev.getOpinion())
        setScore(rev.getScore())
        setDate(rev.getDateAsDate())
    }
    
    func getReview() -> Review {
        return self.review
    }
    
    func setReviewCellProductMode() {
        if(review != nil) {
            self.setUserName(review.getProductName().capitalizedString)
        }
    }
    
    private func setContent(value: String) {
        self.contentLabel.text = value
    }

    private func setUserName(value: String) {
        self.userLabel.text = value
    }
    
    private func setImage(value: String) {
        if(value == "LIKE") {
            self.opinionImageView.image = UIImage(named: "happy_icon.png")
        } else {
            self.opinionImageView.image = UIImage(named: "sad_icon.png")
        }
    }
    
    private func setScore(value: Int) {
        self.scoreLabel.text = String(value)
    }
    
    private func setDate(value: NSDate) {
        var formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        self.dateLabel.text = formatter.stringFromDate(value)
    }
}
