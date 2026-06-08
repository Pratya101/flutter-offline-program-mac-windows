part of '../../../main.dart';

class SalePage extends StatefulWidget {
  const SalePage({
    super.key,
    required this.database,
    required this.saleService,
    required this.receiverName,
    required this.onSaleCreated,
  });

  final AppDatabase database;
  final SaleService saleService;
  final String receiverName;
  final ValueChanged<Sale> onSaleCreated;

  @override
  State<SalePage> createState() => _SalePageState();
}

class _SalePageState extends State<SalePage> {
  final _quantityController = TextEditingController(text: '1');
  final _downPaymentAmountController = TextEditingController(text: '0');
  final _productQuantityFocusNode = FocusNode();
  final _downPaymentFocusNode = FocusNode();

  final _selectedCustomerIdNotifier = ValueNotifier<String?>(null);
  final _selectedProductIdNotifier = ValueNotifier<String?>(null);
  Customer? _pendingSelectedCustomer;
  Product? _pendingSelectedProduct;
  final _cartItemsNotifier = ValueNotifier<List<_SaleCartItem>>(
    const <_SaleCartItem>[],
  );
  final _vatOptionNotifier = ValueNotifier<SaleVatOption>(SaleVatOption.none);
  final _installmentCountNotifier = ValueNotifier<int>(1);
  final _firstDueDateNotifier = ValueNotifier<DateTime>(_defaultFirstDueDate());
  final _downPaymentInputModeNotifier = ValueNotifier<_DownPaymentInputMode>(
    _DownPaymentInputMode.amount,
  );
  final _savingNotifier = ValueNotifier<bool>(false);

  String? get _selectedCustomerId => _selectedCustomerIdNotifier.value;
  set _selectedCustomerId(String? value) {
    if (_selectedCustomerIdNotifier.value != value) {
      _selectedCustomerIdNotifier.value = value;
    }
  }

  String? get _selectedProductId => _selectedProductIdNotifier.value;
  set _selectedProductId(String? value) {
    if (_selectedProductIdNotifier.value != value) {
      _selectedProductIdNotifier.value = value;
    }
  }

  List<_SaleCartItem> get _cartItems => _cartItemsNotifier.value;
  set _cartItems(List<_SaleCartItem> value) {
    _cartItemsNotifier.value = List<_SaleCartItem>.unmodifiable(value);
  }

  SaleVatOption get _vatOption => _vatOptionNotifier.value;
  set _vatOption(SaleVatOption value) {
    if (_vatOptionNotifier.value != value) {
      _vatOptionNotifier.value = value;
    }
  }

  int get _installmentCount => _installmentCountNotifier.value;
  set _installmentCount(int value) {
    if (_installmentCountNotifier.value != value) {
      _installmentCountNotifier.value = value;
    }
  }

  DateTime get _firstDueDate => _firstDueDateNotifier.value;
  set _firstDueDate(DateTime value) {
    final nextDate = _dateOnlyForSale(value);
    if (_firstDueDateNotifier.value != nextDate) {
      _firstDueDateNotifier.value = nextDate;
    }
  }

  _DownPaymentInputMode get _downPaymentInputMode {
    return _downPaymentInputModeNotifier.value;
  }

  set _downPaymentInputMode(_DownPaymentInputMode value) {
    if (_downPaymentInputModeNotifier.value != value) {
      _downPaymentInputModeNotifier.value = value;
    }
  }

  set _saving(bool value) {
    if (_savingNotifier.value != value) {
      _savingNotifier.value = value;
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _downPaymentAmountController.dispose();
    _productQuantityFocusNode.dispose();
    _downPaymentFocusNode.dispose();
    _selectedCustomerIdNotifier.dispose();
    _selectedProductIdNotifier.dispose();
    _cartItemsNotifier.dispose();
    _vatOptionNotifier.dispose();
    _installmentCountNotifier.dispose();
    _firstDueDateNotifier.dispose();
    _downPaymentInputModeNotifier.dispose();
    _savingNotifier.dispose();
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

  List<Customer> _customersWithPending(List<Customer> customers) {
    final pendingCustomer = _pendingSelectedCustomer;
    if (pendingCustomer == null ||
        _selectedCustomerId != pendingCustomer.id ||
        customers.any((customer) => customer.id == pendingCustomer.id)) {
      return customers;
    }
    return [pendingCustomer, ...customers];
  }

  List<Product> _productsWithPending(List<Product> products) {
    final pendingProduct = _pendingSelectedProduct;
    if (pendingProduct == null ||
        _selectedProductId != pendingProduct.id ||
        products.any((product) => product.id == pendingProduct.id)) {
      return products;
    }
    return [pendingProduct, ...products];
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
    final nextCartItems = [..._cartItems];
    if (existingIndex >= 0) {
      final existing = nextCartItems[existingIndex];
      nextCartItems[existingIndex] = existing.copyWith(
        quantity: existing.quantity + quantity,
      );
    } else {
      nextCartItems.add(_SaleCartItem(product: product, quantity: quantity));
    }
    _cartItems = nextCartItems;
    _selectedProductId = null;
    _quantityController.text = '1';
    _showMessage('เพิ่มรายการสินค้าแล้ว');
  }

  void _updateCartQuantity(Product product, double quantity) {
    if (quantity <= 0 || quantity.isNaN || quantity.isInfinite) {
      _showMessage('จำนวนสินค้าต้องมากกว่า 0');
      return;
    }
    final nextCartItems = [..._cartItems];
    final index = nextCartItems.indexWhere(
      (item) => item.product.id == product.id,
    );
    if (index >= 0) {
      nextCartItems[index] = nextCartItems[index].copyWith(quantity: quantity);
      _cartItems = nextCartItems;
    }
  }

  void _removeCartItem(Product product) {
    _cartItems = [
      for (final item in _cartItems)
        if (item.product.id != product.id) item,
    ];
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

    _downPaymentInputMode = mode;
    _downPaymentAmountController.text = nextText;
    _downPaymentAmountController.selection = TextSelection.collapsed(
      offset: nextText.length,
    );
  }

  Future<void> _openCustomerForm() async {
    final customer = await showDialog<Customer>(
      context: context,
      barrierDismissible: false,
      builder: (context) => _CustomerFormDialog(
        customerService: CustomerService(widget.database),
        editingCustomer: null,
      ),
    );
    if (!mounted || customer == null) {
      return;
    }

    setState(() {
      _selectedCustomerId = customer.id;
      _pendingSelectedCustomer = customer;
    });
    _showMessage('สร้างลูกค้าแล้ว');
  }

  Future<void> _openProductForm() async {
    final product = await showDialog<Product>(
      context: context,
      barrierDismissible: false,
      builder: (context) => _ProductFormDialog(
        productService: ProductService(widget.database),
        editingProduct: null,
      ),
    );
    if (!mounted || product == null) {
      return;
    }

    setState(() {
      _selectedProductId = product.id;
      _pendingSelectedProduct = product;
    });
    _showMessage('สร้างสินค้าแล้ว');
  }

  Future<void> _pickFirstDueDate() async {
    final now = _dateOnlyForSale(DateTime.now());
    final selectedDate = _firstDueDate;
    final initialDate = selectedDate.isBefore(now) ? now : selectedDate;
    final picked = await showDatePicker(
      context: context,
      locale: const Locale('th', 'TH'),
      helpText: 'เลือกวันที่ต้องชำระรอบแรก',
      cancelText: 'ยกเลิก',
      confirmText: 'ตกลง',
      initialDate: initialDate,
      firstDate: now,
      lastDate: DateTime(now.year + 10, now.month, now.day),
    );
    if (picked == null || !mounted) {
      return;
    }
    _firstDueDate = picked;
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

    final confirmation = _SaleConfirmationSnapshot(
      customer: customer,
      cartItems: List<_SaleCartItem>.unmodifiable(_cartItems),
      vatOption: _vatOption,
      downPaymentAmount: downPaymentAmount,
      installmentCount: _installmentCount,
      firstDueDate: _firstDueDate,
      totals: _totals,
    );
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return _SaleConfirmationDialog(snapshot: confirmation);
      },
    );
    if (confirmed != true || !mounted) {
      return;
    }

    _saving = true;
    try {
      final sale = await widget.saleService.createSale(
        SalePayload(
          customer: confirmation.customer,
          items: confirmation.cartItems
              .map((item) => item.toPayload())
              .toList(),
          vatOption: confirmation.vatOption,
          downPaymentAmount: confirmation.downPaymentAmount,
          installmentCount: confirmation.installmentCount,
          firstDueDate: confirmation.firstDueDate,
          receiverName: widget.receiverName,
        ),
      );

      if (mounted) {
        _selectedProductId = null;
        _quantityController.text = '1';
        _cartItems = const <_SaleCartItem>[];
        _showMessage('บันทึกการขายแล้ว');
        widget.onSaleCreated(sale);
      }
    } on SaleException catch (error) {
      _showMessage(error.message);
    } catch (_) {
      _showMessage('ไม่สามารถบันทึกการขายได้');
    } finally {
      if (mounted) {
        _saving = false;
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
    final mediaQuery = MediaQuery.of(context);
    return MediaQuery(
      data: mediaQuery.copyWith(disableAnimations: true),
      child: Theme(
        data: _saleNoFlickerTheme(context),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: StreamBuilder<List<Customer>>(
              stream: widget.database.watchActiveCustomers(),
              builder: (context, customerSnapshot) {
                final customers = _customersWithPending(
                  customerSnapshot.data ?? const <Customer>[],
                );
                final selectedCustomer = _selectedCustomer(customers);
                if (_selectedCustomerId != null && selectedCustomer == null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      _selectedCustomerId = null;
                    }
                  });
                }

                return StreamBuilder<List<Product>>(
                  stream: widget.database.watchActiveProducts(),
                  builder: (context, productSnapshot) {
                    final products = _productsWithPending(
                      productSnapshot.data ?? const <Product>[],
                    );
                    final selectedProduct = _selectedProduct(products);
                    if (_selectedProductId != null && selectedProduct == null) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          _selectedProductId = null;
                        }
                      });
                    }

                    final loading =
                        customerSnapshot.connectionState ==
                            ConnectionState.waiting ||
                        productSnapshot.connectionState ==
                            ConnectionState.waiting;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'ขาย',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 14),
                        Expanded(
                          child: loading
                              ? const Center(child: CircularProgressIndicator())
                              : _SaleWorkspace(
                                  customers: customers,
                                  products: products,
                                  selectedCustomerIdListenable:
                                      _selectedCustomerIdNotifier,
                                  selectedProductIdListenable:
                                      _selectedProductIdNotifier,
                                  cartItemsListenable: _cartItemsNotifier,
                                  quantityController: _quantityController,
                                  productQuantityFocusNode:
                                      _productQuantityFocusNode,
                                  downPaymentAmountController:
                                      _downPaymentAmountController,
                                  downPaymentFocusNode: _downPaymentFocusNode,
                                  downPaymentAmountListenable:
                                      _downPaymentAmountController,
                                  calculateTotals: () => _totals,
                                  downPaymentInputModeListenable:
                                      _downPaymentInputModeNotifier,
                                  vatOptionListenable: _vatOptionNotifier,
                                  installmentCountListenable:
                                      _installmentCountNotifier,
                                  firstDueDateListenable: _firstDueDateNotifier,
                                  savingListenable: _savingNotifier,
                                  onCustomerChanged: (value) {
                                    _selectedCustomerId = value;
                                    if (value != _pendingSelectedCustomer?.id) {
                                      _pendingSelectedCustomer = null;
                                    }
                                  },
                                  onProductChanged: (value) {
                                    _selectedProductId = value;
                                    if (value != _pendingSelectedProduct?.id) {
                                      _pendingSelectedProduct = null;
                                    }
                                  },
                                  onAddToCart: () =>
                                      _addToCart(_selectedProduct(products)),
                                  onCartQuantityChanged: _updateCartQuantity,
                                  onRemoveCartItem: _removeCartItem,
                                  onVatOptionChanged: (value) =>
                                      _vatOption = value,
                                  onInstallmentChanged: (value) =>
                                      _installmentCount = value,
                                  onFirstDueDatePick: _pickFirstDueDate,
                                  onDownPaymentInputModeChanged:
                                      _changeDownPaymentInputMode,
                                  onCreateCustomer: _openCustomerForm,
                                  onCreateProduct: _openProductForm,
                                  onSave: () => _saveSale(
                                    customer: _selectedCustomer(customers),
                                  ),
                                ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _SaleWorkspace extends StatelessWidget {
  const _SaleWorkspace({
    required this.customers,
    required this.products,
    required this.selectedCustomerIdListenable,
    required this.selectedProductIdListenable,
    required this.cartItemsListenable,
    required this.quantityController,
    required this.productQuantityFocusNode,
    required this.downPaymentAmountController,
    required this.downPaymentFocusNode,
    required this.downPaymentAmountListenable,
    required this.calculateTotals,
    required this.downPaymentInputModeListenable,
    required this.vatOptionListenable,
    required this.installmentCountListenable,
    required this.firstDueDateListenable,
    required this.savingListenable,
    required this.onCustomerChanged,
    required this.onProductChanged,
    required this.onAddToCart,
    required this.onCartQuantityChanged,
    required this.onRemoveCartItem,
    required this.onVatOptionChanged,
    required this.onInstallmentChanged,
    required this.onFirstDueDatePick,
    required this.onDownPaymentInputModeChanged,
    required this.onCreateCustomer,
    required this.onCreateProduct,
    required this.onSave,
  });

  final List<Customer> customers;
  final List<Product> products;
  final ValueListenable<String?> selectedCustomerIdListenable;
  final ValueListenable<String?> selectedProductIdListenable;
  final ValueListenable<List<_SaleCartItem>> cartItemsListenable;
  final TextEditingController quantityController;
  final FocusNode productQuantityFocusNode;
  final TextEditingController downPaymentAmountController;
  final FocusNode downPaymentFocusNode;
  final ValueListenable<TextEditingValue> downPaymentAmountListenable;
  final SaleTotals Function() calculateTotals;
  final ValueListenable<_DownPaymentInputMode> downPaymentInputModeListenable;
  final ValueListenable<SaleVatOption> vatOptionListenable;
  final ValueListenable<int> installmentCountListenable;
  final ValueListenable<DateTime> firstDueDateListenable;
  final ValueListenable<bool> savingListenable;
  final ValueChanged<String?> onCustomerChanged;
  final ValueChanged<String?> onProductChanged;
  final VoidCallback onAddToCart;
  final void Function(Product product, double quantity) onCartQuantityChanged;
  final ValueChanged<Product> onRemoveCartItem;
  final ValueChanged<SaleVatOption> onVatOptionChanged;
  final ValueChanged<int> onInstallmentChanged;
  final VoidCallback onFirstDueDatePick;
  final ValueChanged<_DownPaymentInputMode> onDownPaymentInputModeChanged;
  final VoidCallback onCreateCustomer;
  final VoidCallback onCreateProduct;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final form = _SaleFormPanel(
          customers: customers,
          selectedCustomerIdListenable: selectedCustomerIdListenable,
          downPaymentAmountController: downPaymentAmountController,
          downPaymentFocusNode: downPaymentFocusNode,
          downPaymentAmountListenable: downPaymentAmountListenable,
          calculateTotals: calculateTotals,
          downPaymentInputModeListenable: downPaymentInputModeListenable,
          installmentCountListenable: installmentCountListenable,
          firstDueDateListenable: firstDueDateListenable,
          savingListenable: savingListenable,
          onCustomerChanged: onCustomerChanged,
          onInstallmentChanged: onInstallmentChanged,
          onFirstDueDatePick: onFirstDueDatePick,
          onDownPaymentInputModeChanged: onDownPaymentInputModeChanged,
          onCreateCustomer: onCreateCustomer,
          onSave: onSave,
        );
        final cart = _SaleCartPanel(
          products: products,
          selectedProductIdListenable: selectedProductIdListenable,
          quantityController: quantityController,
          productQuantityFocusNode: productQuantityFocusNode,
          cartItemsListenable: cartItemsListenable,
          vatOptionListenable: vatOptionListenable,
          installmentCountListenable: installmentCountListenable,
          firstDueDateListenable: firstDueDateListenable,
          downPaymentAmountListenable: downPaymentAmountListenable,
          calculateTotals: calculateTotals,
          onProductChanged: onProductChanged,
          onAddToCart: onAddToCart,
          onCreateProduct: onCreateProduct,
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

class _SaleConfirmationSnapshot {
  const _SaleConfirmationSnapshot({
    required this.customer,
    required this.cartItems,
    required this.vatOption,
    required this.downPaymentAmount,
    required this.installmentCount,
    required this.firstDueDate,
    required this.totals,
  });

  final Customer customer;
  final List<_SaleCartItem> cartItems;
  final SaleVatOption vatOption;
  final double downPaymentAmount;
  final int installmentCount;
  final DateTime firstDueDate;
  final SaleTotals totals;
}

class _SaleConfirmationDialog extends StatelessWidget {
  const _SaleConfirmationDialog({required this.snapshot});

  final _SaleConfirmationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760, maxHeight: 760),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Icon(
                    SolarIconsOutline.billCheck,
                    color: _primaryColor,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'ตรวจสอบก่อนบันทึกการขาย',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _SaleConfirmationSection(
                        title: 'ข้อมูลลูกค้า',
                        icon: SolarIconsOutline.userId,
                        child: Column(
                          children: [
                            _SaleConfirmationRow(
                              label: 'ชื่อ - สกุล',
                              value: snapshot.customer.name,
                            ),
                            _SaleConfirmationRow(
                              label: 'ชื่อเล่น',
                              value: _displayText(snapshot.customer.nickname),
                            ),
                            _SaleConfirmationRow(
                              label: 'โทรศัพท์',
                              value: _displayText(snapshot.customer.phone),
                            ),
                            _SaleConfirmationRow(
                              label: 'เลขบัตรประชาชน',
                              value: _displayText(snapshot.customer.taxId),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      _SaleConfirmationSection(
                        title: 'รายการสินค้า',
                        icon: SolarIconsOutline.box,
                        child: _SaleConfirmationItemsTable(
                          items: snapshot.cartItems,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _SaleConfirmationSection(
                        title: 'การชำระเงิน',
                        icon: SolarIconsOutline.walletMoney,
                        child: Column(
                          children: [
                            _SaleConfirmationRow(
                              label: 'ภาษี',
                              value: snapshot.vatOption.label,
                            ),
                            _SaleConfirmationRow(
                              label: 'เงินดาวน์',
                              value:
                                  '${_formatSalePrice(snapshot.downPaymentAmount)} บาท',
                            ),
                            _SaleConfirmationRow(
                              label: 'จำนวนงวด',
                              value: '${snapshot.installmentCount} งวด',
                            ),
                            _SaleConfirmationRow(
                              label: 'ชำระรอบแรก',
                              value: _formatDate(snapshot.firstDueDate),
                            ),
                            _SaleConfirmationRow(
                              label: 'รอบบิล',
                              value: 'ทุกวันที่ ${snapshot.firstDueDate.day}',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      _SaleConfirmationSection(
                        title: 'สรุปราคา',
                        icon: SolarIconsOutline.calculatorMinimalistic,
                        child: Column(
                          children: [
                            _SaleConfirmationRow(
                              label: 'ยอดก่อน VAT',
                              value:
                                  '${_formatSalePrice(snapshot.totals.subtotal)} บาท',
                            ),
                            _SaleConfirmationRow(
                              label: 'VAT',
                              value:
                                  '${_formatSalePrice(snapshot.totals.vatAmount)} บาท',
                            ),
                            _SaleConfirmationRow(
                              label: 'ยอดรวม',
                              value:
                                  '${_formatSalePrice(snapshot.totals.grandTotal)} บาท',
                              emphasized: true,
                            ),
                            _SaleConfirmationRow(
                              label: 'ยอดคงเหลือ',
                              value:
                                  '${_formatSalePrice(snapshot.totals.remainingAmount)} บาท',
                            ),
                            _SaleConfirmationRow(
                              label: 'ค่างวด',
                              value:
                                  '${_formatSalePrice(snapshot.totals.installmentAmount)} บาท/งวด',
                              emphasized: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('ยกเลิก'),
                  ),
                  const SizedBox(width: 10),
                  FilledButton.icon(
                    onPressed: () => Navigator.of(context).pop(true),
                    icon: const Icon(SolarIconsOutline.checkCircle),
                    label: const Text('Submit'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SaleConfirmationSection extends StatelessWidget {
  const _SaleConfirmationSection({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FBFA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFD8E7E4)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(icon, color: _primaryColor, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: const Color(0xFF0F172A),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}

class _SaleConfirmationRow extends StatelessWidget {
  const _SaleConfirmationRow({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final amountStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: emphasized ? _primaryColor : const Color(0xFF334155),
      fontWeight: emphasized ? FontWeight.w900 : FontWeight.w700,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 132,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: const Color(0xFF64748B),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(value, style: amountStyle)),
        ],
      ),
    );
  }
}

class _SaleConfirmationItemsTable extends StatelessWidget {
  const _SaleConfirmationItemsTable({required this.items});

  final List<_SaleCartItem> items;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(_softSlateColor),
          dataRowMinHeight: 44,
          dataRowMaxHeight: 58,
          columns: const [
            DataColumn(label: Text('รหัส')),
            DataColumn(label: Text('สินค้า')),
            DataColumn(label: Text('จำนวน')),
            DataColumn(label: Text('ราคา')),
            DataColumn(label: Text('รวม')),
          ],
          rows: [
            for (final item in items)
              DataRow(
                cells: [
                  DataCell(Text(item.product.code)),
                  DataCell(
                    SizedBox(
                      width: 220,
                      child: Text(
                        item.product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  DataCell(Text(_formatSalePrice(item.quantity))),
                  DataCell(Text(_formatSalePrice(item.product.salePrice))),
                  DataCell(Text(_formatSalePrice(item.lineTotal))),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

enum _DownPaymentInputMode { amount, percent }

DateTime _defaultFirstDueDate() {
  return _addMonthsClampedForSale(DateTime.now(), 1);
}

DateTime _dateOnlyForSale(DateTime value) {
  final local = value.toLocal();
  return DateTime(local.year, local.month, local.day);
}

DateTime _addMonthsClampedForSale(DateTime value, int months) {
  final date = _dateOnlyForSale(value);
  final monthIndex = date.month - 1 + months;
  final year = date.year + monthIndex ~/ 12;
  final month = monthIndex % 12 + 1;
  final day = date.day.clamp(1, _daysInMonthForSale(year, month));
  return DateTime(year, month, day);
}

int _daysInMonthForSale(int year, int month) {
  return DateTime(year, month + 1, 0).day;
}

String _billingCycleText(DateTime firstDueDate) {
  final day = firstDueDate.day;
  if (day > 28) {
    return 'รอบบิลทุกวันที่ $day ของเดือน และปรับเป็นวันสุดท้ายเมื่อเดือนไม่มีวันที่นี้';
  }
  return 'รอบบิลทุกวันที่ $day ของเดือน';
}

ThemeData _saleNoFlickerTheme(BuildContext context) {
  final theme = Theme.of(context);
  final enabledInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: _surfaceBorderColor),
  );
  final focusedInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: _primaryColor, width: 1.8),
  );
  return theme.copyWith(
    splashFactory: NoSplash.splashFactory,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    hoverColor: Colors.transparent,
    focusColor: Colors.transparent,
    inputDecorationTheme: theme.inputDecorationTheme.copyWith(
      focusedBorder: focusedInputBorder,
      enabledBorder: enabledInputBorder,
      focusColor: _softMintColor,
      activeIndicatorBorder: const BorderSide(color: Colors.transparent),
    ),
    textSelectionTheme: theme.textSelectionTheme.copyWith(
      cursorColor: _primaryColor,
      selectionColor: _primaryColor.withValues(alpha: 0.18),
      selectionHandleColor: _primaryColor,
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        overlayColor: Colors.transparent,
        animationDuration: Duration.zero,
      ),
    ),
  );
}

ButtonStyle _saleActionButtonStyle() {
  return FilledButton.styleFrom(
    minimumSize: const Size(0, 48),
    padding: const EdgeInsets.symmetric(horizontal: 16),
    overlayColor: Colors.transparent,
    animationDuration: Duration.zero,
  );
}

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
        child: Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: selected ? _surfaceColor : Colors.transparent,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: selected ? const Color(0xFFB7DDD6) : Colors.transparent,
            ),
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
    required this.selectedCustomerIdListenable,
    required this.downPaymentAmountController,
    required this.downPaymentFocusNode,
    required this.downPaymentAmountListenable,
    required this.calculateTotals,
    required this.downPaymentInputModeListenable,
    required this.installmentCountListenable,
    required this.firstDueDateListenable,
    required this.savingListenable,
    required this.onCustomerChanged,
    required this.onInstallmentChanged,
    required this.onFirstDueDatePick,
    required this.onDownPaymentInputModeChanged,
    required this.onCreateCustomer,
    required this.onSave,
  });

  final List<Customer> customers;
  final ValueListenable<String?> selectedCustomerIdListenable;
  final TextEditingController downPaymentAmountController;
  final FocusNode downPaymentFocusNode;
  final ValueListenable<TextEditingValue> downPaymentAmountListenable;
  final SaleTotals Function() calculateTotals;
  final ValueListenable<_DownPaymentInputMode> downPaymentInputModeListenable;
  final ValueListenable<int> installmentCountListenable;
  final ValueListenable<DateTime> firstDueDateListenable;
  final ValueListenable<bool> savingListenable;
  final ValueChanged<String?> onCustomerChanged;
  final ValueChanged<int> onInstallmentChanged;
  final VoidCallback onFirstDueDatePick;
  final ValueChanged<_DownPaymentInputMode> onDownPaymentInputModeChanged;
  final VoidCallback onCreateCustomer;
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
            _SaleCustomerInputRow(
              customers: customers,
              selectedCustomerIdListenable: selectedCustomerIdListenable,
              onChanged: onCustomerChanged,
              onCreateCustomer: onCreateCustomer,
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
            ValueListenableBuilder<int>(
              valueListenable: installmentCountListenable,
              builder: (context, installmentCount, child) {
                return _SaleInstallmentSelector(
                  selectedCount: installmentCount,
                  onChanged: onInstallmentChanged,
                );
              },
            ),
            const SizedBox(height: 14),
            ValueListenableBuilder<DateTime>(
              valueListenable: firstDueDateListenable,
              builder: (context, firstDueDate, child) {
                return _SaleBillingCycleField(
                  firstDueDate: firstDueDate,
                  onTap: onFirstDueDatePick,
                );
              },
            ),
            const SizedBox(height: 14),
            ValueListenableBuilder<_DownPaymentInputMode>(
              valueListenable: downPaymentInputModeListenable,
              builder: (context, downPaymentInputMode, child) {
                return _SaleDownPaymentInputRow(
                  controller: downPaymentAmountController,
                  focusNode: downPaymentFocusNode,
                  amountListenable: downPaymentAmountListenable,
                  inputMode: downPaymentInputMode,
                  calculateTotals: calculateTotals,
                  onInputModeChanged: onDownPaymentInputModeChanged,
                );
              },
            ),
          ],
        ),
      ],
    );
    final saveButton = ValueListenableBuilder<bool>(
      valueListenable: savingListenable,
      builder: (context, saving, child) {
        return FilledButton.icon(
          onPressed: saving ? null : onSave,
          style: _saleActionButtonStyle(),
          icon: saving
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(SolarIconsOutline.diskette),
          label: Text(saving ? 'กำลังบันทึก...' : 'บันทึกการขาย'),
        );
      },
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

class _SaleCustomerInputRow extends StatelessWidget {
  const _SaleCustomerInputRow({
    required this.customers,
    required this.selectedCustomerIdListenable,
    required this.onChanged,
    required this.onCreateCustomer,
  });

  final List<Customer> customers;
  final ValueListenable<String?> selectedCustomerIdListenable;
  final ValueChanged<String?> onChanged;
  final VoidCallback onCreateCustomer;

  Customer? _selectedCustomer(String? selectedCustomerId) {
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
    final createButton = SizedBox(
      height: 48,
      child: FilledButton.icon(
        onPressed: onCreateCustomer,
        style: _saleActionButtonStyle(),
        icon: const Icon(SolarIconsOutline.userPlusRounded),
        label: const Text('เพิ่มลูกค้า'),
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        return ValueListenableBuilder<String?>(
          valueListenable: selectedCustomerIdListenable,
          builder: (context, selectedCustomerId, child) {
            final selectedCustomer = _selectedCustomer(selectedCustomerId);
            final customerField = _SaleCustomerSearchField(
              fieldKey: const ValueKey('sale-customer-search-field'),
              label: 'ค้นหาลูกค้า',
              icon: SolarIconsOutline.userSpeakRounded,
              customers: customers,
              selectedCustomerId: selectedCustomerId,
              onChanged: onChanged,
            );

            Widget inputRow;
            if (constraints.maxWidth < 340) {
              inputRow = Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  customerField,
                  const SizedBox(height: 10),
                  Align(alignment: Alignment.centerLeft, child: createButton),
                ],
              );
            } else {
              inputRow = Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: customerField),
                  const SizedBox(width: 12),
                  SizedBox(width: 132, child: createButton),
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                inputRow,
                if (selectedCustomer != null) ...[
                  const SizedBox(height: 10),
                  _SaleSelectedCustomerCard(customer: selectedCustomer),
                ],
                if (selectedCustomer?.isBlacklisted == true) ...[
                  const SizedBox(height: 8),
                  const _SaleBlacklistWarning(),
                ],
              ],
            );
          },
        );
      },
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? _softMintColor : _surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? const Color(0xFF9FD8CE) : _surfaceBorderColor,
          ),
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

class _SaleBillingCycleField extends StatelessWidget {
  const _SaleBillingCycleField({
    required this.firstDueDate,
    required this.onTap,
  });

  final DateTime firstDueDate;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'เลือกวันที่ต้องชำระรอบแรก',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: InputDecorator(
            isEmpty: false,
            decoration: const InputDecoration(
              labelText: 'วันที่ต้องชำระรอบแรก *',
              prefixIcon: Icon(SolarIconsOutline.calendarMinimalistic),
              suffixIcon: Icon(Icons.keyboard_arrow_down_rounded),
            ).copyWith(helperText: _billingCycleText(firstDueDate)),
            child: Text(
              _formatDate(firstDueDate),
              key: const ValueKey('sale-first-due-date-value'),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: const Color(0xFF0F172A),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SaleTotalSummaryCard extends StatelessWidget {
  const _SaleTotalSummaryCard({
    required this.vatOptionListenable,
    required this.installmentCountListenable,
    required this.firstDueDateListenable,
    required this.cartItemsListenable,
    required this.downPaymentAmountListenable,
    required this.calculateTotals,
    required this.onVatOptionChanged,
  });

  final ValueListenable<SaleVatOption> vatOptionListenable;
  final ValueListenable<int> installmentCountListenable;
  final ValueListenable<DateTime> firstDueDateListenable;
  final ValueListenable<List<_SaleCartItem>> cartItemsListenable;
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
    return ValueListenableBuilder<SaleVatOption>(
      valueListenable: vatOptionListenable,
      builder: (context, vatOption, child) {
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
                    ValueListenableBuilder<int>(
                      valueListenable: installmentCountListenable,
                      builder: (context, installmentCount, child) {
                        return ValueListenableBuilder<DateTime>(
                          valueListenable: firstDueDateListenable,
                          builder: (context, firstDueDate, child) {
                            return ValueListenableBuilder<List<_SaleCartItem>>(
                              valueListenable: cartItemsListenable,
                              builder: (context, cartItems, child) {
                                return ValueListenableBuilder<TextEditingValue>(
                                  valueListenable: downPaymentAmountListenable,
                                  builder: (context, value, child) {
                                    return _SaleAccountingStatement(
                                      totals: calculateTotals(),
                                      installmentCount: installmentCount,
                                      firstDueDate: firstDueDate,
                                    );
                                  },
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _SaleAccountingStatement extends StatelessWidget {
  const _SaleAccountingStatement({
    required this.totals,
    required this.installmentCount,
    required this.firstDueDate,
  });

  final SaleTotals totals;
  final int installmentCount;
  final DateTime firstDueDate;

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
          _SaleAccountingRow(
            label: 'วันที่ต้องชำระ',
            detail: 'รอบแรก',
            amount: _formatDate(firstDueDate),
            unit: '',
            showDivider: true,
          ),
          _SaleAccountingRow(
            label: 'รอบบิล',
            amount: 'ทุกวันที่ ${firstDueDate.day}',
            unit: 'ของเดือน',
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

  @override
  Widget build(BuildContext context) {
    return _SaleSearchField<Customer>(
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

class _SaleSearchField<T extends Object> extends StatefulWidget {
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

class _SaleSearchFieldState<T extends Object>
    extends State<_SaleSearchField<T>> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  var _preserveTextForUserClear = false;

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

  List<T> _optionsForText(String value) {
    final query = value.trim().toLowerCase();
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
    _controller.addListener(_handleControllerChanged);
    _focusNode = FocusNode();
  }

  @override
  void didUpdateWidget(covariant _SaleSearchField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedValue == oldWidget.selectedValue &&
        widget.items == oldWidget.items) {
      return;
    }
    if (_preserveTextForUserClear &&
        widget.selectedValue == null &&
        oldWidget.selectedValue != null) {
      _preserveTextForUserClear = false;
      return;
    }
    if (!_focusNode.hasFocus ||
        widget.selectedValue != oldWidget.selectedValue ||
        widget.selectedValue != null) {
      _syncControllerToSelectedLabel();
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.removeListener(_handleControllerChanged);
    _controller.dispose();
    super.dispose();
  }

  void _handleControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _handleFocusChanged() {
    // Compatibility for debug hot reload: older live _SaleSearchFieldState
    // instances may still have this listener attached to their FocusNode.
  }

  @override
  void reassemble() {
    super.reassemble();
    _focusNode.removeListener(_handleFocusChanged);
  }

  void _handleTextChanged(String value) {
    final selectedLabel = _selectedLabel;
    if (widget.selectedValue != null && value != selectedLabel) {
      _preserveTextForUserClear = true;
      widget.onChanged(null);
    }
  }

  void _syncControllerToSelectedLabel() {
    final selectedLabel = _selectedLabel ?? '';
    if (_controller.text == selectedLabel) {
      return;
    }
    _controller.value = TextEditingValue(
      text: selectedLabel,
      selection: TextSelection.collapsed(offset: selectedLabel.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RawAutocomplete<T>(
      textEditingController: _controller,
      focusNode: _focusNode,
      displayStringForOption: widget.itemLabel,
      optionsBuilder: (value) => _optionsForText(value.text),
      onSelected: (item) {
        widget.onChanged(widget.itemValue(item));
        _focusNode.unfocus();
      },
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return TextFormField(
          key: widget.fieldKey,
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            hintText: widget.label,
            prefixIcon: Icon(widget.icon),
            suffixIcon: controller.text.isEmpty
                ? null
                : IconButton(
                    tooltip: 'ล้าง',
                    onPressed: () {
                      controller.clear();
                      widget.onChanged(null);
                      focusNode.requestFocus();
                    },
                    icon: const Icon(SolarIconsOutline.closeCircle),
                  ),
          ),
          onChanged: _handleTextChanged,
          onFieldSubmitted: (_) => onFieldSubmitted(),
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return _SaleSearchOptionsPopover<T>(
          emptyText: widget.emptyText,
          options: options.toList(growable: false),
          selectedValue: widget.selectedValue,
          itemValue: widget.itemValue,
          optionBuilder: widget.optionBuilder,
          onSelect: onSelected,
        );
      },
    );
  }
}

class _SaleSearchOptionsPopover<T extends Object> extends StatelessWidget {
  const _SaleSearchOptionsPopover({
    required this.emptyText,
    required this.options,
    required this.selectedValue,
    required this.itemValue,
    required this.optionBuilder,
    required this.onSelect,
  });

  final String emptyText;
  final List<T> options;
  final String? selectedValue;
  final String Function(T item) itemValue;
  final Widget Function(BuildContext context, T item, bool selected)
  optionBuilder;
  final ValueChanged<T> onSelect;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: _surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _surfaceBorderColor),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A0F172A),
              blurRadius: 16,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 180),
          child: options.isEmpty
              ? SizedBox(height: 48, child: Center(child: Text(emptyText)))
              : ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  itemCount: options.length,
                  separatorBuilder: (context, index) {
                    return const Divider(height: 1);
                  },
                  itemBuilder: (context, index) {
                    final item = options[index];
                    final selected = selectedValue == itemValue(item);
                    return Semantics(
                      button: true,
                      onTap: () => onSelect(item),
                      child: Listener(
                        behavior: HitTestBehavior.opaque,
                        onPointerUp: (_) => onSelect(item),
                        child: optionBuilder(context, item, selected),
                      ),
                    );
                  },
                ),
        ),
      ),
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

class _SaleSelectedCustomerCard extends StatelessWidget {
  const _SaleSelectedCustomerCard({required this.customer});

  final Customer customer;

  String get _displayName {
    final nickname = customer.nickname?.trim();
    if (nickname == null || nickname.isEmpty) {
      return customer.name;
    }
    return '${customer.name} ($nickname)';
  }

  String get _displayAddress {
    final parts =
        [
              customer.address,
              customer.subDistrict,
              customer.district,
              customer.province,
              customer.zipcode,
            ]
            .whereType<String>()
            .map((value) => value.trim())
            .where((value) => value.isNotEmpty)
            .toList();
    if (parts.isEmpty) {
      return '-';
    }
    return parts.join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FBFA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD8E7E4)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(
                  SolarIconsOutline.userId,
                  color: _primaryColor,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'ข้อมูลลูกค้า',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: const Color(0xFF0F172A),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                _SaleCustomerStatusBadge(isBlacklisted: customer.isBlacklisted),
              ],
            ),
            const SizedBox(height: 10),
            _SaleCustomerDetailRow(label: 'ชื่อ - สกุล', value: _displayName),
            _SaleCustomerDetailRow(
              label: 'เลขบัตรประชาชน',
              value: _displayText(customer.taxId),
            ),
            _SaleCustomerDetailRow(
              label: 'วันเกิด',
              value: customer.birthDate == null
                  ? '-'
                  : _formatDate(customer.birthDate!),
            ),
            _SaleCustomerDetailRow(label: 'ที่อยู่', value: _displayAddress),
          ],
        ),
      ),
    );
  }
}

class _SaleCustomerDetailRow extends StatelessWidget {
  const _SaleCustomerDetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 108,
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: const Color(0xFF64748B),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: const Color(0xFF334155),
                fontWeight: FontWeight.w700,
              ),
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
    required this.selectedProductIdListenable,
    required this.quantityController,
    required this.productQuantityFocusNode,
    required this.cartItemsListenable,
    required this.vatOptionListenable,
    required this.installmentCountListenable,
    required this.firstDueDateListenable,
    required this.downPaymentAmountListenable,
    required this.calculateTotals,
    required this.onProductChanged,
    required this.onAddToCart,
    required this.onCreateProduct,
    required this.onQuantityChanged,
    required this.onRemove,
    required this.onVatOptionChanged,
  });

  final List<Product> products;
  final ValueListenable<String?> selectedProductIdListenable;
  final TextEditingController quantityController;
  final FocusNode productQuantityFocusNode;
  final ValueListenable<List<_SaleCartItem>> cartItemsListenable;
  final ValueListenable<SaleVatOption> vatOptionListenable;
  final ValueListenable<int> installmentCountListenable;
  final ValueListenable<DateTime> firstDueDateListenable;
  final ValueListenable<TextEditingValue> downPaymentAmountListenable;
  final SaleTotals Function() calculateTotals;
  final ValueChanged<String?> onProductChanged;
  final VoidCallback onAddToCart;
  final VoidCallback onCreateProduct;
  final void Function(Product product, double quantity) onQuantityChanged;
  final ValueChanged<Product> onRemove;
  final ValueChanged<SaleVatOption> onVatOptionChanged;

  @override
  Widget build(BuildContext context) {
    final header = LayoutBuilder(
      builder: (context, constraints) {
        final title = Row(
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
        final createButton = FilledButton.icon(
          onPressed: onCreateProduct,
          style: _saleActionButtonStyle(),
          icon: const Icon(SolarIconsOutline.box),
          label: const Text('เพิ่มสินค้า'),
        );

        if (constraints.maxWidth < 360) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              title,
              const SizedBox(height: 10),
              Align(alignment: Alignment.centerLeft, child: createButton),
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: title),
            const SizedBox(width: 12),
            createButton,
          ],
        );
      },
    );
    final inputBar = _SaleCartInputBar(
      products: products,
      selectedProductIdListenable: selectedProductIdListenable,
      quantityController: quantityController,
      productQuantityFocusNode: productQuantityFocusNode,
      onProductChanged: onProductChanged,
      onAddToCart: onAddToCart,
    );
    final cartItemsArea = ValueListenableBuilder<List<_SaleCartItem>>(
      valueListenable: cartItemsListenable,
      builder: (context, cartItems, child) {
        return _SaleCartItemsArea(
          cartItems: cartItems,
          onQuantityChanged: onQuantityChanged,
          onRemove: onRemove,
        );
      },
    );
    final summaryCard = _SaleTotalSummaryCard(
      vatOptionListenable: vatOptionListenable,
      installmentCountListenable: installmentCountListenable,
      firstDueDateListenable: firstDueDateListenable,
      cartItemsListenable: cartItemsListenable,
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
    required this.selectedProductIdListenable,
    required this.quantityController,
    required this.productQuantityFocusNode,
    required this.onProductChanged,
    required this.onAddToCart,
  });

  final List<Product> products;
  final ValueListenable<String?> selectedProductIdListenable;
  final TextEditingController quantityController;
  final FocusNode productQuantityFocusNode;
  final ValueChanged<String?> onProductChanged;
  final VoidCallback onAddToCart;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final productField = ValueListenableBuilder<String?>(
          valueListenable: selectedProductIdListenable,
          builder: (context, selectedProductId, child) {
            return _SaleProductSearchField(
              fieldKey: const ValueKey('sale-product-search-field'),
              label: 'ค้นหาสินค้า',
              icon: SolarIconsOutline.box,
              products: products,
              selectedProductId: selectedProductId,
              onChanged: onProductChanged,
            );
          },
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
        final addButton = SizedBox(
          height: 48,
          child: FilledButton.icon(
            onPressed: onAddToCart,
            style: _saleActionButtonStyle(),
            icon: const Icon(SolarIconsOutline.cartPlus),
            label: const Text('เพิ่มรายการ'),
          ),
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
