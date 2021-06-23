import 'dart:html';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:rwk20/ui/base_widget.dart';
import 'package:rwk20/ui/sizing_information.dart';
import 'package:rwk20/utils/payment_api.dart';
import 'package:rwk20/utils/ui_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentPage extends StatefulWidget {
  final PaymentInit paymentInitData;

  const PaymentPage({Key key, @required this.paymentInitData})
      : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    // ignore: undefined_prefixed_name
    // ui.platformViewRegistry.registerViewFactory(
    //     'hello-world-html',
    //     (int viewId) => IFrameElement()
    //       ..width = '640'
    //       ..height = '360'
    //       ..src = 'https://www.youtube.com/embed/IyFZznAk69U'
    //       ..style.border = 'none');

    return BaseWidget(
      builder: (context, sizingInformation) {
        return Scaffold(
          appBar: AppBar(
            title: Text('RW \'20 Preorder'),
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      // textStyle: TextStyle(color: Colors.white),
                      color: Colors.grey.shade200,
                      elevation: 8,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: mobileWidthLimit,
                        margin: const EdgeInsets.all(10),
                        child: BaseWidget(
                          builder: (context, sizingInfo) {
                            SizingInformation si = sizingInfo;
                            return WebView(
                              initialUrl:
                                  '${widget.paymentInitData.authorizationUrl}',
                              javascriptMode: JavascriptMode.unrestricted,
                              userAgent: 'Flutter;Webview',
                              navigationDelegate: (navigation) async {
                                //Listen for callback URL
                                if (navigation.url == PaymentApi.callbackUrl) {
                                  bool verified =
                                      await PaymentApi.verifyPayment(
                                          widget.paymentInitData.reference);
                                  if (!verified)
                                    Navigator.of(context).pop(); //close webview
                                  else
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text(
                                              "Successful!",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            content: Text(
                                                "Thank you for pre-ordering for the redemption week branded wears. Your order has been received successfully! You will be notified of further information on your order via mail"),
                                            actions: <Widget>[
                                              TextButton(
                                                child: Text('Done'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                }
                                return NavigationDecision.navigate;
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
