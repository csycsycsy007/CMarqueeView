//
//  CMarqueeView.swift
//  CMarqueeView
//
//  Created by chengshaoyu on 2025/4/25.
//

import UIKit

public class CMarqueeView: UIView {
    // MARK: - Public Properties
    public var startDelay: TimeInterval = 0.0 // 添加延时配置属性
    
    public var text: String = "" {
        didSet { updateText() }
    }
    
    public var textColor: UIColor = .black {
        didSet {                 [firstLabel, secondLabel].forEach { label in
            label.textColor = textColor
        }  }
    }
    
    public var font: UIFont = .systemFont(ofSize: 14) {
        didSet {
            [firstLabel, secondLabel].forEach { label in
                label.font = font
            }
            
            updateText()
        }
    }
    
    public var scrollSpeed: CGFloat = 40.0 // 每秒移动点数
    public var pauseInterval: TimeInterval = 2.0 // 在边缘停顿时间
    
    public var spacing: CGFloat = 80.0 // 间距
    
    // MARK: - Private Properties
    private let firstLabel = UILabel()
    private let secondLabel = UILabel()
    private var scrolling = false
    private var textWidth: CGFloat = 0
    private var displayLink: CADisplayLink?
    private var offset: CGFloat = 0
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Private Methods
    private func setupView() {
        clipsToBounds = true
        [firstLabel, secondLabel].forEach { label in
            label.numberOfLines = 1
            addSubview(label)
        }
    }
    
    private func updateText() {
        [firstLabel, secondLabel].forEach { label in
            label.text = text
            label.font = font
            label.textColor = textColor
        }
        
        let size = firstLabel.sizeThatFits(CGSize(width: .greatestFiniteMagnitude, height: bounds.height))
        textWidth = size.width
        
        // 设置初始位置
        firstLabel.frame = CGRect(x: 0, y: 0, width: textWidth, height: bounds.height)
        secondLabel.frame = CGRect(x: textWidth + spacing, y: 0, width: textWidth, height: bounds.height)
        
        if textWidth > bounds.width {
            stopScrolling()
            DispatchQueue.main.asyncAfter(deadline: .now() + startDelay) { [weak self] in
                self?.startScrolling()
            }
        } else {
            stopScrolling()
            firstLabel.frame.origin.x = 0
            secondLabel.isHidden = true
        }
    }
    
    // MARK: - Public Methods
    public func startScrolling() {
        guard !scrolling && textWidth > bounds.width else { return }
        scrolling = true
        displayLink?.invalidate()
        displayLink = CADisplayLink(target: self, selector: #selector(updateScrolling))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    public func stopScrolling() {
        scrolling = false
        displayLink?.invalidate()
        displayLink = nil
        offset = 0
        firstLabel.frame.origin.x = 0
        secondLabel.frame.origin.x = textWidth + spacing
    }
    
    @objc private func updateScrolling() {
        offset += scrollSpeed / 60.0
        let totalWidth = textWidth + spacing
        
        if offset >= totalWidth {
            offset = 0
        }

        // 平滑滚动效果
        firstLabel.frame.origin.x = -offset
        secondLabel.frame.origin.x = totalWidth - offset
    }
    
    // MARK: - Layout
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateText()
    }
    
    // MARK: - Cleanup
    deinit {
        displayLink?.invalidate()
    }
}
