import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_theme.dart';
import '../../models/captain_model.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../main_app_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _vehicleNumberController = TextEditingController();
  final _vehicleModelController = TextEditingController();
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  VehicleType _selectedVehicleType = VehicleType.car;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _vehicleNumberController.dispose();
    _vehicleModelController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // In a real app, you would upload these files to Firebase Storage
      // and get the download URLs
      const photoUrl = '';
      const drivingLicenseUrl = '';
      const vehicleRegistrationUrl = '';

      final vehicle = VehicleModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        number: _vehicleNumberController.text.trim(),
        model: _vehicleModelController.text.trim(),
        type: _selectedVehicleType,
        registrationUrl: vehicleRegistrationUrl,
      );

      await Provider.of<AuthService>(context, listen: false).registerWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text,
        _nameController.text.trim(),
        _phoneController.text.trim(),
        vehicle,
        drivingLicenseUrl,
        photoUrl,
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainAppScreen(),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          AppStrings.register,
          style: TextStyle(
            color: AppTheme.textColor,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: AppTheme.textColor,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Personal Information',
                  style: AppTheme.subheadingStyle,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  hint: AppStrings.name,
                  controller: _nameController,
                  prefixIcon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  hint: AppStrings.email,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  hint: AppStrings.phone,
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                      return 'Please enter a valid 10-digit phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  hint: AppStrings.password,
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  prefixIcon: Icons.lock,
                  suffix: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      color: AppTheme.lightTextColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  hint: AppStrings.confirmPassword,
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  prefixIcon: Icons.lock,
                  suffix: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                      color: AppTheme.lightTextColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                const Text(
                  AppStrings.vehicleDetails,
                  style: AppTheme.subheadingStyle,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  hint: AppStrings.vehicleNumber,
                  controller: _vehicleNumberController,
                  prefixIcon: Icons.directions_car,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your vehicle number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  hint: AppStrings.vehicleModel,
                  controller: _vehicleModelController,
                  prefixIcon: Icons.directions_car,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your vehicle model';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  AppStrings.vehicleType,
                  style: AppTheme.bodyStyle,
                ),
                const SizedBox(height: 8),
                _buildVehicleTypeSelector(),
                const SizedBox(height: 32),
                const Text(
                  'Documents',
                  style: AppTheme.subheadingStyle,
                ),
                const SizedBox(height: 16),
                _buildDocumentUploadButton(
                  AppStrings.uploadDrivingLicense,
                  Icons.assignment_ind,
                ),
                const SizedBox(height: 16),
                _buildDocumentUploadButton(
                  AppStrings.uploadVehicleRegistration,
                  Icons.description,
                ),
                const SizedBox(height: 16),
                _buildDocumentUploadButton(
                  AppStrings.uploadProfilePhoto,
                  Icons.person,
                ),
                const SizedBox(height: 32),
                CustomButton(
                  text: AppStrings.createAccount,
                  onPressed: _register,
                  isLoading: _isLoading,
                  width: double.infinity,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.alreadyHaveAccount,
                      style: AppTheme.bodyStyle.copyWith(
                        color: AppTheme.lightTextColor,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        AppStrings.signIn,
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleTypeSelector() {
    return Row(
      children: [
        _buildVehicleTypeOption(
          'Car',
          Icons.directions_car,
          VehicleType.car,
        ),
        const SizedBox(width: 16),
        _buildVehicleTypeOption(
          'Bike',
          Icons.two_wheeler,
          VehicleType.bike,
        ),
        const SizedBox(width: 16),
        _buildVehicleTypeOption(
          'Auto',
          Icons.electric_rickshaw,
          VehicleType.auto,
        ),
      ],
    );
  }

  Widget _buildVehicleTypeOption(String label, IconData icon, VehicleType type) {
    final isSelected = _selectedVehicleType == type;
    
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedVehicleType = type;
          });
        },
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(AppTheme.borderRadius),
            border: Border.all(
              color: isSelected ? AppTheme.primaryColor : AppTheme.lightTextColor.withOpacity(0.3),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? AppTheme.primaryColor : AppTheme.lightTextColor,
                size: 24,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: AppTheme.bodyStyle.copyWith(
                  color: isSelected ? AppTheme.primaryColor : AppTheme.textColor,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentUploadButton(String label, IconData icon) {
    return InkWell(
      onTap: () {
        // In a real app, you would implement file picking and uploading
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Document upload will be implemented in the full app'),
            backgroundColor: AppTheme.infoColor,
          ),
        );
      },
      borderRadius: BorderRadius.circular(AppTheme.borderRadius),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: AppTheme.lightBackgroundColor,
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          border: Border.all(
            color: AppTheme.lightTextColor.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppTheme.primaryColor,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: AppTheme.bodyStyle,
              ),
            ),
            const Icon(
              Icons.upload_file,
              color: AppTheme.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}