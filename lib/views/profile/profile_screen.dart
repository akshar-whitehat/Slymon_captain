import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_theme.dart';
import '../../models/captain_model.dart';
import '../../models/earnings_model.dart';
import '../../services/auth_service.dart';
import '../../services/earnings_service.dart';
import '../../widgets/custom_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = false;
  bool _isOnline = true;

  @override
  void initState() {
    super.initState();
    _loadCaptainData();
  }

  Future<void> _loadCaptainData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final captain = await Provider.of<AuthService>(context, listen: false).getCaptainData();
      if (mounted && captain != null) {
        setState(() {
          _isOnline = captain.isOnline;
        });
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

  Future<void> _toggleOnlineStatus() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<AuthService>(context, listen: false).updateOnlineStatus(!_isOnline);
      
      if (mounted) {
        setState(() {
          _isOnline = !_isOnline;
        });
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

  Future<void> _signOut() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<AuthService>(context, listen: false).signOut();
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
    final authService = Provider.of<AuthService>(context);
    final earningsService = Provider.of<EarningsService>(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          AppStrings.profile,
          style: TextStyle(
            color: AppTheme.textColor,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: AppTheme.textColor),
            onPressed: () {
              // Navigate to settings screen
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileHeader(authService),
                  const SizedBox(height: 24),
                  _buildEarningsSummary(earningsService),
                  const SizedBox(height: 24),
                  _buildMenuItems(),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: AppStrings.logout,
                    icon: Icons.logout,
                    onPressed: _signOut,
                    isLoading: _isLoading,
                    isOutlined: true,
                    backgroundColor: AppTheme.errorColor,
                    textColor: AppTheme.errorColor,
                    width: double.infinity,
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileHeader(AuthService authService) {
    return FutureBuilder<CaptainModel?>(
      future: authService.getCaptainData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final captain = snapshot.data;

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                      backgroundImage: captain?.photoUrl.isNotEmpty == true
                          ? NetworkImage(captain!.photoUrl)
                          : null,
                      child: captain?.photoUrl.isEmpty == true
                          ? const Icon(
                              Icons.person,
                              size: 40,
                              color: AppTheme.primaryColor,
                            )
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            captain?.name ?? 'Captain',
                            style: AppTheme.headingStyle,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            captain?.phone ?? '',
                            style: AppTheme.bodyStyle.copyWith(
                              color: AppTheme.lightTextColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${captain?.rating.toStringAsFixed(1) ?? '0.0'} Rating',
                                style: AppTheme.bodyStyle.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _isOnline ? 'Online' : 'Offline',
                      style: AppTheme.bodyStyle.copyWith(
                        fontWeight: FontWeight.w600,
                        color: _isOnline ? AppTheme.successColor : AppTheme.errorColor,
                      ),
                    ),
                    Switch(
                      value: _isOnline,
                      onChanged: (value) => _toggleOnlineStatus(),
                      activeColor: AppTheme.successColor,
                      activeTrackColor: AppTheme.successColor.withOpacity(0.5),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildVehicleInfo('Vehicle', captain?.vehicle.model ?? ''),
                    _buildVehicleInfo('Number', captain?.vehicle.number ?? ''),
                    _buildVehicleInfo(
                      'Type',
                      captain?.vehicle.type.toString().split('.').last.toUpperCase() ?? '',
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildVehicleInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.captionStyle,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTheme.bodyStyle.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildEarningsSummary(EarningsService earningsService) {
    return FutureBuilder<EarningsSummary>(
      future: earningsService.getEarningsSummary(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final summary = snapshot.data ?? EarningsSummary.empty();

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      AppStrings.earnings,
                      style: AppTheme.subheadingStyle,
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to earnings screen
                      },
                      child: const Text(
                        'View All',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildEarningsItem(
                      AppStrings.todayEarnings,
                      '₹${summary.todayEarnings.toStringAsFixed(0)}',
                    ),
                    _buildEarningsItem(
                      AppStrings.weeklyEarnings,
                      '₹${summary.weeklyEarnings.toStringAsFixed(0)}',
                    ),
                    _buildEarningsItem(
                      AppStrings.monthlyEarnings,
                      '₹${summary.monthlyEarnings.toStringAsFixed(0)}',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildEarningsItem(
                      AppStrings.totalEarnings,
                      '₹${summary.totalEarnings.toStringAsFixed(0)}',
                    ),
                    _buildEarningsItem(
                      AppStrings.totalRides,
                      summary.totalRides.toString(),
                    ),
                    _buildEarningsItem(
                      AppStrings.totalDistance,
                      '${summary.totalDistance.toStringAsFixed(0)} km',
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEarningsItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.captionStyle,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTheme.bodyStyle.copyWith(
            fontWeight: FontWeight.w600,
            color: label == AppStrings.totalEarnings || label == AppStrings.todayEarnings
                ? AppTheme.primaryColor
                : AppTheme.textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItems() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            _buildMenuItem(
              Icons.person,
              AppStrings.personalInfo,
              () {
                // Navigate to personal info screen
              },
            ),
            const Divider(),
            _buildMenuItem(
              Icons.directions_car,
              AppStrings.vehicleInfo,
              () {
                // Navigate to vehicle info screen
              },
            ),
            const Divider(),
            _buildMenuItem(
              Icons.description,
              AppStrings.documents,
              () {
                // Navigate to documents screen
              },
            ),
            const Divider(),
            _buildMenuItem(
              Icons.help,
              AppStrings.help,
              () {
                // Navigate to help screen
              },
            ),
            const Divider(),
            _buildMenuItem(
              Icons.info,
              AppStrings.about,
              () {
                // Navigate to about screen
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppTheme.primaryColor,
      ),
      title: Text(
        title,
        style: AppTheme.bodyStyle,
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: AppTheme.lightTextColor,
      ),
      onTap: onTap,
    );
  }
}