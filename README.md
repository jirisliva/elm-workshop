# Elm Workshop

## Contents

- Basics - Elm Architecture, Syntax, Packages
- Hello World
- Modules
- Commands (HTTP client and REST, ...)
- Decoders
- Tasks (Chaning REST requests, ...)
- JavaScript interoperability - Ports, WebComponents

## Install Prerequisites

### Elm Compiler

1. Installer from [https://elm-lang.org](https://guide.elm-lang.org/install/elm.html) (Windows, macOS, Linux) or

2. NPM package

		npm install -g elm

### Elm Format
1. Binaries on [github.com/avh4/elm-format](https://github.com/avh4/elm-format/releases) 

2. NPM package

		npm install -g elm-format


### elm-live (optional)

	npm install -g elm-live

### json-server

	npm install -g json-server

### Editor Plugins

- Visual Studio Code, [Krzysztof-Cieslak/vscode-elm](https://marketplace.visualstudio.com/items?itemName=sbrink.elm)
- IntelliJ IDEA, [klazuka/intellij-elm](https://plugins.jetbrains.com/plugin/10268-elm)
- Sublime Text, [Elm Language Support](https://packagecontrol.io/packages/Elm%20Language%20Support)

## Start with "Hello World"

    git clone git@github.com:jirisliva/elm-workshop.git

    cd 1_hello

    elm make src/Main.elm --debug

or with reactor

	elm reactor

or with `elm-live`

	elm-live src/Main.elm -- --debug

or exapmle on [Ellie-app](https://ellie-app.com/7ThBMQ54Dhja1).


## Resources
- [Elm Syntax](https://elm-lang.org/docs/syntax)
- [Official Guide](https://guide.elm-lang.org)
- [Learn X in Y minutes](https://learnxinyminutes.com/docs/elm/) (in czech: [zdrojak.cz](https://www.zdrojak.cz/clanky/rychly-prehled-elm/))

