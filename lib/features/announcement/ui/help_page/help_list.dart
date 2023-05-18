// Importing required packages and files
import 'package:flutter/material.dart';
import 'package:vocel/LocalizedButtonResolver.dart';
import 'package:vocel/LocalizedMessageResolver.dart';
import 'package:vocel/common/utils/colors.dart' as constants;

// Defining ContactPage as a stateless widget
class ContactPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
// Returning a Scaffold widget that provides a basic structure for the app's layout
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removes back button in the app bar
        leading: SizedBox(
          height: 60,
          width: 60,
          child: FloatingActionButton(
            backgroundColor: Colors.transparent, // Makes the background of the back button transparent
            elevation: 0,
            child: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white, // Sets the color of the back button to white
              size: 30,
            ),
            onPressed: () {
              Navigator.pop(context); // Navigates back to the previous screen when the back button is pressed
            },
          ),
        ),
        title: Text(
            const LocalizedButtonResolver().helps(context), // Sets the title of the app bar to "Settings"
        ),
        actions: const [], // Removes any actions in the app bar
        centerTitle: false, // Aligns the title of the app bar to the left
        elevation: 2, // Adds a shadow to the app bar
        backgroundColor: const Color(constants.primaryColorDark), // Sets the background color of the app bar to a constant value defined in the "colors.dart" file
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
// Adds a container that displays an image with some text in the center
          Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(constants.primaryDarkTeal).withOpacity(0.4), // Adds a shadow to the container
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
            image: const DecorationImage(
                image: AssetImage('images/vocel_logo.png'), // Sets the image asset to display in the container
                fit: BoxFit.cover,
                opacity: 0.7 // Sets the opacity of the image to 0.7
            ),
          ),
          child: Center(
            child: Text(
              const LocalizedMessageResolver().getInTouch(context), // Displays the text "Get In Touch" in the center of the container
              style: const TextStyle(
                color: Color(constants.primaryDarkTeal), // Sets the color of the text to a constant value defined in the "colors.dart" file
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 30), // Adds a sized box with a height of 30 pixels
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20), // Adds padding to the left and right of the text field
          child: Text(
            "How can we help you? Contact us via the form below, and we'll get back to you as soon as possible.", // Displays a message to the user
            style: TextStyle(
            fontSize: 18,
            height: 1.5,
          ),
        ),
      ),
      const SizedBox(height: 30), // Adds a sized box with a height of 30 pixels
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20), // Adds padding to the left and right of the column
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
                   Text(
                    const LocalizedMessageResolver().contactForm(context),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                   TextField(
                    decoration: InputDecoration(
                      hintText: const LocalizedMessageResolver().name(context),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                   TextField(
                    decoration: InputDecoration(
                      hintText: const LocalizedButtonResolver().email(context),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                   TextField(
                    decoration: InputDecoration(
                      hintText: const LocalizedMessageResolver().message(context),
                      border: const OutlineInputBorder(),
                    ),
                    maxLines: 5,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 120,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: MaterialButton(
                          onPressed: () {},
                          color: const Color(constants.primaryColorDark),
                          textColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          child: Text(
                            const LocalizedButtonResolver().submit(context),
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Container(
              color: Colors.grey[100],
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Text(
                      const LocalizedMessageResolver().contactForm(context),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                     Text(
                      '${const LocalizedMessageResolver().address(context)}: Chicago ... ',
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                     Text(
                      '${const LocalizedMessageResolver().phoneNumber(context)}: 555-555-5555',
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                     Text(
                      '${const LocalizedButtonResolver().email(context)}: info@fitch....com',
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
