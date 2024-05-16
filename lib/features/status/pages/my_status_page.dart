import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:mustafachatclone/features/status/controllers/chat/status_controller.dart';
import 'package:mustafachatclone/features/status/models/status_model.dart';
import 'package:mustafachatclone/features/status/pages/widgets/delete_status_update_alert.dart';

import '../../../global/theme/style.dart';
import '../../../global/widgets/profile_widget.dart';
import '../../user/screens/home/home_page.dart';

class MyStatusPage extends StatefulWidget {
  final StatusModel status;

  const MyStatusPage({super.key, required this.status});

  @override
  State<MyStatusPage> createState() => _MyStatusPageState();
}

class _MyStatusPageState extends State<MyStatusPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Status"),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: profileWidget(
                        imageUrl: widget.status.imageUrl
                    ),
                  ),
                ),
                const SizedBox(width: 15,),
                Expanded(
                  child: Text(
                    GetTimeAgo.parse(widget.status.createdAt!.toDate().subtract(Duration(seconds: DateTime.now().second))),
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                ),

                PopupMenuButton<String>(
                  icon:Icon(Icons.more_vert, color: greyColor.withOpacity(.5),),
                  color: appBarColor,
                  iconSize: 28,
                  onSelected: (value) {},
                  itemBuilder: (context) => <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: "Delete",
                      child: GestureDetector(onTap: () {
                        deleteStatusUpdate(context, onTap: () {
                          Navigator.pop(context);
                          StatusController.instance.deleteStatus(
                              status: StatusModel(
                                  statusId: widget.status.statusId
                              )
                          );
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
                        });
                      },
                        child: const Text('Delete'),),),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
