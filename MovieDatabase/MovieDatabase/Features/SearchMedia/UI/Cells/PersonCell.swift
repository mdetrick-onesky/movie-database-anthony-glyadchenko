import UIKit

public class PersonCell: UITableViewCell {

  let backdropImageView = UIImageView()
  let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .headline)
    return label
  }()
  let knownForLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    return label
  }()
  let voteLabel = UILabel()

  public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    backdropImageView.translatesAutoresizingMaskIntoConstraints = false
    backdropImageView.contentMode = .scaleAspectFill
    backdropImageView.layer.masksToBounds = true

    let textStackView = UIStackView(arrangedSubviews: [titleLabel, knownForLabel, voteLabel, UIView()])
    textStackView.axis = .vertical
    textStackView.spacing = 8

    let mainStackView = UIStackView(arrangedSubviews: [backdropImageView, textStackView])
    mainStackView.axis = .horizontal
    mainStackView.distribution = .fillEqually
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    mainStackView.isLayoutMarginsRelativeArrangement = true
    mainStackView.layoutMargins = .init(top: 15, left: 15, bottom: 15, right: 15)
    mainStackView.spacing = 8

    contentView.addSubview(mainStackView)

    NSLayoutConstraint.activate([
      mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
      mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public func configure(with person: Person) {
    titleLabel.text = person.name
    voteLabel.text = "\(round(person.voteAverage * 10) / 10)" // round to tenths
    knownForLabel.text = person.ratingAverages.map {
      "\($0.key) (\($0.value))"
    }.joined(separator: ", ")
    downloadImage(person.profilePath)
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
