import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_theme.dart';
import '../../models/ride_model.dart';
import '../../services/ride_service.dart';
import '../../widgets/custom_button.dart';
import '../tracking/tracking_screen.dart';

class RideDetailsScreen extends StatefulWidget {
  final String rideId;

  const RideDetailsScreen({
    Key? key,
    required this.rideId,
  }) : super(key: key);

  @override
  State<RideDetailsScreen> createState() => _RideDetailsScreenState();
}

class _RideDetailsScreenState extends State<RideDetailsScreen> {
  bool _isLoading = false;
  RideModel? _ride;

  @override
  void initState() {
    super.initState();
    _loadRideDetails();
  }

  Future<void> _loadRideDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final ride = await Provider.of<RideService>(context, listen: false)
          .getRideById(widget.rideId);
      
      if (mounted) {
        setState(() {
          _ride = ride;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  Future<void> _startRide() async {
    if (_ride == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<RideService>(context, listen: false)
          .updateRideStatus(_ride!.id, RideStatus.inProgress);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ride started successfully'),
            backgroundColor: AppTheme.successColor,
          ),
        );
        
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TrackingScreen(rideId: _ride!.id),
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

  Future<void> _cancelRide() async {
    if (_ride == null) return;

    final reason = await _showCancelReasonDialog();
    if (reason == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<RideService>(context, listen: false)
          .cancelRide(_ride!.id, reason);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ride cancelled successfully'),
            backgroundColor: AppTheme.successColor,
          ),
        );
        
        Navigator.pop(context);
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

  Future<String?> _showCancelReasonDialog() async {
    final reasonController = TextEditingController();
    
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Ride'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please provide a reason for cancellation:'),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                hintText: 'Enter reason',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (reasonController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a reason'),
                    backgroundColor: AppTheme.errorColor,
                  ),
                );
                return;
              }
              Navigator.pop(context, reasonController.text.trim());
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  Future<void> _callPassenger() async {
    // In a real app, you would get the passenger's phone number from the user document
    final phoneNumber = 'tel:+1234567890';
    
    if (await canLaunch(phoneNumber)) {
      await launch(phoneNumber);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not launch phone app'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          AppStrings.rideDetails,
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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _ride == null
              ? const Center(
                  child: Text('Ride not found'),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRideInfoCard(),
                      const SizedBox(height: 16),
                      _buildLocationCard(),
                      const SizedBox(height: 16),
                      _buildPassengerCard(),
                      const SizedBox(height: 24),
                      _buildActionButtons(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildRideInfoCard() {
    if (_ride == null) return const SizedBox.shrink();

    String statusText;
    Color statusColor;

    switch (_ride!.status) {
      case RideStatus.accepted:
        statusText = 'Accepted';
        statusColor = AppTheme.infoColor;
        break;
      case RideStatus.arriving:
        statusText = 'Arriving';
        statusColor = AppTheme.infoColor;
        break;
      case RideStatus.arrived:
        statusText = 'Arrived';
        statusColor = AppTheme.warningColor;
        break;
      case RideStatus.inProgress:
        statusText = 'In Progress';
        statusColor = AppTheme.primaryColor;
        break;
      case RideStatus.completed:
        statusText = 'Completed';
        statusColor = AppTheme.successColor;
        break;
      case RideStatus.cancelled:
        statusText = 'Cancelled';
        statusColor = AppTheme.errorColor;
        break;
      default:
        statusText = 'Pending';
        statusColor = AppTheme.warningColor;
    }

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
                  AppStrings.rideId,
                  style: AppTheme.captionStyle,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    statusText,
                    style: AppTheme.captionStyle.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              _ride!.id.substring(0, 8),
              style: AppTheme.bodyStyle.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoItem(
                  AppStrings.rideDate,
                  '${_ride!.scheduledTime.day}/${_ride!.scheduledTime.month}/${_ride!.scheduledTime.year}',
                ),
                _buildInfoItem(
                  AppStrings.rideTime,
                  '${_ride!.scheduledTime.hour}:${_ride!.scheduledTime.minute.toString().padLeft(2, '0')}',
                ),
                _buildInfoItem(
                  AppStrings.estimatedFare,
                  '₹${_ride!.estimatedFare.toStringAsFixed(0)}',
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoItem(
                  AppStrings.distance,
                  '${_ride!.estimatedDistance.toStringAsFixed(1)} km',
                ),
                _buildInfoItem(
                  AppStrings.estimatedTime,
                  '${_ride!.estimatedDuration} min',
                ),
                if (_ride!.status == RideStatus.completed)
                  _buildInfoItem(
                    'Actual Fare',
                    '₹${_ride!.actualFare?.toStringAsFixed(0) ?? _ride!.estimatedFare.toStringAsFixed(0)}',
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationCard() {
    if (_ride == null) return const SizedBox.shrink();

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
            const Text(
              'Locations',
              style: AppTheme.subheadingStyle,
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    const Icon(
                      Icons.circle,
                      color: AppTheme.primaryColor,
                      size: 14,
                    ),
                    Container(
                      width: 2,
                      height: 40,
                      color: AppTheme.lightTextColor.withOpacity(0.3),
                    ),
                    const Icon(
                      Icons.location_on,
                      color: AppTheme.errorColor,
                      size: 14,
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _ride!.pickup.name,
                        style: AppTheme.bodyStyle.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _ride!.pickup.address ?? '',
                        style: AppTheme.captionStyle,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        _ride!.dropoff.name,
                        style: AppTheme.bodyStyle.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _ride!.dropoff.address ?? '',
                        style: AppTheme.captionStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPassengerCard() {
    if (_ride == null) return const SizedBox.shrink();

    // In a real app, you would fetch the passenger details from the user document
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
            const Text(
              AppStrings.passengerDetails,
              style: AppTheme.subheadingStyle,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                  child: const Icon(
                    Icons.person,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'John Doe', // Replace with actual passenger name
                        style: AppTheme.bodyStyle,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '4.5', // Replace with actual passenger rating
                            style: AppTheme.captionStyle.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: _callPassenger,
                  icon: const Icon(
                    Icons.phone,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    if (_ride == null) return const SizedBox.shrink();

    // Show different buttons based on ride status
    switch (_ride!.status) {
      case RideStatus.accepted:
      case RideStatus.arriving:
      case RideStatus.arrived:
        return Column(
          children: [
            CustomButton(
              text: AppStrings.startRide,
              icon: Icons.play_arrow,
              onPressed: _startRide,
              isLoading: _isLoading,
              width: double.infinity,
            ),
            const SizedBox(height: 12),
            CustomButton(
              text: AppStrings.cancelRide,
              icon: Icons.cancel,
              onPressed: _cancelRide,
              isLoading: _isLoading,
              isOutlined: true,
              backgroundColor: AppTheme.errorColor,
              textColor: AppTheme.errorColor,
              width: double.infinity,
            ),
          ],
        );
      case RideStatus.inProgress:
        return CustomButton(
          text: AppStrings.trackRide,
          icon: Icons.location_on,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TrackingScreen(rideId: _ride!.id),
              ),
            );
          },
          width: double.infinity,
        );
      case RideStatus.completed:
      case RideStatus.cancelled:
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildInfoItem(String label, String value) {
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
}