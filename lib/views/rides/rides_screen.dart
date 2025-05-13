import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_theme.dart';
import '../../models/ride_model.dart';
import '../../services/ride_service.dart';
import 'ride_details_screen.dart';

class RidesScreen extends StatefulWidget {
  const RidesScreen({Key? key}) : super(key: key);

  @override
  State<RidesScreen> createState() => _RidesScreenState();
}

class _RidesScreenState extends State<RidesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          AppStrings.myRides,
          style: TextStyle(
            color: AppTheme.textColor,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: AppTheme.lightTextColor,
          indicatorColor: AppTheme.primaryColor,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
          tabs: const [
            Tab(text: AppStrings.activeRides),
            Tab(text: AppStrings.completedRides),
            Tab(text: AppStrings.cancelledRides),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _ActiveRidesTab(),
          _CompletedRidesTab(),
          _CancelledRidesTab(),
        ],
      ),
    );
  }
}

class _ActiveRidesTab extends StatelessWidget {
  const _ActiveRidesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rideService = Provider.of<RideService>(context);

    return StreamBuilder<List<RideModel>>(
      stream: rideService.getCaptainActiveRides(),
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
                  AppStrings.noActiveRides,
                  style: AppTheme.subheadingStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'You don\'t have any active rides at the moment',
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
    );
  }

  Widget _buildRideCard(BuildContext context, RideModel ride) {
    String statusText;
    Color statusColor;

    switch (ride.status) {
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
      default:
        statusText = 'Active';
        statusColor = AppTheme.infoColor;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RideDetailsScreen(rideId: ride.id),
            ),
          );
        },
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        '${ride.scheduledTime.hour}:${ride.scheduledTime.minute.toString().padLeft(2, '0')}',
                        style: AppTheme.captionStyle.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
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
                        const SizedBox(height: 16),
                        Text(
                          ride.dropoff.name,
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
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '₹${ride.estimatedFare.toStringAsFixed(0)}',
                    style: AppTheme.subheadingStyle.copyWith(
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  Text(
                    'View Details',
                    style: AppTheme.bodyStyle.copyWith(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
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

class _CompletedRidesTab extends StatelessWidget {
  const _CompletedRidesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rideService = Provider.of<RideService>(context);

    return StreamBuilder<List<RideModel>>(
      stream: rideService.getCaptainCompletedRides(),
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
                  Icons.check_circle_outline,
                  size: 80,
                  color: AppTheme.lightTextColor.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                const Text(
                  AppStrings.noCompletedRides,
                  style: AppTheme.subheadingStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Your completed rides will appear here',
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
            return _buildCompletedRideCard(context, ride);
          },
        );
      },
    );
  }

  Widget _buildCompletedRideCard(BuildContext context, RideModel ride) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RideDetailsScreen(rideId: ride.id),
            ),
          );
        },
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: AppTheme.primaryColor,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${ride.completedAt?.day}/${ride.completedAt?.month}/${ride.completedAt?.year}',
                        style: AppTheme.captionStyle.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.successColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Completed',
                      style: AppTheme.captionStyle.copyWith(
                        color: AppTheme.successColor,
                        fontWeight: FontWeight.w600,
                      ),
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
                        const SizedBox(height: 16),
                        Text(
                          ride.dropoff.name,
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
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '₹${ride.actualFare?.toStringAsFixed(0) ?? ride.estimatedFare.toStringAsFixed(0)}',
                    style: AppTheme.subheadingStyle.copyWith(
                      color: AppTheme.successColor,
                    ),
                  ),
                  if (ride.captainRating != null)
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          ride.captainRating!.toStringAsFixed(1),
                          style: AppTheme.bodyStyle.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
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

class _CancelledRidesTab extends StatelessWidget {
  const _CancelledRidesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rideService = Provider.of<RideService>(context);

    return StreamBuilder<List<RideModel>>(
      stream: rideService.getCaptainCancelledRides(),
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
                  Icons.cancel_outlined,
                  size: 80,
                  color: AppTheme.lightTextColor.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                const Text(
                  AppStrings.noCancelledRides,
                  style: AppTheme.subheadingStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Your cancelled rides will appear here',
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
            return _buildCancelledRideCard(context, ride);
          },
        );
      },
    );
  }

  Widget _buildCancelledRideCard(BuildContext context, RideModel ride) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RideDetailsScreen(rideId: ride.id),
            ),
          );
        },
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: AppTheme.primaryColor,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${ride.cancelledAt?.day}/${ride.cancelledAt?.month}/${ride.cancelledAt?.year}',
                        style: AppTheme.captionStyle.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.errorColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Cancelled',
                      style: AppTheme.captionStyle.copyWith(
                        color: AppTheme.errorColor,
                        fontWeight: FontWeight.w600,
                      ),
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
                        const SizedBox(height: 16),
                        Text(
                          ride.dropoff.name,
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
              if (ride.cancelReason != null) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                Text(
                  'Reason: ${ride.cancelReason}',
                  style: AppTheme.captionStyle.copyWith(
                    color: AppTheme.errorColor,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}