import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '/api/api_enpoint.dart';
import '/screens/otp_confimation.dart';
import 'package:shared_preferences/shared_preferences.dart';

//TODO : use shared preferences package for validate once and googleAuth for OTP verification
//remember must be involved at main function
class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final MongoAPI mongoAPI = MongoAPI();

  final TextEditingController _phoneController = TextEditingController();
  final MongoAPI _mongoAPI = MongoAPI();

  String _statusMessage = '';
  String _generatedOtp = '';

  Future<void> _generateOtp() async {
    try {
      final result = await _mongoAPI.otpGen(_phoneController.text);
      setState(() {
        _statusMessage = 'OTP Generated: ${result['message']}';
        _generatedOtp =
            result['otp']; // Assuming the OTP is returned with this key
        print(_generatedOtp);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return OtpConfirmation(
            phoneController: _phoneController,
            generatedOtp: _generatedOtp,
          );
        }));
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error: $e';
      });
    }
  }

  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    //for phone number
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    String initialCountry = 'MY';
    PhoneNumber number = PhoneNumber(isoCode: 'MY');

    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      return Colors.blue;
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              Image.asset(
                'assets/upmlogo.png',
                width: 280,
                height: 120,
                alignment: Alignment.topLeft,
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Text(
                  'Welcome !',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 40),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD9D9D9),
                          borderRadius: BorderRadius.circular(
                              10), // Optional: To add rounded corners
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.grey.withOpacity(0.5), // Shadow color
                              spreadRadius: 2, // Spread radius of the shadow
                              blurRadius: 4, // Blur radius of the shadow
                              offset:
                                  const Offset(0, 3), // Offset of the shadow
                            ),
                          ],
                        ),
                        height: 500,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                flex: 1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                        width: 280,
                                        child: Text(
                                          'Enter your mobile number to activate your account.',
                                          style: TextStyle(fontSize: 18),
                                        )),
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.info_outline),
                                      tooltip:
                                          'Only registered number can\nrequest for activation.',
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                flex: 2,
                                child: Form(
                                  key: formKey,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 20, 0, 40),
                                        child: SizedBox(
                                          width: 320,
                                          child: InternationalPhoneNumberInput(
                                              inputDecoration:
                                                  const InputDecoration(
                                                isCollapsed: true,
                                                contentPadding:
                                                    EdgeInsets.all(10),
                                                suffixIconColor: Colors.white,
                                                filled: true,
                                                fillColor: Colors
                                                    .white, // Change the background color here
                                                border: OutlineInputBorder(),
                                              ),
                                              onInputChanged:
                                                  (PhoneNumber number) {
                                                print(number.phoneNumber);
                                              },
                                              onInputValidated: (bool value) {
                                                print(value);
                                              },
                                              selectorConfig:
                                                  const SelectorConfig(
                                                selectorType:
                                                    PhoneInputSelectorType
                                                        .BOTTOM_SHEET,
                                              ),
                                              ignoreBlank: false,
                                              autoValidateMode:
                                                  AutovalidateMode.disabled,
                                              selectorTextStyle:
                                                  const TextStyle(
                                                      color: Colors.black),
                                              initialValue: number,
                                              textFieldController:
                                                  _phoneController,
                                              formatInput: false,
                                              keyboardType: const TextInputType
                                                  .numberWithOptions(
                                                  signed: true, decimal: true),
                                              inputBorder:
                                                  const OutlineInputBorder(),
                                              onSaved: (PhoneNumber number) {
                                                print('On Saved: $number');
                                              }),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Checkbox(
                                            checkColor: Colors.white,
                                            fillColor: MaterialStateProperty
                                                .resolveWith(getColor),
                                            value: isChecked,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                isChecked = value!;
                                              });
                                            },
                                          ),
                                          const Text(
                                              'I agree to the terms & conditions'),
                                        ],
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          //currently only check if phone number in valid form
                                          //TODO : Need to add condition here to check if they are registered (found in records) and do OTP
                                          _generateOtp();
                                        },
                                        child: const Text(
                                          'Get Activation Code',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      Text(_statusMessage),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'Disclaimer | Privacy Statement',
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.blue),
                  ),
                ),
              ),
              const Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Copyright UPM & Kejuruteraan Minyak Sawit',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    'CCS Sdn. Bhd.',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
