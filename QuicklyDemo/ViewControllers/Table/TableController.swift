//
//  Quickly
//

import Quickly

protocol TableControllerDelegate : class {
}

class TableController : QTableController {

    weak var delegate: TableControllerDelegate?
    var section: IQTableSection?

    init(_ delegate: TableControllerDelegate) {
        self.delegate = delegate

        super.init(cells: [
            QCompositionTableCell< QImageComposition >.self,
            QCompositionTableCell< QImageTitleComposition >.self,
            QCompositionTableCell< QImageTitleShapeComposition >.self,
            QCompositionTableCell< QImageTitleIconComposition >.self,
            QCompositionTableCell< QImageTitleValueComposition >.self,
            QCompositionTableCell< QImageTitleValueShapeComposition >.self,
            QCompositionTableCell< QImageTitleValueIconComposition >.self,
            QCompositionTableCell< QImageTitleDetailComposition >.self,
            QCompositionTableCell< QImageTitleDetailShapeComposition >.self,
            QCompositionTableCell< QImageTitleDetailIconComposition >.self,
            QCompositionTableCell< QTitleComposition >.self,
            QCompositionTableCell< QTitleValueComposition >.self,
            QCompositionTableCell< QTitleValueShapeComposition >.self,
            QCompositionTableCell< QTitleValueIconComposition >.self,
            QCompositionTableCell< QTitleDetailComposition >.self,
            QCompositionTableCell< QTitleDetailShapeComposition >.self,
            QCompositionTableCell< QTitleDetailIconComposition >.self,
            QCompositionTableCell< QTitleButtonComposition >.self,
            QCompositionTableCell< QButtonComposition >.self,
            QCompositionTableCell< QTextFieldComposition >.self,
            QCompositionTableCell< QListFieldComposition >.self,
            QCompositionTableCell< QDateFieldComposition >.self
        ])
        self.sections = [
            QTableSection(rows: [
                QCompositionTableRow< QImageComposable >(
                    composable: QImageComposable(
                        image: QImageViewStyleSheet(source: QImageSource("icon_confirm"))
                    ),
                    backgroundColor: UIColor(white: 1, alpha: 1),
                    selectedBackgroundColor: UIColor(white: 0, alpha: 0.1)
                ),
                QCompositionTableRow< QImageTitleComposable >(
                    composable: QImageTitleComposable(
                        image: QImageViewStyleSheet(source: QImageSource("icon_confirm")),
                        imageWidth: 24,
                        title: QLabelStyleSheet(text: QText("Title"))
                    ),
                    backgroundColor: UIColor(white: 1, alpha: 1),
                    selectedBackgroundColor: UIColor(white: 0, alpha: 0.1)
                ),
                QCompositionTableRow< QImageTitleShapeComposable >(
                    composable: QImageTitleShapeComposable(
                        image: QImageViewStyleSheet(source: QImageSource("icon_confirm")),
                        imageWidth: 24,
                        title: QLabelStyleSheet(text: QText("Title")),
                        shape: DisclosureShape(color: UIColor.black)
                    ),
                    backgroundColor: UIColor(white: 1, alpha: 1),
                    selectedBackgroundColor: UIColor(white: 0, alpha: 0.1)
                ),
                QCompositionTableRow< QImageTitleIconComposable >(
                    composable: QImageTitleIconComposable(
                        image: QImageViewStyleSheet(source: QImageSource("icon_confirm")),
                        imageWidth: 24,
                        title: QLabelStyleSheet(text: QText("Title")),
                        icon: QImageViewStyleSheet(source: QImageSource("icon_confirm")),
                        iconWidth: 24
                    ),
                    backgroundColor: UIColor(white: 1, alpha: 1),
                    selectedBackgroundColor: UIColor(white: 0, alpha: 0.1)
                ),
                QCompositionTableRow< QImageTitleValueComposable >(
                    composable: QImageTitleValueComposable(
                        image: QImageViewStyleSheet(source: QImageSource("icon_confirm")),
                        imageWidth: 24,
                        title: QLabelStyleSheet(text: QText("Title")),
                        value: QLabelStyleSheet(text: QText("Value"))
                    ),
                    backgroundColor: UIColor(white: 1, alpha: 1),
                    selectedBackgroundColor: UIColor(white: 0, alpha: 0.1)
                ),
                QCompositionTableRow< QImageTitleValueShapeComposable >(
                    composable: QImageTitleValueShapeComposable(
                        image: QImageViewStyleSheet(source: QImageSource("icon_confirm")),
                        imageWidth: 24,
                        title: QLabelStyleSheet(text: QText("Title")),
                        value: QLabelStyleSheet(text: QText("Value")),
                        shape: DisclosureShape(color: UIColor.black)
                    ),
                    backgroundColor: UIColor(white: 1, alpha: 1),
                    selectedBackgroundColor: UIColor(white: 0, alpha: 0.1)
                ),
                QCompositionTableRow< QImageTitleValueIconComposable >(
                    composable: QImageTitleValueIconComposable(
                        image: QImageViewStyleSheet(source: QImageSource("icon_confirm")),
                        imageWidth: 24,
                        title: QLabelStyleSheet(text: QText("Title")),
                        value: QLabelStyleSheet(text: QText("Value")),
                        icon: QImageViewStyleSheet(source: QImageSource("icon_confirm")),
                        iconWidth: 24
                    ),
                    backgroundColor: UIColor(white: 1, alpha: 1),
                    selectedBackgroundColor: UIColor(white: 0, alpha: 0.1)
                ),
                QCompositionTableRow< QImageTitleDetailComposable >(
                    composable: QImageTitleDetailComposable(
                        image: QImageViewStyleSheet(source: QImageSource("icon_confirm")),
                        imageWidth: 24,
                        title: QLabelStyleSheet(text: QText("Title")),
                        detail: QLabelStyleSheet(text: QText("Detail"))
                    ),
                    backgroundColor: UIColor(white: 1, alpha: 1),
                    selectedBackgroundColor: UIColor(white: 0, alpha: 0.1)
                ),
                QCompositionTableRow< QImageTitleDetailShapeComposable >(
                    composable: QImageTitleDetailShapeComposable(
                        image: QImageViewStyleSheet(source: QImageSource("icon_confirm")),
                        imageWidth: 24,
                        title: QLabelStyleSheet(text: QText("Title")),
                        detail: QLabelStyleSheet(text: QText("Detail")),
                        shape: DisclosureShape(color: UIColor.black)
                    ),
                    backgroundColor: UIColor(white: 1, alpha: 1),
                    selectedBackgroundColor: UIColor(white: 0, alpha: 0.1)
                ),
                QCompositionTableRow< QImageTitleDetailIconComposable >(
                    composable: QImageTitleDetailIconComposable(
                        image: QImageViewStyleSheet(source: QImageSource("icon_confirm")),
                        imageWidth: 24,
                        title: QLabelStyleSheet(text: QText("Title")),
                        detail: QLabelStyleSheet(text: QText("Detail")),
                        icon: QImageViewStyleSheet(source: QImageSource("icon_confirm")),
                        iconWidth: 24
                    ),
                    backgroundColor: UIColor(white: 1, alpha: 1),
                    selectedBackgroundColor: UIColor(white: 0, alpha: 0.1)
                ),
                QCompositionTableRow< QTitleComposable >(
                    composable: QTitleComposable(
                        title: QLabelStyleSheet(text: QText("Title"))
                    ),
                    backgroundColor: UIColor(white: 1, alpha: 1),
                    selectedBackgroundColor: UIColor(white: 0, alpha: 0.1)
                ),
                QCompositionTableRow< QTitleValueComposable >(
                    composable: QTitleValueComposable(
                        title: QLabelStyleSheet(text: QText("Title")),
                        value: QLabelStyleSheet(text: QText("Value"))
                    ),
                    backgroundColor: UIColor(white: 1, alpha: 1),
                    selectedBackgroundColor: UIColor(white: 0, alpha: 0.1)
                ),
                QCompositionTableRow< QTitleValueShapeComposable >(
                    composable: QTitleValueShapeComposable(
                        title: QLabelStyleSheet(text: QText("Title")),
                        value: QLabelStyleSheet(text: QText("Value")),
                        shape: DisclosureShape(color: UIColor.black)
                    ),
                    backgroundColor: UIColor(white: 1, alpha: 1),
                    selectedBackgroundColor: UIColor(white: 0, alpha: 0.1)
                ),
                QCompositionTableRow< QTitleValueIconComposable >(
                    composable: QTitleValueIconComposable(
                        title: QLabelStyleSheet(text: QText("Title")),
                        value: QLabelStyleSheet(text: QText("Value")),
                        icon: QImageViewStyleSheet(source: QImageSource("icon_confirm")),
                        iconWidth: 24
                    ),
                    backgroundColor: UIColor(white: 1, alpha: 1),
                    selectedBackgroundColor: UIColor(white: 0, alpha: 0.1)
                ),
                QCompositionTableRow< QTitleDetailComposable >(
                    composable: QTitleDetailComposable(
                        title: QLabelStyleSheet(text: QText("Title")),
                        detail: QLabelStyleSheet(text: QText("Detail"))
                    ),
                    backgroundColor: UIColor(white: 1, alpha: 1),
                    selectedBackgroundColor: UIColor(white: 0, alpha: 0.1)
                ),
                QCompositionTableRow< QTitleDetailShapeComposable >(
                    composable: QTitleDetailShapeComposable(
                        title: QLabelStyleSheet(text: QText("Title")),
                        detail: QLabelStyleSheet(text: QText("Detail")),
                        shape: DisclosureShape(color: UIColor.black)
                    ),
                    backgroundColor: UIColor(white: 1, alpha: 1),
                    selectedBackgroundColor: UIColor(white: 0, alpha: 0.1)
                ),
                QCompositionTableRow< QTitleDetailIconComposable >(
                    composable: QTitleDetailIconComposable(
                        title: QLabelStyleSheet(text: QText("Title")),
                        detail: QLabelStyleSheet(text: QText("Detail")),
                        icon: QImageViewStyleSheet(source: QImageSource("icon_confirm")),
                        iconWidth: 24
                    ),
                    backgroundColor: UIColor(white: 1, alpha: 1),
                    selectedBackgroundColor: UIColor(white: 0, alpha: 0.1)
                ),
                QCompositionTableRow< QTitleButtonComposable >(
                    composable: QTitleButtonComposable(
                        title: QLabelStyleSheet(text: QText("Title")),
                        button: QButtonStyleSheet(
                            normalStyle: QButtonStyle(color: UIColor.red, cornerRadius: .auto, text: QText("Button")),
                            highlightedStyle: QButtonStyle(color: UIColor.green, cornerRadius: .auto, text: QText("Button"))
                        ),
                        buttonPressed: { (composable) in
                            print("Pressed \(composable)")
                        }
                    ),
                    backgroundColor: UIColor(white: 1, alpha: 1),
                    selectedBackgroundColor: UIColor(white: 0, alpha: 0.1)
                ),
                QCompositionTableRow< QTextFieldComposable >(
                    composable: QTextFieldComposable(
                        field: QTextFieldStyleSheet(
                            placeholder: QText("Placeholder")
                        ),
                        fieldText: "",
                        fieldEditing: { (composable) in
                            print("Editing \(composable) \(composable.fieldText)")
                        }
                    ),
                    backgroundColor: UIColor(white: 1, alpha: 1),
                    selectedBackgroundColor: UIColor(white: 0, alpha: 0.1)
                ),
                QCompositionTableRow< QListFieldComposable >(
                    composable: QListFieldComposable(
                        field: QListFieldStyleSheet(
                            rows: [
                                QListFieldPickerRow(
                                    field: QText("Text in field #1"),
                                    row: QText("Text in row #1")
                                ),
                                QListFieldPickerRow(
                                    field: QText("Text in field #2"),
                                    row: QText("Text in row #2")
                                ),
                                QListFieldPickerRow(
                                    field: QText("Text in field #3"),
                                    row: QText("Text in row #3")
                                )
                            ],
                            placeholder: QText("Placeholder")
                        ),
                        fieldSelect: { (composable) in
                            print("Selected \(composable) \(composable.fieldSelectedRow?.row.text.string ?? "none")")
                        }
                    ),
                    backgroundColor: UIColor(white: 1, alpha: 1),
                    selectedBackgroundColor: UIColor(white: 0, alpha: 0.1)
                ),
                QCompositionTableRow< QDateFieldComposable >(
                    composable: QDateFieldComposable(
                        field: QDateFieldStyleSheet(
                            placeholder: QText("Placeholder")
                        ),
                        fieldSelect: { (composable) in
                            print("Selected \(composable) \(composable.fieldDate.debugDescription)")
                        }
                    ),
                    backgroundColor: UIColor(white: 1, alpha: 1),
                    selectedBackgroundColor: UIColor(white: 0, alpha: 0.1)
                )
            ])
        ]
    }

}
