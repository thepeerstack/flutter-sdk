import 'package:thepeer_flutter/thepeer_flutter.dart';

/// Raw Thepeer html formation
String buildThepeerHtml(ThePeerData data) {
  final url = data.isProd
      ? 'https://cdn.thepeer.co/v1/chain.js'
      : 'https://vision.thepeer.co/v1/chain.js';

  return '''
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ThePeer Dart</title>
    <script src="$url"></script>
</head>

<body style="border-radius: 20px; background-color:#fff;height:100vh;overflow: hidden; "> </body>

</html>
''';
}
