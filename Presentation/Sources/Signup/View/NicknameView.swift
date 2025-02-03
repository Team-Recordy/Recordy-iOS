import UIKit

import SnapKit
import Then

import Common

final class NicknameView: UIView {
  
  var textFieldCount = "0"

  let nicknameText = UILabel()
  let nicknameTextField = RecordyTextField(placeholder: "닉네임 (한글, 숫자, 밑줄 및 마침표만 사용 가능)")
  let nextButton = RecordyButton()
  let textFieldCountLabel = UILabel()
  let errorLabel = UILabel()
  private let indicatorImage = UIImageView()
  
  var onTextChange: ((String) -> Void)?
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setStyle()
    setUI()
    setAutoLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setStyle() {
    backgroundColor = CommonAsset.viskitBG.color
    
    nicknameText.do {
      $0.text = "비스킷에서 사용할\n닉네임을 작성해 주세요."
      $0.font = ViskitFont.title1.font
      $0.textColor = CommonAsset.viskitGray01.color
      $0.numberOfLines = 0
      $0.textAlignment = .right
      $0.setLineSpacing(lineHeightMultiple: 1.3)
    }
    
    nextButton.do {
      $0.setTitle("다음", for: .normal)
      $0.buttonState = .inactive
    }
    
    textFieldCountLabel.do {
      $0.text = "0 / 10"
      $0.font = ViskitFont.caption2Medium.font
      $0.textColor = CommonAsset.viskitGray02.color
    }
    
    errorLabel.do {
      $0.text = ""
      $0.font = ViskitFont.caption2Medium.font
      $0.textColor = CommonAsset.viskitAlert01.color
    }
    
    indicatorImage.do {
      $0.image = CommonAsset.secondIndicator.image
    }
  }
  
  func setUI() {
    addSubviews(
      nicknameText,
      nicknameTextField,
      nextButton,
      textFieldCountLabel,
      errorLabel,
      indicatorImage
    )
  }
  
  func setAutoLayout() {
    
    nicknameText.snp.makeConstraints {
      $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(54)
      $0.leading.equalToSuperview().offset(20)
    }
    
    nicknameTextField.snp.makeConstraints {
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.height.equalTo(53.adaptiveHeight)
      $0.top.equalTo(nicknameText.snp.bottom).offset(24)
    }
    
    nextButton.snp.makeConstraints {
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.bottom.equalTo(safeAreaLayoutGuide).inset(14)
      $0.height.equalTo(54.adaptiveHeight)
    }
    
    textFieldCountLabel.snp.makeConstraints {
      $0.top.equalTo(nicknameTextField.snp.bottom).offset(8)
      $0.trailing.equalTo(nicknameTextField.snp.trailing)
    }
    
    errorLabel.snp.makeConstraints {
      $0.top.equalTo(nicknameTextField.snp.bottom).offset(8)
      $0.leading.equalToSuperview().offset(20)
    }
    
    indicatorImage.snp.makeConstraints {
      $0.horizontalEdges.equalToSuperview()
      $0.bottom.equalTo(nextButton.snp.top).offset(-14)
      $0.height.equalTo(26.adaptiveHeight)
    }
  }
  
  public func updateUI(state: RecordyTextFieldState) {
    switch state {
    case .unselected:
      errorLabel.text = ""
      
    case .valid:
      errorLabel.text = "ⓘ 사용 가능한 닉네임이에요!"
      errorLabel.textColor = CommonAsset.viskitYellow80.color
      
    case .selected:
      errorLabel.text = ""
      
    case .duplicated:
      errorLabel.text = "ⓘ 이미 사용 중인 닉네임이에요."
      errorLabel.textColor = CommonAsset.viskitAlert01.color
      
    case .invalidPattern:
      errorLabel.text = "ⓘ 한글, 숫자, 밑줄 및 마침표만 사용할 수 있어요."
      errorLabel.textColor = CommonAsset.viskitAlert01.color
      
    case .error:
      errorLabel.text = "ⓘ 닉네임 검증 중 오류가 발생했어요."
      errorLabel.textColor = CommonAsset.viskitAlert01.color
    }
  }
}

