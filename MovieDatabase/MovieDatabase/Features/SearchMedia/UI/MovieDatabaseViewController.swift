import UIKit

public class MovieDatabaseViewController: UITableViewController {

  private let viewModel = MovieDatabaseViewModel()
  private let movieCellIdentifier = "MovieCell"
  private let tvShowCellIdentifier = "TVShowCell"
  private let personCellIdentifier = "PersonCell"

  private let searchController = UISearchController(searchResultsController: nil)
  
  private var sortedElements: [any HasVoteAverage] = []
  
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
  
  public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let isIndexOutOfBounds = indexPath.row < 0 || indexPath.row >= sortedElements.count
    if isIndexOutOfBounds {
      fatalError("MovieDB VC model inconsistency error")
    }
    
    let element = sortedElements[indexPath.row]

    let isTVShow = element is TVShow
    let isMovie = element is Movie
    let isPerson = element is Person
    
    if isTVShow {
      let cell = tableView.dequeueReusableCell(withIdentifier: tvShowCellIdentifier, for: indexPath) as! TVShowCell
      cell.configure(with: element as! TVShow)
      return cell
    } else if isMovie {
      let cell = tableView.dequeueReusableCell(withIdentifier: movieCellIdentifier, for: indexPath) as! MovieCell
      cell.configure(with: element as! Movie)
      return cell
    } else if isPerson {
      let cell = tableView.dequeueReusableCell(withIdentifier: personCellIdentifier, for: indexPath) as! PersonCell
      cell.configure(with: element as! Person)
      return cell
    } else {
      fatalError()
    }
  }
  
  public override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    sortedElements.count
  }
}

extension MovieDatabaseViewController: UISearchResultsUpdating {
  public func updateSearchResults(for searchController: UISearchController) {
    if let searchText = searchController.searchBar.text, !searchText.isEmpty {
      viewModel.retrieveMediaResults(searchTerms: searchText) { tvShows, movies, people in
        self.sortedElements = (tvShows as [any HasVoteAverage] + movies as [any HasVoteAverage] + people as [any HasVoteAverage]).sorted(by: { voteAvg1, voteAvg2 in
          voteAvg1.voteAverage > voteAvg2.voteAverage
        })
        
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
      }
    }
  }
}
