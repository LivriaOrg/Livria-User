import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../common/theme/app_colors.dart';
import '../providers/profile_provider.dart';

class SubscriptionPaymentPage extends StatelessWidget {
  const SubscriptionPaymentPage({super.key});

  @override
  Widget build(BuildContext context) {

    final profileProvider = context.watch<ProfileProvider>();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text("COMMUNITY PLAN", style: TextStyle(color: AppColors.primaryOrange, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.darkBlue),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              children: [
                // INFO DEL PLAN
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.softTeal.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.softTeal),
                  ),
                  child: const Column(
                    children: [
                      Text("Upgrade to Community Plan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkBlue)),
                      SizedBox(height: 10),
                      Text("Get exclusive access to book clubs, premium reviews, and free shipping on orders over S/100.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
                      SizedBox(height: 15),
                      Text("S/ 19.90 / month", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.vibrantBlue)),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // TARJETA DE PAGO (Stripe)
                Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Text("PAYMENT METHOD", style: TextStyle(color: AppColors.primaryOrange, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),

                      // --- WIDGET STRIPE ---
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CardField(
                          autofocus: false,
                          style: const TextStyle(color: Colors.black, fontSize: 16),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.zero,
                          ),
                          enablePostalCode: false,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // BOTÓN PAGAR
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: profileProvider.isLoading
                        ? null
                        : () => _handleSubscriptionPayment(context, profileProvider),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryOrange,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: profileProvider.isLoading
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text("SUBSCRIBE NOW", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSubscriptionPayment(BuildContext context, ProfileProvider provider) async {
    try {
      await Stripe.instance.createPaymentMethod(
        params: const PaymentMethodParams.card(paymentMethodData: PaymentMethodData()),
      );

      final success = await provider.changeSubscriptionPlan("communityplan");

      if (success && context.mounted) {
        context.pop(); // Volver al perfil
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Welcome to the Community! 🎉"), backgroundColor: Colors.green),
        );
      }
    } on StripeException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.error.localizedMessage ?? "Error"), backgroundColor: Colors.red));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Payment failed"), backgroundColor: Colors.red));
    }
  }
}