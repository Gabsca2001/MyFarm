import 'package:flutter/material.dart';
import 'package:my_farm/models/activityModel.dart';
import 'package:my_farm/models/spesaModel.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {

  //form key1
  final _formKey1 = GlobalKey<FormState>();

  //form key2
  final _formKey2 = GlobalKey<FormState>();

  //List of workers
  late Future<List<String>> _workers;

  //List of stores
  late Future<List<String>> _stores;

  @override
  void initState() {
    super.initState();
    _workers = _loadWorkers();
    _stores = _loadStores();
  }

  Future<List<String>> _loadWorkers() async {
    List<String> workers = await getWorkers();
    return workers;
  }

  Future<List<String>> _loadStores() async {
    List<String> stores = await getStores();
    return stores;
  }

  //add worker
  Future<void> addWorker(String worker) async {
    List<String> workers = await getWorkers();
    workers.add(worker);
    await storeWorkers(workers);
    setState(() {
      _workers = _loadWorkers();
    });
  }

  //add store
  Future<void> addStore(String store) async {
    List<String> stores = await getStores();
    stores.add(store);
    await storeStores(stores);
    setState(() {
      _stores = _loadStores();
    });
  }



  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          //form per aggiungere un nuovo operaio
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Form(
                key: _formKey1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Aggiungi un nuovo operaio',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Nome operaio',
                        icon: Icon(Icons.person),
                        labelStyle: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                      validator: (value) => value!.isEmpty ? 'Inserisci un nome' : null,
                      //value is the worker name
                      onSaved: (value) => addWorker(value!),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        //if the form is valid call addWorker with the worker name
                        if (_formKey1.currentState!.validate()) {
                          _formKey1.currentState!.save();
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 39, 65, 71)),
                        elevation: MaterialStateProperty.all(1),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      
                      ),
                      child: const Text('Aggiungi', style: TextStyle(color: Colors.white),
                    ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          //lista degli operai
          Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8.0),
            height: 250,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: FutureBuilder<List<String>>(
              future: _workers,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Errore: ${snapshot.error}');
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(

                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text(snapshot.data![index], style: Theme.of(context).textTheme.bodyMedium,),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Color.fromARGB(255, 247, 98, 87)),
                          onPressed: () {
                            //show a dialog to confirm the deletion
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Conferma'),
                                  content: const Text('Sei sicuro di voler eliminare questo operaio?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Annulla'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        setState(() {
                                          snapshot.data!.removeAt(index);
                                          storeWorkers(snapshot.data!);
                                        });
                                      },
                                      child: const Text('Conferma'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          //aggiungi un nuovo store
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Form(
                key: _formKey2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Aggiungi un nuovo store',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Nome store',
                        icon: Icon(Icons.store),
                        labelStyle: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                      validator: (value) => value!.isEmpty ? 'Inserisci un nome' : null,
                      //value is the store name
                      onSaved: (value) => addStore(value!),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        //if the form is valid call addStore with the store name
                        if (_formKey2.currentState!.validate()) {
                          _formKey2.currentState!.save();
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 39, 65, 71)),
                        elevation: MaterialStateProperty.all(1),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      
                      ),
                      child: const Text('Aggiungi', style: TextStyle(color: Colors.white),
                    ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          //lista degli store
          Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8.0),
            height: 250,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: FutureBuilder<List<String>>(
              future: _stores,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Errore: ${snapshot.error}');
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text(snapshot.data![index], style: Theme.of(context).textTheme.bodyMedium,),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Color.fromARGB(255, 247, 98, 87)),
                          onPressed: () {
                            //show a dialog to confirm the deletion
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Conferma'),
                                  content: const Text('Sei sicuro di voler eliminare questo store?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Annulla'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        setState(() {
                                          snapshot.data!.removeAt(index);
                                          storeStores(snapshot.data!);
                                        });
                                      },
                                      child: const Text('Conferma'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),

    );
  }
}