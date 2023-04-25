import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:vocel/common/utils/colors.dart' as constant;

class CustomEventNotification extends StatefulWidget {
  const CustomEventNotification({Key? key}) : super(key: key);

  @override
  State<CustomEventNotification> createState() =>
      _CustomEventNotificationState();
}

class _CustomEventNotificationState extends State<CustomEventNotification>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  )..addListener(() {
    setState(() {});
  });
  late final Animation<double> _animation =
  CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

  bool isRegistered = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        height: 80,
        child: InkWell(
          onTap: () {
            _controller.forward();
            Future.delayed(const Duration(milliseconds: 1500)).then((value) {
              _controller.reverse();
            });
          },
          child: Row(
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 2,
                  ),
                  image: const DecorationImage(
                    image: AssetImage('images/vocel_logo.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                width: 13,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "New Event",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Event details",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              MaterialButton(
                height: 28,
                minWidth: 64,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(
                    color: isRegistered ? Colors.grey : Colors.blue,
                    width: 1,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    isRegistered = !isRegistered;
                  });
                },
                child: Text(
                  isRegistered ? "Registered" : "Register",
                  style: TextStyle(
                    color: isRegistered ? Colors.grey : Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
