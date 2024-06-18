import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mustafachatclone/features/call/pages/call_contacts_page.dart';
import 'package:mustafachatclone/features/call/pages/calls_history_page.dart';
import 'package:mustafachatclone/features/user/controllers/user_controller.dart';

import '../../../../data/user/user_repository.dart';
import '../../../../global/theme/style.dart';
import '../../../chat/pages/chat_page.dart';
import '../../../status/controllers/chat/status_controller.dart';
import '../../../status/pages/status_page.dart';
import '../settings/settings_page.dart';
import 'contacts_page.dart';

class HomePage extends StatefulWidget {


  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin, WidgetsBindingObserver {

  TabController? _tabController;
  int _currentTabIndex = 0;

  final userController = Get.put(UserController());
  final controllerStatus = Get.put(StatusController());
  @override
  void initState() {
    print("Nit Homeeeeeeeeeeeeeeeeeeeeeeee");

    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addObserver(this);
    _tabController!.addListener(() {
      setState(() {
        _currentTabIndex = _tabController!.index;
      });
    });


    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tabController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        userController.updateUserOnline(
                uid: userController.user.value.uid,
                isOnline: true
        );
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
      userController.updateUserOnline(
          uid: userController.user.value.uid,
          isOnline: false
      );
        break;
      case AppLifecycleState.hidden:
      // TODO: Handle this case.
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: (){
            UserRepository.instance.signOut();
          },
          child: const Text(
            "WhatsApp",
            style: TextStyle(
                fontSize: 20,
                color: greyColor,
                fontWeight: FontWeight.w600),
          ),
        ),
        actions: [
          Row(
            children: [
              const Icon(
                Icons.camera_alt_outlined,
                color: greyColor,
                size: 28,
              ),
              const SizedBox(
                width: 25,
              ),
              const Icon(Icons.search, color: greyColor, size: 28),
              const SizedBox(
                width: 10,
              ),
              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert,
                  color: greyColor,
                  size: 28,
                ),
                color: appBarColor,
                iconSize: 28,
                onSelected: (value) {},
                itemBuilder: (context) =>
                <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: "Settings",
                    child: GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>  SettingPage(uid: UserRepository.instance.auth.currentUser!.uid,)));
                        },
                        child: const Text('Settings')),
                  ),
                ],
              ),
            ],
          ),
        ],
        bottom: TabBar(
          indicatorSize:TabBarIndicatorSize.tab,
          labelColor: tabColor,
          unselectedLabelColor: greyColor,
          indicatorColor: tabColor,
          controller: _tabController,
          tabs: const [
            Tab(

              child: Text(
                "Chats",
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            Tab(
              child: Text(
                "Status",
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            Tab(
              child: Text(
                "Calls",
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],

        ),
      ),
      floatingActionButton: switchFloatingActionButtonOnTabIndex(
          _currentTabIndex),
      body: TabBarView(
        
        controller: _tabController,

        children:  [
          ChatPage(),
          StatusPage(),
          CallHistoryPage(currentUser: userController.user.value,)
          // StatusPage(),
        ],
      ),
    );
  }

  switchFloatingActionButtonOnTabIndex(int index) {
    switch (index) {
      case 0:
        {
          return FloatingActionButton(
            backgroundColor: tabColor,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ContactsPage()));

            },
            child: const Icon(
              Icons.message,
              color: Colors.white,
            ),
          );
        }
      case 1:
        {
          return FloatingActionButton(
            backgroundColor: tabColor,
            onPressed: () {
              controllerStatus.eitherShowOrUploadSheet(null);
              ///Navigator.push(context, MaterialPageRoute(builder: (context) => const ContactsPage()));

            },
            child: const Icon(
              Icons.camera_alt,
              color: Colors.white,
            ),
          );
        }
      case 2:
        {
          return FloatingActionButton(
            backgroundColor: tabColor,
            onPressed: () {
              // Navigator.pushNamed(context, PageConst.callContactsPage);
              Navigator.push(context, MaterialPageRoute(builder: (context) =>  CallContactsPage()));

            },
            child: const Icon(
              Icons.add_call,
              color: Colors.white,
            ),
          );
        }
      default:
        {
          return FloatingActionButton(
            backgroundColor: tabColor,
            onPressed: () {},
            child: const Icon(
              Icons.message,
              color: Colors.white,
            ),
          );
        }
    }
  }


}
