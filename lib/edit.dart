import 'package:flutter/material.dart';
import 'package:sqlitekpdemo/databasehandler.dart';
import 'package:sqlitekpdemo/user.dart';

class Edit extends StatefulWidget {
  Edit({Key? key, required this.pass}) : super(key: key);

  final User pass;

  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  late DatabaseHandler handler;

  @override
  void initState() {
    super.initState();
    this.handler = DatabaseHandler();
    this.handler.initializeDB().whenComplete(() async {});
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController namaController = TextEditingController()
      ..text = widget.pass.name;
    TextEditingController umurController = TextEditingController()
      ..text = widget.pass.age.toString();
    TextEditingController negaraController = TextEditingController()
      ..text = widget.pass.country;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit user'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Text('ID ${widget.pass.id.toString()}'),
              SizedBox(
                height: 30,
              ),
              Text('Name:'),
              TextField(
                controller: namaController,
              ),
              Text('Age:'),
              TextField(
                controller: umurController,
              ),
              Text('Country'),
              TextField(
                controller: negaraController,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        //edit function here
                        await this.handler.updateUser(User(
                            id: widget.pass.id,
                            name: namaController.text,
                            age: int.parse(umurController.text),
                            country: negaraController.text));
                        Navigator.pop(context);
                      },
                      child: Text('Edit User')),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}