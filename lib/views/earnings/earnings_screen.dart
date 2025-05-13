import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_theme.dart';
import '../../models/earnings_model.dart';
import '../../services/earnings_service.dart';
import '../../widgets/custom_button.dart';

class EarningsScreen extends StatefulWidget {
  const EarningsScreen({Key? key}) : super(key: key);

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final earningsService = Provider.of<EarningsService>(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          AppStrings.earnings,
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
            Tab(text: AppStrings.today),
            Tab(text: AppStrings.thisWeek),
            Tab(text: AppStrings.thisMonth),
            Tab(text: AppStrings.allTime),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildEarningsSummary(earningsService),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildEarningsTab(earningsService, _getDateRange(DateRangeType.today)),
                _buildEarningsTab(earningsService, _getDateRange(DateRangeType.week)),
                _buildEarningsTab(earningsService, _getDateRange(DateRangeType.month)),
                _buildEarningsTab(earningsService, _getDateRange(DateRangeType.allTime)),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: CustomButton(
          text: AppStrings.withdrawFunds,
          icon: Icons.account_balance_wallet,
          onPressed: () {
            // Show withdraw funds dialog
            _showWithdrawDialog();
          },
          width: double.infinity,
        ),
      ),
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
          margin: const EdgeInsets.all(16),
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
                  AppStrings.totalEarnings,
                  style: AppTheme.captionStyle,
                ),
                Text(
                  '₹${summary.totalEarnings.toStringAsFixed(0)}',
                  style: AppTheme.headingStyle.copyWith(
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
          ),
        ),
      ],
    );
  }

  Widget _buildEarningsTab(EarningsService earningsService, DateTimeRange dateRange) {
    return FutureBuilder<List<EarningsModel>>(
      future: earningsService.getEarningsByDateRange(dateRange.start, dateRange.end),
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

        final earnings = snapshot.data ?? [];

        if (earnings.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 80,
                  color: AppTheme.lightTextColor.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                const Text(
                  AppStrings.noEarnings,
                  style: AppTheme.subheadingStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Complete rides to earn money',
                  style: AppTheme.bodyStyle.copyWith(
                    color: AppTheme.lightTextColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        // Calculate total earnings for this period
        double totalEarnings = 0;
        for (final earning in earnings) {
          totalEarnings += earning.amount;
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total: ₹${totalEarnings.toStringAsFixed(0)}',
                    style: AppTheme.subheadingStyle.copyWith(
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  Text(
                    '${earnings.length} transactions',
                    style: AppTheme.captionStyle,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: earnings.length,
                itemBuilder: (context, index) {
                  final earning = earnings[index];
                  return _buildEarningCard(earning);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEarningCard(EarningsModel earning) {
    final dateFormat = DateFormat('dd MMM yyyy, hh:mm a');
    
    IconData icon;
    Color iconColor;
    
    switch (earning.type) {
      case EarningsType.ride:
        icon = Icons.directions_car;
        iconColor = AppTheme.primaryColor;
        break;
      case EarningsType.bonus:
        icon = Icons.card_giftcard;
        iconColor = AppTheme.successColor;
        break;
      case EarningsType.referral:
        icon = Icons.people;
        iconColor = AppTheme.infoColor;
        break;
      case EarningsType.withdrawal:
        icon = Icons.account_balance;
        iconColor = AppTheme.errorColor;
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: iconColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    earning.type == EarningsType.ride
                        ? 'Ride Earnings'
                        : earning.type == EarningsType.bonus
                            ? 'Bonus'
                            : earning.type == EarningsType.referral
                                ? 'Referral Bonus'
                                : 'Withdrawal',
                    style: AppTheme.bodyStyle.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    dateFormat.format(earning.date),
                    style: AppTheme.captionStyle,
                  ),
                ],
              ),
            ),
            Text(
              earning.amount > 0 ? '+₹${earning.amount.toStringAsFixed(0)}' : '-₹${(-earning.amount).toStringAsFixed(0)}',
              style: AppTheme.bodyStyle.copyWith(
                fontWeight: FontWeight.w600,
                color: earning.amount > 0 ? AppTheme.successColor : AppTheme.errorColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showWithdrawDialog() {
    final amountController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Withdraw Funds'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixText: '₹',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Funds will be transferred to your registered bank account.',
              style: AppTheme.captionStyle,
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
              if (amountController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter an amount'),
                    backgroundColor: AppTheme.errorColor,
                  ),
                );
                return;
              }
              
              final amount = double.tryParse(amountController.text);
              if (amount == null || amount <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a valid amount'),
                    backgroundColor: AppTheme.errorColor,
                  ),
                );
                return;
              }
              
              Navigator.pop(context);
              
              // In a real app, you would check if the captain has a bank account
              // If not, navigate to add bank account screen
              // For now, just show a success message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Withdrawal request submitted successfully'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            child: const Text('Withdraw'),
          ),
        ],
      ),
    );
  }

  DateTimeRange _getDateRange(DateRangeType type) {
    final now = DateTime.now();
    
    switch (type) {
      case DateRangeType.today:
        final start = DateTime(now.year, now.month, now.day);
        return DateTimeRange(start: start, end: now);
      case DateRangeType.week:
        final start = DateTime(now.year, now.month, now.day - now.weekday + 1);
        return DateTimeRange(start: start, end: now);
      case DateRangeType.month:
        final start = DateTime(now.year, now.month, 1);
        return DateTimeRange(start: start, end: now);
      case DateRangeType.allTime:
        final start = DateTime(2020, 1, 1); // Some date in the past
        return DateTimeRange(start: start, end: now);
    }
  }
}

enum DateRangeType {
  today,
  week,
  month,
  allTime,
}