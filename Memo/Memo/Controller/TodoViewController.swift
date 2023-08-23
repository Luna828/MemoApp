import UIKit

class TodoViewController: UIViewController {
    let todoManager = TodoManager()
    
    let tableView = UITableView()
    
    let cellReuseIdentifier = "cell"
    let sectionNames = ["Work", "Life"]
    
    var workTodos: [Todo] = []
    var lifeTodos: [Todo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.systemGray3
        
        // TableView 설정
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        view.addSubview(tableView)
        title = "TODO"
        
        // 섹션별로 Todo 배열을 초기화
        workTodos = todoManager.getWorkTodos()
        lifeTodos = todoManager.getLifeTodos()
    }
}

extension TodoViewController: UITableViewDelegate {}

extension TodoViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNames.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionName = sectionNames[section]
        
        if sectionName == "Work" {
            return todoManager.workTodos.count
        } else if sectionName == "Life" {
            return todoManager.lifeTodos.count
        }
        
        return 0
    }
    
    // 섹션 헤더 뷰 설정
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 20))
        headerView.backgroundColor = .white
        
        let titleLabel = UILabel(frame: headerView.bounds)
        titleLabel.textAlignment = .left
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.text = sectionNames[section]
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor)
        ])
        
        return headerView
    }
    
    // 섹션 푸터 뷰 설정
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 20))
        tableView.tableFooterView = footerView
        footerView.backgroundColor = .white
        
        // 푸터 뷰의 오토레이아웃 설정
        footerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 50) // 푸터 뷰의 높이 설정
        ])
        
        let titleLabel = UILabel(frame: footerView.bounds)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.text = "Work 갯수: \(todoManager.getWorkTodos().count)/Life 갯수: \(todoManager.getLifeTodos().count)"
        footerView.addSubview(titleLabel)
        
        return footerView
    }
    
    // 섹션 헤더 높이 설정
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    // 섹션 푸터 높이 설정
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var workTodos = todoManager.getWorkTodos() // 메모 배열 가져오기
        var lifeTodos = todoManager.getLifeTodos() // 메모 배열 가져오기
        
        let sectionName = sectionNames[indexPath.section] // 현재 섹션 이름 가져오기
        
        if sectionName == "Work" {
            workTodos = todoManager.workTodos
            if indexPath.row < workTodos.count {
                let todo = workTodos[indexPath.row]
                cell.textLabel?.text = todo.content
                
                let switchView = UISwitch()
                switchView.isOn = todo.isCompleted
                switchView.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
                cell.accessoryView = switchView
            }
            return cell
        } else if sectionName == "Life" {
            lifeTodos = todoManager.lifeTodos
            if indexPath.row < lifeTodos.count {
                let todo = lifeTodos[indexPath.row]
                cell.textLabel?.text = todo.content
                
                let switchView = UISwitch()
                switchView.isOn = todo.isCompleted
                switchView.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
                cell.accessoryView = switchView
            }
        } else {
            let switchView = UISwitch()
            switchView.isOn = false
            cell.accessoryView = switchView
                
            cell.textLabel?.text = "No todo" // 메모가 없는 경우 대비
            cell.textLabel?.textColor = .gray
        }
        return cell
    }

    @objc func switchValueChanged(_ sender: UISwitch) {
        // 스위치의 상태가 변경되었을 때 처리하는 로직을 구현
        if let switchIndex = sender.tag as? Int {
            let indexPath = IndexPath(row: switchIndex, section: 0) // Assuming the section is 0
            let sectionName = sectionNames[indexPath.section]
            var todos: [Todo] = []

            if sectionName == "Work" {
                todos = workTodos
            } else if sectionName == "Life" {
                todos = lifeTodos
            }

            if switchIndex < todos.count {
                let todo = todos[switchIndex]
                todoManager.updateTodo(at: switchIndex, with: todo.content, isCompleted: sender.isOn, section: sectionName)

                // Reload only the specific row to update the switch state
                tableView.reloadRows(at: [indexPath], with: .none)
            }
        }
    }
}
