import UIKit

class TodoListVC: UIViewController {
    private lazy var tasksTable:UITableView = {
        let tasksTable = UITableView()
        tasksTable.register(TodoTableViewCell.self, forCellReuseIdentifier: TodoTableViewCell.identifier)
        tasksTable.translatesAutoresizingMaskIntoConstraints = false
        
        tasksTable.dataSource = self
        tasksTable.delegate = self
        return tasksTable
    }()
    
    var isEditingTable = false
    
    var tasks = [
        TodoTask(title: "Communication task (Protocol)"),
        TodoTask(title: "User interface constraints"),
        TodoTask(title: "UITableView/UICollectionView")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupTableView()
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        navigationItem.title = "My Todo List"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action:#selector(editTask))
    }
    
    func setupTableView() {
        view.addSubview(tasksTable)
        
        NSLayoutConstraint.activate([
            tasksTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tasksTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tasksTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tasksTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    @objc func addTask() {
        let addTaskAlert = UIAlertController(title: "New Task", message: "Add a new task", preferredStyle: .alert)
        addTaskAlert.addTextField { textField in
            textField.placeholder = "Enter task"
        }
        addTaskAlert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action) in
            if let taskName = addTaskAlert.textFields?.first?.text {
                self.tasks.append(TodoTask(title: taskName))
                self.tasksTable.reloadData()
            }
        }))
        present(addTaskAlert, animated: true)
    }
    
    @objc func editTask() {
        isEditingTable.toggle()
        tasksTable.reloadData()
    }
}

extension TodoListVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tasksTable.dequeueReusableCell(withIdentifier: TodoTableViewCell.identifier, for: indexPath) as?TodoTableViewCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        let task = tasks[indexPath.row]
        cell.configureCell(title: task.title, checked: task.isComplete, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? TodoTableViewCell else { return }
        cell.toggleDeleteButtonVisiblity(isEditing: isEditingTable)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tasks.remove(at: indexPath.row)
            tasksTable.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

extension TodoListVC: TodoTableViewCellDelegate {
    func deleteButtonTapped(indexPath: IndexPath) {
        self.tasks.remove(at: indexPath.row)
        self.tasksTable.deleteRows(at: [indexPath], with: .automatic)
        self.tasksTable.reloadRows(at: [indexPath], with: .automatic)
    }
}
