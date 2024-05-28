
import 'package:flutter/material.dart';
import 'package:weather/weather.dart';

class MeteoWidget extends StatefulWidget {
  const MeteoWidget({super.key});

  @override
  State<MeteoWidget> createState() => _MeteoWidgetState();
}

class _MeteoWidgetState extends State<MeteoWidget> {

  //weather
  WeatherFactory wf = WeatherFactory('2661e12887ecec562eb70d600607c52c', language: Language.ITALIAN);
  Weather? weather;
  
  double lat = 37.926568493424256;
  double lon = 13.141088154950348;

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    weather = await wf.currentWeatherByLocation(lat, lon);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
              width: double.infinity,
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //nome località
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: Colors.black,
                        ),
                        const SizedBox(width: 5),
                        //mostra il meteo
                        Text(
                          '${weather?.areaName.toString()}',
                          style: const TextStyle(
                            fontSize: 18,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    //temperatura e massima e minima e icona meteo
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        //mostra la temperatura
                        Row(
                          children: [
                            Text(
                              '${weather?.temperature?.celsius?.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Text(
                              '°C',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        //mostra la massima e la minima
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //higher and lower temperature
                            Row(
                              children: [
                                const Icon(
                                  Icons.arrow_drop_up,
                                  color: Color.fromARGB(255, 255, 71, 71),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'Max: ${weather?.tempMax!.celsius?.toStringAsFixed(2)} °C',
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Icon(
                                  //icon arrow filled down
                                  Icons.arrow_drop_down,
                                  color: Color.fromARGB(255, 82, 149, 236),
                                  
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'Min: ${weather?.tempMin!.celsius?.toStringAsFixed(2)} °C',
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            //description
                            const SizedBox(height: 5),
                            Text(
                              '${weather?.weatherDescription}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        //icona meteo
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: weather?.weatherIcon != null
                                ? Image.network('http://openweathermap.org/img/w/${weather?.weatherIcon}.png')
                                : const Icon(Icons.error),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    //humidity, wind and pressure and cloudiness
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Umidità',
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '${weather?.humidity}%',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Vento',
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '${weather?.windSpeed} km/h',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                        //probabilità pioggia
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Nuvolosità',
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '${weather?.cloudiness} %',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
            
  }
}