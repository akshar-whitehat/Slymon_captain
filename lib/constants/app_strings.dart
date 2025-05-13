// App strings

class AppStrings {
  // General
  static const String appName = 'Slymon Captain';
  
  // Time Periods
  static const String today = 'Today';
  static const String thisWeek = 'This Week';
  static const String thisMonth = 'This Month';
  static const String allTime = 'All Time';
  
  // Navigation
  static const String home = 'Home';
  static const String rides = 'Rides';
  static const String profile = 'Profile';
  static const String settings = 'Settings';
  static const String earnings = 'Earnings';
  
  // Ride Status
  static const String tracking = 'Ride Tracking';
  static const String myRides = 'My Rides';
  static const String activeRides = 'Active';
  static const String completedRides = 'Completed';
  static const String cancelledRides = 'Cancelled';
  static const String noActiveRides = 'No Active Rides';
  static const String noCompletedRides = 'No Completed Rides';
  static const String noCancelledRides = 'No Cancelled Rides';
  static const String availableRides = 'Available Rides';
  static const String noRidesAvailable = 'No Rides Available';
  static const String rideId = 'Ride ID';
  static const String statusAccepted = 'Accepted';
  static const String statusArriving = 'Arriving';
  static const String statusArrived = 'Arrived';
  static const String statusInProgress = 'In Progress';
  static const String statusCompleted = 'Completed';
  static const String statusCancelled = 'Cancelled';
  static const String statusPending = 'Pending';
  static const String checkBackLater = 'Check back later for new ride requests';
  static const String rideNotFound = 'Ride not found';
  
  // Ride Details
  static const String distance = 'Distance';
  static const String estimatedFare = 'Est. Fare';
  static const String estimatedTime = 'Est. Time';
  static const String bidNow = 'Bid Now';
  static const String rideDate = 'Date';
  static const String rideTime = 'Time';
  static const String rideDetails = 'Ride Details';
  static const String passengerDetails = 'Passenger Details';
  static const String actualFare = 'Actual Fare';
  static const String locations = 'Locations';
  static const String mapView = 'Map View';
  static const String mapPlaceholder = 'This would show a real map in the full app';
  
  // Bidding
  static const String placeBid = 'Place Bid';
  static const String yourBid = 'Your Bid';
  static const String enterBidAmount = 'Enter Bid Amount';
  static const String enterValidBid = 'Please enter a valid bid amount';
  static const String minBid = 'Min Bid';
  static const String maxBid = 'Max Bid';
  static const String addNote = 'Add Note (Optional)';
  static const String submitBid = 'Submit Bid';
  static const String bidPlaced = 'Bid placed successfully!';
  static const String bidUpdated = 'Bid updated successfully!';
  static const String updateBid = 'Update Bid';
  static const String bidNoteHint = 'E.g., I can arrive in 10 minutes';
  static const String bidTooLow = 'Bid must be at least ₹{0}';
  static const String bidTooHigh = 'Bid cannot exceed ₹{0}';
  
  // Earnings
  static const String totalEarnings = 'Total Earnings';
  static const String todayEarnings = 'Today';
  static const String weeklyEarnings = 'This Week';
  static const String monthlyEarnings = 'This Month';
  static const String totalRides = 'Total Rides';
  static const String totalDistance = 'Total Distance';
  static const String noEarnings = 'No Earnings Yet';
  static const String withdrawFunds = 'Withdraw Funds';
  static const String completeRidesToEarn = 'Complete rides to earn money';
  static const String withdrawFundsTitle = 'Withdraw Funds';
  static const String amount = 'Amount';
  static const String fundsTransferInfo = 'Funds will be transferred to your registered bank account.';
  static const String pleaseEnterAmount = 'Please enter an amount';
  static const String pleaseEnterValidAmount = 'Please enter a valid amount';
  static const String withdrawalSuccess = 'Withdrawal request submitted successfully';
  static const String withdraw = 'Withdraw';
  static const String rideEarnings = 'Ride Earnings';
  static const String bonus = 'Bonus';
  static const String referralBonus = 'Referral Bonus';
  static const String withdrawal = 'Withdrawal';
  static const String transactions = 'transactions';
  static const String viewAll = 'View All';
  
  // Actions
  static const String startRide = 'Start Ride';
  static const String endRide = 'End Ride';
  static const String cancelRide = 'Cancel Ride';
  static const String callPassenger = 'Call Passenger';
  static const String navigateToPickup = 'Navigate to Pickup';
  static const String navigateToDropoff = 'Navigate to Dropoff';
  static const String trackRide = 'Track Ride';
  static const String cancelRideTitle = 'Cancel Ride';
  static const String cancelRideReason = 'Please provide a reason for cancellation:';
  static const String enterReason = 'Enter reason';
  static const String cancel = 'Cancel';
  static const String submit = 'Submit';
  static const String pleaseEnterReason = 'Please enter a reason';
  static const String rideStartedSuccess = 'Ride started successfully';
  static const String rideCancelledSuccess = 'Ride cancelled successfully';
  static const String rideCompletedSuccess = 'Ride completed successfully';
  static const String couldNotLaunchMaps = 'Could not launch maps';
  static const String couldNotLaunchPhone = 'Could not launch phone app';
  
  // Authentication
  static const String login = 'Login';
  static const String signUp = 'Sign Up';
  static const String signIn = 'Sign In';
  static const String logout = 'Logout';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String forgotPassword = 'Forgot Password?';
  static const String dontHaveAccount = "Don't have an account?";
  static const String alreadyHaveAccount = "Already have an account?";
  static const String name = 'Full Name';
  static const String phoneNumber = 'Phone Number';
  static const String phone = 'Phone Number';
  static const String register = 'Register';
  static const String createAccount = 'Create Account';
  static const String welcomeBack = 'Welcome back, please login to your account';
  static const String enterEmail = 'Please enter your email';
  static const String enterValidEmail = 'Please enter a valid email';
  static const String enterPassword = 'Please enter your password';
  static const String passwordMinLength = 'Password must be at least 6 characters';
  static const String enterName = 'Please enter your name';
  static const String enterPhoneNumber = 'Please enter your phone number';
  static const String enterValidPhoneNumber = 'Please enter a valid 10-digit phone number';
  static const String passwordsDoNotMatch = 'Passwords do not match';
  
  // Vehicle
  static const String vehicleDetails = 'Vehicle Details';
  static const String vehicleNumber = 'Vehicle Number';
  static const String vehicleModel = 'Vehicle Model';
  static const String vehicleType = 'Vehicle Type';
  static const String enterVehicleNumber = 'Please enter your vehicle number';
  static const String enterVehicleModel = 'Please enter your vehicle model';
  static const String car = 'Car';
  static const String bike = 'Bike';
  static const String auto = 'Auto';
  
  // Documents
  static const String uploadDrivingLicense = 'Upload Driving License';
  static const String uploadVehicleRegistration = 'Upload Vehicle Registration';
  static const String uploadProfilePhoto = 'Upload Profile Photo';
  
  // Profile
  static const String personalInfo = 'Personal Information';
  static const String vehicleInfo = 'Vehicle Information';
  static const String documents = 'Documents';
  static const String help = 'Help & Support';
  static const String about = 'About Us';
  static const String online = 'Online';
  static const String offline = 'Offline';
  static const String vehicle = 'Vehicle';
  static const String number = 'Number';
  static const String type = 'Type';
}