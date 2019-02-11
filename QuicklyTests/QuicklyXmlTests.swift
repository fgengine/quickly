//
//  Quickly
//

import XCTest
import Quickly

class QuicklyXmlTests : XCTestCase {

    func testParse() {
        do {
            let xml = try QXmlReader(string: """
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE recipe>
<recipe name="хлеб" preptime="5min" cooktime="180min">
    <title>Простой хлеб</title>
    <composition>
        <ingredient amount="3" unit="стакан">Мука</ingredient>
        <ingredient amount="0.25" unit="грамм">Дрожжи</ingredient>
        <ingredient amount="1.5" unit="стакан">Тёплая вода</ingredient>
    </composition>
    <instructions>
        <step>Смешать все ингредиенты и тщательно замесить.</step>
        <step>Закрыть тканью и оставить на один час в тёплом помещении.</step>
        <!--
        <step>Почитать вчерашнюю газету.</step>
        - это сомнительный шаг...
        -->
        <step>Замесить ещё раз, положить на противень и поставить в духовку.</step>
    </instructions>
</recipe>
""")
            let text = xml.document.debugString()
            XCTAssert(text.count > 0)
        } catch {
            XCTFail("\(error)")
        }
    }
    
}
