class Crop{
  final String name;
  //center of the polygon
  final List<double> center;
  //polygon coordinates using the format [[lat, long], [lat, long], [lat, long], [lat, long]]
  final List<List<double>> coordinates;

  //current cultivation
  final String cultivation;

  Crop({required this.name, required this.center, required this.coordinates, required this.cultivation,});

  factory Crop.fromJson(Map<String, dynamic> json){
    return Crop(
      name: json['name'],
      center: json['center'],
      coordinates: json['coordinates'],
      cultivation: json['cultivation'],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'name': name,
      'coordinates': coordinates,
      'center': center,
      'cultivation': cultivation,
    };
  }
}

//create a list of crops
List<Crop> crops = [
  Crop(
    name: 'Casa',
    center: [37.949229, 13.179165],
    coordinates: [
      [
        13.179165,
        37.949229
      ],
      [
        13.180241,
        37.948375
      ],
      [
        13.180275,
        37.948494
      ],
      [
        13.18028,
        37.948577
      ],
      [
        13.180282,
        37.948641
      ],
      [
        13.180328,
        37.948676
      ],
      [
        13.17951,
        37.94994
      ],
      [
        13.179165,
        37.949229
      ]
    ],
    cultivation: 'Apricot field',
  ),
  Crop(
    name: 'Olive field',
    center: [37.943054, 13.161722],
    coordinates: [
      [
        13.161722,
        37.943054
      ],
      [
        13.161978,
        37.942854
      ],
      [
        13.162088,
        37.942928
      ],
      [
        13.162097,
        37.943009
      ],
      [
        13.162147,
        37.943028
      ],
      [
        13.162204,
        37.942988
      ],
      [
        13.162223,
        37.943043
      ],
      [
        13.162267,
        37.943033
      ],
      [
        13.162298,
        37.942951
      ],
      [
        13.162353,
        37.942991
      ],
      [
        13.16245,
        37.942987
      ],
      [
        13.16245,
        37.943036
      ],
      [
        13.162511,
        37.943077
      ],
      [
        13.162227,
        37.943413
      ],
      [
        13.162099,
        37.943344
      ],
      [
        13.162049,
        37.943459
      ],
      [
        13.161849,
        37.943532
      ],
      [
        13.161751,
        37.943555
      ],
      [
        13.161722,
        37.943054
      ]
    ],
    cultivation: 'Olive field',
  ),
  Crop(
    name: 'Balletto',
    center: [37.92675, 13.14100],
    coordinates: [
      [
        13.14074160459873,
        37.92571414257374
      ],
      [
        13.139952106616136,
        37.92681822617382
      ],
      [
        13.140062000108571,
        37.92688437941699
      ],
      [
        13.140140082326297,
        37.927037215992655
      ],
      [
        13.140290462894143,
        37.927073714232264
      ],
      [
        13.140539169218385,
        37.92707143309259
      ],
      [
        13.140649062710764,
        37.92711021245373
      ],
      [
        13.140762767593799,
        37.92718915273457
      ],
      [
        13.14081224701036,
        37.92726987174106
      ],
      [
        13.140949439934587,
        37.92733285024478
      ],
      [
        13.141296920374856,
        37.92734083343163
      ],
      [
        13.14200637832576,
        37.92625243310799
      ],
      [
        13.141493619716726,
        37.926011606049926
      ],
      [
        13.141188313065271,
        37.9258726670043
      ],
      [
        13.14074160459873,
        37.92571414257374
      ]
    ],
    cultivation: 'Meloni Piel de Sapo',
  ),
];

