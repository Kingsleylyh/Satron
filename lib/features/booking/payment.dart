import 'package:flutter/material.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the screen width here using context
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a Payment Method"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              "Third-party payment methods",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildPaymentMethodCard('TouchNGo', 'assets/images/tng.png', screenWidth),
                _buildPaymentMethodCard('GrabPay', 'assets/images/grab.png', screenWidth),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              "Banks",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            GridView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(), // Disable gridview scroll
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              children: [
                _buildBankCard('Maybank', 'assets/images/maybank.png'),
                _buildBankCard('Public Bank', 'assets/images/public.png'),
                _buildBankCard('CIMB Bank', 'assets/images/cimb.png'),
                _buildBankCard('OCBC Bank', 'assets/images/ocbc.png'),
                _buildBankCard('UOB Bank', 'assets/images/uob.png'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Builds a rectangular payment method card with an icon/logo
  Widget _buildPaymentMethodCard(String title, String logoPath, double screenWidth) {
    return Container(
      width: screenWidth * 0.4, // Adjust width based on screen size
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            logoPath,
            width: 40,
            height: 40,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // Builds a bank card with bank logo
  Widget _buildBankCard(String bankName, String logoPath) {
    return Container(
      width: double.infinity, // Make the width full
      height: 100, // Ensure equal height for all bank cards
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            logoPath,
            width: 40,
            height: 40,
          ),
          const SizedBox(height: 8),
          Text(
            bankName,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
