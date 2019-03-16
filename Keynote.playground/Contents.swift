import Cocoa
import NaturalLanguage

extension NLLanguage {
    var name: String {
        let code = self.rawValue
        let locale = NSLocale(localeIdentifier: code)
        return locale.displayName(forKey: NSLocale.Key.languageCode, value: code) ?? "unknown"
    }
}


// `NLLanguageRecognizer` чудово справляється із розпізнаванням мови у загальному випадку
NLLanguageRecognizer.dominantLanguage(for: "Hello, how are you doing?")?.name
// English

NLLanguageRecognizer.dominantLanguage(for: "Привіт, як твої справи")?.name
// Українська

NLLanguageRecognizer.dominantLanguage(for: "Привет, как твои дела?")?.name
// Русский

NLLanguageRecognizer.dominantLanguage(for: "Hallo, wie geht es dir?")?.name
// Deutsch






// Однак, коли справа стосуєтсья дуже специфічних випадків, все не так гладко:
let realWorldSMS =
    """
    VITAEMO Kompiuternum vidbirom na nomer,vipav
    pryz:AUTO-MAZDA SX-5
    Detali:
    +38(095)857-58-64
    abo na saiti:
    www.mir-europay.com.ua
    """

NLLanguageRecognizer.dominantLanguage(for: realWorldSMS)?.name
// Hrvatski



// В Cocoa[Touch] є чудовий інструмент для транслітерації:
let detransliteratedString =
    realWorldSMS.applyingTransform(StringTransform.latinToCyrillic, reverse: false) ?? ""
print(detransliteratedString)

// Але він не дуже допомагає в цьому випадку:
NLLanguageRecognizer.dominantLanguage(for: detransliteratedString)?.name


// Дану задачу я пробував вирішувати наступним чином:
// let originalLanguageGuess = language(for: realWorldSMS)
// let transliteratedLanguageGuess = language(for: detransliterate(realWorldSMS))
// if originalLanguageGuess.probability > transliteratedLanguageGuess.probability {
//     return originalLanguageGuess
// else
//     return transliteratedLanguageGuess
let recognizer = NLLanguageRecognizer()
recognizer.processString(detransliteratedString)
let (detransliteratedHypothesis, detransliteratedProbability) = recognizer.languageHypotheses(withMaximum: 1).first!
recognizer.reset()

recognizer.processString(realWorldSMS)
let (hypothesis, probability) = recognizer.languageHypotheses(withMaximum: 1).first!
recognizer.reset()

if detransliteratedProbability < probability {

}


// Насправді, це дуже наївно припускати, що ймовірність вгадати текст після детранслітерації буде адекватною:

let ukrainianTranslitText = "Privit, jak tvoji spravy?"
let detransliteredUkrText = ukrainianTranslitText
    .applyingTransform(StringTransform.latinToCyrillic, reverse: false) ?? ""
// Привит, йак твойи справы?

let englishText = "Hello, how are you doing?"
let detransliteredEngText = englishText
    .applyingTransform(StringTransform.latinToCyrillic, reverse: false) ?? ""
// Хелло, хоу аре ыоу доинг?

public protocol Preprocessor {
    /// Preprocesses text of DatasetItem.
    /// - returns: a feature dictionary: Key is feature (e.g. word), Value is how many times it is observed in text.
    func preprocess(text: String) -> [String]
}


class PreprocessingUnit: Preprocessor {
    func preprocess(text: String) -> [String] {
        return text.split(separator: " ")
    }
}

let preprocessor = PreprocessingUnit()

let labels = ["label"]
let textsForLabel = ["label": ["text1", "text2"]]
for label in labels {
    for text in textsForLabel[label] ?? [] {
        let words = preprocessor.preprocess(text: text)
        for word in words {
            model[label][word] += 1
        }
    }
}

["Зателефонуйте", "нам", "на"]

[
    "uk": 0.88,
    "ru": 0.74,
    "en": 0.2,
    ...
]


