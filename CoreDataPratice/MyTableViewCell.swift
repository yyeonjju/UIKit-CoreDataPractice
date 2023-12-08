//
//  MyTableViewCell.swift
//  CoreDataPratice
//
//  Created by 하연주 on 2023/12/08.
//

import UIKit

final class MyTableViewCell: UITableViewCell {
    static let cellID = "listCell"
    
    let label : UILabel = {
        var label = UILabel()
        label.font = .boldSystemFont(ofSize: 25)
        
        return label
    }()
    


//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    //⭐️⭐️⭐️⭐️ 오토레이아웃 정하는 정확한 시점
    override func updateConstraints() {
        
//        setConstraints()
        super.updateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    


}
