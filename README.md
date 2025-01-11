

![whisp](Resources/whisp.png)

# whisp

Official iOS SDK for interacting with the ***whisp*** agent.

# About

Whisp is a web3 orchestrating agent designed to simplify how we interact with crypto. It relies on the Whispers Protocol to select the most suitable agent for tasks like transfers, swaps, token management and more.

We see AI agents as the future of web3. ***Whispers*** is an open protocol that lets developers build, orchestrate,
and embed AI agents making blockchain accessible for everyone.

# SDK

> ⚠️ This is an alpha version of the SDK. It's currently under active development. Public APIs are subject to change until the beta release.

SDK provides developers with the tools necessary to integrate core ***whisp*** functionality into their iOS or macOS applications.

## Requirements

- iOS 13.0+
- macOS 10.15+

## Installation

To add a package dependency to your Xcode project, select `File > Add Package` and enter this repository's URL:

```
https://github.com/whsprs/ios-whisp-sdk
```

To add a package dependency to your Swift Package, add this repository to your list of dependencies.

```swift
.package(url: "https://github.com/whsprs/ios-whisp-sdk", from: "0.0.1")
```
And to your target as a product:

```swift
.product(name: "Whisp", package: "Whisp")
```

Now you can use `ios-whisp-sdk` in your app.

## Usage

### Setup

If you want to interact with ***whisp*** agent, you need to create `WhispAgent` instance first.

```swift
import WhispAgent

let whispAgent = try WhispAgentBuilder.shared.build(
    url: url,
    webSocketUrl: webSocketUrl,
    apiKey: apiKey,
    publicKey: publicKey,
    network: .devnet
)
```

### Observing

Now you can use `WhispAgent` instance and listen agent events:

```swift
Task.detached {
    for await event in whispAgent.listen() {
        // event processing code
    }
}
```

### Interaction

You can interact with ***whisp*** in multiple ways.

#### Text Message

Send text message from the user:

```swift
try whispAgent.send(message: WhispAgentSendTextMessage(text: input))
```

#### Transaction

Send transaction signature after transaction request event:

```swift
try whispAgent.send(message: WhispAgentSendTransactionTxHash(id: id, txHash: txHash))
```

Send sign transaction (base64) after transaction request event:

```swift
try whispAgent.send(message: WhispAgentSendSignedTransaction(id: id, signedTransaction: signedTransaction))
```

Send decline transaction request event:

```swift
try whispAgent.send(message: WhispAgentSendDeclinedTransaction(id: id))
```

### UI

> ⚠️ This is an alpha version of the chat UI SDK. It's currently under active development. Public APIs are subject to change until the beta release.

The UI framework provides a simple way to integrate chat interactions with ***whisp*** into your application. It offers ready-to-use components for building chat interfaces with minimal setup required.

# Links

- [whsprs.ai](https://whsprs.ai/)
- [x.com](https://x.com/whispersai)
