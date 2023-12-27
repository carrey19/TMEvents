//
//  EventTableViewCell.swift
//  TMEvents
//
//  Created by Juan Carlos Carrera Reyes on 25/12/23.
//

import UIKit
import Kingfisher

class EventTableViewCell: UITableViewCell {
    // MARK: - Private Properties
    private let eventImageView = UIImageView()
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let venueNameLabel = UILabel()
    private let cityLabel = UILabel()
    private let stackView = UIStackView()

    // MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    // MARK: - Configuration
    func configure(with event: Event) {
        setup()
        titleLabel.text = event.name
        dateLabel.text = event.dates?.start?.localDate?.toMonthFormatDate()
        venueNameLabel.text = event.embedded?.venues?.first?.name
        if let cityName = event.embedded?.venues?.first?.city?.name,
           let stateCode = event.embedded?.venues?.first?.state?.stateCode {
            cityLabel.text =  "\(cityName), \(stateCode)"
        }
        guard let imageUrl = URL(string: event.images?.first?.url ?? "") else { return }
        self.eventImageView.kf.setImage(with: imageUrl)
    }
}

// MARK: - Setup Implementation
extension EventTableViewCell {
    private func setup() {
        self.backgroundColor = .systemBackground
        addSubViews()
        setupViews()
        setupConstraints()
    }

    private func addSubViews() {
        let subviews = [eventImageView, titleLabel, dateLabel, venueNameLabel, cityLabel, stackView]
        subviews.forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func setupViews() {
        stackView.axis = .vertical
        stackView.spacing = 2
        titleLabel.numberOfLines = 0
        dateLabel.numberOfLines = 0
        venueNameLabel.numberOfLines = 0
        cityLabel.numberOfLines = 0
        titleLabel.font = UIFont(name: "LDFComicSansBold", size: UIFont.labelFontSize)
        dateLabel.font = UIFont(name: "LDFComicSansHairline", size: UIFont.labelFontSize)
        venueNameLabel.font = UIFont(name: "LDFComicSansLight", size: UIFont.labelFontSize)
        cityLabel.font = UIFont(name: "LDFComicSansLight", size: UIFont.labelFontSize)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            //image view
            eventImageView.topAnchor.constraint(equalTo: topAnchor),
            eventImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            eventImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            eventImageView.widthAnchor.constraint(equalToConstant: 150),
            //stack view
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: 5),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(venueNameLabel)
        stackView.addArrangedSubview(cityLabel)
    }
}

// MARK: - Debug

#if DEBUG
extension EventTableViewCell {
    var testHooks: TestHooks {
        return TestHooks(target: self)
    }

    struct TestHooks {
        private let target: EventTableViewCell

        fileprivate init(target: EventTableViewCell) {
            self.target = target
        }

        var eventImageView: UIImageView { target.eventImageView }
        var titleLabel: UILabel { target.titleLabel }
        var dateLabel: UILabel { target.dateLabel }
        var venueNameLabel: UILabel { target.venueNameLabel }
        var cityLabel: UILabel { target.cityLabel }
    }
}
#endif
