import UIKit

public class MovieCell: UITableViewCell {

  let backdropImageView = UIImageView()
  let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .headline)
    return label
  }()
  let dateLabel = UILabel()
  let voteLabel = UILabel()

  public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    backdropImageView.translatesAutoresizingMaskIntoConstraints = false
    backdropImageView.contentMode = .scaleAspectFill
    backdropImageView.layer.masksToBounds = true

    let topStackView = UIStackView(arrangedSubviews: [titleLabel, UIView(), voteLabel])
    topStackView.axis = .horizontal

    let textStackView = UIStackView(arrangedSubviews: [topStackView, dateLabel])
    textStackView.axis = .vertical
    textStackView.spacing = 8

    let mainStackView = UIStackView(arrangedSubviews: [backdropImageView, textStackView])
    mainStackView.axis = .vertical
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    mainStackView.isLayoutMarginsRelativeArrangement = true
    mainStackView.layoutMargins = .init(top: 15, left: 15, bottom: 15, right: 15)
    mainStackView.spacing = 8

    contentView.addSubview(mainStackView)

    NSLayoutConstraint.activate([
      mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
      mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public func configure(with movie: Movie) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let newDateFormatter = DateFormatter()
    newDateFormatter.dateStyle = .long
    newDateFormatter.timeStyle = .none
    titleLabel.text = movie.title
    voteLabel.text = String(movie.voteAverage)
    let parsedDate = dateFormatter.date(from: movie.releaseDate)
    dateLabel.text = parsedDate != nil ? newDateFormatter.string(from: parsedDate!) : nil
    downloadImage(movie.backdropPath)
  }

  private func downloadImage(_ path: String?) {
    backdropImageView.image = nil
    guard let path = path else { return }

    let url = URL(string: "https://image.tmdb.org/t/p/w500\(path)")!
    let task = URLSession.shared.dataTask(with: url) { [weak self] data, res, err in
      DispatchQueue.main.async {
        self?.backdropImageView.image = data != nil ? UIImage(data: data!) : nil
      }
    }
    task.resume()
  }
}

