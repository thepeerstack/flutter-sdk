# Flutter Thepeer

This package makes it easy to use the Thepeer in a flutter project.

## 📸 Screen Shots

<p float="left">
<img src="https://github.com/thepeerstack/flutter-sdk/blob/main/1.png?raw=true" width="200">
<img src="https://github.com/thepeerstack/flutter-sdk/blob/main/4.png?raw=true" width="200">
<img src="https://github.com/thepeerstack/flutter-sdk/blob/main/5.png?raw=true" width="200">
<img src="https://github.com/thepeerstack/flutter-sdk/blob/main/6.png?raw=true" width="200">
</p>

### 🚀 How to Use plugin


### ThePeer Send

- Launch ThepeerSendView in a bottom_sheet

```dart
import 'package:thepeer_flutter/thepeer_flutter.dart';
    
  void launch() async {
      await ThepeerSendView(
               data: ThePeerData(
                  amount: 400000,
                  publicKey: "pspk_one_more_thing",
                  userReference: "stay-foolish-stay-hungry-forever",
                  receiptUrl: "https://apple.com/thepeer",
                  meta: {
                    "city": "San Fransisco",
                    "state": "california"
                  }
               ),
            showLogs: true,
            onClosed: () {
               print('closed');
               Navigator.pop(context);
            },
            onSuccess: (data) {
               print(data); // ThepeerSuccessModel
               Navigator.pop(context);
            },
            onError: print,
      ).show(context);
  }
```


- Use ThepeerSendView widget

```dart
import 'package:thepeer_flutter/thepeer_flutter.dart';
    
     ...

     ThepeerSendView(
         data: ThePeerData(
            amount: 10000,
            publicKey: "pspk_one_more_thing",
            userReference: "stay-foolish-stay-hungry-forever",
            receiptUrl: "https://apple.com/thepeer",
            meta: {
               "city": "San Fransisco",
               "state": "california"
            }
         ),
         onClosed: () {
            Navigator.pop(context);
            print('Widget closed')
         },
         onSuccess: (data) {
            print(data); // ThepeerSuccessModel
            Navigator.pop(context);
         },
         onError: print,
        error: Text('Error'),
      )

      ...
  
```
--- 

### ThePeer DirectCharge

- Launch ThepeerDirectChargeView in a bottom_sheet

```dart
import 'package:thepeer_flutter/thepeer_flutter.dart';
    
  void launch() async {
    await ThepeerDirectChargeView(
            data: ThePeerData(
              amount: 10000,
              publicKey: "pspk_one_more_thing",
              userReference: "stay-foolish-stay-hungry-forever",
              meta: {
                  "city": "San Fransisco",
                  "state": "california"
               }
            ),
            showLogs: true,
             onClosed: () {
            Navigator.pop(context);
            print('Widget closed')
         },
         onSuccess: () {
            print(data); // ThepeerSuccessModel
            Navigator.pop(context);
         },
         onError: print,
      ).show(context);
  }
```


- Use ThepeerDirectChargeView widget

```dart
import 'package:thepeer_flutter/thepeer_flutter.dart';
    
     ...

      await ThepeerDirectChargeView(
            data: ThePeerData(
              amount: 10000,
              publicKey: "pspk_one_more_thing",
              userReference: "stay-foolish-stay-hungry-forever",
              meta: {
                  "city": "San Fransisco",
                  "state": "california"
               }
            ),
            showLogs: true,
            onClosed: () {
            Navigator.pop(context);
            print('Widget closed')
         },
         onSuccess: (data) {
            print(data); // ThepeerSuccessModel
            Navigator.pop(context);
         },
         onError: print,
      )

      ...
  
```

## Configuration Options

- [`publicKey`](#publicKey)
- [`userReference`](#userReference)
- [`amount`](#amount)
- [`onSuccess`](#onSuccess)
- [`onError`](#onError)
- [`onClose`](#onClose)
- [`meta`](#meta)

### <a name="publicKey"></a> `publicKey`

**String: required**

Your public key can be found on your [dashboard](https://dashboard.thepeer.co) settings.

### <a name="userReference"></a> `userReference`

**String: required**

The user reference returned by Thepeer API when a user has been indexed

### <a name="amount"></a> `amount`

**String: required**

The amount you intend to send in kobo

### <a name="onSuccess"></a> `onSuccess`

**(ThepeerSuccessModel) =>: optional**

`returns ThepeerSuccessModel`

This is called when a transaction is successfully. It returns a response with event type and transaction details.

See the [event details](#thepeerEvent) below.

### <a name="onError"></a> `onError `

**VoidCallback: optional**

`returns dynamic`

This is called when a transaction fails. It returns a response with event type

See the [event details](#thepeerEvent) below.

### <a name="onClose"></a> `onClose `

**VoidCallback: optional**

This is called when a user clicks on the close button.

### <a name="meta"></a> `meta`

**Map<String, Object>: optional**
This object should contain additional/optional attributes you would like to have on your transaction response


#### <a name="transactionObject"></a> `transaction: ThepeerSuccessModel`
The transaction ThepeerSuccessModel object returned from the success events.


## ✨ Contribution
 Lots of PR's would be needed to improve this plugin. So lots of suggestions and PRs are welcome.
