import UIKit

class SearchController: UITableViewController {

    // MARK: - Properties

    private var viewModel: SearchViewModel
    private let searchController = UISearchController(searchResultsController: nil)

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

        viewModel.delegate = self
        viewModel.load()

        configureTableView()
        configureSearchController()
    }

    // MARK: - Helpers

    func configureTableView() {
        view.backgroundColor = .white
        tableView.register(UserCell.self, forCellReuseIdentifier: UserCell.reuseIdentifier)
        tableView.rowHeight = 64
    }

    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = false
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

// MARK: - Delegates

extension SearchController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = viewModel.users[indexPath.row]
        let profileViewModel = ProfileViewModel(user: user)
        let controller = ProfileController(viewModel: profileViewModel)
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension SearchController: SearchViewModelDelegate {
    func searchViewModelDidUpdate() {
        self.tableView.reloadData()
    }
}

//MARK: - UISearchResultsUpdating

extension SearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        print("DEBUG: search text: \(searchText)")

        viewModel.search(for: searchText)
    }
}

