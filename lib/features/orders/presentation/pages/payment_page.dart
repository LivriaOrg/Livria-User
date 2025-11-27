import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../common/theme/app_colors.dart';
import '../providers/order_provider.dart';
import '../widgets/checkout_progress_bar.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                const Text(
                  "SUBMIT ORDER",
                  style: TextStyle(
                    color: AppColors.primaryOrange,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 30),

                const Center(child: CheckoutProgressBar(currentStep: 3)),
                const SizedBox(height: 30),

                // TARJETA DE PAGO
                Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "PAYMENT METHOD",
                        style: TextStyle(
                          color: AppColors.primaryOrange,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 20),

                      const Text(
                        "Enter your credit card details.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.darkBlue, fontSize: 13),
                      ),
                      const SizedBox(height: 20),

                      // --- CARD FIELD FIX ---
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),

                        child: SizedBox(
                          height: 60, // Altura recomendada
                          child: CardField(
                            enablePostalCode: false,
                            autofocus: false,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                            onCardChanged: (details) {
                              // aquí puedes validar si details.complete == true
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),
                      const Row(
                        children: [
                          Icon(Icons.lock, size: 14, color: Colors.grey),
                          SizedBox(width: 5),
                          Text(
                            "Transactions are secure and encrypted.",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // BOTONES
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back, size: 18),
                      label: const Text("BACK", style: TextStyle(fontWeight: FontWeight.bold)),
                      style: TextButton.styleFrom(foregroundColor: AppColors.darkBlue),
                    ),

                    ElevatedButton(
                      onPressed: orderProvider.isLoading
                          ? null
                          : () async {
                        await _handlePayment(context, orderProvider);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.softTeal,
                        foregroundColor: AppColors.darkBlue,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: orderProvider.isLoading
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                          : const Text("PAY NOW", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handlePayment(BuildContext context, OrderProvider provider) async {
    try {
      final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: const PaymentMethodParams.card(paymentMethodData: PaymentMethodData()),
      );

      debugPrint("Stripe Token creado: ${paymentMethod.id}");

      final success = await provider.submitOrder(context);

      if (success && context.mounted) {
        provider.clearForm();
        context.go('/checkout/confirmation');
      }

    } on StripeException catch (e) {
      String errorMessage = e.error.localizedMessage ?? "Payment failed. Please check your card.";

      if (e.error.code == FailureCode.Canceled) {
        errorMessage = "Payment canceled by user.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: AppColors.primaryOrange),
      );

    } catch (e) {
      String friendlyError = "Something went wrong with the payment system.";

      assert(() {
        friendlyError = "Dev Error: $e";
        return true;
      }());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(friendlyError), backgroundColor: AppColors.errorRed),
      );
    }
  }
}
