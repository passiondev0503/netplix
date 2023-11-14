//
//  HomeViewController.swift
//  Netplix
//
//  Created by Octo Siswardhono on 10/11/23.
//

import Foundation
import UIKit

final class HomeViewController: BaseUIViewController {
    private lazy var tableView: UITableView = setupTableView()
    private lazy var searchBar:UISearchBar = setupSearchBar()
    var isSearch : Bool = false
    var presenter: IHomePresenter!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = "Netplix"
        navigationItem.titleView = searchBar
        view.addSubview(tableView)
        presenter.fetchMovieList()
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        
        ])
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension HomeViewController: IHomeView {
    
    func showLoading() {
        startLoading(isHidden: false)
    }
    
    func hideLoading() {
        startLoading(isHidden: true)
    }
    
    func update() {
        tableView.reloadData()
    }
}

private extension HomeViewController {
    func setupTableView() -> UITableView {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.estimatedRowHeight = 44
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(MovieNowPlayingTableViewCell.self)
        tableView.register(MovieUpcomingTableViewCell.self)
        tableView.register(MovieTopRatedTableViewCell.self)
        tableView.register(UITableViewCell.self)
        tableView.backgroundColor = .white
        tableView.registerHeaderFooterView(HomeTableHeaderViewCell.self)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }

    func setupSearchBar() -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = "Search top rated..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        return searchBar
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        if isSearch {
            return 1
        }
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            return presenter.movieFiltered.count == 0 ? 0 : 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isSearch {
            let cell: MovieTopRatedTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setup(with: presenter.movieFiltered)
            return cell
        } else {
            switch indexPath.section {
            case 0:
                guard let model = presenter.viewModel.movieNowPlaying else {
                    return UITableViewCell()
                }
                let cell: MovieNowPlayingTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                cell.delegate = self
                cell.setup(with: model)
                return cell
            case 1:
                guard let model = presenter.viewModel.movieUpcoming else {
                    return UITableViewCell()
                }
                let cell: MovieUpcomingTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                cell.delegate = self
                cell.setup(with: model)
                return cell
            case 2:
                guard let model = presenter.viewModel.movieTopRated else {
                    return UITableViewCell()
                }
                let cell: MovieTopRatedTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                cell.delegate = self
                cell.setup(with: model)
                return cell
            default :
                return UITableViewCell()
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isSearch {
            return CGFloat(UIScreen.main.bounds.height) - CGFloat(64)
        } else {
            switch indexPath.section {
            case 0:
                return CGFloat(220)
            case 1:
                return CGFloat(150)
            case 2:
                return CGFloat(250)
            default:
                return UITableView.automaticDimension
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: HomeTableHeaderViewCell = tableView.dequeueReusableHeaderFooterView()
        switch section {
        case 1:
            headerView.headerLabel.text = "Upcoming"
            return headerView
        case 2:
            headerView.headerLabel.text = "Top Rated"
            return headerView

        default:
            return nil
        }
       
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 1, 2:
            return 44
        default:
            return 0
        }
    }
}

extension HomeViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearch = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        isSearch = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        isSearch = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        isSearch = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            isSearch = false
            tableView.reloadData()
        } else {
            presenter.search(searchText)
            
            if presenter.movieFiltered.count == 0 {
                isSearch = false
            } else {
                isSearch = true
            }
            tableView.reloadData()
        }
    }
}

extension HomeViewController: MovieNowPlayingTableViewCellDelegate {
    func didSelectMovieNowPlaying(movieId: Int) {
        presenter.navigateToMovieDetail(movieId)
    }
}

extension HomeViewController: MovieUpcomingTableViewCellDelegate {
    func didSelectMovieUpcoming(movieId: Int) {
        presenter.navigateToMovieDetail(movieId)
    }
}

extension HomeViewController: MovieTopRatedTableViewCellDelegate {
    func didSelectMovieTopRated(movieId: Int) {
        presenter.navigateToMovieDetail(movieId)
    }
}
