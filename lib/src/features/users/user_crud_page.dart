part of '../../../main.dart';

class UserCrudPage extends StatefulWidget {
  const UserCrudPage({
    super.key,
    required this.database,
    required this.authService,
    required this.currentUser,
    required this.onCurrentUserChanged,
    required this.onCurrentUserDeleted,
  });

  final AppDatabase database;
  final AuthService authService;
  final User currentUser;
  final Future<void> Function() onCurrentUserChanged;
  final VoidCallback onCurrentUserDeleted;

  @override
  State<UserCrudPage> createState() => _UserCrudPageState();
}

class _UserCrudPageState extends State<UserCrudPage> {
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

  Future<void> _deleteUser(User user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _surfaceColor,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: _cardBorderRadius()),
        title: const Text('ลบผู้ใช้'),
        content: Text('ต้องการลบ ${user.fullName} หรือไม่'),
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

    await widget.authService.deleteUser(user.id);
    if (user.id == widget.currentUser.id) {
      widget.onCurrentUserDeleted();
      return;
    }
    _showMessage('ลบผู้ใช้แล้ว');
  }

  void _showMessage(String message, {_ToastType type = _ToastType.success}) {
    if (!mounted) {
      return;
    }
    _showToast(context, message, type: type);
  }

  Future<void> _openUserForm([User? user]) async {
    final saved = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => _UserFormDialog(
        authService: widget.authService,
        editingUser: user,
        currentUserId: widget.currentUser.id,
        onCurrentUserChanged: widget.onCurrentUserChanged,
      ),
    );

    if (saved != true) {
      return;
    }
    _showMessage(user == null ? 'สร้างผู้ใช้แล้ว' : 'อัปเดตผู้ใช้แล้ว');
  }

  List<User> _filterUsers(List<User> users) {
    if (_searchText.isEmpty) {
      return users;
    }
    return users.where((user) {
      final values = [
        user.fullName,
        user.username,
        user.phone ?? '',
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
            _UserToolbar(
              searchController: _searchController,
              onCreate: () => _openUserForm(),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: _UserTablePanel(
                database: widget.database,
                currentUser: widget.currentUser,
                filterUsers: _filterUsers,
                onEdit: _openUserForm,
                onDelete: _deleteUser,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserToolbar extends StatelessWidget {
  const _UserToolbar({required this.searchController, required this.onCreate});

  final TextEditingController searchController;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text('ผู้ใช้', style: Theme.of(context).textTheme.titleLarge),
        ),
        SizedBox(
          width: 280,
          child: TextField(
            controller: searchController,
            decoration: const InputDecoration(
              labelText: 'ค้นหา',
              prefixIcon: Icon(SolarIconsOutline.magnifier),
              isDense: true,
            ),
          ),
        ),
        const SizedBox(width: 12),
        FilledButton.icon(
          onPressed: onCreate,
          icon: const Icon(SolarIconsOutline.userPlus),
          label: const Text('เพิ่มผู้ใช้'),
        ),
      ],
    );
  }
}

class _UserTablePanel extends StatelessWidget {
  const _UserTablePanel({
    required this.database,
    required this.currentUser,
    required this.filterUsers,
    required this.onEdit,
    required this.onDelete,
  });

  final AppDatabase database;
  final User currentUser;
  final List<User> Function(List<User> users) filterUsers;
  final ValueChanged<User> onEdit;
  final ValueChanged<User> onDelete;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: _surfaceDecoration(),
      child: StreamBuilder<List<User>>(
        stream: database.watchActiveUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = filterUsers(snapshot.data ?? const []);
          if (users.isEmpty) {
            return const _EmptyUsers();
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
                        dataRowMaxHeight: 68,
                        headingTextStyle: Theme.of(context).textTheme.labelLarge
                            ?.copyWith(fontWeight: FontWeight.w700),
                        columns: const [
                          DataColumn(label: Text('ชื่อ-นามสกุล')),
                          DataColumn(label: Text('ชื่อผู้ใช้')),
                          DataColumn(label: Text('เบอร์โทร')),
                          DataColumn(label: Text('สถานะ')),
                          DataColumn(label: Text('อัปเดตล่าสุด')),
                          DataColumn(label: Text('จัดการ')),
                        ],
                        rows: users.map((user) {
                          final isCurrentUser = user.id == currentUser.id;
                          return DataRow(
                            cells: [
                              DataCell(Text(user.fullName)),
                              DataCell(Text(user.username)),
                              DataCell(Text(_displayText(user.phone))),
                              DataCell(
                                isCurrentUser
                                    ? const _CurrentUserBadge()
                                    : const Text('-'),
                              ),
                              DataCell(Text(_formatDateTime(user.updatedAt))),
                              DataCell(
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      tooltip: 'แก้ไข',
                                      onPressed: () => onEdit(user),
                                      icon: const Icon(SolarIconsOutline.pen),
                                    ),
                                    IconButton(
                                      tooltip: 'ลบ',
                                      onPressed: () => onDelete(user),
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

class _UserFormDialog extends StatefulWidget {
  const _UserFormDialog({
    required this.authService,
    required this.editingUser,
    required this.currentUserId,
    required this.onCurrentUserChanged,
  });

  final AuthService authService;
  final User? editingUser;
  final String currentUserId;
  final Future<void> Function() onCurrentUserChanged;

  @override
  State<_UserFormDialog> createState() => _UserFormDialogState();
}

class _UserFormDialogState extends State<_UserFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  var _saving = false;
  var _passwordVisible = false;

  bool get _editing => widget.editingUser != null;

  @override
  void initState() {
    super.initState();
    final user = widget.editingUser;
    if (user != null) {
      _fullNameController.text = user.fullName;
      _usernameController.text = user.username;
      _phoneController.text = user.phone ?? '';
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() => _saving = true);
    try {
      final user = widget.editingUser;
      if (user == null) {
        await widget.authService.register(
          fullName: _fullNameController.text,
          username: _usernameController.text,
          password: _passwordController.text,
          phone: _phoneController.text,
        );
      } else {
        await widget.authService.updateUser(
          id: user.id,
          fullName: _fullNameController.text,
          username: _usernameController.text,
          password: _passwordController.text,
          phone: _phoneController.text,
        );
        if (user.id == widget.currentUserId) {
          await widget.onCurrentUserChanged();
        }
      }

      if (mounted) {
        Navigator.pop(context, true);
      }
    } on AuthException catch (error) {
      _showMessage(error.message, type: _ToastType.warning);
    } catch (_) {
      _showMessage('ไม่สามารถบันทึกผู้ใช้ได้', type: _ToastType.error);
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  void _showMessage(String message, {_ToastType type = _ToastType.success}) {
    if (!mounted) {
      return;
    }
    _showToast(context, message, type: type);
  }

  String? _required(String? value) {
    if ((value ?? '').trim().isEmpty) {
      return 'จำเป็นต้องกรอก';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: _surfaceColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: _cardBorderRadius()),
      title: Text(_editing ? 'แก้ไขผู้ใช้' : 'เพิ่มผู้ใช้'),
      content: SizedBox(
        width: 430,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _fullNameController,
                  textInputAction: TextInputAction.next,
                  validator: _required,
                  decoration: const InputDecoration(
                    labelText: 'ชื่อ-นามสกุล',
                    prefixIcon: Icon(SolarIconsOutline.userId),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _usernameController,
                  textInputAction: TextInputAction.next,
                  validator: _required,
                  decoration: const InputDecoration(
                    labelText: 'ชื่อผู้ใช้',
                    prefixIcon: Icon(SolarIconsOutline.userRounded),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_passwordVisible,
                  textInputAction: TextInputAction.next,
                  validator: _editing ? null : _required,
                  decoration: InputDecoration(
                    labelText: _editing ? 'รหัสผ่านใหม่' : 'รหัสผ่าน',
                    prefixIcon: const Icon(SolarIconsOutline.lockKeyhole),
                    suffixIcon: IconButton(
                      tooltip: _passwordVisible
                          ? 'ซ่อนรหัสผ่าน'
                          : 'แสดงรหัสผ่าน',
                      onPressed: () {
                        setState(() => _passwordVisible = !_passwordVisible);
                      },
                      icon: Icon(
                        _passwordVisible
                            ? SolarIconsOutline.eyeClosed
                            : SolarIconsOutline.eye,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _phoneController,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _save(),
                  decoration: const InputDecoration(
                    labelText: 'เบอร์โทร',
                    prefixIcon: Icon(SolarIconsOutline.phone),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
              : Icon(
                  _editing
                      ? SolarIconsOutline.diskette
                      : SolarIconsOutline.userPlus,
                ),
          label: Text(_editing ? 'บันทึกการแก้ไข' : 'เพิ่มผู้ใช้'),
        ),
      ],
    );
  }
}

class _CurrentUserBadge extends StatelessWidget {
  const _CurrentUserBadge();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _softSlateColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: _surfaceBorderColor),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: Text('กำลังใช้งาน'),
      ),
    );
  }
}

class _EmptyUsers extends StatelessWidget {
  const _EmptyUsers();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 180,
      child: Center(child: Text('ยังไม่มีผู้ใช้')),
    );
  }
}
