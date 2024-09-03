import UIKit
import SnapKit
import Then

public enum MediumState {
  case active
  case inactive
}

public class MediumButton: UIButton {
  
  public var mediumState: MediumState = .active {
    didSet {
      mediumButtonAppearance()
    }
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setUI() {
    layer.cornerRadius = 8
    titleLabel?.font = RecordyFont.button2.font
    mediumButtonAppearance()
  }
  
  private func mediumButtonAppearance() {
    switch mediumState {
    case .active:
      backgroundColor = CommonAsset.recordyGrey08.color
      setTitleColor(CommonAsset.recordyGrey01.color, for: .normal)
      setTitle("팔로잉", for: .normal)
    case .inactive:
      backgroundColor = CommonAsset.recordyWhite.color
      setTitleColor(CommonAsset.recordyGrey09.color, for: .normal)
      setTitle("팔로우", for: .normal)
    }
  }
}
