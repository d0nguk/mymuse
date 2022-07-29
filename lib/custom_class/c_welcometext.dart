import 'package:flutter/material.dart';

class WelcomeText extends StatelessWidget {

  final String userName;

  const WelcomeText({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,//MediaQuery.of(context).size.width,
      height: 100,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'Hello',
                  style: TextStyle(
                    fontSize: 30,
                    // color: Theme.of(context).primaryColor,
                  ),
                ),
                const Padding(padding: EdgeInsets.only(left: 4)),
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 25,
                    color: Colors.purple,//Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            //Divider(height: 3, thickness: 1, color: Color.fromARGB(255, 0, 0, 0)),
            const Padding(padding: EdgeInsets.fromLTRB(4, 10, 0, 0)),
            const Text('Welcome to Application'),
          ],
        ),
      ),
    );
  }
}
