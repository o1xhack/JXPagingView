//
//  ViewHeader.swift
//  JXPagingViewExample
//
//  Created by wyx on 2021/2/26.
//  Copyright © 2021 jiaxin. All rights reserved.
//

import UIKit

class ViewHeader: UIView {

    @IBOutlet var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder)  {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame.size.width = self.frame.size.width
        contentView.frame.size.height = self.frame.size.height
    }
    
}
