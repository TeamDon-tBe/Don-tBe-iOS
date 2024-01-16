//
//  HomeViewController.swift
//  DontBe-iOS
//
//  Created by yeonsu on 1/8/24.
//

import UIKit

import SnapKit
import Combine

final class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    var tabBarHeight: CGFloat = 0
    var showUploadToastView: Bool = false
    var deleteBottomsheet = DontBeBottomSheetView(singleButtonImage: ImageLiterals.Posting.btnDelete)
    private let refreshControl = UIRefreshControl()
    var transparentPopupVC = TransparentPopupViewController()
    var deletePostPopupVC = CancelReplyPopupViewController()
    
    private var cancelBag = CancelBag()
    private let viewModel: HomeViewModel
    
    // MARK: - UI Components
    
    private let myView = HomeView()
    private lazy var homeCollectionView = HomeCollectionView().collectionView
    private var uploadToastView: DontBeToastView?
    
    // MARK: - Life Cycles
    
    override func loadView() {
        super.loadView()
        
        view = myView
    }
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setHierarchy()
        setLayout()
        setDelegate()
        setNotification()
        setRefreshControll()
        setAddTarget()
        bindViewModel()
    }
    
    // MARK: - TabBar Height
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tabBarHeight = tabBarController?.tabBar.frame.size.height ?? 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
}

// MARK: - Extensions

extension HomeViewController {
    private func setUI() {
        self.view.backgroundColor = UIColor.donGray1
        transparentPopupVC.modalPresentationStyle = .overFullScreen
        deletePostPopupVC.modalPresentationStyle = .overFullScreen
    }
    
    private func setHierarchy() {
        view.addSubviews(homeCollectionView)
    }
    
    private func setLayout() {
        homeCollectionView.snp.makeConstraints {
            $0.top.equalTo(myView.safeAreaLayoutGuide.snp.top).offset(52.adjusted)
            $0.bottom.equalTo(tabBarHeight.adjusted)
            $0.width.equalToSuperview()
        }
    }
    
    private func setAddTarget() {
        deleteBottomsheet.deleteButton.addTarget(self, action: #selector(deletePost), for: .touchUpInside)
    }
    
    @objc
    func deletePost() {
        popView()
        presentView()
    }
    
    func popView() {
        if UIApplication.shared.keyWindowInConnectedScenes != nil {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.deleteBottomsheet.dimView.alpha = 0
                if let window = UIApplication.shared.keyWindowInConnectedScenes {
                    self.deleteBottomsheet.bottomsheetView.frame = CGRect(x: 0, y: window.frame.height, width: self.deleteBottomsheet.frame.width, height: self.deleteBottomsheet.bottomsheetView.frame.height)
                }
            })
            deleteBottomsheet.dimView.removeFromSuperview()
            deleteBottomsheet.bottomsheetView.removeFromSuperview()
        }
    }
    
    func presentView() {
        self.present(self.deletePostPopupVC, animated: false, completion: nil)
    }
    
    @objc
    private func dismissViewController() {
        self.dismiss(animated: false)
    }
    
    private func setDelegate() {
        homeCollectionView.dataSource = self
        homeCollectionView.delegate = self
    }
    
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(showToast(_:)), name: WriteViewController.showWriteToastNotification, object: nil)
    }
    
    private func setRefreshControll() {
        refreshControl.addTarget(self, action: #selector(refreshPost), for: .valueChanged)
        homeCollectionView.refreshControl = refreshControl
        refreshControl.backgroundColor = .donGray1
    }
    
    @objc
    func refreshPost() {
        DispatchQueue.main.async {
            self.bindViewModel()
        }
        self.homeCollectionView.reloadData()
        self.perform(#selector(self.finishedRefreshing), with: nil, afterDelay: 0.1)
    }
    
    @objc
    func finishedRefreshing() {
        refreshControl.endRefreshing()
    }
    
    @objc func showToast(_ notification: Notification) {
        if let showToast = notification.userInfo?["showToast"] as? Bool {
            if showToast == true {
                DispatchQueue.main.async {
                    self.uploadToastView = DontBeToastView()
                    
                    self.view.addSubviews(self.uploadToastView ?? DontBeToastView())
                    
                    self.uploadToastView?.snp.makeConstraints {
                        $0.leading.trailing.equalToSuperview().inset(16.adjusted)
                        $0.bottom.equalTo(self.tabBarHeight.adjusted).inset(6.adjusted)
                        $0.height.equalTo(44)
                    }
                    
                    var value: Double = 0.0
                    let duration: TimeInterval = 1.0 // 애니메이션 기간 (초 단위)
                    let increment: Double = 0.01 // 증가량
                    
                    // 0에서 1까지 1초 동안 0.01씩 증가하는 애니메이션 블록
                    UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: {
                        for i in 1...100 {
                            DispatchQueue.main.asyncAfter(deadline: .now() + (duration / 100) * TimeInterval(i)) {
                                value = Double(i) * increment
                                self.uploadToastView?.circleProgressBar.value = value
                            }
                        }
                    })
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.uploadToastView?.circleProgressBar.alpha = 0
                        self.uploadToastView?.checkImageView.alpha = 1
                        self.uploadToastView?.toastLabel.text = StringLiterals.Toast.uploaded
                        self.uploadToastView?.container.backgroundColor = .donPrimary
                    }
                    
                    UIView.animate(withDuration: 1.0, delay: 3, options: .curveEaseIn) {
                        self.uploadToastView?.alpha = 0
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                        self.uploadToastView?.circleProgressBar.alpha = 1
                        self.uploadToastView?.checkImageView.alpha = 0
                        self.uploadToastView?.toastLabel.text = StringLiterals.Toast.uploading
                        self.uploadToastView?.container.backgroundColor = .donGray3
                    }
                }
            }
        }
    }
}

// MARK: - Network

extension HomeViewController {
    private func bindViewModel() {
        let input = HomeViewModel.Input(viewUpdate: Just(()).eraseToAnyPublisher())
        
        let output = viewModel.transform(from: input, cancelBag: cancelBag)
        
        output.getData
            .receive(on: RunLoop.main)
            .sink { _ in
                self.homeCollectionView.reloadData()
            }
            .store(in: self.cancelBag)
    }
}

extension HomeViewController: UICollectionViewDelegate { }

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sortedData = viewModel.postData.sorted {
                $0.time.compare($1.time, options: .numeric) == .orderedDescending
            }
            
            // Replace the viewModel.postData array with the sortedData
            viewModel.postData = sortedData
        
        return viewModel.postData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =
        HomeCollectionViewCell.dequeueReusableCell(collectionView: collectionView, indexPath: indexPath)
        cell.KebabButtonAction = {
            self.deleteBottomsheet.showSettings()
        }
        cell.LikeButtonAction = {
            cell.isLiked.toggle()
            cell.likeButton.setImage(cell.isLiked ? ImageLiterals.Posting.btnFavoriteActive : ImageLiterals.Posting.btnFavoriteInActive, for: .normal)
        }
        cell.TransparentButtonAction = {
            // present
            self.present(self.transparentPopupVC, animated: false, completion: nil)
        }
        cell.nicknameLabel.text = viewModel.postData[indexPath.row].memberNickname
        cell.transparentLabel.text = "투명도 \(viewModel.postData[indexPath.row].memberGhost)%"
        cell.contentTextLabel.text = viewModel.postData[indexPath.row].contentText
        cell.likeNumLabel.text = "\(viewModel.postData[indexPath.row].likedNumber)"
        cell.commentNumLabel.text = "\(viewModel.postData[indexPath.row].commentNumber)"
        cell.timeLabel.text = "\(viewModel.postData[indexPath.row].formatTime)"
        cell.profileImageView.load(url: "\(viewModel.postData[indexPath.row].memberProfileUrl)")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destinationViewController = PostViewController()
        self.navigationController?.pushViewController(destinationViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let footer = homeCollectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "HomeCollectionFooterView", for: indexPath) as? HomeCollectionFooterView else { return UICollectionReusableView() }
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        return CGSize(width: UIScreen.main.bounds.width, height: 24.adjusted)
    }
}
