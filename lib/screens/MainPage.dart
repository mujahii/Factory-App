import 'package:flutter/material.dart';
import '/api/api_enpoint.dart';
import '/widgets/mills.dart';
import '/widgets/home.dart';
import '/widgets/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'userlist.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedMillIndex = 0;
  String appBarTitle = "Default Title"; // Default title
  final MongoAPI _apiService = MongoAPI();
  List<String> _factoryNames = [];
  List<String?> selectedFactoryNames = List.filled(3, null);
  String? factoryName1;
  List<dynamic> _avgParamValues = [];
  String _statusMessage = '';
  List<String> timestamps = [];
  List<int> currentValues = [];
  List<int> maxValues = [];
  List<String> metrics = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeData(); // Call the initialization method
  }

  Future<void> _initializeData() async {
    await _fetchFactoryNames(); // Wait for factory names to be fetched
    if (_factoryNames.isNotEmpty) {
      await _fetchFactoryParams(_factoryNames[selectedMillIndex]);
      _separateAvgParamValues();
    }
  }

  Future<void> _fetchFactoryNames() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final bearerToken = prefs.getString('bearerToken') ?? '';

      final result = await _apiService.factoryGet(bearerToken);
      setState(() {
        _factoryNames = (result['factories'] as List<dynamic>)
            .map((item) => item as String)
            .toList();

        for (int i = 0;
            i < _factoryNames.length && i < selectedFactoryNames.length;
            i++) {
          selectedFactoryNames[i] = _factoryNames[i];
        }

        if (_factoryNames.isNotEmpty) {
          factoryName1 = _factoryNames[0];
          _setAppBarTitle(_factoryNames[0]);
        }
      });
    } catch (e) {
      print('Error fetching factory names: $e');
    }
  }

  Future<void> _fetchFactoryParams(String factoryName) async {
    setState(() {
      _isLoading = true;
      timestamps.clear();
      currentValues.clear();
      maxValues.clear();
      metrics.clear();
      _avgParamValues.clear();
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final bearerToken = prefs.getString('bearerToken') ?? '';

      final result =
          await _apiService.factoryParamGet(factoryName, bearerToken);
      final avgParamData = result['item'] as Map<String, dynamic>;

      setState(() {
        _avgParamValues = avgParamData.values.toList();
        _statusMessage = 'Factory Parameters fetched successfully';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error: $e';
      });
    } finally {
      _separateAvgParamValues();
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _separateAvgParamValues() {
    // Ensure the _avgParamValues list is not empty before accessing elements
    if (_avgParamValues.isNotEmpty) {
      timestamps = [_avgParamValues[0].toString()];
      currentValues = List<int>.from(_avgParamValues[1]);
      maxValues = List<int>.from(_avgParamValues[2]);
      metrics = List<String>.from(_avgParamValues[3]);

      print('Timestamps: $timestamps');
      print('Current Values: $currentValues');
      print('Max Values: $maxValues');
      print('Metrics: $metrics');
    }
  }

  void _onMillSelected(int index) async {
    setState(() {
      selectedMillIndex = index;
      String selectedLabel =
          _factoryNames.isNotEmpty ? _factoryNames[index] : '';
      _setAppBarTitle(selectedLabel);
    });

    await _fetchFactoryParams(_factoryNames[selectedMillIndex]);
    _separateAvgParamValues();
  }

  void _setAppBarTitle(String title) {
    setState(() {
      appBarTitle = title;
    });
  }

  int _selectedIndex = 1;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> get _widgetOptions {
    return [
      const UserList(),
      HomeWidget(
        millID:
            _factoryNames.isNotEmpty ? _factoryNames[selectedMillIndex] : '',
        timestamps: timestamps.isNotEmpty ? timestamps : ["Error"],
        currentValues:
            currentValues.isNotEmpty ? currentValues : [20, 20, 20, 20],
        maxValues: maxValues.isNotEmpty ? maxValues : [50, 50, 50, 50],
        metrics: metrics.isNotEmpty
            ? metrics
            : ["Para 1", "Para 2", "Para 3", "Para 4"],
      ),
      Settings(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appBarTitle,
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Column(
            children: [
              if (_isLoading)
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(), // Show loading spinner
                  ),
                )
              else
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      _widgetOptions.elementAt(_selectedIndex),
                      const SizedBox(
                        height: 20,
                      ),
                      Flexible(
                        flex: 2,
                        fit: FlexFit.loose,
                        child: SizedBox(
                          height: 90,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _factoryNames.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  _onMillSelected(index);
                                },
                                child: Mills(
                                  raspberrypi_id: _factoryNames[index],
                                  label: _factoryNames[index],
                                  isSelected: selectedMillIndex == index,
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    ]),
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: 'Userlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
