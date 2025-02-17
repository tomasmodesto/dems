import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'models/patient.dart';

class PatientDetailsPage extends StatelessWidget {
  final Patient patient;

  const PatientDetailsPage({required this.patient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(patient.name),
        actions: [
          if (patient.status == 'Crítico')
            IconButton(
              icon: Icon(Icons.warning, color: Colors.red),
              onPressed: () {
                // Implementar alerta
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoSection(),
            SizedBox(height: 20),
            _buildVitalsChart(),
            SizedBox(height: 20),
            _buildHistorySection(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informações do Paciente',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _buildInfoRow('Idade', '${patient.age} anos'),
            _buildInfoRow('Localização', patient.room),
            _buildInfoRow('Pressão Arterial', patient.bloodPressure),
            _buildInfoRow('Temperatura', '${patient.temperature}°C'),
          ],
        ),
      ),
    );
  }

  Widget _buildVitalsChart() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Monitoramento das últimas 24 horas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Container(
              height: 200,
              child: LineChart(
                LineChartData(
                  // Implementar gráfico com fl_chart
                  // Dados do patient.historicalData
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistorySection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Histórico de Registros',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: patient.historicalData.length,
              itemBuilder: (context, index) {
                final data = patient.historicalData[index];
                return ListTile(
                  title: Text('${_formatDateTime(data.timestamp)}'),
                  subtitle: Text(
                    'O₂: ${data.o2Level}% | FC: ${data.heartRate} bpm',
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
} 