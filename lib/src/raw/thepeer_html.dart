import 'package:thepeer_flutter/src/model/thepeer_data.dart';

/// Raw Peerstack html formation
String buildPeerstackHtml(ThePeerData data) => '''
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ThePeer Dart</title>
</head>

<body onload="usePeerstack()" style="border-radius: 20px; background-color:#fff;height:100vh;overflow: hidden; ">
     <script src="https://money.thepeer.co/send.js"></script>
    <script type="text/javascript">
        window.onload = usePeerstack;
        function usePeerstack() {

            let send = new ThePeer({
                publicKey: "${data.publicKey}",
                amount: "${data.amount}",
                userReference: "${data.userReference}",
                firstName: "${data.firstName ?? ''}",
                receiptUrl: "${data.receiptUrl ?? ''}",
                onSuccess: function (data) {
                    const response = { "type": "thepeer.dart.success", response: { ...data } }
                    PeerstackClientInterface.postMessage(JSON.stringify(response))
                },
                onClose: function () {
                    const response = { type: 'thepeer.dart.closed', }
                    PeerstackClientInterface.postMessage(JSON.stringify(response))
                }
        });

        send.setup();
        send.open();
    }
    </script>
</body>

</html>
''';
