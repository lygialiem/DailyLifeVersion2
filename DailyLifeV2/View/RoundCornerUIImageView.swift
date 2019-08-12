import UIKit

class RoundCornerUIImageView: UIImageView{

  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.clipsToBounds = true
    self.layer.cornerRadius = 15
  }
}
