//
//  PostViewController.swift
//  DontBe-iOS
//
//  Created by yeonsu on 1/12/24.
//

import UIKit

final class PostViewController: UIViewController {
    
    // MARK: - Properties
    var tabBarHeight: CGFloat = 0
    
    // MARK: - UI Components
    
    private lazy var myView = PostDetailView()
    private lazy var postView = PostView()
    private lazy var postReplyCollectionView = PostReplyCollectionView().collectionView
    
    private let verticalBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .donGray3
        return view
    }()
    
    // MARK: - Life Cycles
    
    override func loadView() {
        super.loadView()
        
        view = myView
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAPI()
        setUI()
        setHierarchy()
        setLayout()
        setDelegate()
    }
    
    // MARK: - TabBar Height
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tabBarHeight = tabBarController?.tabBar.frame.size.height ?? 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.donBlack]
        
        let backButton = UIBarButtonItem.backButton(target: self, action: #selector(backButtonPressed))
        self.navigationItem.leftBarButtonItem = backButton
    }
}

// MARK: - Extensions

extension PostViewController {
    private func setUI() {
        self.navigationItem.title = StringLiterals.Post.navigationTitleLabel
    }
    
    private func setHierarchy() {
        view.addSubviews(postView,
                         verticalBarView,
                         postReplyCollectionView)
    }
    
    private func setLayout() {
        postView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        postReplyCollectionView.snp.makeConstraints {
            $0.top.equalTo(postView.PostbackgroundUIView.snp.bottom).offset(10.adjusted)
            $0.bottom.equalTo(tabBarHeight)
            $0.leading.equalTo(verticalBarView.snp.trailing)
            $0.trailing.equalToSuperview().inset(16.adjusted)
        }
        
        verticalBarView.snp.makeConstraints {
            $0.top.equalTo(postView.horizontalDivierView.snp.bottom)
            $0.leading.equalToSuperview().inset(18.adjusted)
            $0.width.equalTo(1.adjusted)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func setDelegate() {
        postReplyCollectionView.dataSource = self
        postReplyCollectionView.delegate = self
    }
    
    @objc
    private func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Network

extension PostViewController {
    private func getAPI() {
        
    }
}

extension PostViewController: UICollectionViewDelegate { }

extension PostViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =
        PostReplyCollectionViewCell.dequeueReusableCell(collectionView: collectionView, indexPath: indexPath)
        
        return cell
    }
}
