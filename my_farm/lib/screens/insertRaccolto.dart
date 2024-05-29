import 'package:flutter/material.dart';
import 'package:my_farm/models/raccoltoModel.dart';
import 'package:go_router/go_router.dart';

class InsertRaccolto extends StatefulWidget {
  const InsertRaccolto({super.key});

  @override
  State<InsertRaccolto> createState() => _InsertRaccoltoState();
}

class _InsertRaccoltoState extends State<InsertRaccolto> {

  //list of raccolto
  List<Raccolto> _raccolto = [];

  //form key
  final _formKey = GlobalKey<FormState>();

  //nome
  String? _name;
  //quantità
  double? _quantity;
  //importo
  String? _price;
  //descrizione
  String? _description;
  //date
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _loadRaccolto();
  }

  //load raccolto
  Future<void> _loadRaccolto() async {
    List<Raccolto> raccolto = await getRaccolti();
    setState(() {
      _raccolto = raccolto;
    });
  }

  //save data function
  Future<void> saveData() async{
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Seleziona una data'),
        ),
      );
      return;
    }

    // Save the form state
    _formKey.currentState!.save();

    //add raccolto
    Raccolto newRaccolto = Raccolto(
      nome: _name!,
      quantita: _quantity!,
      data: _selectedDate!,
      description: _description,
      prezzo: double.parse(_price!),
    );

    //add raccolto to list
    _raccolto.add(newRaccolto);
    await storeRaccolto(_raccolto);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Raccolto salvato con successo'),
        backgroundColor: Colors.green,
        showCloseIcon: true,
      ),
    );

    // Clear the form after saving data
    _formKey.currentState?.reset();
    setState(() {
      _selectedDate = null;
    });
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
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Inserisci un nuovo raccolto',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Nome *',
                      icon: Icon(Icons.title),
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Inserisci un nome';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _name = value;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Quantità in Kg *',
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                      icon: Icon(Icons.monitor_weight),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Inserisci una quantità';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _quantity = double.parse(value!);
                    },
                    //keyboard type
                    keyboardType: TextInputType.number,
                  ),
                  //date picker
                  Container(
                    margin: const EdgeInsets.only(top: 20),
          
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
                  //importo
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Importo *',
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                      icon: Icon(Icons.euro),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Inserisci un importo';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _price = value;
                    },
                    //keyboard type
                    keyboardType: TextInputType.number,
                  ),
                  //description
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Descrizione',
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                      icon: Icon(Icons.description),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Inserisci una descrizione';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _description = value;
                    },
                    //max lines
                    maxLines: 2,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 8, right: 8, bottom: 16, top: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          saveData();
                        }
                      },
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
        ],
      ),
    );
  }
}