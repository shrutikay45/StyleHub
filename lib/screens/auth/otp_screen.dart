import 'package:flutter/material.dart';
import 'package:new_expense/screens/auth/login_screen.dart';
import 'package:new_expense/screens/home/home_screen.dart';
import '../../core/constants/app_colors.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({
    super.key,
    required this.phoneNumber,
  });
  final String phoneNumber;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String otp = '';

  // otp helper
  Widget otpBox(int index) {
    String digit = '';

    if (index < otp.length) {
      digit = otp[index];
    }

    return Container(
      width: 48,
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Text(
        digit,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.dark,
        ),
      ),
    );
  }

  // to add otp
  void addDigit(String digit) {
    if (otp.length < 6) {
      setState(() {
        otp = otp + digit;
      });
    }
  }

  // reusable number button
  Widget numberButton(String number) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: SizedBox(
          height: 58,
          child: ElevatedButton(
            onPressed: () {
              addDigit(number);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.dark,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // delete button function
  void deleteDigit() {
    if (otp.isNotEmpty) {
      setState(() {
        otp = otp.substring(0, otp.length - 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 10),

              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      color: AppColors.dark,
                      size: 22,
                    ),
                  ),

                  const Expanded(
                    child: Center(
                      child: Text(
                        'Verify Phone',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.dark,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 22),
                ],
              ),
              const SizedBox(height: 36),

              Text(
                'Code is sent to ${widget.phoneNumber}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.lightGrey,
                ),
              ),

              const SizedBox(height: 32),


              // otp boxes

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  otpBox(0),
                  otpBox(1),
                  otpBox(2),
                  otpBox(3),
                  otpBox(4),
                  otpBox(5),
                ],
              ),
              const SizedBox(height: 24),

              // some text

              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('OTP sent again'),
                    ),
                  );
                },
                child: const Text(
                  "Didn't receive code? Request again",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // get via call text


              // main button
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    if (otp.length == 6) {
                      // verification will be added later
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter the 6-digit OTP'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
                    },
                    child: const Text(
                      'Verify otp',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // keypad buttons

              Column(
                children: [
                  Row(
                    children: [
                      numberButton('1'),
                      numberButton('2'),
                      numberButton('3'),
                    ],
                  ),
                  Row(
                    children: [
                      numberButton('4'),
                      numberButton('5'),
                      numberButton('6'),
                    ],
                  ),
                  Row(
                    children: [
                      numberButton('7'),
                      numberButton('8'),
                      numberButton('9'),
                    ],
                  ),
                  Row(
                    children: [
                      const Expanded(
                        child: SizedBox(),
                      ),

                      numberButton('0'),

                      Expanded(
                        child: IconButton(
                          onPressed: deleteDigit,
                          icon: const Icon(
                            Icons.backspace_outlined,
                            color: AppColors.dark,
                            size: 20,
                          ),
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