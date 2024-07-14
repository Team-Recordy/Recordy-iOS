import UIKit
import SnapKit
import Then

protocol RecordyProgressViewDelegate: AnyObject {
  func didUpdatePage(currentPage: Int, totalPages: Int)
}

public final class RecordyProgressView: UIView {
  
  weak var delegate: RecordyProgressViewDelegate?
  private var totalPages: Int = 0
  private var currentPage: Int = 0
  
  var ratio: CGFloat = 0.0 {
    didSet {
      self.isHidden = !self.ratio.isLess(than: 1.0)
      
      self.progressBarView.snp.remakeConstraints {
        $0.leading.equalToSuperview()
        $0.top.equalToSuperview().offset(-1)
        $0.bottom.equalToSuperview().offset(1)
        $0.width.equalToSuperview().multipliedBy(self.ratio)
      }
      
      UIView.animate(
        withDuration: 0.5,
        delay: 0,
        options: .curveEaseInOut,
        animations: {
          self.layoutIfNeeded()
        },
        completion: nil
      )
    }
  }
  
  let progressBarView = UIView().then {
    $0.backgroundColor = CommonAsset.recordyMain.color
  }
  
  public override init(frame: CGRect = .zero) {
    super.init(frame: frame)
    setStyle()
    setUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setStyle() {
    self.isUserInteractionEnabled = false
    self.backgroundColor = CommonAsset.recordySub01.color
    self.layer.cornerRadius = 4
    self.clipsToBounds = true
    progressBarView.layer.cornerRadius = 6
    progressBarView.clipsToBounds = true
  }
  
  func setUI() {
    self.addSubview(progressBarView)
  }
  
  public func updateProgress(currentPage: Int, totalPages: Int) {
    let newRatio = CGFloat(currentPage + 1) / CGFloat(totalPages)
    self.ratio = newRatio
  }
}
