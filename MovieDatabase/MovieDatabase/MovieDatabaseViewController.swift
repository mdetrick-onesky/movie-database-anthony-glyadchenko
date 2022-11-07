import UIKit

public class MovieDatabaseViewController: UITableViewController {

  private let viewModel = MovieDatabaseViewModel()
  private let movieCellIdentifier = "MovieCell"
  private let tvShowCellIdentifier = "TVShowCell"
  private let personCellIdentifier = "PersonCell"

  private let searchController = UISearchController(searchResultsController: nil)

  init() {
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func viewDidLoad() {
    super.viewDidLoad()

    title = "Movie Database"
    navigationController?.navigationBar.prefersLargeTitles = true
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search"
    navigationItem.searchController = searchController
    definesPresentationContext = true

    tableView.register(MovieCell.self, forCellReuseIdentifier: movieCellIdentifier)
    tableView.register(TVShowCell.self, forCellReuseIdentifier: tvShowCellIdentifier)
    tableView.register(PersonCell.self, forCellReuseIdentifier: personCellIdentifier)
  }
}

extension MovieDatabaseViewController: UISearchResultsUpdating {
  public func updateSearchResults(for searchController: UISearchController) {
    
  }
}
