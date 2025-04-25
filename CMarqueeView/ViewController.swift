//
//  ViewController.swift
//  CMarqueeView
//
//  Created by chengshaoyu on 2025/4/25.
//

import UIKit

class ViewController: UIViewController {

    private let marqueeView = CMarqueeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置跑马灯视图
        marqueeView.frame = CGRect(x: 20, y: 100, width: view.bounds.width - 40, height: 30)
        marqueeView.startDelay = 2
        marqueeView.text = "这是一个跑马灯效果的文本示例而且文本要足够长足够长才能跑起来..."
        marqueeView.textColor = .blue
        marqueeView.font = .systemFont(ofSize: 16)
        
        view.addSubview(marqueeView)
    }


}

