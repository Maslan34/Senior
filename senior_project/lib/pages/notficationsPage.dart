import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senior_project/pages/additional/app_drawer.dart';
import 'package:senior_project/repository/notifications_repository.dart';
import 'package:senior_project/model/Notifications.dart';

class notificationsPage extends ConsumerStatefulWidget {
  notificationsPage({super.key, required this.title});

  final String title;

  @override
  _notificationsPageState createState() => _notificationsPageState();
}

class _notificationsPageState extends ConsumerState<notificationsPage> {
  @override
  Widget build(BuildContext context) {
    List<Notifications> notificaions =
        ref.watch(notificationProvider).notifications;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Stack(
          children: [
            Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image:AssetImage('lib/assets/images/notificationBackground.jpeg'),
                        fit:BoxFit.cover,opacity: 0.2
                    )

                  // Arka plan resminizin yolu
                )
            ),
            SingleChildScrollView(
                child: ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  notificaions[index].isShowed = isExpanded;
                });
              },
              children: notificaions.map<ExpansionPanel>((Notifications item) {
                return ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return Container(
                      color: item.isReaden == true
                          ? Colors.blueAccent
                          : Colors.red,
                      child: ListTile(
                        title: Text(item.Title),
                      ),
                    );
                  },
                  body: Container(
                    child: ListTile(
                        title: Text(item.Text),
                        subtitle: Text("Send at: " + item.Time.toString()),
                        trailing: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: SizedBox(
                              width: 50,
                              height: 50,
                              child: InkWell(
                                onTap: () {
                                  //_dialogBuilder(context, allThesis, item);
                                },
                                child: const Icon(Icons.mark_chat_read_sharp),
                              )),
                        ),
                        onTap: () {
                            item.isReaden=true;
                        }),
                  ),
                  isExpanded: item.isShowed,
                );
              }).toList(),
            )),
          ],
        ),
        drawer: app_drawer());
  }
}
