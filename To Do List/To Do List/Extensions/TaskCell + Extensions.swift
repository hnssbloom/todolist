//
//  TaskCell + Extensions.swift
//  To Do List
//
//  Created by Alina Kazantseva on 2/23/25.
//

import UIKit

//MARK: - TaskCell Methods
extension TaskCell {
    func uiConfig() {
        contentView.layer.cornerRadius = 15
        taskTitleConfig()
        taskSubTitleConfig()
        taskDateConfig()
        separatorLineConfig()
        taskStateConfig()
    }
    
    func taskTitleConfig() {
        updateTitleStyle()
        taskTitle.textColor = .black
        taskTitle.font = .boldSystemFont(ofSize: 20)
        
        //Constraints
        contentView.addSubview(taskTitle)
        taskTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            taskTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            taskTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            taskTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -60)
        ])
    }
    
    func taskSubTitleConfig() {
        taskSubTitle.text = task.subTitle
        taskSubTitle.textColor = .secondaryLabel
        taskSubTitle.font = .systemFont(ofSize: 15, weight: .light)
        taskSubTitle.numberOfLines = 3
        
        //Constraints
        contentView.addSubview(taskSubTitle)
        taskSubTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            taskSubTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            taskSubTitle.topAnchor.constraint(equalTo: taskTitle.bottomAnchor, constant: 8),
            taskSubTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -60)
        ])
    }
    
    func taskDateConfig() {
        taskDate.text = formattedDate(from: task.creationDate)
        taskDate.textColor = .secondaryLabel
        taskDate.font = .boldSystemFont(ofSize: 15)
        
        //Constraints
        contentView.addSubview(taskDate)
        taskDate.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            taskDate.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            taskDate.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func separatorLineConfig() {
        separatorLineView.backgroundColor = .gray
        separatorLineView.layer.cornerRadius = 3
        
        //Constraints
        contentView.addSubview(separatorLineView)
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separatorLineView.widthAnchor.constraint(equalToConstant: 1),
            separatorLineView.heightAnchor.constraint(equalToConstant: 35),
            separatorLineView.leadingAnchor.constraint(equalTo: taskDate.trailingAnchor, constant: 60),
            separatorLineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6)
        ])
    }
    
    func taskStateConfig() {
        taskState.text = task.isCompleted ? "✔️" : "✖️"
        taskState.font = .systemFont(ofSize: 20)
        taskState.isUserInteractionEnabled = true
        
        //Configuring gesture recognizer for the 'taskState' label
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(taskStateAction))
        taskState.addGestureRecognizer(tapGesture)
        
        //Constraints
        contentView.addSubview(taskState)
        taskState.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            taskState.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -45),
            taskState.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    //Logic that happens whenever user presses 'checkmark'/'cross' emojis. Those represents task's isCompleted property
    @objc func taskStateAction(_ sender: Any) {
        task.isCompleted.toggle()
        taskState.text = task.isCompleted ? "✔️" : "✖️"
        updateTitleStyle()
        print(task.isCompleted)
    }
    
    //Code that is responsible for drawing a strikethrough when task's isCompleted property is set to true
    func updateTitleStyle() {
        let attributes: [NSAttributedString.Key : Any] = [.strikethroughStyle: task.isCompleted ? NSUnderlineStyle.single.rawValue : 0,
                                                          .strikethroughColor: UIColor.black,
                                                          .foregroundColor: task.isCompleted ? UIColor.lightGray : UIColor.black]
        let attributedString = NSAttributedString(string: task.title ?? "", attributes: attributes)
        taskTitle.attributedText = attributedString
    }
}
