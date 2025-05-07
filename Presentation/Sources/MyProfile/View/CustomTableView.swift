import UIKit

import Then
import SnapKit

import Common
import Core

protocol AccountActionDelegate: AnyObject {
    func didTapProfileEdit()
}

protocol SignOutDelegate: AnyObject {
    func signOut()
}

protocol WithDrawDelegate: AnyObject {
    func withDraw()
}

enum SettingType: String {
    case community = "커뮤니티 가이드라인"
    case service = "서비스 이용약관"
    case privacy = "개인정보 취급방침"
    case inquiry = "문의"
    
    var url: URL {
        switch self {
        case .community:
            URL(string: "https://bohyunnkim.notion.site/98d0fa7eac84431ab6f6dd63be0fb8ff?pvs=4")!
        case .service:
            URL(string: "https://bohyunnkim.notion.site/e5c0a49d73474331a21b1594736ee0df?pvs=4")!
        case .privacy:
            URL(string: "https://bohyunnkim.notion.site/c2bdf3572df1495c92aedd0437158cf0?pvs=4")!
        case .inquiry:
            URL(string: "https://bohyunnkim.notion.site/46bdd724bf734cf79d34142a03ad52bc?pvs=4")!
        }
    }
}

enum SettingSection {
    case help
    case etc
    case account
}

public class CustomTableView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var settingTableView = UITableView()
    var list: [String]
    var headerTitle: String
    var footerView: UIView?
    var cellArrowImages: [UIImage] = []
    let type: SettingSection
    weak var signOutDelegate: SignOutDelegate?
    weak var withDrawDelegate: WithDrawDelegate?
    weak var accountActionDelegate: AccountActionDelegate?
    
    init(
        type: SettingSection,
        list: [String],
        headerTitle: String,
        footerView: UIView? = nil,
        cellArrowImages: [UIImage] = []
    ) {
        self.type = type
        self.list = list
        self.headerTitle = headerTitle
        self.footerView = footerView
        self.cellArrowImages = cellArrowImages
        super.init(
            frame: .zero
        )
        setStyle()
        setUI()
        setAutoLayout()
    }
    
    private func getPlatformLogo(for loginState: LoginState) -> UIImage? {
        switch loginState {
        case .kakao:
            return CommonAsset.kakao.image
        case .apple:
            return CommonAsset.appleLogo.image
        }
    }
    
    private func updateTableViewHeight() {
        layoutIfNeeded()
        settingTableView.layoutIfNeeded()
        
        if let heightConstraint = self.constraints.first(where: { $0.firstAttribute == .height }) {
            heightConstraint.constant = settingTableView.contentSize.height
        } else {
            self.snp.makeConstraints {
                $0.height.equalTo(settingTableView.contentSize.height)
            }
        }
    }
    
    public func reloadAndUpdateHeight() {
      settingTableView.reloadData()
      DispatchQueue.main.async { [weak self] in
        self?.updateTableViewHeight()
      }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle() {
        backgroundColor = CommonAsset.viskitBG.color
        settingTableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            $0.backgroundColor = .clear
            $0.isScrollEnabled = false
            $0.sectionHeaderTopPadding = 0
            $0.separatorStyle = .none
        }
    }
    
    private func setUI() {
        addSubview(settingTableView)
    }
    
    private func setAutoLayout() {
        settingTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.greaterThanOrEqualTo(0)
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let headerLabel = UILabel()
        
        headerLabel.do {
            $0.textColor = CommonAsset.viskitWhite.color
            $0.font = ViskitFont.title4.font
            $0.text = headerTitle
        }
        headerView.addSubview(headerLabel)
        headerLabel.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.top).inset(28)
            $0.leading.equalToSuperview().inset(20)
        }
        return headerView
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    public func tableView(_ tableView: UITableView,cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settingTableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath
        )
        cell.textLabel?.text = list[indexPath.row]
        cell.textLabel?.font = ViskitFont.body1.font
        cell.textLabel?.textColor = CommonAsset.viskitGray01.color
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        if cellArrowImages.indices.contains(
            indexPath.row
        ) {
            let arrowImageView = UIImageView(
                image: cellArrowImages[indexPath.row]
            )
            cell.accessoryView = arrowImageView
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let footerView = footerView,
           let heightConstraint = footerView.constraints.first(where: { $0.firstAttribute == .height })
        {
            return heightConstraint.constant
        }
        return footerView == nil ? 0 : 8
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return footerView
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch type {
        case .help:
            if let url = SettingType(rawValue: list[indexPath.row])?.url {
                UIApplication.shared.open(url)
            }
        case .account:
            switch list[indexPath.row] {
            case "프로필 수정":
                accountActionDelegate?.didTapProfileEdit()
            default:
                break
            }
        case .etc:
            if list[indexPath.row] == "로그아웃" {
                signOutDelegate?.signOut()
            } else if list[indexPath.row] == "탈퇴" {
                withDrawDelegate?.withDraw()
            }
        }
    }
}
