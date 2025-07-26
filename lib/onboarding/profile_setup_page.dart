import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:math';
import '../models/user_role.dart';
import 'package:multi_role_flutter_auth/services/supabase_services.dart';
import 'package:multi_role_flutter_auth/dashboard/dashboard_router.dart';

/*
 * CUSTOMIZABLE PROFILE SETUP PAGE
 * 
 * This template provides a complete profile setup page that you can easily customize
 * for your specific application needs, or you can skip it. 
 * 
 * DATABASE CUSTOMIZATION:
 * 1. Create your own Supabase table (suggested name: 'user_profiles')
 * 2. Add any columns you need (examples below)
 * 3. Update the field controllers and builders in this file
 * 
 * SUGGESTED SUPABASE SCHEMA:
 * 
 * CREATE TABLE user_profiles (
 *   id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
 *   user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
 *   custom_user_id TEXT UNIQUE, -- Auto-generated ID like "MEM0001"
 *   email TEXT,
 *   name TEXT,
 *   role TEXT,
 *   phone TEXT,
 *   date_of_birth DATE,
 *   gender TEXT,
 *   department TEXT,
 *   location TEXT,
 *   profile_image_url TEXT,
 *   
 *   -- ADD YOUR CUSTOM FIELDS HERE:
 * */

class ProfileSetupPage extends StatefulWidget {
  final UserRole selectedRole;

  const ProfileSetupPage({super.key, required this.selectedRole});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
final _formKey = GlobalKey<FormState>();

  // Core fields
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();
  
  // Custom fields
  final _field1Controller = TextEditingController();
  final _field2Controller = TextEditingController();
  final _field3Controller = TextEditingController();
  
  // State variables
  bool _isLoading = false;
  String? _errorMessage;
  File? _selectedImage;
  DateTime? _selectedDate;
  
  // Dropdown selections
  String? _selectedGender;
  String? _selectedDepartment;
  String? _selectedLocation;
  
  final List<String> _genderOptions = ['Male', 'Female', 'Other', 'Prefer not to say'];
  final List<String> _departmentOptions = ['Engineering', 'Marketing', 'Sales', 'HR', 'Finance', 'Operations'];
  final List<String> _locationOptions = ['Samastipur', 'Patna', 'Delhi', 'Remote'];

  @override
  void initState() {
    super.initState();
    final user = SupabaseService.getCurrentUser();
    if (user?.email != null) {
      _emailController.text = user!.email!;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _field1Controller.dispose();
    _field2Controller.dispose();
    _field3Controller.dispose();
    super.dispose();
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.guest:
        return Colors.green;
      case UserRole.member:
        return Colors.blue;
      case UserRole.lead:
        return Colors.orange;
      case UserRole.admin:
        return Colors.purple;
      case UserRole.superadmin:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive design
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final horizontalPadding = isTablet ? 32.0 : 20.0;
    final maxWidth = isTablet ? 500.0 : double.infinity;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Complete Profile',
          style: TextStyle(
            fontSize: isTablet ? 20 : 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey[800],
        elevation: 0,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.grey[200],
          ),
        ),
      ),
      body: SafeArea(
        child: _isLoading ? _buildLoadingState() : _buildScrollableForm(horizontalPadding, maxWidth),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: _getRoleColor(widget.selectedRole),
          ),
          const SizedBox(height: 16),
          Text(
            'Setting up your profile...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScrollableForm(double horizontalPadding, double maxWidth) {
  return SingleChildScrollView(
    physics: const ClampingScrollPhysics(),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                
                // Profile image
                _buildMobileImageUpload(),
                
                const SizedBox(height: 16),

                // Role info
                _buildCompactRoleInfo(),
                
                const SizedBox(height: 24),

                // Basic Information Card
                _buildFormCard(
                  title: 'Basic Information',
                  children: [
                    _buildNameField(),
                    const SizedBox(height: 12),
                    _buildEmailField(),
                    const SizedBox(height: 12),
                    _buildPhoneField(),
                    const SizedBox(height: 12),
                    _buildDOBField(),
                    const SizedBox(height: 12),
                    _buildGenderDropdown(),
                  ],
                ),
                
                const SizedBox(height: 16),

                // Additional Information Card
                _buildFormCard(
                  title: 'Additional Information',
                  children: [
                    _buildDepartmentDropdown(),
                    const SizedBox(height: 12),
                    _buildLocationDropdown(),
                    const SizedBox(height: 12),
                    _buildCustomField1(),
                    const SizedBox(height: 12),
                    _buildCustomField2(),
                    const SizedBox(height: 12),
                    _buildCustomField3(),
                  ],
                ),
                
                const SizedBox(height: 20),

                // Error message
                if (_errorMessage != null) ...[
                  _buildErrorMessage(),
                  const SizedBox(height: 16),
                ],

                // Submit button
                _buildSubmitButton(),
                
                const SizedBox(height: 16),

                // Additional info
                _buildAdditionalInfo(),
                
                // Bottom padding for mobile keyboards
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}


  Widget _buildCompactRoleInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getRoleColor(widget.selectedRole).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getRoleColor(widget.selectedRole).withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            widget.selectedRole.icon,
            color: _getRoleColor(widget.selectedRole),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Signing up as ${widget.selectedRole.displayName}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _getRoleColor(widget.selectedRole),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: _getRoleColor(widget.selectedRole),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'SELECTED',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileImageUpload() {
    return Center(
      child: GestureDetector(
        onTap: _pickImage,
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: _getRoleColor(widget.selectedRole).withOpacity(0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: _selectedImage != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(48),
                  child: Image.file(
                    _selectedImage!,
                    fit: BoxFit.cover,
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_a_photo,
                      size: 28,
                      color: _getRoleColor(widget.selectedRole),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Photo',
                      style: TextStyle(
                        color: _getRoleColor(widget.selectedRole),
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildFormCard({required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 3,
                height: 16,
                decoration: BoxDecoration(
                  color: _getRoleColor(widget.selectedRole),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  // Optimized field builders for mobile
  Widget _buildNameField() {
    return _buildMobileTextField(
      controller: _nameController,
      label: 'Full Name',
      icon: Icons.person_outline,
      required: true,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your full name';
        }
        if (value.trim().length < 2) {
          return 'Name must be at least 2 characters';
        }
        return null;
      },
    );
  }

  Widget _buildEmailField() {
    return _buildMobileTextField(
      controller: _emailController,
      label: 'Email Address',
      icon: Icons.email_outlined,
      enabled: false,
      suffixIcon: Icons.check_circle,
      suffixIconColor: Colors.green,
    );
  }

  Widget _buildPhoneField() {
    return _buildMobileTextField(
      controller: _phoneController,
      label: 'Phone Number',
      icon: Icons.phone_outlined,
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          if (value.length < 10) {
            return 'Please enter a valid phone number';
          }
        }
        return null;
      },
    );
  }

  Widget _buildDOBField() {
    return GestureDetector(
      onTap: _selectDate,
      child: AbsorbPointer(
        child: _buildMobileTextField(
          controller: _dobController,
          label: 'Date of Birth',
          icon: Icons.calendar_today_outlined,
          hintText: 'Select date',
          suffixIcon: Icons.arrow_drop_down,
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return _buildMobileDropdownField(
      value: _selectedGender,
      label: 'Gender',
      icon: Icons.person_outline,
      items: _genderOptions,
      onChanged: (value) {
        setState(() {
          _selectedGender = value;
        });
      },
    );
  }

  Widget _buildDepartmentDropdown() {
    return _buildMobileDropdownField(
      value: _selectedDepartment,
      label: 'Department',
      icon: Icons.business_outlined,
      items: _departmentOptions,
      onChanged: (value) {
        setState(() {
          _selectedDepartment = value;
        });
      },
    );
  }

  Widget _buildLocationDropdown() {
    return _buildMobileDropdownField(
      value: _selectedLocation,
      label: 'Location',
      icon: Icons.location_on_outlined,
      items: _locationOptions,
      onChanged: (value) {
        setState(() {
          _selectedLocation = value;
        });
      },
    );
  }

  Widget _buildCustomField1() {
    return _buildMobileTextField(
      controller: _field1Controller,
      label: 'Custom Field 1',
      icon: Icons.star_outline,
      hintText: 'Enter custom field 1',
    );
  }

  Widget _buildCustomField2() {
    return _buildMobileTextField(
      controller: _field2Controller,
      label: 'Custom Field 2',
      icon: Icons.work_outline,
      hintText: 'Enter custom field 2',
    );
  }

  Widget _buildCustomField3() {
    return _buildMobileTextField(
      controller: _field3Controller,
      label: 'Custom Field 3',
      icon: Icons.info_outline,
      hintText: 'Enter custom field 3',
      multiline: true,
    );
  }

  // Mobile-optimized text field
  Widget _buildMobileTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hintText,
    bool required = false,
    bool enabled = true,
    bool multiline = false,
    TextInputType? keyboardType,
    IconData? suffixIcon,
    Color? suffixIconColor,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Compact label
        RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
            children: required
                ? [
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]
                : [],
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          maxLines: multiline ? 3 : 1,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(fontSize: 14, color: Colors.grey[500]),
            prefixIcon: Icon(icon, size: 20),
            suffixIcon: suffixIcon != null
                ? Icon(suffixIcon, color: suffixIconColor, size: 20)
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: _getRoleColor(widget.selectedRole)),
            ),
            filled: true,
            fillColor: enabled ? Colors.grey[50] : Colors.grey[100],
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            isDense: true,
          ),
          validator: validator,
        ),
      ],
    );
  }

  // Mobile-optimized dropdown field
  Widget _buildMobileDropdownField({
    required String? value,
    required String label,
    required IconData icon,
    required List<String> items,
    required void Function(String?) onChanged,
    bool required = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
            children: required
                ? [
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]
                : [],
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: _getRoleColor(widget.selectedRole)),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            isDense: true,
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: const TextStyle(fontSize: 14)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.red.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _errorMessage!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submitProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: _getRoleColor(widget.selectedRole),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 2,
        ),
        child: _isLoading
            ? const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                'Complete Setup',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildAdditionalInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.blue,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'You can update your profile information anytime from settings.',
              style: TextStyle(
                color: Colors.blue[700],
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Select Photo',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildImageOption(
                        icon: Icons.photo_library,
                        label: 'Gallery',
                        onTap: () async {
                          Navigator.pop(context);
                          final XFile? image = await picker.pickImage(
                            source: ImageSource.gallery,
                            imageQuality: 80,
                          );
                          if (image != null) {
                            setState(() {
                              _selectedImage = File(image.path);
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildImageOption(
                        icon: Icons.camera_alt,
                        label: 'Camera',
                        onTap: () async {
                          Navigator.pop(context);
                          final XFile? image = await picker.pickImage(
                            source: ImageSource.camera,
                            imageQuality: 80,
                          );
                          if (image != null) {
                            setState(() {
                              _selectedImage = File(image.path);
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: _getRoleColor(widget.selectedRole)),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now().subtract(const Duration(days: 6570)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: _getRoleColor(widget.selectedRole),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  Future<void> _submitProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final user = SupabaseService.getCurrentUser();
    if (user == null) {
      setState(() {
        _errorMessage = 'Please sign in to continue';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final profileData = {
        'user_id': user.id,
        'email': user.email,
        'name': _nameController.text.trim(),
        'role': widget.selectedRole.name,
        'phone': _phoneController.text.trim().isNotEmpty ? _phoneController.text.trim() : null,
        'date_of_birth': _selectedDate?.toIso8601String(),
        'gender': _selectedGender,
        'department': _selectedDepartment,
        'location': _selectedLocation,
        'custom_field_1': _field1Controller.text.trim().isNotEmpty ? _field1Controller.text.trim() : null,
        'custom_field_2': _field2Controller.text.trim().isNotEmpty ? _field2Controller.text.trim() : null,
        'custom_field_3': _field3Controller.text.trim().isNotEmpty ? _field3Controller.text.trim() : null,
      };

      final insertResult = await SupabaseService.client
          .from('user_profiles')
          .insert(profileData)
          .select()
          .maybeSingle();

      if (insertResult == null) {
        setState(() {
          _errorMessage = 'Failed to create user profile.';
        });
        return;
      }

      bool idAssigned = false;
      int retryCount = 0;
      const maxRetries = 5;

      while (!idAssigned && retryCount < maxRetries) {
        final customUserId = await generateUniqueUserId();

        try {
          final updateResult = await SupabaseService.client
              .from('user_profiles')
              .update({'custom_user_id': customUserId})
              .eq('user_id', user.id)
              .select()
              .maybeSingle();

          if (updateResult != null &&
              updateResult['custom_user_id'] == customUserId) {
            idAssigned = true;
          } else {
            retryCount++;
            await Future.delayed(const Duration(milliseconds: 150));
          }
        } catch (e) {
          if (e.toString().contains('duplicate key value')) {
            retryCount++;
            await Future.delayed(const Duration(milliseconds: 150));
          } else {
            rethrow;
          }
        }
      }

      if (!idAssigned) {
        setState(() {
          _errorMessage = 'Failed to assign a unique user ID after several attempts.';
        });
        return;
      }

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardRouter(role: widget.selectedRole),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: $e';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<String> generateUniqueUserId() async {
    final prefix = widget.selectedRole.prefix;
    final random = Random();

    for (int i = 0; i < 10; i++) {
      final number = random.nextInt(10000);
      final candidateId = '$prefix${number.toString().padLeft(4, '0')}';

      final existing = await SupabaseService.client
          .from('user_profiles')
          .select('custom_user_id')
          .eq('custom_user_id', candidateId)
          .maybeSingle();

      if (existing == null) {
        return candidateId;
      }
    }

    throw Exception('Failed to generate unique user ID after 10 attempts');
  }
}
