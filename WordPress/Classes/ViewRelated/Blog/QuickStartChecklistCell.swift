import Gridicons

class QuickStartChecklistCell: UITableViewCell {
    @IBOutlet private var titleLabel: UILabel! {
        didSet {
            WPStyleGuide.configureLabel(titleLabel, textStyle: .headline)
        }
    }
    @IBOutlet private var descriptionLabel: UILabel! {
        didSet {
            WPStyleGuide.configureLabel(descriptionLabel, textStyle: .subheadline)
        }
    }
    @IBOutlet private var iconView: UIImageView?
    @IBOutlet private var stroke: UIView?
    @IBOutlet private var topSeparator: UIView?

    private var bottomStrokeLeading: NSLayoutConstraint?
    private var contentViewLeadingAnchor: NSLayoutXAxisAnchor {
        return WPDeviceIdentification.isiPhone() ? contentView.leadingAnchor : contentView.readableContentGuide.leadingAnchor
    }
    private var contentViewTrailingAnchor: NSLayoutXAxisAnchor {
        return WPDeviceIdentification.isiPhone() ? contentView.trailingAnchor : contentView.readableContentGuide.trailingAnchor
    }

    public var completed = false {
        didSet {
            if completed {
                guard let titleText = tour?.title else {
                    return
                }

                if Feature.enabled(.quickStartV2) {
                    titleLabel.attributedText = NSAttributedString(string: titleText,
                                                                   attributes: [.strikethroughStyle: 1,
                                                                                .foregroundColor: WPStyleGuide.grey()])
                    descriptionLabel.textColor = WPStyleGuide.grey()
                } else {
                    titleLabel.attributedText = NSAttributedString(string: titleText, attributes: [.strikethroughStyle: 1])
                    accessoryView = UIImageView(image: Gridicon.iconOfType(.checkmark))
                }
            } else {
                if Feature.enabled(.quickStartV2) {
                    titleLabel.textColor = WPStyleGuide.darkGrey()
                    descriptionLabel.textColor = WPStyleGuide.darkGrey()
                } else {
                    accessoryView = nil
                }
            }
        }
    }
    public var tour: QuickStartTour? {
        didSet {
            titleLabel.text = tour?.title
            descriptionLabel.text = tour?.description
            iconView?.image = tour?.icon.imageWithTintColor(WPStyleGuide.greyLighten10())

            if !Feature.enabled(.quickStartV2) {
                accessoryType = .disclosureIndicator
            }
        }
    }

    public var lastRow: Bool = false {
        didSet {
            bottomStrokeLeading?.isActive = !lastRow && Feature.enabled(.quickStartV2)
        }
    }

    public var topSeparatorIsHidden: Bool = false {
        didSet {
            topSeparator?.isHidden = topSeparatorIsHidden
        }
    }


    override func awakeFromNib() {
        super.awakeFromNib()

        if Feature.enabled(.quickStartV2) {
            setupConstraints()
        }
    }

    static let reuseIdentifier = "QuickStartChecklistCell"
}

private extension QuickStartChecklistCell {
    func setupConstraints() {
        guard let stroke = stroke,
            let topSeparator = topSeparator else {
            return
        }

        bottomStrokeLeading = stroke.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor)
        bottomStrokeLeading?.isActive = true
        let strokeSuperviewLeading = stroke.leadingAnchor.constraint(equalTo: contentViewLeadingAnchor)
        strokeSuperviewLeading.priority = UILayoutPriority(999.0)
        strokeSuperviewLeading.isActive = true
        stroke.trailingAnchor.constraint(equalTo: contentViewTrailingAnchor).isActive = true
        topSeparator.leadingAnchor.constraint(equalTo: contentViewLeadingAnchor).isActive = true
        topSeparator.trailingAnchor.constraint(equalTo: contentViewTrailingAnchor).isActive = true
    }
}
