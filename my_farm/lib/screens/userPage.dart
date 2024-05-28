import 'package:flutter/material.dart';
import 'package:my_farm/models/activityModel.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {

  //form key
  //final _formKey = GlobalKey<FormState>();

  late Future<List<String>> _prova;

  @override
  void initState() {
    super.initState();
    _prova = _loadProva();
  }

  Future<List<String>> _loadProva() async {
    List<String> prova = await getProva();
    return prova;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          //form per aggiungere un nuovo operaio
           FutureBuilder<List<String>>(
             future: _prova,
             builder: (context, snapshot) {
               if (snapshot.connectionState == ConnectionState.waiting) {
                 return const CircularProgressIndicator();
               } else {
                 return Column(
                   children: [
                     Text(snapshot.data.toString()),
                   ],
                 );
               }
             },
           ),
          
        ],
      ),

    );
  }
}