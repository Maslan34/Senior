import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senior_project/pages/additional/app_drawer.dart';
import 'package:senior_project/pages/thesisInfoPage.dart';
import 'package:senior_project/repository/thesis_repository.dart';

import 'package:senior_project/model/Thesis.dart' as thModel ;




class thesisPage extends ConsumerStatefulWidget {
  const thesisPage({Key? key}) : super(key: key);

  @override
  _thesisPageState createState() => _thesisPageState();


}

class _thesisPageState extends ConsumerState<thesisPage> {




  Future<void> _dialogBuilder(BuildContext context, allThesis, deletedItem) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Warning'),
          content: const Text("This thesis will be removed. Are you sure ?"),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Delete'),
              onPressed: () {
                allThesis.removeWhere(
                        (thModel.thesisModel currentItem) => deletedItem == currentItem);
                Navigator.of(context).pop();
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {

    List<thModel.thesisModel> allThesis =ref.watch(thesisProvider).thesis;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Thesis"),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image:AssetImage('lib/assets/images/kbu.png'),
                fit:BoxFit.fitWidth,opacity: 0.9
            )

          // Arka plan resminizin yolu
        ),

        child: Column(
          children: [
            SingleChildScrollView(
                child: ExpansionPanelList(
                  expansionCallback: (int index, bool isExpanded) {
                    setState(() {
                      allThesis[index].isShowed = isExpanded;
                    });
                  },
                  children: allThesis.map<ExpansionPanel>((thModel.thesisModel item) {
                    return ExpansionPanel(
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return Container(
                          child: ListTile(
                            title: Text(item.title),
                          ),
                        );
                      },
                      body: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image:AssetImage('lib/assets/images/thesis.jpg'),
                                fit:BoxFit.cover,opacity: 0.9
                            )

                          // Arka plan resminizin yolu
                        ),
                        child: SizedBox(
                          height: 200,

                          child: ListTile(
                              title: Text(item.title),
                              subtitle: Text(item.makaleIcerigi['textAreaThesis']),
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
                                        _dialogBuilder(context, allThesis, item);
                                      },
                                      child: const Icon(Icons.delete),
                                    )),
                              ),
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            thesisInfoPage(thesis:item)));
                              }),
                        ),
                      ),
                      isExpanded: item.isShowed,
                    );
                  }).toList(),
                )),
          ],
        ),
      ),drawer: app_drawer(),
      // drawer: AppDrawer(user: "Muharrem"));  // `AppDrawer` widget'ı burada tanımlı değil, bu yüzden yorum satırı haline getirildi.
    );
  }
}



