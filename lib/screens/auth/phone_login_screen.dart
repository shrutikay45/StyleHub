import 'package:flutter/material.dart';
import 'package:new_expense/screens/auth/otp_screen.dart';
import '../../core/constants/app_colors.dart';
// import 'otp_screen.dart';
// import '../core/constants/app_colors.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  // function to write number in textfield
  String phoneNumber = '';
  void addNumber(String number) {
    if (phoneNumber.length < 10) {
      setState(() {
        phoneNumber += number;
      });
    }
  }
  // function to remove number from textfield
  void deleteNumber() {
    if (phoneNumber.isNotEmpty) {
      setState(() {
        phoneNumber =
            phoneNumber.substring(0, phoneNumber.length - 1);
      });
    }
  }
  // helper for buttons
  Widget numberButton(String number) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: SizedBox(
          height: 58,
          child: ElevatedButton(
            onPressed: () {
              addNumber(number);
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
                        'Continue with Phone',
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
              const SizedBox(height: 38),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Enter Your\nMobile Number',
                  style: TextStyle(
                    fontSize: 30,
                    height: 1.18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.dark,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'We will send you a confirmation code',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 12),


              // the textfield container
              Container(
                width: double.infinity,
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.lightGrey.withOpacity(0.3),
                    width: 1.2,
                  ),
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  phoneNumber.isEmpty
                      ? '91 ('
                      : '91 ( $phoneNumber',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: phoneNumber.isEmpty
                        ? AppColors.lightGrey
                        : AppColors.dark,
                  ),
                ),
              ),

              // next button
              const SizedBox(height: 48),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                    // OTP navigation will come later
                  onPressed: () {
                    if (phoneNumber.length == 10) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>  OtpScreen(
                            phoneNumber: phoneNumber,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a valid 10-digit number'),
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
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              // keypad buttons
              const Spacer(),

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
                      onPressed: () {
                        deleteNumber();
                      },
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
        ),
      ),
    );
  }
}