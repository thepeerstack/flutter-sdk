import 'package:thepeer_flutter/thepeer_flutter.dart';

/// Raw Thepeer html formation
String buildThepeerHtml(ThePeerData data) {
  final url = 'https://cdn.thepeer.co/v1/chain.js';

  return '''
<!DOCTYPE html>
<html lang="en">



<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <title>ThePeer Dart</title>
</head>

<body style="border-radius: 20px; background-color:#fff; height:100vh; overflow: hidden;">
    <style type="text/css" >
          * {
          -webkit-tap-highlight-color: rgba(0, 0, 0, 0);
          -webkit-tap-highlight-color: rgba(0, 0, 0, 0);
          -webkit-touch-callout: none;
          -webkit-user-select: none;
          -khtml-user-select: none;
          -moz-user-select: none;
          -ms-user-select: none;
          user-select: none;
        }
  </style>
  <script src="$url"></script>
</body>


</html>
''';
}
