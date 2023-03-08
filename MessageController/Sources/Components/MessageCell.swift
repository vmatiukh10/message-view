//
//  MessageCell.swift
//  MessageController
//
//  Created by Volodymyr Matiukh on 08.03.2023.
//

import UIKit

class MessageCell: UITableViewCell {
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var bubbleView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bubbleView.layer.cornerRadius = 7
    }
    
    func config(_ message: String, time: String) {
        messageLabel.text = message
        timeLabel.text = time
    }
}
