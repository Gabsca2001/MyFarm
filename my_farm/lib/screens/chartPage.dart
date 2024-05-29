import 'package:flutter/material.dart';
import 'package:my_farm/models/salesData.dart';
import 'package:my_farm/models/spesaModel.dart';
import 'package:my_farm/models/raccoltoModel.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {

  late Future<List<SalesData>> _futureChartSpese;
  late Future<List<SalesData>> _futureChartRaccolto;
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    super.initState();
    _futureChartSpese = _loadSpese();
    _futureChartRaccolto = _loadRaccolto();
    _tooltipBehavior = TooltipBehavior(enable: true);
  }

  @override
  void didUpdateWidget(covariant ChartPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _futureChartSpese = _loadSpese();
    _futureChartRaccolto = _loadRaccolto();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<SalesData>> _loadSpese() async {
    List<Spesa> spese = await getSpese();
    if (spese.isEmpty) {
      print('No data');
    } else {
      spese.sort((a, b) => a.date.compareTo(b.date));
    }
    double runningTotal = 0;
    return spese.map((spesa) {
      runningTotal += spesa.price;
      return SalesData(date: spesa.date, amount: runningTotal);
    }).toList();
  }

  Future<List<SalesData>> _loadRaccolto() async {
    List<Raccolto> raccolti = await getRaccolti();
    if (raccolti.isEmpty) {
    } else {
      raccolti.sort((a, b) => a.data.compareTo(b.data));
    }
    double runningTotal = 0;
    return raccolti.map((raccolto) {
      runningTotal += raccolto.prezzo;
      return SalesData(date: raccolto.data, amount: runningTotal);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: FutureBuilder<List<List<SalesData>>>(
        future: Future.wait([_futureChartSpese, _futureChartRaccolto]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Errore: ${snapshot.error}'),
            );
          } else if(!snapshot.hasData || snapshot.data!.isEmpty){
            return const Center(
              child: Text('Nessun dato disponibile'),
            );
          }
          else {
            // Create a chart with two lines
            List<SalesData> spese = snapshot.data![0];
            List<SalesData> raccolto = snapshot.data![1];

            return SfCartesianChart(
              tooltipBehavior: _tooltipBehavior,
              primaryXAxis: const DateTimeAxis(),
              primaryYAxis: const NumericAxis(),
              backgroundColor: Colors.white,
              legend: const Legend(isVisible: true),
              series: <LineSeries>[
                LineSeries<SalesData, DateTime>(
                  dataSource: spese,
                  xValueMapper: (SalesData sales, _) => sales.date,
                  yValueMapper: (SalesData sales, _) => sales.amount,
                  name: 'Spese (€)',
                  color: Colors.red,
                ),
                LineSeries<SalesData, DateTime>(
                  dataSource: raccolto,
                  xValueMapper: (SalesData sales, _) => sales.date,
                  yValueMapper: (SalesData sales, _) => sales.amount,
                  name: 'Raccolto (€)',
                  color: Colors.green,
                ),
              ],
              zoomPanBehavior: ZoomPanBehavior(
                enablePinching: true,
                enablePanning: true,
                enableDoubleTapZooming: true,
                enableMouseWheelZooming: true,
              ),
              trackballBehavior: TrackballBehavior(
                enable: true,
                activationMode: ActivationMode.singleTap,
                tooltipSettings: const InteractiveTooltip(
                  enable: true,
                ),
              ),
            );
          }
        },
      ),

    );
  }
}