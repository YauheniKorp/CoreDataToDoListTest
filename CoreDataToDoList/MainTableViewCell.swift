//
//  MainTableViewCell.swift
//  CoreDataToDoList
//
//  Created by Admin on 17.02.2022.
//

import UIKit


protocol MainTableViewCellDelegate: AnyObject {
    func checkDidTap(_ model: ToDoListItem)
}

class MainTableViewCell: UITableViewCell {

    static let identifier = "MainTableViewCell"
    
    weak var delegate: MainTableViewCellDelegate?
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "")
        return imageView
    }()
    
    private var model: ToDoListItem?
    
    private let checkButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .thin)
        let image = UIImage(systemName: "checkmark.circle", withConfiguration: config)
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .label
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(checkButton)
        contentView.addSubview(label)
        checkButton.addTarget(self, action: #selector(checkButtonDidTap), for: .touchUpInside)
    }
    
    @objc private func checkButtonDidTap() {
        guard let model = model else {
            return
        }

        delegate?.checkDidTap(model)
    }
    
    public func configure(with model: ToDoListItem) {
        self.model = model
        if model.check == false {
            let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .thin)
            let image = UIImage(systemName: "checkmark.circle", withConfiguration: config)
            checkButton.setImage(image, for: .normal)
        } else {
            let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .thin)
            let image = UIImage(systemName: "checkmark.circle.fill", withConfiguration: config)
            checkButton.setImage(image, for: .normal)
        }
        
        label.text = model.name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = contentView.height - 4
        
        checkButton.frame = CGRect(x: 0, y: 2, width: size, height: size)
        label.frame = CGRect(x: checkButton.right + 10, y: 2, width: contentView.width-size-20, height: contentView.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
