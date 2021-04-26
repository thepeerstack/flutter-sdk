# Flutter Peerstack
`** This is an unofficial SDK for flutter`

This package makes it easy to use the Peerstack in a flutter project.

## 📸 Screen Shots

<p float="left">
<img src="https://github.com/Zfinix/thepeer_flutter/blob/main/1.png?raw=true" width="200">
<img src="https://github.com/Zfinix/thepeer_flutter/blob/main/2.png?raw=true" width="200">
<img src="https://github.com/Zfinix/thepeer_flutter/blob/main/3.png?raw=true" width="200">
</p>

### 🚀 How to Use plugin

- Launch PeerstackView in a bottom_sheet

```dart
import 'package:thepeer_flutter/thepeer_flutter.dart';
    
  void launch() async {
    await PeerstackView(
            data: ThePeerData(
               amount: 10000,
               firstName: '$firstName',
               receiptUrl: '$receiptUrl',
               publicKey: '$publicKey',
               userReference: '$userReference',
            ),
            showLogs: true,
            onClosed: () {
               Navigator.pop(context);
            },
            onSuccess: () {
               Navigator.pop(context);
            },
      ).show(context);
  }
```


- Use PeerstackView widget

```dart
import 'package:thepeer_flutter/thepeer_flutter.dart';
    
     ...

     PeerstackView(
         data: ThePeerData(
               amount: 10000,
               firstName: '$firstName',
               receiptUrl: '$receiptUrl',
               publicKey: '$publicKey',
               userReference: '$userReference',
         ),
         onClosed: () {
            Navigator.pop(context);
            print('Widget closed')
         },
         onSuccess: () {
            Navigator.pop(context);
         },
        error: Text('Error'),
      )

      ...
  
```

## ✨ Contribution
 Lots of PR's would be needed to improve this plugin. So lots of suggestions and PRs are welcome.
