part of '../../../main.dart';

class SalePage extends StatefulWidget {
  const SalePage({
    super.key,
    required this.database,
    required this.saleService,
  });

  final AppDatabase database;
  final SaleService saleService;

  @override
  State<SalePage> createState() => _SalePageState();
}

class _SalePageState extends State<SalePage> {
  final _quantityController = TextEditingController(text: '1');
  final _downPaymentAmountController = TextEditingController(text: '0');
  final _productQuantityFocusNode = FocusNode();
  final _downPaymentFocusNode = FocusNode();

  String? _selectedCustomerId;
  String? _selectedProductId;
  final List<_SaleCartItem> _cartItems = [];
  SaleVatOption _vatOption = SaleVatOption.none;
  var _installmentCount = 1;
  var _downPaymentInputMode = _DownPaymentInputMode.amount;
  var _saving = false;

  @override
  void dispose() {
    _quantityController.dispose();
    _downPaymentAmountController.dispose();
    _productQuantityFocusNode.dispose();
    _downPaymentFocusNode.dispose();
    super.dispose();
  }

  Customer? _selectedCustomer(List<Customer> customers) {
    final selectedId = _selectedCustomerId;
    if (selectedId == null) {
      return null;
    }
    for (final customer in customers) {
      if (customer.id == selectedId) {
        return customer;
      }
    }
    return null;
  }

  Product? _selectedProduct(List<Product> products) {
    final selectedId = _selectedProductId;
    if (selectedId == null) {
      return null;
    }
    for (final product in products) {
      if (product.id == selectedId) {
        return product;
      }
    }
    return null;
  }

  double? get _quantity => _parseSalePrice(_quantityController.text);

  double? get _downPaymentAmount {
    final value = _downPaymentInputValue;
    if (value == null) {
      return null;
    }
    if (_downPaymentInputMode == _DownPaymentInputMode.amount) {
      return value;
    }

    final grandTotal = _grandTotalBeforeDownPayment;
    if (grandTotal == null) {
      return null;
    }
    return grandTotal * value / 100;
  }

  double? get _downPaymentInputValue {
    return _parseSalePrice(_downPaymentAmountController.text);
  }

  double? get _grandTotalBeforeDownPayment {
    if (_cartItems.isEmpty) {
      return 0;
    }
    if (_installmentCount < 1 || _installmentCount > 10) {
      return null;
    }

    try {
      return widget.saleService
          .calculateTotals(
            items: _cartItems.map((item) => item.toPayload()).toList(),
            vatOption: _vatOption,
            downPaymentAmount: 0,
            installmentCount: _installmentCount,
          )
          .grandTotal;
    } on SaleException {
      return null;
    }
  }

  SaleTotals get _totals {
    final downPaymentAmount = _downPaymentAmount;
    if (_cartItems.isEmpty ||
        downPaymentAmount == null ||
        downPaymentAmount < 0 ||
        _installmentCount < 1 ||
        _installmentCount > 10) {
      return SaleTotals(
        subtotal: 0,
        vatAmount: 0,
        grandTotal: 0,
        downPaymentPercent: 0,
        downPaymentAmount: 0,
        remainingAmount: 0,
        installmentCount: _installmentCount,
        installmentAmount: 0,
      );
    }

    try {
      return widget.saleService.calculateTotals(
        items: _cartItems.map((item) => item.toPayload()).toList(),
        vatOption: _vatOption,
        downPaymentAmount: downPaymentAmount,
        installmentCount: _installmentCount,
      );
    } on SaleException {
      return SaleTotals(
        subtotal: 0,
        vatAmount: 0,
        grandTotal: 0,
        downPaymentPercent: 0,
        downPaymentAmount: downPaymentAmount,
        remainingAmount: 0,
        installmentCount: _installmentCount,
        installmentAmount: 0,
      );
    }
  }

  void _addToCart(Product? product) {
    final quantity = _quantity;
    if (product == null) {
      _showMessage('กรุณาเลือกสินค้า');
      return;
    }
    if (quantity == null || quantity <= 0) {
      _showMessage('จำนวนสินค้าต้องมากกว่า 0');
      return;
    }

    final existingIndex = _cartItems.indexWhere(
      (item) => item.product.id == product.id,
    );
    setState(() {
      if (existingIndex >= 0) {
        final existing = _cartItems[existingIndex];
        _cartItems[existingIndex] = existing.copyWith(
          quantity: existing.quantity + quantity,
        );
      } else {
        _cartItems.add(_SaleCartItem(product: product, quantity: quantity));
      }
      _selectedProductId = null;
      _quantityController.text = '1';
    });
    _showMessage('เพิ่มรายการสินค้าแล้ว');
  }

  void _updateCartQuantity(Product product, double quantity) {
    if (quantity <= 0 || quantity.isNaN || quantity.isInfinite) {
      _showMessage('จำนวนสินค้าต้องมากกว่า 0');
      return;
    }
    setState(() {
      final index = _cartItems.indexWhere(
        (item) => item.product.id == product.id,
      );
      if (index >= 0) {
        _cartItems[index] = _cartItems[index].copyWith(quantity: quantity);
      }
    });
  }

  void _removeCartItem(Product product) {
    setState(() {
      _cartItems.removeWhere((item) => item.product.id == product.id);
    });
    _showMessage('ลบรายการสินค้าแล้ว');
  }

  void _changeDownPaymentInputMode(_DownPaymentInputMode mode) {
    if (_downPaymentInputMode == mode) {
      return;
    }

    final currentAmount = _downPaymentAmount;
    final grandTotal = _grandTotalBeforeDownPayment;
    var nextText = _downPaymentAmountController.text;

    if (mode == _DownPaymentInputMode.percent) {
      if (currentAmount != null && grandTotal != null && grandTotal > 0) {
        nextText = _formatPercent(currentAmount / grandTotal * 100);
      } else {
        nextText = '0';
      }
    } else {
      if (currentAmount != null) {
        nextText = _formatSalePrice(currentAmount);
      } else {
        nextText = '0.00';
      }
    }

    setState(() {
      _downPaymentInputMode = mode;
      _downPaymentAmountController.text = nextText;
      _downPaymentAmountController.selection = TextSelection.collapsed(
        offset: nextText.length,
      );
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _downPaymentFocusNode.requestFocus();
      }
    });
  }

  Future<void> _saveSale({required Customer? customer}) async {
    final downPaymentInputValue = _downPaymentInputValue;
    final downPaymentAmount = _downPaymentAmount;
    if (customer == null) {
      _showMessage('กรุณาเลือกลูกค้า');
      return;
    }
    if (_cartItems.isEmpty) {
      _showMessage('กรุณาเพิ่มรายการสินค้า');
      return;
    }
    if (downPaymentInputValue == null || downPaymentInputValue < 0) {
      _showMessage(
        _downPaymentInputMode == _DownPaymentInputMode.percent
            ? 'เปอร์เซ็นต์เงินดาวน์ต้องอยู่ระหว่าง 0-100'
            : 'ยอดเงินดาวน์ต้องมากกว่าหรือเท่ากับ 0',
      );
      return;
    }
    if (_downPaymentInputMode == _DownPaymentInputMode.percent &&
        downPaymentInputValue > 100) {
      _showMessage('เปอร์เซ็นต์เงินดาวน์ต้องอยู่ระหว่าง 0-100');
      return;
    }
    if (downPaymentAmount == null || downPaymentAmount < 0) {
      _showMessage('ยอดเงินดาวน์ไม่ถูกต้อง');
      return;
    }
    if (_installmentCount < 1 || _installmentCount > 10) {
      _showMessage('จำนวนงวดต้องอยู่ระหว่าง 1-10');
      return;
    }

    setState(() => _saving = true);
    try {
      await widget.saleService.createSale(
        SalePayload(
          customer: customer,
          items: _cartItems.map((item) => item.toPayload()).toList(),
          vatOption: _vatOption,
          downPaymentAmount: downPaymentAmount,
          installmentCount: _installmentCount,
        ),
      );

      if (mounted) {
        setState(() {
          _selectedProductId = null;
          _quantityController.text = '1';
          _cartItems.clear();
        });
        _showMessage('บันทึกการขายแล้ว');
      }
    } on SaleException catch (error) {
      _showMessage(error.message);
    } catch (_) {
      _showMessage('ไม่สามารถบันทึกการขายได้');
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }
    _showToast(context, message);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: StreamBuilder<List<Customer>>(
          stream: widget.database.watchActiveCustomers(),
          builder: (context, customerSnapshot) {
            final customers = customerSnapshot.data ?? const <Customer>[];
            final selectedCustomer = _selectedCustomer(customers);
            if (_selectedCustomerId != null && selectedCustomer == null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  setState(() => _selectedCustomerId = null);
                }
              });
            }

            return StreamBuilder<List<Product>>(
              stream: widget.database.watchActiveProducts(),
              builder: (context, productSnapshot) {
                final products = productSnapshot.data ?? const <Product>[];
                final selectedProduct = _selectedProduct(products);
                if (_selectedProductId != null && selectedProduct == null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      setState(() => _selectedProductId = null);
                    }
                  });
                }

                final totals = _totals;
                final loading =
                    customerSnapshot.connectionState ==
                        ConnectionState.waiting ||
                    productSnapshot.connectionState == ConnectionState.waiting;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('ขาย', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 14),
                    Expanded(
                      child: loading
                          ? const Center(child: CircularProgressIndicator())
                          : _SaleWorkspace(
                              customers: customers,
                              products: products,
                              selectedCustomerId: _selectedCustomerId,
                              selectedProductId: _selectedProductId,
                              cartItems: _cartItems,
                              quantityController: _quantityController,
                              productQuantityFocusNode:
                                  _productQuantityFocusNode,
                              downPaymentAmountController:
                                  _downPaymentAmountController,
                              downPaymentFocusNode: _downPaymentFocusNode,
                              downPaymentAmountListenable:
                                  _downPaymentAmountController,
                              calculateTotals: () => _totals,
                              downPaymentInputMode: _downPaymentInputMode,
                              vatOption: _vatOption,
                              installmentCount: _installmentCount,
                              totals: totals,
                              saving: _saving,
                              onCustomerChanged: (value) {
                                setState(() => _selectedCustomerId = value);
                              },
                              onProductChanged: (value) {
                                setState(() => _selectedProductId = value);
                                if (value != null) {
                                  WidgetsBinding.instance.addPostFrameCallback((
                                    _,
                                  ) {
                                    if (mounted) {
                                      _productQuantityFocusNode.requestFocus();
                                    }
                                  });
                                }
                              },
                              onAddToCart: () => _addToCart(selectedProduct),
                              onCartQuantityChanged: _updateCartQuantity,
                              onRemoveCartItem: _removeCartItem,
                              onVatOptionChanged: (value) {
                                setState(() => _vatOption = value);
                              },
                              onInstallmentChanged: (value) {
                                setState(() => _installmentCount = value);
                                WidgetsBinding.instance.addPostFrameCallback((
                                  _,
                                ) {
                                  if (mounted) {
                                    _downPaymentFocusNode.requestFocus();
                                  }
                                });
                              },
                              onDownPaymentInputModeChanged:
                                  _changeDownPaymentInputMode,
                              onSave: () =>
                                  _saveSale(customer: selectedCustomer),
                            ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _SaleWorkspace extends StatelessWidget {
  const _SaleWorkspace({
    required this.customers,
    required this.products,
    required this.selectedCustomerId,
    required this.selectedProductId,
    required this.cartItems,
    required this.quantityController,
    required this.productQuantityFocusNode,
    required this.downPaymentAmountController,
    required this.downPaymentFocusNode,
    required this.downPaymentAmountListenable,
    required this.calculateTotals,
    required this.downPaymentInputMode,
    required this.vatOption,
    required this.installmentCount,
    required this.totals,
    required this.saving,
    required this.onCustomerChanged,
    required this.onProductChanged,
    required this.onAddToCart,
    required this.onCartQuantityChanged,
    required this.onRemoveCartItem,
    required this.onVatOptionChanged,
    required this.onInstallmentChanged,
    required this.onDownPaymentInputModeChanged,
    required this.onSave,
  });

  final List<Customer> customers;
  final List<Product> products;
  final String? selectedCustomerId;
  final String? selectedProductId;
  final List<_SaleCartItem> cartItems;
  final TextEditingController quantityController;
  final FocusNode productQuantityFocusNode;
  final TextEditingController downPaymentAmountController;
  final FocusNode downPaymentFocusNode;
  final ValueListenable<TextEditingValue> downPaymentAmountListenable;
  final SaleTotals Function() calculateTotals;
  final _DownPaymentInputMode downPaymentInputMode;
  final SaleVatOption vatOption;
  final int installmentCount;
  final SaleTotals totals;
  final bool saving;
  final ValueChanged<String?> onCustomerChanged;
  final ValueChanged<String?> onProductChanged;
  final VoidCallback onAddToCart;
  final void Function(Product product, double quantity) onCartQuantityChanged;
  final ValueChanged<Product> onRemoveCartItem;
  final ValueChanged<SaleVatOption> onVatOptionChanged;
  final ValueChanged<int> onInstallmentChanged;
  final ValueChanged<_DownPaymentInputMode> onDownPaymentInputModeChanged;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final form = _SaleFormPanel(
          customers: customers,
          selectedCustomerId: selectedCustomerId,
          downPaymentAmountController: downPaymentAmountController,
          downPaymentFocusNode: downPaymentFocusNode,
          downPaymentAmountListenable: downPaymentAmountListenable,
          calculateTotals: calculateTotals,
          downPaymentInputMode: downPaymentInputMode,
          installmentCount: installmentCount,
          totals: totals,
          saving: saving,
          onCustomerChanged: onCustomerChanged,
          onInstallmentChanged: onInstallmentChanged,
          onDownPaymentInputModeChanged: onDownPaymentInputModeChanged,
          onSave: onSave,
        );
        final cart = _SaleCartPanel(
          products: products,
          selectedProductId: selectedProductId,
          quantityController: quantityController,
          productQuantityFocusNode: productQuantityFocusNode,
          cartItems: cartItems,
          vatOption: vatOption,
          installmentCount: installmentCount,
          downPaymentAmountListenable: downPaymentAmountListenable,
          calculateTotals: calculateTotals,
          onProductChanged: onProductChanged,
          onAddToCart: onAddToCart,
          onQuantityChanged: onCartQuantityChanged,
          onRemove: onRemoveCartItem,
          onVatOptionChanged: onVatOptionChanged,
        );

        if (constraints.maxWidth < 1160) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [form, const SizedBox(height: 16), cart],
            ),
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(width: 430, child: form),
            const SizedBox(width: 16),
            Expanded(child: cart),
          ],
        );
      },
    );
  }
}

class _SaleCartItem {
  const _SaleCartItem({required this.product, required this.quantity});

  final Product product;
  final double quantity;

  double get lineTotal => product.salePrice * quantity;

  SaleItemPayload toPayload() {
    return SaleItemPayload(product: product, quantity: quantity);
  }

  _SaleCartItem copyWith({double? quantity}) {
    return _SaleCartItem(product: product, quantity: quantity ?? this.quantity);
  }
}

enum _DownPaymentInputMode { amount, percent }

class _SaleToggleOption<T> {
  const _SaleToggleOption({
    required this.value,
    required this.icon,
    required this.label,
    this.selectedIcon,
    this.labelKey,
  });

  final T value;
  final IconData icon;
  final IconData? selectedIcon;
  final String label;
  final Key? labelKey;
}

class _SaleToggleGroup<T> extends StatelessWidget {
  const _SaleToggleGroup({
    required this.options,
    required this.selectedValue,
    required this.onChanged,
  });

  final List<_SaleToggleOption<T>> options;
  final T selectedValue;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FBFA),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD8E7E4)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x080F172A),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Row(
          children: [
            for (final option in options)
              Expanded(
                child: _SaleToggleButton<T>(
                  option: option,
                  selected: option.value == selectedValue,
                  onTap: () => onChanged(option.value),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SaleToggleButton<T> extends StatelessWidget {
  const _SaleToggleButton({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final _SaleToggleOption<T> option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? _primaryColor : const Color(0xFF475569);
    final iconColor = selected ? _surfaceColor : _primaryColor;
    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOut,
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: selected ? _surfaceColor : Colors.transparent,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: selected ? const Color(0xFFB7DDD6) : Colors.transparent,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: _primaryColor.withValues(alpha: 0.14),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: selected ? _primaryColor : const Color(0xFFE6F4F1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Icon(
                        selected
                            ? option.selectedIcon ?? option.icon
                            : option.icon,
                        size: 14,
                        color: iconColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    option.label,
                    key: option.labelKey,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: foreground,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SaleFormPanel extends StatelessWidget {
  const _SaleFormPanel({
    required this.customers,
    required this.selectedCustomerId,
    required this.downPaymentAmountController,
    required this.downPaymentFocusNode,
    required this.downPaymentAmountListenable,
    required this.calculateTotals,
    required this.downPaymentInputMode,
    required this.installmentCount,
    required this.totals,
    required this.saving,
    required this.onCustomerChanged,
    required this.onInstallmentChanged,
    required this.onDownPaymentInputModeChanged,
    required this.onSave,
  });

  final List<Customer> customers;
  final String? selectedCustomerId;
  final TextEditingController downPaymentAmountController;
  final FocusNode downPaymentFocusNode;
  final ValueListenable<TextEditingValue> downPaymentAmountListenable;
  final SaleTotals Function() calculateTotals;
  final _DownPaymentInputMode downPaymentInputMode;
  final int installmentCount;
  final SaleTotals totals;
  final bool saving;
  final ValueChanged<String?> onCustomerChanged;
  final ValueChanged<int> onInstallmentChanged;
  final ValueChanged<_DownPaymentInputMode> onDownPaymentInputModeChanged;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final formContent = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _CustomerFormSection(
          icon: SolarIconsOutline.cartLarge,
          iconColor: _primaryColor,
          title: 'ข้อมูลการขาย',
          children: [
            _SaleCustomerSearchField(
              fieldKey: const ValueKey('sale-customer-search-field'),
              label: 'ค้นหาลูกค้า',
              icon: SolarIconsOutline.userSpeakRounded,
              customers: customers,
              selectedCustomerId: selectedCustomerId,
              onChanged: onCustomerChanged,
            ),
          ],
        ),
        const SizedBox(height: 22),
        _CustomerFormSection(
          icon: SolarIconsOutline.walletMoney,
          iconColor: const Color(0xFFEA580C),
          title: 'เงินดาวน์',
          children: [
            Text(
              'จำนวนงวด',
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            _SaleInstallmentSelector(
              selectedCount: installmentCount,
              onChanged: onInstallmentChanged,
            ),
            const SizedBox(height: 14),
            _SaleDownPaymentInputRow(
              controller: downPaymentAmountController,
              focusNode: downPaymentFocusNode,
              amountListenable: downPaymentAmountListenable,
              inputMode: downPaymentInputMode,
              calculateTotals: calculateTotals,
              onInputModeChanged: onDownPaymentInputModeChanged,
            ),
          ],
        ),
      ],
    );
    final saveButton = FilledButton.icon(
      onPressed: saving ? null : onSave,
      icon: saving
          ? const SizedBox.square(
              dimension: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(SolarIconsOutline.diskette),
      label: Text(saving ? 'กำลังบันทึก...' : 'บันทึกการขาย'),
    );

    return DecoratedBox(
      decoration: _surfaceDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (!constraints.hasBoundedHeight) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    formContent,
                    const SizedBox(height: 22),
                    saveButton,
                  ],
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: SingleChildScrollView(child: formContent)),
                const SizedBox(height: 16),
                saveButton,
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SaleDownPaymentInputRow extends StatelessWidget {
  const _SaleDownPaymentInputRow({
    required this.controller,
    required this.focusNode,
    required this.amountListenable,
    required this.inputMode,
    required this.calculateTotals,
    required this.onInputModeChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueListenable<TextEditingValue> amountListenable;
  final _DownPaymentInputMode inputMode;
  final SaleTotals Function() calculateTotals;
  final ValueChanged<_DownPaymentInputMode> onInputModeChanged;

  @override
  Widget build(BuildContext context) {
    final isPercentMode = inputMode == _DownPaymentInputMode.percent;
    final modeSelector = _SaleToggleGroup<_DownPaymentInputMode>(
      options: const [
        _SaleToggleOption(
          value: _DownPaymentInputMode.amount,
          icon: SolarIconsOutline.walletMoney,
          label: 'จำนวนเงิน',
          labelKey: ValueKey('sale-down-payment-mode-amount'),
        ),
        _SaleToggleOption(
          value: _DownPaymentInputMode.percent,
          icon: SolarIconsOutline.calculatorMinimalistic,
          label: '%',
          labelKey: ValueKey('sale-down-payment-mode-percent'),
        ),
      ],
      selectedValue: inputMode,
      onChanged: onInputModeChanged,
    );
    final amountField = _CustomerTextField(
      controller: controller,
      label: isPercentMode ? 'เงินดาวน์ (%)' : 'ยอดเงินดาวน์',
      placeholder: isPercentMode ? '20' : '0.00',
      icon: isPercentMode
          ? SolarIconsOutline.calculatorMinimalistic
          : SolarIconsOutline.walletMoney,
      fieldKey: const ValueKey('sale-down-payment-amount-field'),
      focusNode: focusNode,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      required: true,
    );
    final helper = ValueListenableBuilder<TextEditingValue>(
      valueListenable: amountListenable,
      builder: (context, value, child) {
        final currentTotals = calculateTotals();
        final text = isPercentMode
            ? 'ยอดดาวน์ ${_formatSalePrice(currentTotals.downPaymentAmount)} บาท'
            : 'คิดเป็น ${_formatPercent(currentTotals.downPaymentPercent)}% ของยอดรวม';
        return Text(
          text,
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: const Color(0xFF64748B)),
        );
      },
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 360) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: modeSelector,
              ),
              const SizedBox(height: 10),
              amountField,
              const SizedBox(height: 6),
              helper,
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 224, child: modeSelector),
                const SizedBox(width: 12),
                Expanded(child: amountField),
              ],
            ),
            const SizedBox(height: 6),
            helper,
          ],
        );
      },
    );
  }
}

class _SaleInstallmentSelector extends StatelessWidget {
  const _SaleInstallmentSelector({
    required this.selectedCount,
    required this.onChanged,
  });

  final int selectedCount;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const columns = 5;
        const gap = 8.0;
        final itemWidth =
            (constraints.maxWidth - (gap * (columns - 1))) / columns;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (var count = 1; count <= 10; count++)
              SizedBox(
                width: itemWidth,
                child: _SaleInstallmentOption(
                  count: count,
                  selected: selectedCount == count,
                  onTap: () => onChanged(count),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _SaleInstallmentOption extends StatelessWidget {
  const _SaleInstallmentOption({
    required this.count,
    required this.selected,
    required this.onTap,
  });

  final int count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? _primaryColor : const Color(0xFF64748B);
    return GestureDetector(
      key: ValueKey('sale-installment-$count'),
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? _softMintColor : _surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? const Color(0xFF9FD8CE) : _surfaceBorderColor,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: _primaryColor.withValues(alpha: 0.12),
                    blurRadius: 14,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  selected
                      ? SolarIconsBold.calendarMinimalistic
                      : SolarIconsOutline.calendarMinimalistic,
                  size: 16,
                  color: color,
                ),
                const SizedBox(width: 6),
                Text(
                  '$count งวด',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SaleTotalSummaryCard extends StatelessWidget {
  const _SaleTotalSummaryCard({
    required this.vatOption,
    required this.installmentCount,
    required this.downPaymentAmountListenable,
    required this.calculateTotals,
    required this.onVatOptionChanged,
  });

  final SaleVatOption vatOption;
  final int installmentCount;
  final ValueListenable<TextEditingValue> downPaymentAmountListenable;
  final SaleTotals Function() calculateTotals;
  final ValueChanged<SaleVatOption> onVatOptionChanged;

  @override
  Widget build(BuildContext context) {
    final title = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(
          SolarIconsOutline.calculatorMinimalistic,
          color: _primaryColor,
          size: 20,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'สรุปราคารวม',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
          ),
        ),
      ],
    );
    final vatSelector = _SaleToggleGroup<SaleVatOption>(
      options: const [
        _SaleToggleOption(
          value: SaleVatOption.none,
          icon: SolarIconsOutline.bill,
          label: 'ไม่มี VAT',
        ),
        _SaleToggleOption(
          value: SaleVatOption.excluded,
          icon: SolarIconsOutline.billCheck,
          label: 'VAT 7% แยก',
        ),
        _SaleToggleOption(
          value: SaleVatOption.included,
          icon: SolarIconsOutline.billList,
          label: 'VAT 7% รวม',
        ),
      ],
      selectedValue: vatOption,
      onChanged: onVatOptionChanged,
    );

    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: _surfaceBorderColor)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: LayoutBuilder(
          builder: (context, constraints) {
            Widget header;
            if (constraints.maxWidth >= 520) {
              var selectorWidth = constraints.maxWidth - 170;
              if (selectorWidth > 430) {
                selectorWidth = 430;
              }

              header = Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: title),
                  const SizedBox(width: 18),
                  SizedBox(width: selectorWidth, child: vatSelector),
                ],
              );
            } else {
              header = Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [title, const SizedBox(height: 12), vatSelector],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                header,
                const SizedBox(height: 8),
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: downPaymentAmountListenable,
                  builder: (context, value, child) {
                    return _SaleAccountingStatement(
                      totals: calculateTotals(),
                      installmentCount: installmentCount,
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SaleAccountingStatement extends StatelessWidget {
  const _SaleAccountingStatement({
    required this.totals,
    required this.installmentCount,
  });

  final SaleTotals totals;
  final int installmentCount;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: _surfaceBorderColor),
          bottom: BorderSide(color: _surfaceBorderColor),
        ),
      ),
      child: Column(
        children: [
          _SaleAccountingRow(
            label: 'ยอดก่อน VAT',
            amount: _formatSalePrice(totals.subtotal),
            unit: 'บาท',
          ),
          _SaleAccountingRow(
            label: 'VAT',
            amount: _formatSalePrice(totals.vatAmount),
            unit: 'บาท',
            amountColor: const Color(0xFF7C3AED),
          ),
          _SaleAccountingRow(
            label: 'ยอดรวม',
            amount: _formatSalePrice(totals.grandTotal),
            unit: 'บาท',
            amountKey: const ValueKey('sale-summary-grand-total-amount'),
            amountColor: _primaryColor,
            emphasized: true,
            showDivider: true,
          ),
          _SaleAccountingRow(
            label: 'เงินดาวน์',
            amount: _formatSalePrice(totals.downPaymentAmount),
            unit: 'บาท',
            amountColor: const Color(0xFFEA580C),
          ),
          _SaleAccountingRow(
            label: 'ยอดคงเหลือ',
            amount: _formatSalePrice(totals.remainingAmount),
            unit: 'บาท',
            showDivider: true,
          ),
          _SaleAccountingRow(
            label: 'ค่างวด',
            detail: '$installmentCount งวด',
            amount: _formatSalePrice(totals.installmentAmount),
            unit: 'บาท/งวด',
            amountKey: const ValueKey('sale-summary-installment-amount'),
            amountColor: _primaryColor,
            emphasized: true,
          ),
        ],
      ),
    );
  }
}

class _SaleAccountingRow extends StatelessWidget {
  const _SaleAccountingRow({
    required this.label,
    required this.amount,
    required this.unit,
    this.detail,
    this.amountKey,
    this.amountColor,
    this.emphasized = false,
    this.showDivider = false,
  });

  final String label;
  final String amount;
  final String unit;
  final String? detail;
  final Key? amountKey;
  final Color? amountColor;
  final bool emphasized;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: const Color(0xFF334155),
      fontWeight: emphasized ? FontWeight.w800 : FontWeight.w600,
    );
    final amountStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: amountColor ?? const Color(0xFF334155),
      fontWeight: emphasized ? FontWeight.w900 : FontWeight.w700,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
    final unitStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: const Color(0xFF64748B),
      fontWeight: emphasized ? FontWeight.w800 : FontWeight.w600,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: showDivider ? _surfaceBorderColor : Colors.transparent,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: showDivider ? 7 : 4),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final labelWidth = constraints.maxWidth >= 430 ? 122.0 : 96.0;
            final amountWidth = constraints.maxWidth >= 430 ? 150.0 : 118.0;
            final unitWidth = constraints.maxWidth >= 430 ? 68.0 : 60.0;
            final gap = constraints.maxWidth >= 430 ? 14.0 : 8.0;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                SizedBox(
                  width: labelWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        label,
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                        style: labelStyle,
                      ),
                      if (detail != null)
                        Text(
                          detail!,
                          textAlign: TextAlign.right,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(color: const Color(0xFF64748B)),
                        ),
                    ],
                  ),
                ),
                SizedBox(width: gap),
                SizedBox(
                  width: amountWidth,
                  child: Text(
                    amount,
                    key: amountKey,
                    textAlign: TextAlign.right,
                    style: amountStyle,
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: unitWidth,
                  child: Text(
                    unit,
                    textAlign: TextAlign.left,
                    style: unitStyle,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SaleCustomerSearchField extends StatelessWidget {
  const _SaleCustomerSearchField({
    required this.fieldKey,
    required this.label,
    required this.icon,
    required this.customers,
    required this.selectedCustomerId,
    required this.onChanged,
  });

  final Key fieldKey;
  final String label;
  final IconData icon;
  final List<Customer> customers;
  final String? selectedCustomerId;
  final ValueChanged<String?> onChanged;

  Customer? get _selectedCustomer {
    final id = selectedCustomerId;
    if (id == null) {
      return null;
    }
    for (final customer in customers) {
      if (customer.id == id) {
        return customer;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final selectedCustomer = _selectedCustomer;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SaleSearchField<Customer>(
          fieldKey: fieldKey,
          label: label,
          icon: icon,
          emptyText: 'ไม่พบลูกค้า',
          items: customers,
          selectedValue: selectedCustomerId,
          itemValue: (customer) => customer.id,
          itemLabel: (customer) => customer.name,
          itemSearchText: (customer) => [
            customer.name,
            customer.nickname ?? '',
            customer.phone ?? '',
            customer.lineId ?? '',
            customer.taxId ?? '',
            customer.province ?? '',
          ].join(' '),
          optionBuilder: (context, customer, selected) {
            return _SaleCustomerOption(customer: customer, selected: selected);
          },
          onChanged: onChanged,
        ),
        if (selectedCustomer != null) ...[
          const SizedBox(height: 8),
          _SaleCustomerStatusBadge(
            isBlacklisted: selectedCustomer.isBlacklisted,
          ),
        ],
        if (selectedCustomer?.isBlacklisted == true) ...[
          const SizedBox(height: 8),
          const _SaleBlacklistWarning(),
        ],
      ],
    );
  }
}

class _SaleProductSearchField extends StatelessWidget {
  const _SaleProductSearchField({
    required this.fieldKey,
    required this.label,
    required this.icon,
    required this.products,
    required this.selectedProductId,
    required this.onChanged,
  });

  final Key fieldKey;
  final String label;
  final IconData icon;
  final List<Product> products;
  final String? selectedProductId;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return _SaleSearchField<Product>(
      fieldKey: fieldKey,
      label: label,
      icon: icon,
      emptyText: 'ไม่พบสินค้า',
      items: products,
      selectedValue: selectedProductId,
      itemValue: (product) => product.id,
      itemLabel: (product) => '${product.code} - ${product.name}',
      itemSearchText: (product) => [
        product.code,
        product.name,
        _formatSalePrice(product.salePrice),
        product.remark ?? '',
      ].join(' '),
      optionBuilder: (context, product, selected) {
        return _SaleProductOption(product: product, selected: selected);
      },
      onChanged: onChanged,
    );
  }
}

class _SaleSearchField<T> extends StatefulWidget {
  const _SaleSearchField({
    required this.fieldKey,
    required this.label,
    required this.icon,
    required this.emptyText,
    required this.items,
    required this.selectedValue,
    required this.itemValue,
    required this.itemLabel,
    required this.itemSearchText,
    required this.optionBuilder,
    required this.onChanged,
  });

  final Key fieldKey;
  final String label;
  final IconData icon;
  final String emptyText;
  final List<T> items;
  final String? selectedValue;
  final String Function(T item) itemValue;
  final String Function(T item) itemLabel;
  final String Function(T item) itemSearchText;
  final Widget Function(BuildContext context, T item, bool selected)
  optionBuilder;
  final ValueChanged<String?> onChanged;

  @override
  State<_SaleSearchField<T>> createState() => _SaleSearchFieldState<T>();
}

class _SaleSearchFieldState<T> extends State<_SaleSearchField<T>> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  var _query = '';

  String? get _selectedLabel {
    final value = widget.selectedValue;
    if (value == null) {
      return null;
    }
    for (final item in widget.items) {
      if (widget.itemValue(item) == value) {
        return widget.itemLabel(item);
      }
    }
    return null;
  }

  List<T> get _options {
    final query = _query.trim().toLowerCase();
    final matches = query.isEmpty
        ? widget.items
        : widget.items.where((item) {
            return widget.itemSearchText(item).toLowerCase().contains(query);
          }).toList();
    return matches.take(8).toList();
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _selectedLabel ?? '');
    _query = _controller.text;
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChanged);
  }

  @override
  void didUpdateWidget(covariant _SaleSearchField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_focusNode.hasFocus) {
      final selectedLabel = _selectedLabel ?? '';
      if (_controller.text != selectedLabel) {
        _controller.text = selectedLabel;
      }
      _query = _controller.text;
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChanged);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _handleFocusChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _handleTextChanged(String value) {
    final selectedLabel = _selectedLabel;
    if (widget.selectedValue != null && value != selectedLabel) {
      widget.onChanged(null);
    }
    setState(() => _query = value);
  }

  void _select(T item) {
    final label = widget.itemLabel(item);
    _controller.text = label;
    _query = label;
    widget.onChanged(widget.itemValue(item));
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final options = _options;
    final showOptions = _focusNode.hasFocus;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          key: widget.fieldKey,
          controller: _controller,
          focusNode: _focusNode,
          decoration: InputDecoration(
            labelText: widget.label,
            prefixIcon: Icon(widget.icon),
            suffixIcon: _controller.text.isEmpty
                ? null
                : IconButton(
                    tooltip: 'ล้าง',
                    onPressed: () {
                      _controller.clear();
                      widget.onChanged(null);
                      setState(() => _query = '');
                      _focusNode.requestFocus();
                    },
                    icon: const Icon(SolarIconsOutline.closeCircle),
                  ),
          ),
          onChanged: _handleTextChanged,
        ),
        if (showOptions) ...[
          const SizedBox(height: 8),
          DecoratedBox(
            decoration: BoxDecoration(
              color: _surfaceColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _surfaceBorderColor),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 180),
              child: options.isEmpty
                  ? SizedBox(
                      height: 48,
                      child: Center(child: Text(widget.emptyText)),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      itemCount: options.length,
                      separatorBuilder: (context, index) {
                        return const Divider(height: 1);
                      },
                      itemBuilder: (context, index) {
                        final item = options[index];
                        final selected =
                            widget.selectedValue == widget.itemValue(item);
                        return Semantics(
                          button: true,
                          onTap: () => _select(item),
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTapDown: (_) => _select(item),
                            child: widget.optionBuilder(
                              context,
                              item,
                              selected,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ],
    );
  }
}

class _SaleCustomerOption extends StatelessWidget {
  const _SaleCustomerOption({required this.customer, required this.selected});

  final Customer customer;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Icon(
            selected
                ? SolarIconsBold.userSpeakRounded
                : SolarIconsOutline.userSpeakRounded,
            color: customer.isBlacklisted
                ? const Color(0xFFDC2626)
                : _primaryColor,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customer.name,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                Text(
                  [customer.nickname, customer.phone, customer.province]
                      .whereType<String>()
                      .where((value) => value.trim().isNotEmpty)
                      .join(' / '),
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          if (customer.isBlacklisted) const _SaleBlacklistBadge(),
        ],
      ),
    );
  }
}

class _SaleProductOption extends StatelessWidget {
  const _SaleProductOption({required this.product, required this.selected});

  final Product product;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Icon(
            selected ? SolarIconsBold.box : SolarIconsOutline.box,
            color: _primaryColor,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${product.code} - ${product.name}',
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                Text(
                  _displayText(product.remark),
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          Text(
            _formatSalePrice(product.salePrice),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: _primaryColor,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _SaleBlacklistBadge extends StatelessWidget {
  const _SaleBlacklistBadge();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFFEE2E2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFCA5A5)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          'แบล็คลิสต์',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: const Color(0xFFB91C1C),
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _SaleCustomerStatusBadge extends StatelessWidget {
  const _SaleCustomerStatusBadge({required this.isBlacklisted});

  final bool isBlacklisted;

  @override
  Widget build(BuildContext context) {
    final color = isBlacklisted ? const Color(0xFFDC2626) : _primaryColor;
    return Align(
      alignment: Alignment.centerLeft,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isBlacklisted ? const Color(0xFFFEF2F2) : _softMintColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isBlacklisted
                ? const Color(0xFFFCA5A5)
                : const Color(0xFFD7F3EE),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isBlacklisted
                    ? SolarIconsOutline.forbidden
                    : SolarIconsOutline.checkCircle,
                size: 16,
                color: color,
              ),
              const SizedBox(width: 6),
              Text(
                isBlacklisted ? 'แบล็คลิสต์' : 'ปกติ',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SaleBlacklistWarning extends StatelessWidget {
  const _SaleBlacklistWarning();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFDA4AF)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        child: Row(
          children: [
            const Icon(
              SolarIconsOutline.forbidden,
              color: Color(0xFFE11D48),
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'ลูกค้ารายนี้ติดแบล็คลิสต์',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: const Color(0xFFBE123C),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SaleCartPanel extends StatelessWidget {
  const _SaleCartPanel({
    required this.products,
    required this.selectedProductId,
    required this.quantityController,
    required this.productQuantityFocusNode,
    required this.cartItems,
    required this.vatOption,
    required this.installmentCount,
    required this.downPaymentAmountListenable,
    required this.calculateTotals,
    required this.onProductChanged,
    required this.onAddToCart,
    required this.onQuantityChanged,
    required this.onRemove,
    required this.onVatOptionChanged,
  });

  final List<Product> products;
  final String? selectedProductId;
  final TextEditingController quantityController;
  final FocusNode productQuantityFocusNode;
  final List<_SaleCartItem> cartItems;
  final SaleVatOption vatOption;
  final int installmentCount;
  final ValueListenable<TextEditingValue> downPaymentAmountListenable;
  final SaleTotals Function() calculateTotals;
  final ValueChanged<String?> onProductChanged;
  final VoidCallback onAddToCart;
  final void Function(Product product, double quantity) onQuantityChanged;
  final ValueChanged<Product> onRemove;
  final ValueChanged<SaleVatOption> onVatOptionChanged;

  @override
  Widget build(BuildContext context) {
    final header = Row(
      children: [
        const Icon(SolarIconsOutline.cartLarge, color: _primaryColor),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'รายการสินค้า',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
    final inputBar = _SaleCartInputBar(
      products: products,
      selectedProductId: selectedProductId,
      quantityController: quantityController,
      productQuantityFocusNode: productQuantityFocusNode,
      onProductChanged: onProductChanged,
      onAddToCart: onAddToCart,
    );
    final cartItemsArea = _SaleCartItemsArea(
      cartItems: cartItems,
      onQuantityChanged: onQuantityChanged,
      onRemove: onRemove,
    );
    final summaryCard = _SaleTotalSummaryCard(
      vatOption: vatOption,
      installmentCount: installmentCount,
      downPaymentAmountListenable: downPaymentAmountListenable,
      calculateTotals: calculateTotals,
      onVatOptionChanged: onVatOptionChanged,
    );

    return DecoratedBox(
      decoration: _surfaceDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (!constraints.hasBoundedHeight) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    header,
                    const SizedBox(height: 14),
                    inputBar,
                    const SizedBox(height: 14),
                    cartItemsArea,
                    const SizedBox(height: 16),
                    summaryCard,
                  ],
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                header,
                const SizedBox(height: 14),
                inputBar,
                const SizedBox(height: 14),
                Expanded(child: cartItemsArea),
                const SizedBox(height: 16),
                summaryCard,
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SaleCartItemsArea extends StatelessWidget {
  const _SaleCartItemsArea({
    required this.cartItems,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  final List<_SaleCartItem> cartItems;
  final void Function(Product product, double quantity) onQuantityChanged;
  final ValueChanged<Product> onRemove;

  @override
  Widget build(BuildContext context) {
    if (cartItems.isEmpty) {
      return const SizedBox(
        height: 130,
        child: Center(child: Text('ยังไม่มีรายการสินค้า')),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: LayoutBuilder(
        builder: (context, tableConstraints) {
          return SingleChildScrollView(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: tableConstraints.maxWidth,
                ),
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(_softSlateColor),
                  dataRowMinHeight: 58,
                  dataRowMaxHeight: 74,
                  headingTextStyle: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
                  columns: const [
                    DataColumn(label: Text('รหัส')),
                    DataColumn(label: Text('สินค้า')),
                    DataColumn(label: Text('จำนวน')),
                    DataColumn(label: Text('ราคา')),
                    DataColumn(label: Text('รวม')),
                    DataColumn(label: Text('จัดการ')),
                  ],
                  rows: [
                    for (final item in cartItems)
                      DataRow(
                        cells: [
                          DataCell(Text(item.product.code)),
                          DataCell(
                            SizedBox(
                              width: 190,
                              child: Text(
                                item.product.name,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          DataCell(
                            SizedBox(
                              width: 92,
                              child: _SaleCartQuantityField(
                                key: ValueKey(
                                  'cart-qty-field-${item.product.id}',
                                ),
                                product: item.product,
                                quantity: item.quantity,
                                onQuantityChanged: onQuantityChanged,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(_formatSalePrice(item.product.salePrice)),
                          ),
                          DataCell(Text(_formatSalePrice(item.lineTotal))),
                          DataCell(
                            IconButton(
                              tooltip: 'ลบรายการสินค้า',
                              onPressed: () => onRemove(item.product),
                              icon: const Icon(
                                SolarIconsOutline.trashBinMinimalistic,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SaleCartInputBar extends StatelessWidget {
  const _SaleCartInputBar({
    required this.products,
    required this.selectedProductId,
    required this.quantityController,
    required this.productQuantityFocusNode,
    required this.onProductChanged,
    required this.onAddToCart,
  });

  final List<Product> products;
  final String? selectedProductId;
  final TextEditingController quantityController;
  final FocusNode productQuantityFocusNode;
  final ValueChanged<String?> onProductChanged;
  final VoidCallback onAddToCart;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final productField = _SaleProductSearchField(
          fieldKey: const ValueKey('sale-product-search-field'),
          label: 'ค้นหาสินค้า',
          icon: SolarIconsOutline.box,
          products: products,
          selectedProductId: selectedProductId,
          onChanged: onProductChanged,
        );
        final quantityField = _CustomerTextField(
          controller: quantityController,
          label: 'จำนวน',
          placeholder: '1',
          icon: SolarIconsOutline.boxMinimalistic,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          required: true,
          fieldKey: const ValueKey('sale-product-quantity-field'),
          focusNode: productQuantityFocusNode,
        );
        final addButton = FilledButton.icon(
          onPressed: onAddToCart,
          icon: const Icon(SolarIconsOutline.cartPlus),
          label: const Text('เพิ่มรายการ'),
        );

        if (constraints.maxWidth < 720) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              productField,
              const SizedBox(height: 12),
              quantityField,
              const SizedBox(height: 12),
              addButton,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 5, child: productField),
            const SizedBox(width: 12),
            SizedBox(width: 130, child: quantityField),
            const SizedBox(width: 12),
            SizedBox(width: 150, child: addButton),
          ],
        );
      },
    );
  }
}

class _SaleCartQuantityField extends StatefulWidget {
  const _SaleCartQuantityField({
    super.key,
    required this.product,
    required this.quantity,
    required this.onQuantityChanged,
  });

  final Product product;
  final double quantity;
  final void Function(Product product, double quantity) onQuantityChanged;

  @override
  State<_SaleCartQuantityField> createState() => _SaleCartQuantityFieldState();
}

class _SaleCartQuantityFieldState extends State<_SaleCartQuantityField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _formatPercent(widget.quantity));
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChanged);
  }

  @override
  void didUpdateWidget(covariant _SaleCartQuantityField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_focusNode.hasFocus && widget.quantity != oldWidget.quantity) {
      _controller.text = _formatPercent(widget.quantity);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChanged);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _handleFocusChanged() {
    if (!_focusNode.hasFocus) {
      _commit();
    }
  }

  void _commit() {
    final quantity = _parseSalePrice(_controller.text);
    if (quantity == null || quantity <= 0) {
      _controller.text = _formatPercent(widget.quantity);
      return;
    }

    if (quantity != widget.quantity) {
      widget.onQuantityChanged(widget.product, quantity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: const ValueKey('cart-qty-field'),
      controller: _controller,
      focusNode: _focusNode,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      ),
      onFieldSubmitted: (_) => _commit(),
    );
  }
}

String _formatPercent(double value) {
  if (value % 1 == 0) {
    return value.toStringAsFixed(0);
  }
  return value.toStringAsFixed(2);
}
