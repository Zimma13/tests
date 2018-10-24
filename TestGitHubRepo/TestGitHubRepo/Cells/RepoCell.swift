//
//  RepoCell.swift
//  TestGitHubRepo
//
//  Created by Zimma on 24/10/2018.
//  Copyright © 2018 Zimma. All rights reserved.
//

import UIKit

class RepoCell: UITableViewCell {
    
    let nameLabel: UILabel = {
        let name = UILabel()
        name.numberOfLines = 0
        name.textColor = GlobalColors.textColor
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    let starsIcoLabel: UILabel = {
        let stars = UILabel()
        stars.text = "★"
        stars.textColor = GlobalColors.darkTextColor
        stars.translatesAutoresizingMaskIntoConstraints = false
        return stars
    }()
    
    let starsDataLablel: UILabel = {
        let starsData = UILabel()
        starsData.textColor = GlobalColors.textColor
        starsData.translatesAutoresizingMaskIntoConstraints = false
        return starsData
    }()
    
    let arrowLabel: UILabel = {
        let arrow = UILabel()
        arrow.text = "❯"
        arrow.textColor = GlobalColors.darkTextColor
        arrow.translatesAutoresizingMaskIntoConstraints = false
        return arrow
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func setupCell() {
        addSubview(nameLabel)
        addSubview(starsIcoLabel)
        addSubview(starsDataLablel)
        addSubview(arrowLabel)
        
        //MARK: - Constraints cell items
        let views = ["nameLabel": nameLabel, "starsIcoLabel": starsIcoLabel, "starsDataLablel": starsDataLablel, "arrowLabel": arrowLabel]
        let width = bounds.width * 0.70
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[nameLabel(\(width))]-10-[starsIcoLabel(20)]-3-[starsDataLablel]-3-[arrowLabel]-10-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: views))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-3-[nameLabel]-3-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-3-[starsIcoLabel]-3-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-3-[starsDataLablel]-3-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-3-[arrowLabel]-3-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: views))
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
