part of '../../../main.dart';

class CustomerCrudPage extends StatefulWidget {
  const CustomerCrudPage({
    super.key,
    required this.database,
    required this.customerService,
  });

  final AppDatabase database;
  final CustomerService customerService;

  @override
  State<CustomerCrudPage> createState() => _CustomerCrudPageState();
}

class _CustomerCrudPageState extends State<CustomerCrudPage> {
  final _searchController = TextEditingController();

  var _searchText = '';
  var _blacklistFilter = _BlacklistFilter.all;

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

  Future<void> _openCustomerForm([Customer? customer]) async {
    final savedCustomer = await showDialog<Customer>(
      context: context,
      barrierDismissible: false,
      builder: (context) => _CustomerFormDialog(
        customerService: widget.customerService,
        editingCustomer: customer,
      ),
    );

    if (savedCustomer != null) {
      _showMessage(customer == null ? 'สร้างลูกค้าแล้ว' : 'อัปเดตลูกค้าแล้ว');
    }
  }

  Future<void> _deleteCustomer(Customer customer) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _surfaceColor,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: _cardBorderRadius()),
        title: const Text('ลบลูกค้า'),
        content: Text('ต้องการลบ ${customer.name} หรือไม่'),
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

    await widget.customerService.deleteCustomer(customer.id);
    _showMessage('ลบลูกค้าแล้ว');
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }
    _showToast(context, message);
  }

  List<Customer> _filterCustomers(List<Customer> customers) {
    return customers.where((customer) {
      final matchesStatus = switch (_blacklistFilter) {
        _BlacklistFilter.all => true,
        _BlacklistFilter.normal => !customer.isBlacklisted,
        _BlacklistFilter.blacklisted => customer.isBlacklisted,
      };
      if (!matchesStatus) {
        return false;
      }
      if (_searchText.isEmpty) {
        return true;
      }
      final values = [
        customer.name,
        customer.nickname ?? '',
        customer.phone ?? '',
        customer.lineId ?? '',
        customer.taxId ?? '',
        customer.birthDate == null ? '' : _formatDate(customer.birthDate!),
        customer.province ?? '',
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
            _CustomerToolbar(
              searchController: _searchController,
              blacklistFilter: _blacklistFilter,
              onBlacklistFilterChanged: (value) {
                setState(() => _blacklistFilter = value);
              },
              onCreate: () => _openCustomerForm(),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: _CustomerTablePanel(
                database: widget.database,
                filterCustomers: _filterCustomers,
                onEdit: _openCustomerForm,
                onDelete: _deleteCustomer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _BlacklistFilter { all, normal, blacklisted }

String _formatNullableDate(DateTime? value) {
  if (value == null) {
    return '-';
  }
  return _formatDate(value);
}

class _CustomerToolbar extends StatelessWidget {
  const _CustomerToolbar({
    required this.searchController,
    required this.blacklistFilter,
    required this.onBlacklistFilterChanged,
    required this.onCreate,
  });

  final TextEditingController searchController;
  final _BlacklistFilter blacklistFilter;
  final ValueChanged<_BlacklistFilter> onBlacklistFilterChanged;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final title = Text('ลูกค้า', style: Theme.of(context).textTheme.titleLarge);
    final addButton = FilledButton.icon(
      onPressed: onCreate,
      icon: const Icon(SolarIconsOutline.userPlusRounded),
      label: const Text('เพิ่มลูกค้า'),
    );
    const filterWidth = 340.0;
    final filter = SizedBox(
      width: filterWidth,
      child: _SaleToggleGroup<_BlacklistFilter>(
        options: const [
          _SaleToggleOption(
            value: _BlacklistFilter.all,
            icon: SolarIconsOutline.filter,
            label: 'ทั้งหมด',
          ),
          _SaleToggleOption(
            value: _BlacklistFilter.normal,
            icon: SolarIconsOutline.userCheck,
            label: 'ปกติ',
          ),
          _SaleToggleOption(
            value: _BlacklistFilter.blacklisted,
            icon: SolarIconsOutline.forbidden,
            label: 'แบล็คลิสต์',
          ),
        ],
        selectedValue: blacklistFilter,
        onChanged: onBlacklistFilterChanged,
      ),
    );
    final searchField = TextField(
      controller: searchController,
      decoration: const InputDecoration(
        labelText: 'ค้นหา',
        prefixIcon: Icon(SolarIconsOutline.magnifier),
        isDense: true,
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 1140) {
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
              Wrap(
                spacing: 12,
                runSpacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: filter,
                  ),
                  SizedBox(
                    width: constraints.maxWidth < 300
                        ? constraints.maxWidth
                        : 300,
                    child: searchField,
                  ),
                ],
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: title),
            filter,
            const SizedBox(width: 12),
            SizedBox(width: 280, child: searchField),
            const SizedBox(width: 12),
            addButton,
          ],
        );
      },
    );
  }
}

class _CustomerTablePanel extends StatelessWidget {
  const _CustomerTablePanel({
    required this.database,
    required this.filterCustomers,
    required this.onEdit,
    required this.onDelete,
  });

  final AppDatabase database;
  final List<Customer> Function(List<Customer> customers) filterCustomers;
  final ValueChanged<Customer> onEdit;
  final ValueChanged<Customer> onDelete;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: _surfaceDecoration(),
      child: StreamBuilder<List<Customer>>(
        stream: database.watchActiveCustomers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final customers = filterCustomers(snapshot.data ?? const []);
          if (customers.isEmpty) {
            return const _EmptyCustomers();
          }

          return ClipRRect(
            borderRadius: _cardBorderRadius(),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final tableMinWidth = constraints.maxWidth > 1320
                    ? constraints.maxWidth
                    : 1320.0;

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
                          DataColumn(label: Text('ชื่อ-นามสกุล')),
                          DataColumn(label: Text('ชื่อเล่น')),
                          DataColumn(label: Text('เลขบัตรประชาชน')),
                          DataColumn(label: Text('วันเกิด')),
                          DataColumn(label: Text('สถานะ')),
                          DataColumn(label: Text('เบอร์โทร')),
                          DataColumn(label: Text('จังหวัด')),
                          DataColumn(label: Text('อัปเดตล่าสุด')),
                          DataColumn(label: Text('จัดการ')),
                        ],
                        rows: customers.map((customer) {
                          return DataRow(
                            cells: [
                              DataCell(Text(customer.name)),
                              DataCell(Text(_displayText(customer.nickname))),
                              DataCell(Text(_displayText(customer.taxId))),
                              DataCell(
                                Text(_formatNullableDate(customer.birthDate)),
                              ),
                              DataCell(
                                _CustomerBlacklistBadge(
                                  isBlacklisted: customer.isBlacklisted,
                                ),
                              ),
                              DataCell(Text(_displayText(customer.phone))),
                              DataCell(Text(_displayText(customer.province))),
                              DataCell(
                                Text(_formatDateTime(customer.updatedAt)),
                              ),
                              DataCell(
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      tooltip: 'แก้ไข',
                                      onPressed: () => onEdit(customer),
                                      icon: const Icon(SolarIconsOutline.pen),
                                    ),
                                    IconButton(
                                      tooltip: 'ลบ',
                                      onPressed: () => onDelete(customer),
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

class _CustomerFormDialog extends StatefulWidget {
  const _CustomerFormDialog({
    required this.customerService,
    required this.editingCustomer,
  });

  final CustomerService customerService;
  final Customer? editingCustomer;

  @override
  State<_CustomerFormDialog> createState() => _CustomerFormDialogState();
}

class _CustomerFormDialogState extends State<_CustomerFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _lineIdController = TextEditingController();
  final _citizenIdController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _faxController = TextEditingController();
  final _addressController = TextEditingController();
  final _subDistrictController = TextEditingController();
  final _districtController = TextEditingController();
  final _provinceController = TextEditingController();
  final _zipcodeController = TextEditingController();
  final _remarkController = TextEditingController();

  var _saving = false;
  DateTime? _birthDate;
  var _isBlacklisted = false;

  bool get _editing => widget.editingCustomer != null;

  @override
  void initState() {
    super.initState();
    final customer = widget.editingCustomer;
    if (customer != null) {
      _nameController.text = customer.name;
      _nicknameController.text = customer.nickname ?? '';
      _phoneController.text = customer.phone ?? '';
      _lineIdController.text = customer.lineId ?? '';
      _citizenIdController.text = customer.taxId ?? '';
      _setBirthDate(customer.birthDate);
      _faxController.text = customer.fax ?? '';
      _addressController.text = customer.address ?? '';
      _subDistrictController.text = customer.subDistrict ?? '';
      _districtController.text = customer.district ?? '';
      _provinceController.text = customer.province ?? '';
      _zipcodeController.text = customer.zipcode ?? '';
      _remarkController.text = customer.remark ?? customer.note ?? '';
      _isBlacklisted = customer.isBlacklisted;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nicknameController.dispose();
    _phoneController.dispose();
    _lineIdController.dispose();
    _citizenIdController.dispose();
    _birthDateController.dispose();
    _faxController.dispose();
    _addressController.dispose();
    _subDistrictController.dispose();
    _districtController.dispose();
    _provinceController.dispose();
    _zipcodeController.dispose();
    _remarkController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() => _saving = true);
    try {
      final payload = CustomerPayload(
        name: _nameController.text,
        nickname: _nicknameController.text,
        phone: _phoneController.text,
        email: widget.editingCustomer?.email,
        lineId: _lineIdController.text,
        citizenId: _citizenIdController.text,
        birthDate: _birthDate,
        fax: _faxController.text,
        address: _addressController.text,
        subDistrict: _subDistrictController.text,
        district: _districtController.text,
        province: _provinceController.text,
        zipcode: _zipcodeController.text,
        remark: _remarkController.text,
        isBlacklisted: _isBlacklisted,
      );

      final customer = widget.editingCustomer;
      final savedCustomer = customer == null
          ? await widget.customerService.createCustomer(payload)
          : await widget.customerService.updateCustomer(
              id: customer.id,
              payload: payload,
            );

      if (mounted) {
        Navigator.pop(context, savedCustomer);
      }
    } on CustomerException catch (error) {
      _showMessage(error.message);
    } catch (_) {
      _showMessage('ไม่สามารถบันทึกลูกค้าได้');
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
      return 'กรุณากรอกชื่อ-นามสกุล';
    }
    return null;
  }

  String? _citizenIdValidator(String? value) {
    final citizenId = (value ?? '').replaceAll(RegExp(r'\D'), '');
    if (citizenId.isNotEmpty && !RegExp(r'^\d{13}$').hasMatch(citizenId)) {
      return 'ต้องเป็นตัวเลข 13 หลัก';
    }
    return null;
  }

  void _setBirthDate(DateTime? value) {
    _birthDate = value == null
        ? null
        : DateTime(value.year, value.month, value.day);
    _birthDateController.text = _formatNullableDate(_birthDate);
    if (_birthDate == null) {
      _birthDateController.clear();
    }
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final initialDate = _birthDate == null || _birthDate!.isAfter(now)
        ? DateTime(now.year - 30, now.month, now.day)
        : _birthDate!;
    final picked = await showDatePicker(
      context: context,
      locale: const Locale('th', 'TH'),
      helpText: 'เลือกวันเกิด',
      cancelText: 'ยกเลิก',
      confirmText: 'ตกลง',
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked == null || !mounted) {
      return;
    }
    setState(() => _setBirthDate(picked));
  }

  void _clearBirthDate() {
    setState(() => _setBirthDate(null));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: _surfaceColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: _cardBorderRadius()),
      titlePadding: EdgeInsets.zero,
      title: _CustomerDialogHeader(editing: _editing),
      content: SizedBox(
        width: 860,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _CustomerFormSection(
                  icon: SolarIconsOutline.userId,
                  iconColor: _primaryColor,
                  title: 'ข้อมูลทั่วไป',
                  children: [
                    _CustomerFieldGrid(
                      children: [
                        _CustomerTextField(
                          controller: _nameController,
                          label: 'ชื่อ-นามสกุล',
                          placeholder: 'เช่น คุณสมชาย จัดดี',
                          icon: SolarIconsOutline.userRounded,
                          required: true,
                          validator: _requiredName,
                        ),
                        _CustomerTextField(
                          controller: _nicknameController,
                          label: 'ชื่อเล่น',
                          placeholder: 'เช่น ช่างเอก',
                          icon: SolarIconsOutline.tag,
                        ),
                        _CustomerTextField(
                          controller: _phoneController,
                          label: 'เบอร์โทรศัพท์',
                          placeholder: '081-234-5678',
                          icon: SolarIconsOutline.phoneCalling,
                        ),
                        _CustomerTextField(
                          controller: _lineIdController,
                          label: 'LINE ID',
                          placeholder: '@lineid',
                          icon: SolarIconsOutline.chatLine,
                        ),
                        _CustomerDateField(
                          controller: _birthDateController,
                          label: 'วัน/เดือน/ปีเกิด',
                          placeholder: 'เลือกวันเกิด',
                          selectedDate: _birthDate,
                          onTap: _pickBirthDate,
                          onClear: _clearBirthDate,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                _CustomerFormSection(
                  icon: SolarIconsOutline.card,
                  iconColor: const Color(0xFF2563EB),
                  title: 'ข้อมูลเพิ่มเติม',
                  children: [
                    _CustomerBlacklistSwitch(
                      value: _isBlacklisted,
                      onChanged: (value) {
                        setState(() => _isBlacklisted = value);
                      },
                    ),
                    const SizedBox(height: 16),
                    _CustomerFieldGrid(
                      children: [
                        _CustomerTextField(
                          controller: _citizenIdController,
                          label: 'เลขบัตรประชาชน',
                          placeholder: 'กรอกเลขบัตรประชาชน 13 หลัก',
                          icon: SolarIconsOutline.card,
                          keyboardType: TextInputType.number,
                          maxLength: 13,
                          helperText: 'ไม่บังคับกรอก',
                          validator: _citizenIdValidator,
                        ),
                        _CustomerTextField(
                          controller: _faxController,
                          label: 'เบอร์แฟกซ์',
                          placeholder: 'เบอร์แฟกซ์',
                          icon: SolarIconsOutline.printer,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                _CustomerFormSection(
                  icon: SolarIconsOutline.mapPoint,
                  iconColor: const Color(0xFFE11D48),
                  title: 'ที่อยู่',
                  children: [
                    _CustomerTextField(
                      controller: _addressController,
                      label: 'ที่อยู่',
                      placeholder: 'บ้านเลขที่, ถนน, ซอย...',
                      icon: SolarIconsOutline.mapPoint,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    _CustomerFieldGrid(
                      children: [
                        _CustomerTextField(
                          controller: _subDistrictController,
                          label: 'ตำบล / แขวง',
                          placeholder: 'ตำบล',
                          icon: SolarIconsOutline.mapPoint,
                        ),
                        _CustomerTextField(
                          controller: _districtController,
                          label: 'อำเภอ / เขต',
                          placeholder: 'อำเภอ',
                          icon: SolarIconsOutline.mapPoint,
                        ),
                        _CustomerTextField(
                          controller: _provinceController,
                          label: 'จังหวัด',
                          placeholder: 'จังหวัด',
                          icon: SolarIconsOutline.mapPoint,
                        ),
                        _CustomerTextField(
                          controller: _zipcodeController,
                          label: 'รหัสไปรษณีย์',
                          placeholder: 'รหัสไปรษณีย์',
                          icon: SolarIconsOutline.mapPoint,
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _CustomerTextField(
                      controller: _remarkController,
                      label: 'หมายเหตุเพิ่มเติม',
                      placeholder: 'บันทึกช่วยจำ...',
                      icon: SolarIconsOutline.notes,
                      maxLines: 2,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context),
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

class _CustomerDialogHeader extends StatelessWidget {
  const _CustomerDialogHeader({required this.editing});

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
                        : SolarIconsOutline.userPlusRounded,
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
                      editing ? 'แก้ไขข้อมูลลูกค้า' : 'เพิ่มข้อมูลลูกค้าใหม่',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      editing
                          ? 'ปรับปรุงข้อมูลส่วนตัว ข้อมูลการติดต่อ และเลขบัตรประชาชนของลูกค้า'
                          : 'กรอกข้อมูลลูกค้าใหม่ตามโครงข้อมูลของ SoftSteel CustomerForm',
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

class _CustomerFormSection extends StatelessWidget {
  const _CustomerFormSection({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.children,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DecoratedBox(
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: _surfaceBorderColor)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Icon(icon, color: iconColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        ...children,
      ],
    );
  }
}

class _CustomerFieldGrid extends StatelessWidget {
  const _CustomerFieldGrid({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 640 ? 2 : 1;
        final gap = columns == 2 ? 16.0 : 0.0;
        final width = columns == 2
            ? (constraints.maxWidth - gap) / 2
            : constraints.maxWidth;

        return Wrap(
          spacing: gap,
          runSpacing: 16,
          children: [
            for (final child in children) SizedBox(width: width, child: child),
          ],
        );
      },
    );
  }
}

class _CustomerTextField extends StatelessWidget {
  const _CustomerTextField({
    required this.controller,
    required this.label,
    required this.placeholder,
    required this.icon,
    this.required = false,
    this.validator,
    this.keyboardType,
    this.maxLength,
    this.maxLines = 1,
    this.helperText,
    this.fieldKey,
    this.focusNode,
  });

  final TextEditingController controller;
  final String label;
  final String placeholder;
  final IconData icon;
  final bool required;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final int? maxLength;
  final int maxLines;
  final String? helperText;
  final Key? fieldKey;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final labelText = required ? '$label *' : label;
    return TextFormField(
      key: fieldKey,
      controller: controller,
      focusNode: focusNode,
      validator: validator,
      keyboardType: keyboardType,
      maxLength: maxLength,
      maxLines: maxLines,
      textInputAction: maxLines > 1
          ? TextInputAction.newline
          : TextInputAction.next,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: placeholder,
        helperText: helperText,
        counterText: '',
        prefixIcon: maxLines > 1
            ? Padding(
                padding: const EdgeInsets.only(bottom: 44),
                child: Icon(icon),
              )
            : Icon(icon),
      ),
    );
  }
}

class _CustomerDateField extends StatelessWidget {
  const _CustomerDateField({
    required this.controller,
    required this.label,
    required this.placeholder,
    required this.selectedDate,
    required this.onTap,
    required this.onClear,
  });

  final TextEditingController controller;
  final String label;
  final String placeholder;
  final DateTime? selectedDate;
  final VoidCallback onTap;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        hintText: placeholder,
        prefixIcon: const Icon(SolarIconsOutline.calendarMinimalistic),
        suffixIcon: selectedDate == null
            ? null
            : IconButton(
                tooltip: 'ล้างวันเกิด',
                onPressed: onClear,
                icon: const Icon(SolarIconsOutline.closeCircle),
              ),
      ),
    );
  }
}

class _CustomerBlacklistSwitch extends StatelessWidget {
  const _CustomerBlacklistSwitch({
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final accentColor = value ? const Color(0xFFDC2626) : _primaryColor;
    return Material(
      color: value ? const Color(0xFFFEF2F2) : _softMintColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: value ? const Color(0xFFFECACA) : const Color(0xFFB7E0D8),
        ),
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeThumbColor: const Color(0xFFDC2626),
        title: Text(
          'ติดแบล็คลิสต์',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: accentColor,
            fontWeight: FontWeight.w800,
          ),
        ),
        subtitle: Text(
          value
              ? 'ลูกค้ารายนี้ถูกติดแบล็คลิสต์ และสามารถกรองดูแยกได้'
              : 'ลูกค้ารายนี้อยู่ในสถานะปกติ',
        ),
        secondary: Icon(
          value ? SolarIconsOutline.forbidden : SolarIconsOutline.shieldCheck,
          color: accentColor,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      ),
    );
  }
}

class _CustomerBlacklistBadge extends StatelessWidget {
  const _CustomerBlacklistBadge({required this.isBlacklisted});

  final bool isBlacklisted;

  @override
  Widget build(BuildContext context) {
    final color = isBlacklisted ? const Color(0xFFDC2626) : _primaryColor;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: isBlacklisted ? const Color(0xFFFEF2F2) : _softMintColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isBlacklisted
              ? const Color(0xFFFECACA)
              : const Color(0xFFB7E0D8),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isBlacklisted
                  ? SolarIconsOutline.forbidden
                  : SolarIconsOutline.shieldCheck,
              color: color,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              isBlacklisted ? 'แบล็คลิสต์' : 'ปกติ',
              style: TextStyle(color: color, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyCustomers extends StatelessWidget {
  const _EmptyCustomers();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 180,
      child: Center(child: Text('ยังไม่มีลูกค้า')),
    );
  }
}
