//
//  MyPageContentViewController.swift
//  DontBe-iOS
//
//  Created by 변상우 on 1/11/24.
//

import Combine
import UIKit

import SnapKit

final class MyPageContentViewController: UIViewController {
    
    // MARK: - Properties
    
    var showUploadToastView: Bool = false
    var deleteBottomsheet = DontBeBottomSheetView(singleButtonImage: ImageLiterals.Posting.btnDelete)
    private let refreshControl = UIRefreshControl()
    
    private var cancelBag = CancelBag()
    let viewModel: MyPageViewModel
    
    // MARK: - UI Components
    
    lazy var homeCollectionView = HomeCollectionView().collectionView
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAPI()
        setUI()
        setHierarchy()
        setLayout()
        setDelegate()
        setRefreshControll()
    }
    
    init(viewModel: MyPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        bindViewModel()
    }
}

// MARK: - Extensions

extension MyPageContentViewController {
    private func setUI() {
        self.view.backgroundColor = UIColor.donGray1
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setHierarchy() {
        view.addSubviews(homeCollectionView)
    }
    
    private func setLayout() {
        homeCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }
    
    private func setDelegate() {
        homeCollectionView.dataSource = self
        homeCollectionView.delegate = self
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
    
    private func bindViewModel() {
        let input = MyPageViewModel.Input(viewUpdate: Just((2)).eraseToAnyPublisher())
        
        let output = viewModel.transform(from: input, cancelBag: cancelBag)
        
        output.getContentData
            .receive(on: RunLoop.main)
            .sink { _ in
                self.homeCollectionView.reloadData()
            }
            .store(in: self.cancelBag)
    }
    
}

// MARK: - Network

extension MyPageContentViewController {
    private func getAPI() {
        
    }
}

extension MyPageContentViewController: UICollectionViewDelegate { }

extension MyPageContentViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sortedData = viewModel.myPageContentData.sorted { $0.time.compare($1.time, options: .numeric) == .orderedDescending }
        
        viewModel.myPageContentData = sortedData
        return viewModel.myPageContentData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =
        HomeCollectionViewCell.dequeueReusableCell(collectionView: collectionView, indexPath: indexPath)
        cell.nicknameLabel.text = viewModel.myPageContentData[indexPath.row].memberNickname
        cell.transparentLabel.text = "투명도 \(viewModel.myPageContentData[indexPath.row].memberGhost)%"
        cell.timeLabel.text = "\(viewModel.myPageContentData[indexPath.row].time.formattedTime())"
        cell.contentTextLabel.text = viewModel.myPageContentData[indexPath.row].contentText
        cell.likeNumLabel.text = "\(viewModel.myPageContentData[indexPath.row].likedNumber)"
        cell.commentNumLabel.text = "\(viewModel.myPageContentData[indexPath.row].commentNumber)"
        cell.profileImageView.load(url: "\(viewModel.myPageContentData[indexPath.row].memberProfileUrl)")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destinationViewController = PostViewController()
        self.navigationController?.pushViewController(destinationViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 343.adjusted, height: 210.adjusted)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let footer = homeCollectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "HomeCollectionFooterView", for: indexPath) as? HomeCollectionFooterView else { return UICollectionReusableView() }
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        return CGSize(width: UIScreen.main.bounds.width, height: 24.adjusted)
    }
}

extension MyPageContentViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        if yOffset > 0 {
            scrollView.isScrollEnabled = true
        } else if yOffset < 0 {
            scrollView.isScrollEnabled = false
        }
    }
}

extension MyPageContentViewController: DontBePopupDelegate {
    func cancleButtonTapped() {
//        transparentButtonPopupView.alpha = 0
    }
    
    func confirmButtonTapped() {
//        transparentButtonPopupView.alpha = 0
        // ✅ 투명도 주기 버튼 클릭 시 액션 추가
    }
}
