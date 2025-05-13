import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_theme.dart';
import '../../models/ride_model.dart';
import '../../services/ride_service.dart';
import '../../widgets/custom_button.dart';

class TrackingScreen extends StatefulWidget {
  final String rideId;

  const TrackingScreen({
    Key? key,
    required this.rideId,
  }) : super(key: key);

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
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

  Future<void> _completeRide() async {
    if (_ride == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // In a real app, you might calculate the actual fare based on distance, time, etc.
      final actualFare = _ride!.estimatedFare;
      
      await Provider.of<RideService>(context, listen: false)
          .completeRide(_ride!.id, actualFare);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ride completed successfully'),
            backgroundColor: AppTheme.successColor,
          ),
        );
        
        Navigator.popUntil(context, (route) => route.isFirst);
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

  Future<void> _navigateToPickup() async {
    if (_ride == null) return;
    
    final url = 'https://www.google.com/maps/dir/?api=1&destination=${_ride!.pickup.latitude},${_ride!.pickup.longitude}&travelmode=driving';
    
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not launch maps'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  Future<void> _navigateToDropoff() async {
    if (_ride == null) return;
    
    final url = 'https://www.google.com/maps/dir/?api=1&destination=${_ride!.dropoff.latitude},${_ride!.dropoff.longitude}&travelmode=driving';
    
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not launch maps'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  Future<void> _callPassenger() async {
    // In a real app, you would get the passenger's phone number from the user document
    final phoneNumber = 'tel:+1234567890';
    
    if (await canLaunchUrl(Uri.parse(phoneNumber))) {
      await launchUrl(Uri.parse(phoneNumber));
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
          AppStrings.tracking,
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
              : Column(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          // In a real app, this would be a map showing the route
                          Container(
                            color: Colors.grey[200],
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.map,
                                    size: 80,
                                    color: AppTheme.lightTextColor.withOpacity(0.5),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Map View',
                                    style: AppTheme.subheadingStyle,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'This would show a real map in the full app',
                                    style: AppTheme.bodyStyle.copyWith(
                                      color: AppTheme.lightTextColor,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 16,
                            left: 16,
                            right: 16,
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                                          child: const Icon(
                                            Icons.person,
                                            color: AppTheme.primaryColor,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'John Doe', // Replace with actual passenger name
                                                style: AppTheme.bodyStyle,
                                              ),
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
                                    const SizedBox(height: 16),
                                    const Divider(),
                                    const SizedBox(height: 8),
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
                                              height: 30,
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
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 16),
                                              Text(
                                                _ride!.dropoff.name,
                                                style: AppTheme.bodyStyle.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildBottomPanel(),
                  ],
                ),
    );
  }

  Widget _buildBottomPanel() {
    if (_ride == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Estimated Fare',
                    style: AppTheme.captionStyle,
                  ),
                  Text(
                    '₹${_ride!.estimatedFare.toStringAsFixed(0)}',
                    style: AppTheme.headingStyle.copyWith(
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Distance',
                    style: AppTheme.captionStyle,
                  ),
                  Text(
                    '${_ride!.estimatedDistance.toStringAsFixed(1)} km',
                    style: AppTheme.bodyStyle.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: _ride!.status == RideStatus.inProgress
                      ? AppStrings.navigateToDropoff
                      : AppStrings.navigateToPickup,
                  icon: Icons.directions,
                  onPressed: _ride!.status == RideStatus.inProgress
                      ? _navigateToDropoff
                      : _navigateToPickup,
                  backgroundColor: AppTheme.infoColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomButton(
                  text: AppStrings.endRide,
                  icon: Icons.check_circle,
                  onPressed: _completeRide,
                  isLoading: _isLoading,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}