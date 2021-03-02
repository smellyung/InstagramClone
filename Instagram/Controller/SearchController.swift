import UIKit

class SearchController: UITableViewController {

    // MARK: - Properties

    private var viewModel: SearchViewModel

    // MARK: - Lifecycle

    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()

        viewModel.delegate = self
        viewModel.load()
    }

    // MARK: - Helpers
    func configureTableView() {
        view.backgroundColor = .white
        tableView.register(UserCell.self, forCellReuseIdentifier: UserCell.reuseIdentifier)
        tableView.rowHeight = 64
    }
}

// MARK: - UITableViewDataSource

extension SearchController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.reuseIdentifier, for: indexPath) as! UserCell
        cell.user = viewModel.users[indexPath.row]
        return cell
    }
}

extension SearchController: SearchViewModelDelegate {
    func searchViewModelDidUpdate() {
        self.tableView.reloadData()
    }
}
