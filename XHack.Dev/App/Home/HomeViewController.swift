
import UIKit
import RxSwift
import RxDataSources

class HomeViewController: BaseViewController<HomeViewModel>, Storyboarded {
    static var storyboard = AppStoryboard.home
    
    var refreshHandler: RefreshHandler!
    
    @IBOutlet weak var changeSearchableStateSwitch: UISwitch!
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource:  RxTableViewSectionedReloadDataSource<RequestSection> = {
        let dataSource = RxTableViewSectionedReloadDataSource<RequestSection>(configureCell: { (_, tableView, indexPath, target) -> UITableViewCell in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: IncomingRequestViewCell.reuseIdentifier, for: indexPath) as! IncomingRequestViewCell
            cell.set(target)
            return cell
        })
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].title
        }
        
        return dataSource
    }()
    
    override func completeUi() {
        tableView.tableFooterView = UIView()
        refreshHandler = RefreshHandler(view: tableView)
        tableView.register(IncomingRequestViewCell.nib, forCellReuseIdentifier: IncomingRequestViewCell.reuseIdentifier)
    }
    
    override func applyBinding() {
        guard let dataContext = dataContext else {
            return
        }
        dataContext.isRefreshing
            .bind(to: refreshHandler.isRefreshing)
            .disposed(by: disposeBag)
        
        dataContext.requestSections.bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(IncomingRequest.self)
            .bind(to: dataContext.requestSelected)
            .disposed(by: disposeBag)
        
        refreshHandler.refresh
            .bind(to: dataContext.refresh)
            .disposed(by: disposeBag)
        
        changeSearchableStateSwitch.rx.isOn
            .skip(1)
            .bind(to: dataContext.changeSearchableState)
            .disposed(by: disposeBag)
        
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        dataContext.isAvailableForSearching
            .bind(to: changeSearchableStateSwitch.rx.isOn)
            .disposed(by: disposeBag)
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 42)
        let headerView = UIView(frame: frame)
        headerView.backgroundColor = .white
        let labelXoffset = CGFloat(15)
        let labelWidth = frame.width - labelXoffset
        let sectionLabel = UILabel(frame: CGRect(x: 15, y: 0, width: labelWidth , height: frame.height))
        sectionLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        sectionLabel.text = dataSource[section].title
        
        sectionLabel.textColor = .black
        headerView.addSubview(sectionLabel)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}
