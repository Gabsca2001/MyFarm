import 'package:flutter/material.dart';
import 'package:my_farm/models/activityModel.dart';
import 'package:my_farm/models/spesaModel.dart';
import 'package:my_farm/widgets/noteCard.dart';
import 'package:my_farm/widgets/raccoltoDialog.dart';
import 'package:my_farm/widgets/spesaDialog.dart';
import 'package:my_farm/models/raccoltoModel.dart';


class ListBarPage extends StatefulWidget {
  const ListBarPage({super.key});

  @override
  State<ListBarPage> createState() => _ListBarPageState();

}

class _ListBarPageState extends State<ListBarPage> with SingleTickerProviderStateMixin{
  
  late final TabController _tabController;

  List<Activity> futureActivities = [];
  List<Activity> pastActivities = [];
  late Future<List<Activity>> _activities;
  late Future<List<Spesa>> _spese;
  late Future<List<Raccolto>> _raccolti;

  double totalSpese = 0;

  double totalIncassoRaccolta = 0;

  double tatolQuantitaRaccolta = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _activities = _loadActivities();
    _spese = _loadSpese();
    _raccolti = _loadRaccolti();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<List<Raccolto>> _loadRaccolti() async {
    List<Raccolto> raccolti = await getRaccolti();
    calculateTotalIncassoRaccolti();
    calculateTotalQuantitaRaccolta();
    return raccolti;
  }

  Future<List<Activity>> _loadActivities() async {
    List<Activity> activities = await getActivities();
    setState(() {
      futureActivities = activities.where((activity) => activity.date.isAfter(DateTime.now())).toList();
      pastActivities = activities.where((activity) => activity.date.isBefore(DateTime.now())).toList();
    });
    return activities;
  }

  Future<List<Spesa>> _loadSpese() async {
    List<Spesa> spese = await getSpese();
    calculateTotal();
    return spese;
  }

  //delete future activity
  void deleteActivityFuture(int index) async {
    //delete activity
    futureActivities.removeAt(index);
    _activities.then((activities) {
      activities.removeAt(index);
      storeActivities(activities);
    });
    setState(() {});
  }

  //delete activity from past
  void deleteActivityPast(int index) async {
    //delete activity
    pastActivities.removeAt(index);
    _activities.then((activities) {
      activities.removeAt(index);
      storeActivities(activities);
    });
    setState(() {});
  }

  //delete spesa
  void deleteSpesa(int index) async {
    _spese.then((spese) async{
      spese.removeAt(index);
      await storeSpese(spese);
    });
    calculateTotal();
    setState(() {

    });
  }

  void deleteRaccolto(int index) async {
    _raccolti.then((raccolti) async{
      raccolti.removeAt(index);
      await storeRaccolto(raccolti);
    });
    calculateTotalIncassoRaccolti();
    calculateTotalQuantitaRaccolta();
    setState(() {

    });
  }

  void calculateTotal() {
    _spese.then((spese) {
      totalSpese = spese.fold(0, (previousValue, element) => previousValue + element.price);
    });
  }

  void calculateTotalIncassoRaccolti() {
    _raccolti.then((raccolti) {
      totalIncassoRaccolta = raccolti.fold(0, (previousValue, element) => previousValue + element.prezzo);
    });
  }

  void calculateTotalQuantitaRaccolta() {
    _raccolti.then((raccolti) {
      tatolQuantitaRaccolta = raccolti.fold(0, (previousValue, element) => previousValue + element.quantita);
    });
  }
  
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      const Color.fromARGB(255, 236, 236, 236),
                      const Color.fromARGB(255, 252, 153, 140).withOpacity(0.8),
                      const Color.fromARGB(255, 44, 223, 140).withOpacity(0.8),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                margin: const EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10),
                padding: const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 5),
                width: double.infinity,
                child: TabBar(
                  tabAlignment: TabAlignment.start,
                  isScrollable: true,
                  mouseCursor: MaterialStateMouseCursor.clickable,
                  padding: const EdgeInsets.all(0),
                  indicatorColor: Colors.black,
                  indicatorSize: TabBarIndicatorSize.label,
                  dividerColor: const Color.fromARGB(0, 182, 52, 52),
                  controller: _tabController,
                  labelColor: Colors.black,
                  unselectedLabelColor: const Color.fromARGB(255, 31, 31, 31).withOpacity(0.8),
                  labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                    tabs: const [
                      Tab(text: 'Note future'),
                      Tab(text: 'Note passate',),
                      Tab(text: 'Spese',),
                      Tab(text: 'Raccolti',),
                    ],
                ),
              ),
              // TabBarView
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Future activities
                    futureActivities.isEmpty
                        ? const Center(child: Text('Nessuna nota futura ancora registrata'))
                        :
                        GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.5,
                          ),
                          itemCount: futureActivities.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              //show delete dialog
                              onLongPress: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Annulla'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            //delete activity
                                            deleteActivityFuture(index);
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Elimina'),
                                        ),
                                      ],
                                      title: const Text('Elimina attività'),
                                      content: const Text('Sei sicuro di voler eliminare questa attività?'),
                                      backgroundColor: Colors.white,
                                    );
                                    

                                  },
                                );
                              },

                              child: NoteCard(
                                name: futureActivities[index].name,
                                description: futureActivities[index].description!,
                                date: futureActivities[index].date,
                                time: futureActivities[index].time,
                                workers: futureActivities[index].workers,
                              ),
                            );
                          },
                        ),
                    // Past activities
                    pastActivities.isEmpty
                        ? const Center(child: Text('Nessuna nota passata ancora registrata'))
                        :
                        GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1.5,
                            ),
                            itemCount: pastActivities.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                //show delete dialog
                                onLongPress: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Annulla', style: TextStyle(color: Colors.black),),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              //delete activity
                                              deleteActivityPast(index);
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Elimina', style: TextStyle(color: Colors.red),),
                                          ),
                                        ],
                                        title: const Text('Elimina attività'),
                                        content: const Text('Sei sicuro di voler eliminare questa attività?'),
                                        backgroundColor: Colors.white,
                                      );
                                    },      
                                  );
                                },
                                child: NoteCard(
                                  name: pastActivities[index].name,
                                  description: pastActivities[index].description!,
                                  date: pastActivities[index].date,
                                  time: pastActivities[index].time,
                                  workers: pastActivities[index].workers,
                                ),
                              );
                            },
                          ),
                    // Spese
                    Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Spese totali',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              //total amount
                              Text(
                                '€ $totalSpese',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          
                          ),
                        ),
                        FutureBuilder<List<Spesa>>(
                          future: _spese,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              return const Center(child: Text('Errore'));
                            } else if (snapshot.data!.isEmpty) {
                              return const Center(child: Text('Nessuna spesa ancora registrata'));
                            }
                            return SizedBox(
                              height: snapshot.data!.isNotEmpty
                                  ? MediaQuery.of(context).size.height * 0.6
                                  : 50,
                              child: GridView.builder(
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 1.5,
                                ),
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return SpesaDialog(
                                            name: snapshot.data![index].name,
                                            store: snapshot.data![index].store,
                                            price: snapshot.data![index].price,
                                            date: snapshot.data![index].date,
                                            description: snapshot.data![index].description,
                                          );
                                        }
                                      );
                                    },
                                    onLongPress: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Annulla'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  //delete spesa
                                                  deleteSpesa(index);
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Elimina'),
                                              ),
                                            ],
                                            title: const Text('Elimina spesa'),
                                            content: const Text('Sei sicuro di voler eliminare questa spesa?'),
                                            backgroundColor: Colors.white,
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.all(8),
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: 40,
                                                height: 40,
                                                margin: const EdgeInsets.only(right: 10),
                                                decoration: BoxDecoration(
                                                  color: Colors.black.withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: const Icon(Icons.shopping_cart),
                                              ),
                                              Text(
                                                snapshot.data![index].name.length > 10
                                                    ? '${snapshot.data![index].name.substring(0, 10)}...'
                                                    : snapshot.data![index].name,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            snapshot.data![index].description.length > 5
                                                ? '${snapshot.data![index].description.substring(0, 5)}...'
                                                : snapshot.data![index].description,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    //raccolti
                    Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Raccolti totali',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              //total amount
                              Text(
                                '€ $totalIncassoRaccolta',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Quantità totale raccolta',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              //total amount
                              Text(
                                '$tatolQuantitaRaccolta kg',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          
                          ),
                        ),
                        FutureBuilder<List<Raccolto>>(
                          future: _raccolti,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              return const Center(child: Text('Errore'));
                            } else if (snapshot.data!.isEmpty) {
                              return const Center(child: Text('Nessun raccolto ancora registrato'));
                            }
                            return SizedBox(
                              height: snapshot.data!.isNotEmpty
                                  ? MediaQuery.of(context).size.height * 0.55
                                  : 50,
                              child: GridView.builder(
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 1.5,
                                ),
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          //TODO
                                          return RaccoltoDialog(
                                            name: snapshot.data![index].nome,
                                            price: snapshot.data![index].prezzo,
                                            date: snapshot.data![index].data,
                                            description: snapshot.data![index].description!,
                                            quantity: snapshot.data![index].quantita,
                                          );
                                        }
                                      );
                                    },
                                    onLongPress: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Annulla'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  //delete spesa
                                                  deleteRaccolto(index);
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Elimina'),
                                              ),
                                            ],
                                            title: const Text('Elimina raccolto'),
                                            content: const Text('Sei sicuro di voler eliminare questo raccolto?'),
                                            backgroundColor: Colors.white,
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.all(8),
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: 40,
                                                height: 40,
                                                margin: const EdgeInsets.only(right: 10),
                                                decoration: BoxDecoration(
                                                  color: Colors.black.withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: const Icon(Icons.monetization_on),
                                              ),
                                              Text(
                                                snapshot.data![index].nome.length > 10
                                                    ? '${snapshot.data![index].nome.substring(0, 10)}...'
                                                    : snapshot.data![index].nome,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            snapshot.data![index].description!.length > 5
                                                ? '${snapshot.data![index].description!.substring(0, 5)}...'
                                                : snapshot.data![index].description!,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

