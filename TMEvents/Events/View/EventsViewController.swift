//
//  EventsViewController.swift
//  TMEvents
//
//  Created by Juan Carlos Carrera Reyes on 25/12/23.
//

import UIKit
import Combine
import Network

class EventsViewController: UIViewController {
    // MARK: - Properties
    private let viewModel: EventsViewModel
    private var bindings = Set<AnyCancellable>()
    private let searchController = UISearchController(searchResultsController: nil)
    private let tableView = UITableView()
    private let activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    private let eventCellId = String(describing: EventTableViewCell.self)
    private let monitor = NWPathMonitor()

    init(viewModel: EventsViewModel = EventsViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        validateNetworkConnection()
        setupNavigationBar()
        setupSearchController()
        addSubViews()
        setupTableView()
        setUpConstraints()
        bindViewModelToView()
        view.backgroundColor = .systemBackground
    }

    // MARK: - Methods
    private func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
        self.title = viewModel.eventsModel.title
        navigationController?.navigationBar.backgroundColor = .systemBackground
    }

    private func setupSearchController() {
        searchController.searchBar.placeholder = viewModel.eventsModel.searchBarPlaceholder
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }

    private func addSubViews() {
        let subviews = [tableView, activityView]

        subviews.forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = true
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: eventCellId)
    }

    private func setUpConstraints() {
        let defaultMargin: CGFloat = 5.0

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: defaultMargin),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: defaultMargin),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: defaultMargin),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            activityView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityView.heightAnchor.constraint(equalToConstant: 50),
            activityView.widthAnchor.constraint(equalToConstant: 50)
        ])
    }

    func bindViewModelToView() {
        searchController.searchBar.searchTextField.textPublisher
            .debounce(for: 0.6, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak viewModel] in
                viewModel?.search(keyword: $0)
            }
            .store(in: &bindings)
        viewModel.$events
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] _ in
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            })
            .store(in: &bindings)

        let stateValueHandler: (EventsViewModelState) -> Void = { [weak self] state in
            switch state {
            case .initState:
                self?.initState()
            case .loading:
                self?.startLoading()
            case .finishedLoading:
                self?.finishLoading()
            case .error(let error):
                self?.finishLoading()
                self?.showError(error)
            }
        }

        viewModel.$state
            .receive(on: RunLoop.main)
            .sink(receiveValue: stateValueHandler)
            .store(in: &bindings)
    }

    private func initState() {
        activityView.isHidden = true
    }

    private func startLoading() {
        tableView.isUserInteractionEnabled = false
        activityView.isHidden = false
        activityView.startAnimating()
    }

    private func finishLoading() {
        tableView.isUserInteractionEnabled = true
        activityView.stopAnimating()
    }

    private func showError(_ error: ErrorResponse) {
        let alertController = UIAlertController(title: error.code, message: error.error, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default) { [unowned self] _ in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate, UITableViewDelegate

extension EventsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.events.count
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: eventCellId) as? EventTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: viewModel.events[indexPath.section])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

// MARK: - Network monitoring

extension EventsViewController {
    private func validateNetworkConnection() {
        monitor.pathUpdateHandler = { _ in
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
                if Reachability.isConnectedToNetwork() {
                    self.searchController.searchBar.isEnabled = true
                } else {
                    self.showError(.errorNetwork())
                    self.searchController.searchBar.isEnabled = false
                }
            })
        }
        let queue = DispatchQueue(label: viewModel.eventsModel.monitorLabel)
        monitor.start(queue: queue)
    }
}

// MARK: - Debug

#if DEBUG
extension EventsViewController {
    var testHooks: TestHooks {
        return TestHooks(target: self)
    }

    struct TestHooks {
        private let target: EventsViewController

        fileprivate init(target: EventsViewController) {
            self.target = target
        }

        var viewModel: EventsViewModel? { return target.viewModel }
        var searchController: UISearchController { target.searchController }
        var tableView: UITableView { target.tableView }
        var activityView: UIActivityIndicatorView { target.activityView }
        var monitor: NWPathMonitor { target.monitor }
    }
}
#endif
