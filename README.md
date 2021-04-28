# Flutter Peerstack

This package makes it easy to use the Peerstack in a flutter project.

## 📸 Screen Shots

<p float="left">
![thepeer-one](https://user-images.githubusercontent.com/5338836/116476583-55419980-a873-11eb-9790-09e4c201c635.png)
![thepeer-two](https://user-images.githubusercontent.com/5338836/116476590-57a3f380-a873-11eb-8353-be6f8b95185c.png)
![thepeer-three](https://user-images.githubusercontent.com/5338836/116476596-5a064d80-a873-11eb-8cd4-dc7e7bbe1211.png)
</p>

### 🚀 How to Use plugin

- Launch ThepeerView in a bottom_sheet

```dart
import 'package:thepeer_flutter/thepeer_flutter.dart';
    
  void launch() async {
    await ThepeerView(
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


- Use ThepeerView widget

```dart
import 'package:thepeer_flutter/thepeer_flutter.dart';
    
     ...

     ThepeerView(
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
