part of '../../../main.dart';

class ProductCrudPage extends StatefulWidget {
  const ProductCrudPage({
    super.key,
    required this.database,
    required this.productService,
  });

  final AppDatabase database;
  final ProductService productService;

  @override
  State<ProductCrudPage> createState() => _ProductCrudPageState();
}

class _ProductCrudPageState extends State<ProductCrudPage> {
  final _searchController = TextEditingController();

  var _searchText = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _searchText = _searchController.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openProductForm([Product? product]) async {
    final saved = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => _ProductFormDialog(
        productService: widget.productService,
        editingProduct: product,
      ),
    );

    if (saved == true) {
      _showMessage(product == null ? 'สร้างสินค้าแล้ว' : 'อัปเดตสินค้าแล้ว');
    }
  }

  Future<void> _deleteProduct(Product product) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _surfaceColor,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: _cardBorderRadius()),
        title: const Text('ลบสินค้า'),
        content: Text('ต้องการลบ ${product.name} หรือไม่'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('ยกเลิก'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('ลบ'),
          ),
        ],
      ),
    );
    if (confirmed != true) {
      return;
    }

    await widget.productService.deleteProduct(product.id);
    _showMessage('ลบสินค้าแล้ว');
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }
    _showToast(context, message);
  }

  List<Product> _filterProducts(List<Product> products) {
    if (_searchText.isEmpty) {
      return products;
    }
    return products.where((product) {
      final values = [
        product.code,
        product.name,
        product.remark ?? '',
        _formatSalePrice(product.salePrice),
      ].join(' ').toLowerCase();
      return values.contains(_searchText);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ProductToolbar(
              searchController: _searchController,
              onCreate: () => _openProductForm(),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: _ProductTablePanel(
                database: widget.database,
                filterProducts: _filterProducts,
                onEdit: _openProductForm,
                onDelete: _deleteProduct,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductToolbar extends StatelessWidget {
  const _ProductToolbar({
    required this.searchController,
    required this.onCreate,
  });

  final TextEditingController searchController;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final title = Text('สินค้า', style: Theme.of(context).textTheme.titleLarge);
    final searchField = TextField(
      controller: searchController,
      decoration: const InputDecoration(
        labelText: 'ค้นหา',
        prefixIcon: Icon(SolarIconsOutline.magnifier),
        isDense: true,
      ),
    );
    final addButton = FilledButton.icon(
      onPressed: onCreate,
      icon: const Icon(SolarIconsOutline.box),
      label: const Text('เพิ่มสินค้า'),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 700) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(child: title),
                  addButton,
                ],
              ),
              const SizedBox(height: 12),
              searchField,
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: title),
            SizedBox(width: 280, child: searchField),
            const SizedBox(width: 12),
            addButton,
          ],
        );
      },
    );
  }
}

class _ProductTablePanel extends StatelessWidget {
  const _ProductTablePanel({
    required this.database,
    required this.filterProducts,
    required this.onEdit,
    required this.onDelete,
  });

  final AppDatabase database;
  final List<Product> Function(List<Product> products) filterProducts;
  final ValueChanged<Product> onEdit;
  final ValueChanged<Product> onDelete;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: _surfaceDecoration(),
      child: StreamBuilder<List<Product>>(
        stream: database.watchActiveProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final products = filterProducts(snapshot.data ?? const []);
          if (products.isEmpty) {
            return const _EmptyProducts();
          }

          return ClipRRect(
            borderRadius: _cardBorderRadius(),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final tableMinWidth = constraints.maxWidth > 980
                    ? constraints.maxWidth
                    : 980.0;

                return SingleChildScrollView(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: tableMinWidth),
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(
                          _softSlateColor,
                        ),
                        dataRowMinHeight: 56,
                        dataRowMaxHeight: 72,
                        headingTextStyle: Theme.of(context).textTheme.labelLarge
                            ?.copyWith(fontWeight: FontWeight.w700),
                        columns: const [
                          DataColumn(label: Text('รหัส')),
                          DataColumn(label: Text('ชื่อสินค้า')),
                          DataColumn(label: Text('ราคาขาย')),
                          DataColumn(label: Text('หมายเหตุ')),
                          DataColumn(label: Text('อัปเดตล่าสุด')),
                          DataColumn(label: Text('จัดการ')),
                        ],
                        rows: products.map((product) {
                          return DataRow(
                            cells: [
                              DataCell(Text(product.code)),
                              DataCell(Text(product.name)),
                              DataCell(
                                Text(_formatSalePrice(product.salePrice)),
                              ),
                              DataCell(Text(_displayText(product.remark))),
                              DataCell(
                                Text(_formatDateTime(product.updatedAt)),
                              ),
                              DataCell(
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      tooltip: 'แก้ไข',
                                      onPressed: () => onEdit(product),
                                      icon: const Icon(SolarIconsOutline.pen),
                                    ),
                                    IconButton(
                                      tooltip: 'ลบ',
                                      onPressed: () => onDelete(product),
                                      icon: const Icon(
                                        SolarIconsOutline.trashBinMinimalistic,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _ProductFormDialog extends StatefulWidget {
  const _ProductFormDialog({
    required this.productService,
    required this.editingProduct,
  });

  final ProductService productService;
  final Product? editingProduct;

  @override
  State<_ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<_ProductFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _salePriceController = TextEditingController();
  final _remarkController = TextEditingController();

  var _saving = false;

  bool get _editing => widget.editingProduct != null;

  @override
  void initState() {
    super.initState();
    final product = widget.editingProduct;
    if (product != null) {
      _codeController.text = product.code;
      _nameController.text = product.name;
      _salePriceController.text = _formatSalePrice(product.salePrice);
      _remarkController.text = product.remark ?? '';
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _salePriceController.dispose();
    _remarkController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() => _saving = true);
    try {
      final payload = ProductPayload(
        code: _codeController.text,
        name: _nameController.text,
        salePrice: _parseSalePrice(_salePriceController.text)!,
        remark: _remarkController.text,
      );

      final product = widget.editingProduct;
      if (product == null) {
        await widget.productService.createProduct(payload);
      } else {
        await widget.productService.updateProduct(
          id: product.id,
          payload: payload,
        );
      }

      if (mounted) {
        Navigator.pop(context, true);
      }
    } on ProductException catch (error) {
      _showMessage(error.message);
    } catch (_) {
      _showMessage('ไม่สามารถบันทึกสินค้าได้');
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

  String? _requiredName(String? value) {
    if ((value ?? '').trim().isEmpty) {
      return 'กรุณากรอกชื่อสินค้า';
    }
    return null;
  }

  String? _salePriceValidator(String? value) {
    final price = _parseSalePrice(value ?? '');
    if (price == null) {
      return 'กรุณากรอกราคาขายเป็นตัวเลข';
    }
    if (price < 0) {
      return 'ราคาขายต้องไม่ติดลบ';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: _surfaceColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: _cardBorderRadius()),
      titlePadding: EdgeInsets.zero,
      title: _ProductDialogHeader(editing: _editing),
      content: SizedBox(
        width: 720,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: _CustomerFormSection(
              icon: SolarIconsOutline.box,
              iconColor: _primaryColor,
              title: 'ข้อมูลสินค้า',
              children: [
                _CustomerFieldGrid(
                  children: [
                    _CustomerTextField(
                      controller: _codeController,
                      label: 'รหัสสินค้า',
                      placeholder: 'ไม่กรอกระบบจะสร้างให้อัตโนมัติ',
                      icon: SolarIconsOutline.tagPrice,
                      helperText: 'ถ้าไม่กรอก ระบบจะสร้างรหัสให้อัตโนมัติ',
                    ),
                    _CustomerTextField(
                      controller: _nameController,
                      label: 'ชื่อสินค้า',
                      placeholder: 'เช่น เหล็กแผ่นรีดเย็น',
                      icon: SolarIconsOutline.box,
                      required: true,
                      validator: _requiredName,
                    ),
                    _CustomerTextField(
                      controller: _salePriceController,
                      label: 'ราคาขาย',
                      placeholder: '0.00',
                      icon: SolarIconsOutline.dollarMinimalistic,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      required: true,
                      validator: _salePriceValidator,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _CustomerTextField(
                  controller: _remarkController,
                  label: 'หมายเหตุเพิ่มเติม',
                  placeholder: 'บันทึกรายละเอียดสินค้าเพิ่มเติม...',
                  icon: SolarIconsOutline.notes,
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context, false),
          child: const Text('ยกเลิก'),
        ),
        FilledButton.icon(
          onPressed: _saving ? null : _save,
          icon: _saving
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(SolarIconsOutline.diskette),
          label: Text(_saving ? 'กำลังบันทึก...' : 'บันทึกข้อมูล'),
        ),
      ],
    );
  }
}

class _ProductDialogHeader extends StatelessWidget {
  const _ProductDialogHeader({required this.editing});

  final bool editing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 18),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: _surfaceBorderColor)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: editing
                      ? const Color(0xFFFFF7ED)
                      : const Color(0xFFE6F4F1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Icon(
                    editing
                        ? SolarIconsOutline.penNewSquare
                        : SolarIconsOutline.box,
                    color: editing ? const Color(0xFFEA580C) : _primaryColor,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      editing ? 'แก้ไขข้อมูลสินค้า' : 'เพิ่มข้อมูลสินค้าใหม่',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      editing
                          ? 'ปรับปรุงรหัส ชื่อสินค้า ราคาขาย และหมายเหตุเพิ่มเติม'
                          : 'กรอกชื่อสินค้าและราคาขาย รหัสสินค้าเว้นว่างได้ ระบบจะสร้างให้อัตโนมัติ',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyProducts extends StatelessWidget {
  const _EmptyProducts();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 180,
      child: Center(child: Text('ยังไม่มีสินค้า')),
    );
  }
}
