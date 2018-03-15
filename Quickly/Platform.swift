//
//  Quickly
//

#if os(macOS)

    public typealias QPlatformLineBreakMode = NSParagraphStyle.LineBreakMode

    public typealias QPlatformColor = NSColor
    public typealias QPlatformFont = NSFont
    public typealias QPlatformEdgeInsets = NSEdgeInsets

    public typealias QPlatformLayoutAttribute = NSLayoutConstraint.Attribute
    public typealias QPlatformLayoutRelation = NSLayoutConstraint.Relation
    public typealias QPlatformLayoutPriority = NSLayoutConstraint.Priority

    public typealias QPlatformWindow = NSWindow
    public typealias QPlatformView = NSView
    public typealias QPlatformControl = NSControl
    public typealias QPlatformViewController = NSViewController

#elseif os(iOS)

    public typealias QPlatformLineBreakMode = NSLineBreakMode

    public typealias QPlatformColor = UIColor
    public typealias QPlatformFont = UIFont
    public typealias QPlatformEdgeInsets = UIEdgeInsets

    public typealias QPlatformLayoutAttribute = NSLayoutAttribute
    public typealias QPlatformLayoutRelation = NSLayoutRelation
    public typealias QPlatformLayoutPriority = UILayoutPriority

    public typealias QPlatformWindow = UIWindow
    public typealias QPlatformView = UIView
    public typealias QPlatformControl = UIControl
    public typealias QPlatformViewController = UIViewController

#endif
