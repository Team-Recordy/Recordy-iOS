import UIKit

import Common

final class NicknameView: UIView {
  
  var textFieldCount = "0"
  
  let gradientView = RecordyGradientView()
  let nicknameText = UILabel()
  let nicknameTextField = RecordyTextField(placeholder: "EX) 레코디둥이들")
  let nextButton = RecordyButton()
  let textFieldCountLabel = UILabel()
  let errorLabel = UILabel()
  
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
    self.backgroundColor = CommonAsset.recordyBG.color
    
    nicknameText.do {
      $0.text = "당신의 첫 번째 기록,\n닉네임을 정해주세요"
      $0.font = RecordyFont.title1.font
      $0.textColor = CommonAsset.recordyGrey01.color
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
      $0.font = RecordyFont.caption2.font
      $0.textColor = CommonAsset.recordyGrey04.color
    }
    
    errorLabel.do {
      $0.text = ""
      $0.font = RecordyFont.caption2.font
      $0.textColor = CommonAsset.recordyAlert.color
    }
  }
  
  func setUI() {
    self.addSubviews(
      gradientView,
      nicknameText,
      nicknameTextField,
      nextButton,
      textFieldCountLabel,
      errorLabel
    )
  }
  
  func setAutoLayout() {
    gradientView.snp.makeConstraints {
      $0.top.horizontalEdges.equalToSuperview()
      $0.height.equalTo(400.adaptiveHeight)
    }
    
    nicknameText.snp.makeConstraints {
      $0.top.equalToSuperview().offset(165)
      $0.leading.equalToSuperview().offset(20)
    }
    
    nicknameTextField.snp.makeConstraints {
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.height.equalTo(53.adaptiveHeight)
      $0.top.equalTo(nicknameText.snp.bottom).offset(30)
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
  }
}

