//
//  PlayingCardView.swift
//  poker
//
//  Created by artur on 05.04.2018.
//  Copyright © 2018 artur. All rights reserved.
//

import UIKit

@IBDesignable //показывает в майне вид карты в реальном времени, но не работает с изображениями

class PlayingCardView: UIView {
    
    @IBInspectable //даёт возможность отображать эти вары как атрибуты в правом окне настроек
    var rank: Int = 5 { didSet {setNeedsDisplay(); setNeedsLayout()} } //эти два метода заставляют перерисовать карту если изменяется её значение с 5 на 10 например
    @IBInspectable
    var suit: String = "♦" { didSet {setNeedsDisplay(); setNeedsLayout()} }
    @IBInspectable
    var isFaceUp: Bool = true { didSet {setNeedsDisplay(); setNeedsLayout()} }
    
    //MARK: func for Label
    
    private func centeredAttributedString (_ string: String, fontSize: CGFloat) -> NSAttributedString {
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        font = UIFontMetrics(forTextStyle: .body ).scaledFont(for: font) //даёт нашему шрифту возможность увеличиваться по требованиям в настройках
        let paragraphStyle = NSMutableParagraphStyle() //класс для возможности размещения текста с атрибутами
        paragraphStyle.alignment = .center //ставит текст по центру
        return NSAttributedString(string: string, attributes: [NSAttributedStringKey.paragraphStyle: paragraphStyle, .font: font])
    }
    
    private var cornerString: NSAttributedString {
        return centeredAttributedString(rankString+"\n"+suit, fontSize: cornerFontSize) //значение 0.0 позволяет маштабировать размер шрифта в соответствии с размером нашей карты
    }
    
    private func configureCenterLabel(_ label: UILabel) {
        label.attributedText = cornerString
        label.frame.size = CGSize.zero //значение 0 позволяет изменять размер в любом направлении, уходя от заранее заданных стандартных
        label.sizeToFit() //метод который делает размеры лэйбы по размеру текста внутри
        label.isHidden = !isFaceUp //значение лэйбы скрывается при значении карты лицом вниз !isFaceUp
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) { //функция которая перерисовывает все наши элементы в случае изменения настроек
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    //MARK: Label create
    
    private lazy var centerLabel = createCenterLabel()
    
    private func createCenterLabel() -> UILabel { //функция которая создаёт лэйбу для нашей карты
        let label = UILabel()
        label.numberOfLines = 0 //значение 0 - означает что будет столько строк, сколько нам надо
        addSubview(label)
        return label
    }
    
    //MARK: Other
    
    override func layoutSubviews() { //метод который позволяет перерисовывать лейбы, если что-либо изменяется
        super.layoutSubviews() //обязательно знать путь к главному вью
        configureCenterLabel(centerLabel)
        centerLabel.frame.origin.x = bounds.midX - centerLabel.frame.width/2
        centerLabel.frame.origin.y = bounds.midY - centerLabel.frame.height/2
    }
    
    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()
        /* if isFaceUp {
         if let faceCardImage = UIImage(named: rankString + suit, in: Bundle(for: self.classForCoder), compatibleWith: traitCollection) {
         faceCardImage.draw(in: bounds.zoom(by: faceCardScale))
         }  else {
         drawPips()
         }
         } else {
         if let cardBackImage = UIImage(named: "cardBack") {
         cardBackImage.draw(in: bounds)
         }
         } */
    }
}

//MARK: Extension

extension PlayingCardView {
    private struct SizeRatio {
        static let cornerFontSizeToBoundsHeight: CGFloat = 0.4
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let cornerOffsetToCornerRadius: CGFloat = 0.33
        static let faceCardImageSizeToBoundsSize: CGFloat = 0.75
    }
    private var cornerRadius: CGFloat {
        return bounds.size.height*SizeRatio.cornerRadiusToBoundsHeight
    }
    private var cornerOffset: CGFloat {
        return cornerRadius*SizeRatio.cornerOffsetToCornerRadius
    }
    private var cornerFontSize: CGFloat {
        return bounds.size.height*SizeRatio.cornerFontSizeToBoundsHeight
    }
    private var rankString: String {
        switch rank {
        case 1 : return "A"
        case 2...10: return String(rank)
        case 11 : return "J"
        case 12 : return "Q"
        case 13 : return "K"
        default : return "?"
        }
    }
}

extension CGRect {
    func zoom(by zoomFactor: CGFloat) -> CGRect {
        let zoomedWidth = size.width * zoomFactor
        let zoomedHeight = size.height * zoomFactor
        let originX = origin.x + (size.width - zoomedWidth) / 2
        let originY = origin.y + (size.height - zoomedHeight) / 2
        return CGRect(origin: CGPoint(x: originX,y: originY) , size: CGSize(width: zoomedWidth, height: zoomedHeight))
    }
    var leftHalf: CGRect {
        let width = size.width / 2
        return CGRect(origin: origin, size: CGSize(width: width, height: size.height))
    }
    var rightHalf: CGRect {
        let width = size.width / 2
        return CGRect(origin: CGPoint(x: origin.x + width, y: origin.y), size: CGSize(width: width, height: size.height))
    }
}

extension CGPoint {
    func offsetBy(dx:CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x+dx, y: y+dy)
    }
}
