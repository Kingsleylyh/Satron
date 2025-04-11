import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:satron/service/gemini_service.dart';
import 'package:geocoding/geocoding.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with SingleTickerProviderStateMixin {
  final GeminiService _gemini = GeminiService(apiKey: 'API');
  final TextEditingController _destinationController = TextEditingController();
  final MapController _mapController = MapController();

  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  LatLng? _currentPosition;
  String? _suggestedRoute;
  LatLng? _searchedLocation;
  String _searchedLocationName = '';
  bool _isSearching = false;
  bool _isLoadingLocation = true;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Create pulse animation
    _pulseAnimation = Tween<double>(begin: 0.0, end: 15.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut)
    );

    // Request location permissions as soon as the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestLocationPermission();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  Future<void> _requestLocationPermission() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Show dialog to enable location services
        if (mounted) {
          bool shouldEnable = await _showLocationServiceDialog();
          if (shouldEnable) {
            // Open location settings
            await Geolocator.openLocationSettings();
            // Check again after returning from settings
            serviceEnabled = await Geolocator.isLocationServiceEnabled();
            if (!serviceEnabled && mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Location services are still disabled')),
              );
              setState(() {
                _isLoadingLocation = false;
              });
              return;
            }
          } else {
            setState(() {
              _isLoadingLocation = false;
            });
            return;
          }
        }
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        // Show dialog explaining why we need location
        if (mounted) {
          bool shouldRequest = await _showPermissionRequestDialog();
          if (shouldRequest) {
            permission = await Geolocator.requestPermission();
            if (permission == LocationPermission.denied && mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Location permission denied')),
              );
              setState(() {
                _isLoadingLocation = false;
              });
              return;
            }
          } else {
            setState(() {
              _isLoadingLocation = false;
            });
            return;
          }
        }
      }

      if (permission == LocationPermission.deniedForever && mounted) {
        // Show dialog to open app settings
        bool shouldOpenSettings = await _showOpenSettingsDialog();
        if (shouldOpenSettings) {
          await Geolocator.openAppSettings();
          // We can't check the result of opening settings, so just assume they didn't change anything
          setState(() {
            _isLoadingLocation = false;
          });
          return;
        } else {
          setState(() {
            _isLoadingLocation = false;
          });
          return;
        }
      }

      // If we reach here, we have permission to access location
      await _getCurrentLocation();

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error accessing location: ${e.toString()}')),
        );
        setState(() {
          _isLoadingLocation = false;
        });
      }
    }
  }

  Future<bool> _showLocationServiceDialog() async {
    if (!mounted) return false;

    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location Services Disabled'),
          content: const Text(
              'This app needs location services to show your current location on the map. '
                  'Would you like to enable location services?'
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    ) ?? false;
  }

  Future<bool> _showPermissionRequestDialog() async {
    if (!mounted) return false;

    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location Permission'),
          content: const Text(
              'This app needs access to your location to show your current position on the map. '
                  'Would you like to grant location permission?'
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Deny'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('Allow'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    ) ?? false;
  }

  Future<bool> _showOpenSettingsDialog() async {
    if (!mounted) return false;

    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location Permission Denied'),
          content: const Text(
              'Location permission is permanently denied. '
                  'Please open app settings and grant location permission to use this feature.'
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('Open Settings'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    ) ?? false;
  }

  Future<void> _getCurrentLocation() async {
    if (!mounted) return;

    setState(() {
      _isLoadingLocation = true;
    });

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      if (mounted) {
        setState(() {
          _currentPosition = LatLng(position.latitude, position.longitude);
          _isLoadingLocation = false;
        });

        // Center map on current location
        _mapController.move(_currentPosition!, 15);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error getting location: ${e.toString()}')),
        );
        setState(() {
          _isLoadingLocation = false;
        });
      }
    }
  }

  Future<void> _searchDestination() async {
    if (_destinationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a destination')),
      );
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      // Use geocoding to convert the search text to coordinates
      List<Location> locations = await locationFromAddress(_destinationController.text);

      if (locations.isNotEmpty && mounted) {
        Location location = locations.first;
        final searchedLocation = LatLng(location.latitude, location.longitude);

        setState(() {
          _searchedLocation = searchedLocation;
          _searchedLocationName = _destinationController.text;
          _isSearching = false;
        });

        // If there's a current position, get route suggestion
        if (_currentPosition != null) {
          _getRouteSuggestion();
        }

        // Move the map to show both points
        _adjustMapView();
      } else if (mounted) {
        setState(() {
          _isSearching = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location not found')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSearching = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error finding location: ${e.toString()}')),
        );
      }
    }
  }

  void _adjustMapView() {
    // Only proceed if we have both points and the widget is still mounted
    if (_currentPosition == null || _searchedLocation == null || !mounted) return;

    try {
      // Calculate center point between current location and destination
      double centerLat = (_currentPosition!.latitude + _searchedLocation!.latitude) / 2;
      double centerLng = (_currentPosition!.longitude + _searchedLocation!.longitude) / 2;

      // Calculate distance between points to determine zoom
      double latDiff = (_currentPosition!.latitude - _searchedLocation!.latitude).abs();
      double lngDiff = (_currentPosition!.longitude - _searchedLocation!.longitude).abs();
      double maxDiff = latDiff > lngDiff ? latDiff : lngDiff;

      // Determine appropriate zoom level based on distance
      double zoomLevel = 12.0;
      if (maxDiff > 0.1) zoomLevel = 10.0;
      if (maxDiff > 0.5) zoomLevel = 8.0;
      if (maxDiff > 1.0) zoomLevel = 6.0;

      // Animate the map
      _mapController.move(LatLng(centerLat, centerLng), zoomLevel);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adjusting map view: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _getRouteSuggestion() async {
    if (_currentPosition == null || _searchedLocation == null || !mounted) return;

    try {
      final origin = "${_currentPosition!.latitude},${_currentPosition!.longitude}";
      final destination = "${_searchedLocation!.latitude},${_searchedLocation!.longitude}";

      final result = await _gemini.getRouteSuggestions(origin, destination);

      if (mounted) {
        setState(() {
          _suggestedRoute = result ?? 'No suggestion found';
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error getting route: ${e.toString()}')),
        );
      }
    }
  }

  // Animated current location marker
  Widget _buildCurrentLocationMarker() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Pulse effect
            Container(
              height: 60 + _pulseAnimation.value,
              width: 60 + _pulseAnimation.value,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
            // Inner circle
            Container(
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.red, width: 3),
              ),
            ),
            // Center dot
            Container(
              height: 12,
              width: 12,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ],
        );
      },
    );
  }

  // Destination marker pin
  Widget _buildDestinationMarker() {
    return Column(
      children: [
        // Pin Icon
        const Icon(
          Icons.location_on,
          color: Colors.blue,
          size: 40,
        ),
        // Label
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          constraints: const BoxConstraints(maxWidth: 120),
          child: Text(
            _searchedLocationName,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentPosition ?? const LatLng(3.0553, 101.6088),
              initialZoom: 15,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.myapp',
              ),
              MarkerLayer(
                markers: [
                  // Current location marker
                  if (_currentPosition != null)
                    Marker(
                      point: _currentPosition!,
                      width: 90,
                      height: 90,
                      child: _buildCurrentLocationMarker(),
                    ),
                  // Searched location marker
                  if (_searchedLocation != null)
                    Marker(
                      point: _searchedLocation!,
                      width: 120,
                      height: 80,
                      child: _buildDestinationMarker(),
                    ),
                ],
              ),
            ],
          ),

          // Location loading indicator overlay
          if (_isLoadingLocation)
            Container(
              color: Colors.white.withOpacity(0.5),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.red),
                    SizedBox(height: 16),
                    Text('Getting your location...',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),

          // Search bar
          Positioned(
            top: 50,
            left: 15,
            right: 15,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _destinationController,
                      decoration: const InputDecoration(
                        hintText: 'Enter destination',
                        contentPadding: EdgeInsets.all(16),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _searchDestination(),
                    ),
                  ),
                  _isSearching
                      ? Container(
                    padding: const EdgeInsets.all(10),
                    height: 54,
                    width: 54,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.red,
                    ),
                  )
                      : Material(
                    color: Colors.red,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                    child: InkWell(
                      onTap: _searchDestination,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: const Icon(Icons.search, color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          // Current location button
          Positioned(
            bottom: _suggestedRoute != null ? 100 : 20,
            right: 15,
            child: FloatingActionButton(
              heroTag: 'locationButton',
              backgroundColor: Colors.white,
              onPressed: () {
                if (_currentPosition != null) {
                  _mapController.move(_currentPosition!, 15);
                } else {
                  _requestLocationPermission();
                }
              },
              child: const Icon(Icons.my_location, color: Colors.red),
              elevation: 4,
            ),
          ),

          // Route suggestion display
          if (_suggestedRoute != null)
            Positioned(
              bottom: 20,
              left: 15,
              right: 15,
              child: Card(
                color: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Suggested Route',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(_suggestedRoute!),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}