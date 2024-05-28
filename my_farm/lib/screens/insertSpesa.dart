
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_farm/models/spesaModel.dart';


class InsertSpesa extends StatefulWidget {
  const InsertSpesa({super.key});

  @override
  State<InsertSpesa> createState() => _InsertSpesaState();
}

class _InsertSpesaState extends State<InsertSpesa> {

  final _formKey = GlobalKey<FormState>();

  List<Spesa> _spese = [];

  late TextEditingController _nameController;
  String _name = '';
  String _description = '';
  String? _nameNegozio;
  //data acquisto
  DateTime? _selectedDate;
  //importo spesa
  String? _importoSpesa;

  late Future<List<String>> _stores;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _loadSpese();
    _stores = _loadStores();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<List<String>> _loadStores() async {
    List<String> stores = await getStores();
    return stores;
  }

  Future<void> _loadSpese() async {
    List<Spesa> spese = await getSpese();
    setState(() {
      _spese = spese;
    });
  }

  void _setNameSpesa(String value) {
    _name = value;
  }

  void _setDescription(String value) {
    setState(() {
      _description = value;
    });
  }

  void _setImportoSpesa(String value) {
    setState(() {
      _importoSpesa = value;
    });
  }

  Future<void> _saveSpesa() async {
    if(_name == '' || _nameNegozio == null || _description == '' || _selectedDate == null || _importoSpesa == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Compila tutti i campi obbligatori'),
          backgroundColor: Colors.red,
          showCloseIcon: true,
        ),
      );
      return;
    }

    Spesa newSpesa = Spesa(
      name: _name,
      store: _nameNegozio!,
      description: _description,
      price: double.parse(_importoSpesa!),
      date: _selectedDate!,
    );
    _spese.add(newSpesa);
    await storeSpese(_spese);
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Spesa salvata con successo'),
        backgroundColor: Colors.green,
        showCloseIcon: true,
      ),
    );
    
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //back button
          Container(
            margin: const EdgeInsets.all(16),
            child: IconButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(const EdgeInsets.all(8)),
                foregroundColor: MaterialStateProperty.all(Colors.white),
                backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 142, 212, 174)),
                iconSize: MaterialStateProperty.all(30),
              ),
              color: Colors.white,
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                context.go('/home');
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 140, 230, 188),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: _nameController,
                        onChanged: _setNameSpesa,
                        decoration: const InputDecoration(
                          labelText: 'Nome spesa *',
                          icon: Icon(Icons.title),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                   
                    //store name with future builder
                    //select dropdown for type of activity
                    Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.work),
                          const SizedBox(width: 20),
                          FutureBuilder<List<String>>(
                            future: _stores,
                            builder: (context, snapshot) {
                              if(snapshot.connectionState == ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }
                              if(snapshot.hasError) {
                                return const Text('Errore nel caricamento dei negozi');
                              }
                              return DropdownButton<String>(
                                hint: const Text('Seleziona il negozio *', style: TextStyle(color: Colors.black, fontSize: 16)),
                                value: _nameNegozio,
                                items: snapshot.data!.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value, style: const TextStyle(color: Colors.black, fontSize: 14)),
                                  );
                                }).toList(),
                                onChanged: (String? value) {
                                  setState(() {
                                    _nameNegozio = value;
                                  });
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
          
                    Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        onChanged: _setDescription,
                        decoration: const InputDecoration(
                          labelText: 'Prodotti acquistati *',
                          icon: Icon(Icons.description),
                        ),
                        maxLines: 2,
                      ),
                    ),
          
                    //date picker for activity date
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.date_range),
                          const SizedBox(width: 20),
                          GestureDetector(
                            onTap: () async {
                              final DateTime? date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              setState(() {
                                _selectedDate = date;
                              });
                            },
                            child: Text(_selectedDate == null
                                ? 'Seleziona la data *'
                                : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
                          ),
                        ],
                      ),
                    ),

                    //importo spesa
                    Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        onChanged: _setImportoSpesa,
                        decoration: const InputDecoration(
                          labelText: 'Importo spesa *',
                          icon: Icon(Icons.euro),
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
          
                    //button to submit the form
                    Container(
                      margin: const EdgeInsets.only(left: 8, right: 8, bottom: 16, top: 16),
                      child: ElevatedButton(
                        onPressed: _saveSpesa,
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(const EdgeInsets.all(16)),
                          backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 39, 65, 71)),
                          foregroundColor: MaterialStateProperty.all(Colors.white),
                          textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 18)),
                          elevation: MaterialStateProperty.all(1),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                        ),
                        child: const Text('Inserisci'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}