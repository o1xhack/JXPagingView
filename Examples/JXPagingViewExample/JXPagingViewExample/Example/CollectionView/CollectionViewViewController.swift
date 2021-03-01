//
//  CollectionViewViewController.swift
//  JXPagingView
//
//  Created by jiaxin on 2018/10/9.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit
import JXPagingView
import JXSegmentedView

class CollectionViewViewController: UIViewController {
    
    lazy var pagingView: JXPagingView = JXPagingView(delegate: self)
    lazy var userHeaderView: ViewHeader = ViewHeader(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: CGFloat(tableHeaderViewHeight)))
//    lazy var userHeaderView: PagingViewTableHeaderView = PagingViewTableHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: CGFloat(tableHeaderViewHeight)))
    lazy var segmentedView: JXSegmentedView = JXSegmentedView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: CGFloat(headerInSectionHeight)))
    var dataSource = JXSegmentedTitleDataSource()
    var titles = ["能力", "爱好", "队友"]
    var tableHeaderViewHeight: Int = 273
    var headerInSectionHeight: Int = 50
    lazy var naviBGView: UIView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.title = "CollectionView列表示例"
        self.navigationController?.navigationBar.isTranslucent = false

        dataSource.titles = titles
        dataSource.titleSelectedColor = UIColor(red: 105/255, green: 144/255, blue: 239/255, alpha: 1)
        dataSource.titleNormalColor = UIColor.black
        dataSource.isTitleColorGradientEnabled = true
        dataSource.isTitleZoomEnabled = true

        segmentedView.backgroundColor = UIColor.white
        segmentedView.delegate = self
        segmentedView.dataSource = dataSource

        let lineView = JXSegmentedIndicatorLineView()
        lineView.indicatorColor = UIColor(red: 105/255, green: 144/255, blue: 239/255, alpha: 1)
        lineView.indicatorWidth = 30
        segmentedView.indicators = [lineView]

        let lineWidth = 1/UIScreen.main.scale
        let bottomLineView = UIView()
        bottomLineView.backgroundColor = UIColor.lightGray
        bottomLineView.frame = CGRect(x: 0, y: segmentedView.bounds.height - lineWidth, width: segmentedView.bounds.width, height: lineWidth)
        bottomLineView.autoresizingMask = .flexibleWidth
        segmentedView.addSubview(bottomLineView)

        self.view.addSubview(pagingView)

        segmentedView.listContainer = pagingView.listContainerView

        //扣边返回处理，下面的代码要加上
        pagingView.listContainerView.scrollView.panGestureRecognizer.require(toFail: self.navigationController!.interactivePopGestureRecognizer!)
        pagingView.mainTableView.panGestureRecognizer.require(toFail: self.navigationController!.interactivePopGestureRecognizer!)
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        
        self.view.backgroundColor = UIColor.white

        self.automaticallyAdjustsScrollViewInsets = false

        let topSafeMargin = UIApplication.shared.keyWindow!.jx_layoutInsets().top
        let naviHeight = UIApplication.shared.keyWindow!.jx_navigationHeight()
        //导航栏隐藏就是设置pinSectionHeaderVerticalOffset属性即可，数值越大越往下沉
        pagingView.pinSectionHeaderVerticalOffset = Int(naviHeight)

        //自定义导航栏
        naviBGView.alpha = 0
        naviBGView.backgroundColor = UIColor.white
        naviBGView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: naviHeight)
        self.view.addSubview(naviBGView)

        let navImage = UIImageView()
        navImage.image = UIImage(named: "image")
        navImage.frame = CGRect(x: self.view.bounds.size.width / 2 - 44, y: topSafeMargin, width: 44, height: 44)
        naviBGView.addSubview(navImage)

        let back = UIButton(type: .custom)
        back.setImage(UIImage(named: "image"), for: .normal)
        back.frame = CGRect(x: 12, y: topSafeMargin, width: 14, height: 14)
//        back.addTarget(self, action: #selector(naviBack), for: .touchUpInside)
        naviBGView.addSubview(back)

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        pagingView.frame = self.view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = (segmentedView.selectedIndex == 0)

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func pagingView(_ pagingView: JXPagingView, mainTableViewDidScroll scrollView: UIScrollView) {
        let thresholdDistance: CGFloat = 100
        var percent = scrollView.contentOffset.y/thresholdDistance
        percent = max(0, min(1, percent))
        naviBGView.alpha = percent
    }
    
    func preferredTableHeaderView() -> PagingViewTableHeaderView {
        return PagingViewTableHeaderView()
    }
    
    func preferredPagingView() -> JXPagingView {
        return JXPagingView(delegate: self)
    }
}

extension CollectionViewViewController: JXPagingViewDelegate {

    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        return tableHeaderViewHeight
    }

    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        return userHeaderView
    }

    func heightForPinSectionHeader(in pagingView: JXPagingView) -> Int {
        return headerInSectionHeight
    }

    func viewForPinSectionHeader(in pagingView: JXPagingView) -> UIView {
        return segmentedView
    }

    func numberOfLists(in pagingView: JXPagingView) -> Int {
        return titles.count
    }

    func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate {
        return ListCollectionViewController()
    }
}

extension CollectionViewViewController: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = (index == 0)
    }
}

