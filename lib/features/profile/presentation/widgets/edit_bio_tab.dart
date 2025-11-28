import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common/theme/app_colors.dart';
import '../providers/profile_provider.dart';

class EditBioTab extends StatelessWidget {
  const EditBioTab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TÍTULO DE LA SECCIÓN
          const Text(
            "EDIT PERSONAL INFO",
            style: TextStyle(
              color: AppColors.primaryOrange,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 20),

          Center(
            child: Column(
              children: [
                if (provider.iconController.text.isNotEmpty) ...[
                  const Icon(Icons.image, color: AppColors.softTeal),
                  const SizedBox(height: 8),
                ],

                TextButton.icon(
                  onPressed: () => provider.pickImage(context),
                  icon: const Icon(Icons.camera_alt, color: AppColors.primaryOrange),
                  label: const Text(
                      "CHANGE PROFILE PHOTO",
                      style: TextStyle(
                          color: AppColors.primaryOrange,
                          fontWeight: FontWeight.bold
                      )
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.primaryOrange.withOpacity(0.1),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // DISPLAY NAME
          _buildLabel("Display Name"),
          _buildInput(
            controller: provider.displayController,
            hint: "How do you want to be called?",
            icon: Icons.badge_outlined,
          ),
          const SizedBox(height: 16),

          // USERNAME
          _buildLabel("Username"),
          _buildInput(
            controller: provider.usernameController,
            hint: "unique_handle",
            icon: Icons.alternate_email,
            prefixText: "@",
          ),
          const SizedBox(height: 16),

          // EMAIL
          _buildLabel("Email Address"),
          _buildInput(
            controller: provider.emailController,
            hint: "you@example.com",
            icon: Icons.email_outlined,
            inputType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),

          // PHRASE / BIO
          _buildLabel("Bio / Phrase"),
          _buildInput(
            controller: provider.phraseController,
            hint: "A short description about you...",
            icon: Icons.format_quote,
          ),

          const SizedBox(height: 30),

          // BOTÓN GUARDAR CAMBIOS
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: provider.isLoading
                  ? null
                  : () async {
                FocusScope.of(context).unfocus();

                await provider.saveProfileChanges(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.vibrantBlue,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: provider.isLoading
                  ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
              )
                  : const Text(
                "SAVE CHANGES",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 2.0),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.darkBlue,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType inputType = TextInputType.text,
    int maxLines = 1,
    String? prefixText,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 5,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        maxLines: maxLines,
        style: const TextStyle(color: AppColors.black, fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.withOpacity(0.6)),
          prefixIcon: Icon(icon, color: AppColors.softTeal, size: 20),
          prefixText: prefixText,
          prefixStyle: const TextStyle(color: AppColors.black, fontWeight: FontWeight.bold),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.softTeal, width: 1.5),
          ),
        ),
      ),
    );
  }
}