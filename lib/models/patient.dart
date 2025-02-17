class Patient {
  final String name;
  final int age;
  final String room;
  final String bloodPressure;
  final double temperature;
  final String status;
  final List<VitalData> historicalData;

  Patient({
    required this.name,
    required this.age,
    required this.room,
    required this.bloodPressure,
    required this.temperature,
    required this.status,
    required this.historicalData,
  });
}

class VitalData {
  final DateTime timestamp;
  final int o2Level;
  final int heartRate;

  VitalData({
    required this.timestamp,
    required this.o2Level,
    required this.heartRate,
  });
} 