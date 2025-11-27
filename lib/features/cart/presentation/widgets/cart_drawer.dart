import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../../domain/entities/cart_item.dart';
import '../../infrastructure/datasource/cart_remote_datasource.dart';
import '../../infrastructure/repositories/cart_repository_impl.dart';
import '../../domain/usecases/get_cart_items_usecase.dart';
import '../../domain/usecases/delete_cart_item_usecase.dart';
import '../../domain/usecases/update_cart_quantity_usecase.dart';
import '../../../../common/theme/app_colors.dart';


// Widgets
import 'cart_item_card.dart';

class CartDrawer extends StatefulWidget {
  final int userId;
  const CartDrawer({super.key, required this.userId});

  @override
  State<CartDrawer> createState() => _CartDrawerState();
}

class _CartDrawerState extends State<CartDrawer> {
  // Estado local
  List<CartItem> _items = [];
  bool _isLoading = true;
  double _subtotal = 0.0;

  bool _isClearingCart = false;

  // UseCases
  late final GetCartItemsUseCase _getCartItems;
  late final UpdateCartQuantityUseCase _updateQuantity;
  late final DeleteCartItemUseCase _deleteItem;

  @override
  void initState() {
    super.initState();
    // INYECCIÓN DE DEPENDENCIAS
    final client = http.Client();
    final dataSource = CartRemoteDataSource(client: client);
    final repository = CartRepositoryImpl(remoteDataSource: dataSource);

    _getCartItems = GetCartItemsUseCase(repository);
    _updateQuantity = UpdateCartQuantityUseCase(repository);
    _deleteItem = DeleteCartItemUseCase(repository);

    // Cargar datos iniciales
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final items = await _getCartItems(widget.userId);
      setState(() {
        _items = items;
        _calculateSubtotal();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading cart: $e");
      setState(() => _isLoading = false);
    }
  }

  void _calculateSubtotal() {
    double temp = 0;
    for (var i in _items) {
      temp += i.book.salePrice * i.quantity;
    }
    _subtotal = temp;
  }

  // Lógica de UI
  void _onQuantityChanged(int itemId, int newQty) async {
    try {
      await _updateQuantity(itemId, widget.userId, newQty);
      _loadData();
    } catch (e) {
    }
  }

  void _onDeleteItem(int itemId) async {
    final originalList = List<CartItem>.from(_items);

    setState(() {
      _items.removeWhere((item) => item.id == itemId);
      _calculateSubtotal();
    });

    try {
      // 2. Llamamos a la API
      await _deleteItem(itemId, widget.userId);

    } catch (e) {
      if (mounted) {
        setState(() {
          _items = originalList;
          _calculateSubtotal();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error removing item"), backgroundColor: AppColors.errorRed),
        );
      }
    }
  }

  void _handleEmptyCart() async {
    if (_items.isEmpty) return;

    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Empty Cart"),
        content: const Text("Are you sure you want to remove all items?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Yes, Empty it")),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isClearingCart = true);

    try {
      await Future.wait(_items.map((item) => _deleteItem(item.id, widget.userId)));

      // 3. Recargamos la UI limpia
      await _loadData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Cart cleared!"), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error clearing cart"), backgroundColor: AppColors.errorRed),
        );
      }
    } finally {
      if (mounted) setState(() => _isClearingCart = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Colores del diseño
    const backgroundColor = AppColors.darkBlue;
    const accentColor = AppColors.accentGold;
    const lightBlueBtn = AppColors.softTeal;

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.85,
      backgroundColor: backgroundColor,
      child: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "CART",
                    style: TextStyle(
                      color: accentColor,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: (_items.isEmpty || _isClearingCart) ? null : _handleEmptyCart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: lightBlueBtn,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      disabledBackgroundColor: backgroundColor,
                    ),
                    child: _isClearingCart
                        ? const SizedBox(
                        width: 16, height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: lightBlueBtn)
                    )
                        : const Text(
                      "EMPTY CART",
                      style: TextStyle(color: backgroundColor, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  )
                ],
              ),
            ),
          ),

          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: accentColor))
                : _items.isEmpty
                ? const Center(child: Text("Your cart is empty", style: TextStyle(color: Colors.white70)))
                : ListView.builder(
              padding: const EdgeInsets.only(top: 10),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return CartItemCard(
                  item: item,
                  onQuantityChanged: (qty) => _onQuantityChanged(item.id, qty),
                  onDelete: () => _onDeleteItem(item.id),
                );
              },
            ),
          ),

          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: accentColor, width: 2)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Subtotal:",
                      style: TextStyle(color: accentColor, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "S/ ${_subtotal.toStringAsFixed(2)}",
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (_items.isEmpty || _isLoading)
                        ? null
                        : () {
                      if (Scaffold.of(context).isEndDrawerOpen) {
                        Navigator.of(context).pop();
                      }

                      context.push('/checkout/recipient');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: lightBlueBtn, // Color activo

                      disabledBackgroundColor: Colors.grey.withOpacity(0.2),
                      disabledForegroundColor: Colors.white.withOpacity(0.3),

                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      "COMPLETE MY PURCHASE",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}