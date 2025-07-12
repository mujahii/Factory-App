import 'package:flutter/material.dart';
import '/api/api_enpoint.dart';
import '/screens/MainPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpConfirmation extends StatefulWidget {
  final TextEditingController phoneController;
  final String generatedOtp;
  const OtpConfirmation(
      {super.key,
      required,
      required this.phoneController,
      required this.generatedOtp});

  @override
  State<OtpConfirmation> createState() => _OtpConfirmationState();
}

class _OtpConfirmationState extends State<OtpConfirmation> {
  late TextEditingController _phoneController;
  late String _generatedOtp;
  final TextEditingController _otpController = TextEditingController();
  final MongoAPI _mongoAPI = MongoAPI();

  String _statusMessage = '';
  @override
  void initState() {
    super.initState();
    _phoneController = widget.phoneController;
    _generatedOtp = widget.generatedOtp;
    // Assign the passed data to a new variable
  }

  Future<void> _verifyOtp() async {
    try {
      final result = await _mongoAPI.otpVerify(
        _phoneController.text,
        _otpController.text,
      );

      if (result.containsKey('bearerToken')) {
        final bearerToken = result['bearerToken'];

        // Save the bearer token to shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('bearerToken', bearerToken);

        setState(() {
          _statusMessage = 'OTP Verified. Bearer Token: $bearerToken';
          print('Bearer Token: $bearerToken');
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MainPage(),
          ),
        );
      } else {
        setState(() {
          _statusMessage = 'OTP Verified: ${result['message']}';
        });
        print('OTP Verified: ${result['message']}');
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Error: $e';
      });
      print('Error: $e');
    }
  }

  bool isTablet = false;
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var shortestSide = screenSize.shortestSide;

    if (shortestSide >= 800) {
      isTablet = true;
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            Image.asset(
              'assets/upmlogo.png',
              width: 280,
              height: 120,
              alignment: Alignment.topLeft,
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: screenSize.width * 0.1, bottom: 10),
              child: Text(
                'Welcome!',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: isTablet ? 55 : 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Center(
              child: Column(
                children: [
                  Container(
                    height: screenSize.height * 0.55,
                    width: screenSize.width * 0.9,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          spreadRadius: 5, // Increased spread radius
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, left: 20),
                                child: Text(
                                  'Enter the activation code you\nreceived via SMS.',
                                  style: TextStyle(
                                    fontSize: isTablet ? 33 : 18,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, top: 20),
                                child: Icon(
                                  Icons.info_outline,
                                  size: isTablet ? 45 : 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 40.0,
                              right: 40.0,
                            ),
                            child: TextField(
                              textAlign: TextAlign.center,
                              controller: _otpController,
                              decoration: InputDecoration(
                                hintText: 'OTP',
                                hintStyle:
                                    TextStyle(fontSize: isTablet ? 32 : 18),
                                filled: true,
                                fillColor: Colors.white,
                                border: const OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 50.0,
                              ),
                              child: Text(
                                '0/6',
                                style: TextStyle(fontSize: isTablet ? 27 : 14),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 50),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Didn\'t Receive? ',
                              style: TextStyle(fontSize: isTablet ? 27 : 14),
                            ),
                            Text(
                              'Tap Here',
                              style: TextStyle(
                                  fontSize: isTablet ? 27 : 14,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                            key: const Key("activate"),
                            child: Text(
                              'Activate',
                              style: TextStyle(fontSize: isTablet ? 30 : 15),
                            ),
                            onPressed: _verifyOtp),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Disclaimer | Privacy Statement',
                          style: TextStyle(
                              fontSize: isTablet ? 27 : 14,
                              decoration: TextDecoration.underline,
                              color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: Text(
                        'Copyright UPM & Kejuruteraan Minyak Sawit\nCCS Sdn. Bhd.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isTablet ? 27 : 14,
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
