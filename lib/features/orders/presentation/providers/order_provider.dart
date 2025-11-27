import 'package:flutter/material.dart';
import '../../../auth/infrastructure/datasource/auth_local_datasource.dart';
import '../../domain/entities/order.dart';
import '../../domain/usecases/create_order_usecase.dart';

class OrderProvider extends ChangeNotifier {
  final CreateOrderUseCase createOrderUseCase;

  OrderProvider({required this.createOrderUseCase});

  // --- ESTADO DEL FORMULARIO (Paso 1 y 2) ---

  // Paso 1: Información del Recipient
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  String get fullRecipientName => "${nameController.text} ${lastNameController.text}".trim();

  // Paso 2: Envío
  bool _isDelivery = true;
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController referenceController = TextEditingController();

  bool get isDelivery => _isDelivery;

  void setDelivery(bool value) {
    _isDelivery = value;
    notifyListeners();
  }

  // Estado de carga
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  //MeTODO FINAL: CREAR LA ORDEN
  Future<bool> submitOrder(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      final authDs = AuthLocalDataSource();
      final userId = await authDs.getUserId();


      if (userId == null) throw Exception("User not logged in");

      ShippingDetails? shipping;
      if (_isDelivery) {
        shipping = ShippingDetails(
          address: addressController.text,
          city: cityController.text,
          district: districtController.text,
          reference: referenceController.text,
        );
      }

      await createOrderUseCase(
        userClientId: userId,
        userEmail: "user@email.com",
        userPhone: phoneController.text,
        userFullName: "User Name",
        recipientName: fullRecipientName,
        isDelivery: _isDelivery,
        status: "pending",
        shippingDetails: shipping,
      );

      _isLoading = false;
      notifyListeners();
      return true;

    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint("Error creating order: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
      return false;
    }
  }

  void clearForm() {
    nameController.clear();
    lastNameController.clear();
    phoneController.clear();
    addressController.clear();
    cityController.clear();
    districtController.clear();
    referenceController.clear();
    _isDelivery = true;
    notifyListeners();
  }
}