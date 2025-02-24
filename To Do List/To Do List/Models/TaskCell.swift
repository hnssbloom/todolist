    //
    //  TaskCell.swift
    //  To Do List
    //
    //  Created by Alina Kazantseva on 2/20/25.
    //

    import UIKit


    class TaskCell: UITableViewCell {
        //MARK: - Properties
        //Custom identifier
        static let id = "TaskCell"
        
        //UI Elements
        let taskTitle = UILabel()
        let taskSubTitle = UILabel()
        let taskState = UILabel()
        let taskDate = UILabel()
        var separatorLineView: UIView = {
            $0.backgroundColor = Colors.lightGray
            return $0
        }(UIView())
        
        //Other stuff
        var task: TaskMO
        
        //MARK: - Initializers
        init(task: TaskMO, style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            self.task = task
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            uiConfig()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
