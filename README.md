# TextClassification
Text classification approaches in Swift 4.2. With/Without CoreML

This repo has sample codes for tech talk at https://eatdog.com.ua happened on March 21, 2019. 

## Getting started

1. Ensure you have carthage installed: 

```
brew install carthage
```
2. Install dependencies: 

```
carthage bootstrap
```

3. Run unit tests for `TextClassificationMacOS` target. Failing tests is expected: this way they display actual accuracy for classification method as an output. 

4. To face **MessageFilteringExtension** RAM problem, use `CoreMLClassifier` for message filtering in `MessageFilterExtension.swift`. You will have to run this extension on real iPhone, and receive a real SMS from unknown sender to trigger the extension. Debugger works more or less fine. Changing text classifier onto `MemoryMappedNaiveBayesClassifier` demonstrates fitting into 6Mb memory limit.

6. If you wan't just to see text classification, run the **MessageFilteringApp** on either device or simulator.

## Licence

This project has MIT licence. It uses Google Flatbuffer library as a dependency: https://github.com/google/flatbuffers/blob/master/LICENSE.txt
