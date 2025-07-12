import 'package:flutter/material.dart';
import '/api/api_enpoint.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/screens/auth.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool notification = true;
  final MongoAPI _mongoAPI = MongoAPI();

  final TextEditingController steamPressureController = TextEditingController();
  final TextEditingController waterLevelController = TextEditingController();
  final TextEditingController steamFlowController = TextEditingController();
  final TextEditingController turbineFrequencyController =
      TextEditingController();

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? bearerToken = prefs.getString('bearerToken');
    if (bearerToken != null) {
      try {
        await _mongoAPI.bearerLogout(bearerToken);
        await prefs.remove('bearerToken');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Auth(),
          ),
        );
      } catch (e) {
        print('Failed to logout: $e');
      }
    } else {
      print('No bearer token found.');
    }
  }

  void _updateParameters() {
    // Logic to update parameters
    // You can use the values from the controllers here
    String steamPressure = steamPressureController.text;
    String waterLevel = waterLevelController.text;
    String steamFlow = steamFlowController.text;
    String turbineFrequency = turbineFrequencyController.text;

    print('Updating parameters:');
    print('Steam Pressure: $steamPressure');
    print('Water Level: $waterLevel');
    print('Steam Flow: $steamFlow');
    print('Turbine Frequency: $turbineFrequency');

    // Add your update logic here (e.g., API calls, state updates)
  }

  @override
  void dispose() {
    steamPressureController.dispose();
    waterLevelController.dispose();
    steamFlowController.dispose();
    turbineFrequencyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 5,
      fit: FlexFit.loose,
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(220, 248, 248, 248),
          borderRadius: BorderRadius.circular(13),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 3),
            )
          ],
        ),
        height: 490,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        const Text(
                          'Minimum Threshold',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 20),
                        ),
                        Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.info_outline),
                              tooltip:
                                  'Values lower than the \nvalues specified here will\ntrigger the alert.',
                            ))
                      ],
                    ),
                  ),
                ],
              ),
              Flexible(
                flex: 18,
                child: SingleChildScrollView(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ParamSetting(
                              millID: '',
                              paramtype: 'Steam\nPressure',
                              unit: 'bar',
                              threshold: 30,
                              controller: steamPressureController,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ParamSetting(
                              millID: '',
                              paramtype: 'Water\nLevel',
                              threshold: 42,
                              unit: '%',
                              controller: waterLevelController,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ParamSetting(
                              millID: '',
                              paramtype: 'Steam\nFlow',
                              threshold: 29,
                              unit: 'T/H',
                              controller: steamFlowController,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ParamSetting(
                              millID: '',
                              paramtype: 'Turbine\nFrequency',
                              threshold: 50,
                              unit: 'Hz',
                              controller: turbineFrequencyController,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  'Notifications',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                ),
              ),
              Center(
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: _updateParameters,
                      child: const Text('Update Parameters'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _logout,
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ParamSetting extends StatefulWidget {
  final String millID;
  final String paramtype;
  final int threshold;
  final String unit;
  final TextEditingController controller;

  const ParamSetting({
    super.key,
    required this.millID,
    required this.paramtype,
    required this.threshold,
    required this.unit,
    required this.controller,
  });

  @override
  State<ParamSetting> createState() => _ParamSettingState();
}

class _ParamSettingState extends State<ParamSetting> {
  @override
  void initState() {
    super.initState();
    widget.controller.text = widget.threshold.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.paramtype,
          maxLines: 2,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 20,
              color: Color.fromARGB(255, 104, 104, 104),
              height: 1.2),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 80,
              height: 50,
              child: TextField(
                controller: widget.controller,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10)),
                    ),
                    hintText: widget.threshold.toString(),
                    hintStyle: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.w700, height: 1)),
                textAlign: TextAlign.right,
                textAlignVertical: TextAlignVertical.center,
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
              ),
            ),
            Container(
              width: 40,
              height: 50,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  widget.unit,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
