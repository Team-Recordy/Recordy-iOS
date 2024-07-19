import UIKit

import Common

final class NicknameView: UIView {
  
  var textFieldCount = "0"
  
  let nicknameText = UILabel()
  let nicknameTextField = RecordyTextField(placeholder: "EX) 레코디둥이들")
  let nextButton = RecordyButton()
  let textFieldCountLabel = UILabel()
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setStyle()
    setUI()
    setAutoLayout()
    setupTextFieldObserver()
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self, name: UITextField.textDidChangeNotification, object: nicknameTextField)
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
    }
    
    nextButton.do {
      $0.setTitle("다음", for: .normal)
      $0.buttonState = .inactive
    }
    
    textFieldCountLabel.do {
      $0.text = ""
      $0.font = RecordyFont.caption2.font
      $0.textColor = CommonAsset.recordyGrey04.color
    }
    
    nicknameTextField.stateDelegate = self
  }
  
  func setUI() {
    self.addSubviews(
      nicknameText,
      nicknameTextField,
      nextButton,
      textFieldCountLabel
    )
  }
  
  func setAutoLayout() {
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
  }
  
  @objc func textFieldDidChange(_ sender: Any?) {
    let textCount = nicknameTextField.text?.count ?? 0
    textFieldCountLabel.text = "\(textCount) / 10"
    validateTextField()
  }
  
  func setupTextFieldObserver() {
    NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange), name: UITextField.textDidChangeNotification, object: nicknameTextField)
  }
  
  private func validateTextField() {
    guard let text = nicknameTextField.text else {
      state(.error)
      return
    }
    let pattern = "^[가-힣a-zA-Z0-9._]{1,10}$"
    let regex = try! NSRegularExpression(pattern: pattern)
    let matches = regex.matches(in: text, range: NSRange(location: 0, length: text.utf16.count))
    state(matches.count > 0 && text.count <= 10 ? .selected : .error)
  }
}

extension NicknameView: RecordyTextFieldStateDelegate {
  func state(_ currentState: Common.RecordyTextFieldState) {
    nicknameTextField.layer.borderColor = currentState.borderColor.cgColor
    nicknameTextField.layer.borderWidth = currentState.borderWidth
    
    switch currentState {
    case .unselected, .error:
      nextButton.buttonState = .inactive
    case .selected:
      nextButton.buttonState = .active
    }
  }
}
