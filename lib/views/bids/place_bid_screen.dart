import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_theme.dart';
import '../../models/ride_model.dart';
import '../../services/auth_service.dart';
import '../../services/ride_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class PlaceBidScreen extends StatefulWidget {
  final RideModel ride;

  const PlaceBidScreen({
    Key? key,
    required this.ride,
  }) : super(key: key);

  @override
  State<PlaceBidScreen> createState() => _PlaceBidScreenState();
}

class _PlaceBidScreenState extends State<PlaceBidScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bidController = TextEditingController();
  final _noteController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Check if captain already placed a bid
    final currentUserId = Provider.of<AuthService>(context, listen: false).currentUser?.uid;
    if (currentUserId != null) {
      final existingBid = widget.ride.bids.firstWhere(
        (bid) => bid.captainId == currentUserId,
        orElse: () => BidModel(
          id: '',
          captainId: '',
          rideId: '',
          amount: 0,
          createdAt: DateTime.now(),
        ),
      );

      if (existingBid.id.isNotEmpty) {
        _bidController.text = existingBid.amount.toString();
        _noteController.text = existingBid.note ?? '';
      } else {
        // Set initial bid to estimated fare
        _bidController.text = widget.ride.estimatedFare.toString();
      }
    }
  }

  @override
  void dispose() {
    _bidController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submitBid() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final bidAmount = double.parse(_bidController.text);
      final note = _noteController.text.isEmpty ? null : _noteController.text;

      await Provider.of<RideService>(context, listen: false)
          .placeBid(widget.ride.id, bidAmount, note);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.ride.bids.any(
                (bid) => bid.captainId == Provider.of<AuthService>(context, listen: false).currentUser?.uid,
              )
                  ? AppStrings.bidUpdated
                  : AppStrings.bidPlaced,
            ),
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

  @override
  Widget build(BuildContext context) {
    final minBid = widget.ride.estimatedFare * 0.8;
    final maxBid = widget.ride.estimatedFare * 1.5;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          AppStrings.placeBid,
          style: TextStyle(
            color: AppTheme.textColor,
            fontWeight: FontWeight.bold,
            fontFamily: 'SF Pro Display',
            letterSpacing: -0.3,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: AppTheme.primaryColor,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacing),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRideDetails(),
              const SizedBox(height: 24),
              const Text(
                AppStrings.yourBid,
                style: AppTheme.subheadingStyle,
              ),
              const SizedBox(height: 8),
              CustomTextField(
                hint: AppStrings.enterBidAmount,
                controller: _bidController,
                keyboardType: TextInputType.number,
                prefixIcon: Icons.currency_rupee,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.enterValidBid;
                  }
                  final bid = double.tryParse(value);
                  if (bid == null) {
                    return AppStrings.enterValidBid;
                  }
                  if (bid < minBid) {
                    return 'Bid must be at least ₹${minBid.toStringAsFixed(0)}';
                  }
                  if (bid > maxBid) {
                    return 'Bid cannot exceed ₹${maxBid.toStringAsFixed(0)}';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${AppStrings.minBid}: ₹${minBid.toStringAsFixed(0)}',
                    style: AppTheme.captionStyle,
                  ),
                  Text(
                    '${AppStrings.maxBid}: ₹${maxBid.toStringAsFixed(0)}',
                    style: AppTheme.captionStyle,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                AppStrings.addNote,
                style: AppTheme.subheadingStyle,
              ),
              const SizedBox(height: 8),
              CustomTextField(
                hint: 'E.g., I can arrive in 10 minutes',
                controller: _noteController,
                maxLines: 3,
                maxLength: 200,
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: AppStrings.submitBid,
                onPressed: _submitBid,
                isLoading: _isLoading,
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRideDetails() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
      ),
      margin: EdgeInsets.zero,
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
                  '${widget.ride.scheduledTime.hour}:${widget.ride.scheduledTime.minute.toString().padLeft(2, '0')} - ${widget.ride.scheduledTime.day}/${widget.ride.scheduledTime.month}/${widget.ride.scheduledTime.year}',
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
                        widget.ride.pickup.name,
                        style: AppTheme.bodyStyle.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.ride.pickup.address ?? '',
                        style: AppTheme.captionStyle,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.ride.dropoff.name,
                        style: AppTheme.bodyStyle.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.ride.dropoff.address ?? '',
                        style: AppTheme.captionStyle,
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
                  '${widget.ride.estimatedDistance.toStringAsFixed(1)} km',
                  AppStrings.distance,
                ),
                _buildInfoItem(
                  Icons.attach_money,
                  '₹${widget.ride.estimatedFare.toStringAsFixed(0)}',
                  AppStrings.estimatedFare,
                ),
                _buildInfoItem(
                  Icons.timer,
                  '${widget.ride.estimatedDuration} min',
                  AppStrings.estimatedTime,
                ),
              ],
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