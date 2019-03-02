//
//  TrivialPreprocessorTests.swift
//  TextClassificationMacOSTests
//
//  Created by Viacheslav Volodko on 3/2/19.
//  Copyright © 2019 killobatt. All rights reserved.
//

import XCTest
@testable import TextClassification

class TrivialPreprocessorTests: XCTestCase {

    var testedPreprocessor: Preprocessor!

    override func setUp() {
        testedPreprocessor = TrivialPreprocessor()
    }

    override func tearDown() {
        testedPreprocessor = nil
    }

    func testPreprocessSimple() {
        // GIVEN
        let text = "Hello how are you doing"

        // WHEN
        let features = testedPreprocessor.preprocess(text: text)

        // THEN
        XCTAssertEqual(features, ["Hello": 1,
                                  "how": 1,
                                  "are": 1,
                                  "you": 1,
                                  "doing": 1])
    }

    func testPreprocessPunctuation() {
        // GIVEN
        let text = "Hello, how are you doing?"

        // WHEN
        let features = testedPreprocessor.preprocess(text: text)

        // THEN
        XCTAssertEqual(features, ["Hello": 1,
                                  "how": 1,
                                  "are": 1,
                                  "you": 1,
                                  "doing": 1])
    }

    func testPerformance() {

        let loremIpsum = """
            Lorem ipsum dolor sit amet, cu reque contentiones ius, ex sit mucius verear imperdiet, vel graeci scripta ad. Ad has soleat vocibus eleifend, mea no iisque appareat, eu vim possit minimum. Adversarium mediocritatem eum ut. Cum eu democritum abhorreant rationibus, an quem soluta equidem pro. Habeo dissentias mea id, mea cu ullum mentitum corrumpit. Ullum simul evertitur usu ad, eos tantas repudiare intellegat eu.

            Sea et suavitate expetendis. Id error neglegentur mei. Invidunt postulant at est, mei animal adolescens an, et sea luptatum quaerendum. Soleat labore audire duo ei, eam in definiebas referrentur.

            Et idque ancillae perfecto ius. Et erant eruditi disputationi nam. At putent eleifend pro, ad diam prompta denique mel. Mel in deterruisset vituperatoribus, vel volumus necessitatibus ex. Eu labitur insolens nec, euismod incorrupte repudiandae an est.

            Id simul vulputate est, in duo clita labores habemus. Pro facer tritani id, magna erant senserit eos ne. Vel prompta luptatum an, admodum erroribus referrentur est at. Sint definitionem vix ad. His ex brute docendi vivendum, epicurei consectetuer et vix.

            Te mea ornatus detracto, ius at odio postulant comprehensam. No mei sonet vituperata definitionem. Ut dicit utamur vivendo mel, in nullam voluptaria mei, cu graeco doctus ceteros per. Consequat temporibus sea at, sea eirmod principes cotidieque no. Ipsum voluptua temporibus eu cum, nam eu bonorum sanctus scribentur, vix ne quodsi nominavi.

            Id cum amet aperiri, tempor iracundia ut sit, atqui splendide contentiones at vel. His no dolor partiendo, usu id nisl meis nominati. Tempor recteque nec eu, laudem doming eu cum. Quando offendit sadipscing mel in, vim ea purto homero placerat. Est ea harum virtute. Tale probatus et pri.

            Ad duo iriure viderer. Nec in fugit eripuit neglegentur. Ad modo nostrum laboramus mei, mea singulis qualisque ad. Mel splendide appellantur no, sint voluptatibus nam ne, te semper tibique ius.

            Ei nec natum graeco facilisi, maiorum antiopam percipitur ex ius. No pri suas illum tincidunt. Ea eum menandri recteque, et quo doming nonumes deleniti. Ut quo vidit illum deterruisset, laudem contentiones mei cu. Movet putant repudiandae usu id, alii percipit eu sed.

            Duo ad soluta torquatos, quo ferri facilisis ei. Sit in atqui delenit, purto integre ex usu, at cum erat zril. Causae maluisset ne mea, mei choro prodesset expetendis ea. Ne everti instructior vis, ornatus docendi eleifend ad vix. Sit an equidem singulis pertinacia, probo choro ei usu.

            Epicurei quaerendum ad per. Labore integre petentium usu et. An quando timeam sensibus eos, an vix quis eleifend pertinacia. Quodsi eirmod te usu, purto autem verear eos in. No scripta moderatius scribentur eos, usu ad suscipit detraxit perfecto.

            Qui no clita admodum, nec nusquam patrioque ut, no mei mucius ceteros dissentias. Qui at dolore propriae dissentiet, cum ne wisi soluta voluptatum, primis vocibus interesset est et. Wisi comprehensam ex vim, te usu possim cetero consectetuer. Pro elitr graece facilisi ad, eu per adhuc paulo, ius an vidisse singulis.

            Mea ad bonorum dolorem. Ius te quando viderer perpetua. Malis dicunt impedit in est, invenire abhorreant appellantur an has, est ea offendit theophrastus. Paulo malorum copiosae cu nec. Ei prima mucius eruditi eos. Sed an eripuit ullamcorper, mea assum audire bonorum eu.

            Tempor dictas nostrum sit in, an pri fabellas convenire mediocrem. Cu sed phaedrum cotidieque, soluta aliquid ceteros cum an, legere discere assueverit pro ut. Ad simul molestie scriptorem sea, elit platonem eu cum. Sit cu habeo clita. Ad nibh gloriatur sed, eum populo eripuit ad. Cu wisi explicari definitiones sit, est id nonumy prompta minimum, an qui ridens blandit luptatum. An eos quot oportere, et has sensibus philosophia, ei vim mucius denique.

            Sale oratio voluptatum cu sed, sumo facer semper eum ei, ignota maiorum detracto ei vel. Quod elit his ut, dico aliquid mel ut. Sanctus dolorum dissentiunt mei eu, copiosae tacimates ut vis, eu erat theophrastus vel. No congue essent legendos mel, ullum commodo mei an, in pro affert utamur salutatus. Duo mandamus definiebas ei, cu duo duis exerci latine. In diceret vivendo quo, ei mei verear nostrum incorrupte, et eum prima fugit.

            Duo sint meis omnis ei. Habeo tamquam cu ius. Consul cetero molestiae an eum, no ipsum delectus sadipscing quo. Eum an dolores disputationi. Ridens oportere concludaturque usu an, ius et wisi nostrud, ipsum errem gloriatur his ex. Nec falli quaeque lobortis cu, pro ea meliore praesent rationibus, odio erroribus dissentiet vim id. Audiam legimus id vel.

            Pri te mazim accommodare, nec tempor nominati disputationi ad, solet iudicabit ad pri. Pri no fugit sonet, cu purto dissentias per. Ea erant congue vel. Per nihil zril dolor eu, sed te duis eleifend temporibus. Ferri timeam tibique eu pri, per novum disputando an, mundi audire scriptorem sed ex.

            Pri senserit disputationi ei, quot rebum vitae cum an, quot soleat atomorum eam in. Atqui adversarium vix et, unum augue eirmod sit no. Solet indoctum ius no, est lorem deleniti honestatis ex. Assum rationibus mei te, per ne minim singulis definiebas, ex amet melius usu. Ex omnium iriure officiis per, eu dico erant probatus vix, qui et invidunt verterem liberavisse.

            Ad nec idque nihil, no prima populo vim. Mel in erat euismod. Eu iudico principes mel. Ius ex eripuit perfecto indoctum. Has ea essent electram sadipscing, et sit intellegat mnesarchum quaerendum, his elitr utamur perpetua eu. Epicurei appetere nec ea, dicam antiopam ius an. Ut quo adipisci vulputate, cu justo pertinax definiebas est.

            Vix cu audiam vituperatoribus. Te unum veritus noluisse eos. In altera verterem vix. Sea et minimum sensibus, qui soluta maiorum nusquam ut, te eum eros officiis. Est ne modo euismod.

            Ut case debet posidonium sit, iuvaret scripserit vis ex. Pro no affert pertinax. Aeterno prodesset conclusionemque est eu. No qui sanctus accusata concludaturque. Graecis tractatos ad nam. Tation tibique assentior mel ea.

            Cu odio congue sed. Eu iisque interesset est, te iuvaret blandit pri, mel rebum mundi necessitatibus et. Has nullam cetero perfecto ex, qui id veri modus aliquam, vel suas constituto an. Duo in invidunt reprehendunt, cu qui meliore graecis assueverit. His et viderer utroque pericula. Quo adipiscing ullamcorper in, erat prima disputationi ius ex, minimum repudiandae eum te.

            Vel.
        """

        self.measure {
            _ = testedPreprocessor.preprocess(text: loremIpsum)
        }
    }

}
