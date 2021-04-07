import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool isPaymentComplete = false;
  Razorpay _razorpay = Razorpay();

  @override
  void initState() {
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void _openRazorpay() async {
    var options = {
      'key': 'YOUR_RAZORPAY_KEY',
      // 'order_id': orderId, -> Pass order id by calling Razorpay Order API from backend
      'amount': (200 * 100),
      'name': 'Razorpay Inc.',
      'description': 'Thank you for shopping with us!',
      // 'prefill': {'contact': '2783939294', 'email': 'abc@gmail.com'}, -> pass contact and email details of the user if available
      'theme': {
        'color': '#008000',
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    showPaymentPopupMessage(context, true, 'Payment Successful!');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    showPaymentPopupMessage(context, false, 'Payment Failed!');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print(
        'You have chosen to pay via : ${response.walletName}. It will take some time to reflect your payment.');
  }

  void showPaymentPopupMessage(
      BuildContext ctx, bool isPaymentSuccess, String message) {
    showDialog<void>(
      context: ctx,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              isPaymentSuccess
                  ? Icon(
                      Icons.done,
                      color: Colors.green,
                    )
                  : Icon(
                      Icons.clear,
                      color: Colors.red,
                    ),
              SizedBox(
                width: 5,
              ),
              Text(
                isPaymentSuccess ? 'Payment Successful' : 'Payment Failed',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Divider(
                  color: Colors.grey,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(message),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  int amt;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donation'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                amt = int.parse(value);
              },
              decoration: InputDecoration(labelText: "Enter Amount"),
            ),
            RaisedButton(
                child: Text("Donate"),
                onPressed: () {
                  _openRazorpay();
                }),
          ],
        ),
      ),
    );
  }
}
