import UIKit
import SnapKit
import Then

public class TestViewController: UIViewController {
  
  let views: [UIView] = (0..<8).map { _ in UIView() }
  let labels: [UILabel] = (0..<8).map { _ in UILabel() }
  let titles = ["Title 1", "Title 2", "Title 3", "Title 4", "Title 5", "Title 6", "Title 7", "Title 8"]
  let fonts: [UIFont] = [
    RecordyFont.body1.font,
    RecordyFont.body1Regular.font,
    RecordyFont.body2.font,
    RecordyFont.button1.font,
    RecordyFont.caption1Underline.font,
    RecordyFont.number1.font,
    RecordyFont.keyword1.font,
    RecordyFont.subtitle.font,
  ]
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    setUI()
    setLayout()
    checkFont()
  }
  
  func setUI() {
    for (index, view) in views.enumerated() {
      view.layer.cornerRadius = 10
      view.clipsToBounds = true
      
      labels[index].text = titles[index]
      labels[index].font = fonts[index]
      labels[index].textColor = .black
      labels[index].textAlignment = .center
      
      view.addSubview(labels[index])
      view.addSubview(labels[index])
      view.layer.cornerRadius = 10
      view.clipsToBounds = true
      labels[index].textAlignment = .center
      
      view.addSubview(labels[index])
      view.layer.cornerRadius = 10
      view.clipsToBounds = true
      labels[index].textAlignment = .center
    }
    
    views.forEach {
      view.addSubview($0)
    }
  }
  
  func setLayout() {
    views.forEach { view in
      view.snp.makeConstraints { make in
        make.leading.trailing.equalToSuperview().inset(20)
        make.height.equalTo(50)
      }
    }
    
    for (index, view) in views.enumerated() {
      if index == 0 {
        view.snp.makeConstraints { make in
          make.top.equalToSuperview().offset(100)
        }
      } else {
        view.snp.makeConstraints { make in
          make.top.equalTo(views[index - 1].snp.bottom).offset(10)
        }
      }
      
      labels[index].snp.makeConstraints { make in
        make.edges.equalToSuperview().inset(5)
      }
    }
  }
  
  func checkFont() {
    for family in UIFont.familyNames {
      print("🍏",family)
      for name in UIFont.fontNames(forFamilyName: family) {
        print(name)
      }
    }
  }
}
