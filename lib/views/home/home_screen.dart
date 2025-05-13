import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_theme.dart';
import '../../models/ride_model.dart';
import '../../services/auth_service.dart';
import '../../services/ride_service.dart';
import '../../widgets/custom_button.dart';
import '../bids/place_bid_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rideService = Provider.of<RideService>(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          AppStrings.availableRides,
          style: TextStyle(
            color: AppTheme.textColor,
            fontWeight: FontWeight.bold,
            fontFamily: 'SF Pro Display',
            letterSpacing: -0.3,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppTheme.primaryColor),
            onPressed: () {
              // Refresh rides
            },
          ),
        ],
      ),
      body: StreamBuilder<List<RideModel>>(
        stream: rideService.getAvailableRides(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: AppTheme.bodyStyle,
              ),
            );
          }

          final rides = snapshot.data ?? [];

          if (rides.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.directions_car_outlined,
                    size: 80,
                    color: AppTheme.lightTextColor.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    AppStrings.noRidesAvailable,
                    style: AppTheme.subheadingStyle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Check back later for new ride requests',
                    style: AppTheme.bodyStyle.copyWith(
                      color: AppTheme.lightTextColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: rides.length,
            itemBuilder: (context, index) {
              final ride = rides[index];
              return _buildRideCard(context, ride);
            },
          );
        },
      ),
    );
  }

  Widget _buildRideCard(BuildContext context, RideModel ride) {
    // Check if captain already placed a bid
    final hasBid = ride.bids.any(
      (bid) => bid.captainId == Provider.of<AuthService>(context, listen: false).currentUser?.uid,
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
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
              children: [
                const Icon(
                  Icons.access_time,
                  color: AppTheme.primaryColor,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  '${ride.scheduledTime.hour}:${ride.scheduledTime.minute.toString().padLeft(2, '0')} - ${ride.scheduledTime.day}/${ride.scheduledTime.month}/${ride.scheduledTime.year}',
                  style: AppTheme.captionStyle.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
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
                        ride.pickup.name,
                        style: AppTheme.bodyStyle.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        ride.pickup.address ?? '',
                        style: AppTheme.captionStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        ride.dropoff.name,
                        style: AppTheme.bodyStyle.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        ride.dropoff.address ?? '',
                        style: AppTheme.captionStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                _buildInfoItem(
                  Icons.route,
                  '${ride.estimatedDistance.toStringAsFixed(1)} km',
                  AppStrings.distance,
                ),
                _buildInfoItem(
                  Icons.attach_money,
                  '₹${ride.estimatedFare.toStringAsFixed(0)}',
                  AppStrings.estimatedFare,
                ),
                _buildInfoItem(
                  Icons.timer,
                  '${ride.estimatedDuration} min',
                  AppStrings.estimatedTime,
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: hasBid ? 'Update Bid' : AppStrings.bidNow,
              icon: hasBid ? Icons.edit : Icons.gavel,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlaceBidScreen(ride: ride),
                  ),
                );
              },
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: AppTheme.primaryColor,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              value,
              style: AppTheme.bodyStyle.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTheme.captionStyle,
        ),
      ],
    );
  }
}