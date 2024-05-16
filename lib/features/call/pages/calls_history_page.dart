import 'package:flutter/material.dart';

import '../../../global/date/date_formats.dart';
import '../../../global/theme/style.dart';
import '../../../global/widgets/profile_widget.dart';
class CallHistoryPage extends StatelessWidget {
  const CallHistoryPage ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 15,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
            "Recent" ,
                style: TextStyle(
                    fontSize: 15,
                    color: greyColor,
                    fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: 10,
                itemBuilder: (context, index) {

                  return ListTile(
                    leading: Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: profileWidget(),
                      ),
                    ),
                    title: const Text(
                      "Mustafa",
                      style: TextStyle(fontSize: 16),
                    ),
                    subtitle: Row(
                      children: [
                        Icon(
                        Icons.call_received,
                          color:  Colors.green,
                          size: 19,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(formatDateTime(DateTime.now())),
                      ],
                    ),
                    trailing: const Icon(
                      Icons.call,
                      color: tabColor,
                    ),
                  );
                }),
          ],
        )
    );
  }
}
