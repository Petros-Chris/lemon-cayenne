var username = "";
int highestScore = 0;

var renderViewVal = "full";

List<String> renderView = ['full', 'bust', 'face'];
String url = "";

var renderTypeVal = "default";
final List<String> rendertype = [
  'default',
  'marching',
  'walking',
  'crouching',
  'crossed',
  'criss_cross',
  'ultimate',
  'isometric',
  'custom',
  'cheering',
  'relaxing',
  'trudging',
  'cowering',
  'pointing',
  'lunging',
  'dungeons',
  'facepalm',
  'sleeping',
  'dead',
  'archer',
  'kicking',
  'reading',
  'bitzel',
  'pixel',
  'mojavatar',
  'head'
]; //head, mojavatar

// List<Map<String, double>> cameraPosition = [
//   {"name": "default", "x": 11.92, "y": 15.81, "z": -29.71},
//   {"name": "marching", "x": 21.96, "y": 11.12, "z": -28.25},
//   {"name": "walking", "x": 23.86, "y": 22.67, "z": -26.65},
//   {"name": "crouching", "x": 16.29, "y": 21.82, "z": -34.03},
//   {"name": "crossed", "x": 17.65, "y": 21.37, "z": -24.47},
//   {"name": "criss_cross", "x": 11.92, "y": 15.81, "z": -29.71},
//   {"name": "ultimate", "x": 15, "y": 22, "z": -35},
//   {"name": "isometric", "x": -64, "y": 60.26, "z": -64},
//   {"name": "head", "x": 9.97, "y": 19.64, "z": -20.98},
//   {"name": "cheering", "x": 14.88, "y": 28.91, "z": -30.19},
//   {"name": "relaxing", "x": -16.04, "y": 16.57, "z": -27.5},
//   {"name": "trudging", "x": 16.04, "y": 16.57, "z": -27.5},
//   {"name": "cowering", "x": -14.62, "y": 15.93, "z": -23.63},
//   {"name": "pointing", "x": -3.41, "y": 18.3, "z": -30.8},
//   {"name": "lunging", "x": -0.41, "y": 24.7, "z": -34.73},
//   {"name": "dungeons", "x": 15.26, "y": 19.62, "z": -27.58},
//   {"name": "facepalm", "x": 3.11, "y": 17.56, "z": -31.13},
//   {"name": "mojavatar", "x": 23.05, "y": 26.98, "z": -34.47},
// ];

class CameraPosition {
  String name;
  double x;
  double y;
  double z;

  CameraPosition(
      {required this.name, required this.x, required this.y, required this.z});
}

List<CameraPosition> cameraPositions = [
  CameraPosition(name: "default", x: 11.92, y: 15.81, z: -29.71),
  CameraPosition(name: "marching", x: 21.96, y: 11.12, z: -28.25),
  CameraPosition(name: "walking", x: 23.86, y: 22.67, z: -26.65),
];
