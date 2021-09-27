# Flutter Thepeer

This package makes it easy to use the Thepeer in a flutter project.

## 📸 Screen Shots

![thepeer-one](https://user-images.githubusercontent.com/5338836/116476583-55419980-a873-11eb-9790-09e4c201c635.png)
![thepeer-two](https://user-images.githubusercontent.com/5338836/116476590-57a3f380-a873-11eb-8353-be6f8b95185c.png)
![thepeer-three](https://user-images.githubusercontent.com/5338836/116476596-5a064d80-a873-11eb-8cd4-dc7e7bbe1211.png)

<p float="left">
<img src="https://github.com/thepeerstack/flutter-sdk/blob/main/1.png?raw=true" width="200">
<img src="https://github.com/thepeerstack/flutter-sdk/blob/main/2.png?raw=true" width="200">
<img src="https://github.com/thepeerstack/flutter-sdk/blob/main/3.png?raw=true" width="200">
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

**return ThepeerSuccessModel**
This is called when a transaction is successfully. It returns a response with event type and transaction details.

See the [event details](#thepeerEvent) below.

### <a name="onError"></a> `onError `

**return dynamic**
This is called when a transaction fails. It returns a response with event type

See the [event details](#thepeerEvent) below.

### <a name="onClose"></a> `onClose `

This is called when a user clicks on the close button.

### <a name="meta"></a> `meta`

**Map<String, Object>: optional**
This object should contain additional/optional attributes you would like to have on your transaction response

### <a name="thepeerEvent"></a> Events Details (optional)

#### <a name="event"></a> `event: String`

Event names correspond to the type of event that occurred. Possible options are in the table below.

| Event Name                                                           | Description                                  |
| -------------------------------------------------------------------- | -------------------------------------------- |
| send.success or direct_debit.success                                 | successful transaction.                      |
| send.insufficient_funds or direct_debit.insufficient_funds           | business has no money to process transaction |
| send.user_insufficient_funds or direct_debit.user_insufficient_funds | user has no money to process transaction     |
| send.server_error or direct_debit.server_error                       | something went wrong                         |

#### <a name="transactionObject"></a> `transaction: ThepeerSuccessModel`
The transaction ThepeerSuccessModel object returned from the success events.


## ✨ Contribution
 Lots of PR's would be needed to improve this plugin. So lots of suggestions and PRs are welcome.
