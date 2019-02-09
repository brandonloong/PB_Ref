//
//  CustomButton1.swift
//  Skeletal-Storyboard
//
//  Created by Sean Allen on 6/29/18.
//  Copyright © 2018 Sean Allen. All rights reserved.
//

//import Foundation
import UIKit
let cornerScale: CGFloat = 6.0

// Navigation buttons
class CustomButton1: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    private func setupButton() {
        setTitleColor(Colors.darkGrey, for: .normal)
        backgroundColor     = Colors.lightGrey
        titleLabel?.font    = UIFont(name: Fonts.avenir, size: 20)
        layer.cornerRadius  = frame.size.height/cornerScale
		layer.borderWidth	= 1
		
    }
}
// Action buttons
class CustomButton2: UIButton {
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupButton()
	}
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setupButton()
	}
	private func setupButton() {
		setTitleColor(Colors.darkGrey, for: .normal)
		backgroundColor     = Colors.lightGrey
		titleLabel?.font    = UIFont(name: Fonts.avenir, size: 15)
		layer.cornerRadius  = frame.size.height/cornerScale
		layer.borderWidth	= 0.5
	}
}
// Action buttons
class CustomButton3: UIButton {
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupButton()
	}
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setupButton()
	}
	private func setupButton() {
		setTitleColor(Colors.darkGrey, for: .normal)
		backgroundColor     = Colors.lightGrey
		titleLabel?.font    = UIFont(name: Fonts.avenir, size: 15)
		layer.cornerRadius  = frame.size.width/cornerScale
		layer.borderWidth	= 0.5
	}
}
