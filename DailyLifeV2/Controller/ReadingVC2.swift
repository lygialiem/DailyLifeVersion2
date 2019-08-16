
import UIKit
import SDWebImage
import SafariServices

class ReadingVC2: UIViewController{
  
  @IBOutlet var readingCollectionView: UICollectionView!
  
  var articles = [Article]()
  var indexPathOfDidSelectedArticle: IndexPath?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupReadingCollectionView()

  }
  
  func setupReadingCollectionView(){
    readingCollectionView.delegate = self
    readingCollectionView.dataSource = self
    readingCollectionView.isPagingEnabled = true
    readingCollectionView.scrollToItem(at: indexPathOfDidSelectedArticle!
      , at: .centeredHorizontally, animated: false)
  }
}

extension ReadingVC2: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return articles.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let readingCell = collectionView.dequeueReusableCell(withReuseIdentifier: "readingCell", for: indexPath) as! ReadingCell
    readingCell.delegate = self
    readingCell.configureContent(article: self.articles[indexPath.row])
   return readingCell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: self.view.frame.width, height: self.view.frame.height - 113)
  }
}

extension ReadingVC2: ReadingCellDelegate{
  func didPressSeeMore(url: String) {
    
    let webViewViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebViewVC") as! WebViewController
    webViewViewController.urlOfContent = url
    navigationController?.pushViewController(webViewViewController, animated: true)
  }
}
