import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DEMS',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: Color(0xFF2E7D32), // Verde escuro
          secondary: Color(0xFF81C784), // Verde claro
          background: Color(0xFFF5F5F5), // Cinza claro para fundo
        ),
        useMaterial3: true,
      ),
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 250,
            color: Color(0xFF424242), // Cinza escuro
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'DEMS', 
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _SidebarItem(
                  icon: Icons.dashboard,
                  title: 'Dashboard',
                  isSelected: true,
                ),
                _SidebarItem(
                  icon: Icons.people,
                  title: 'Pacientes',
                ),
                _SidebarItem(
                  icon: Icons.calendar_today,
                  title: 'Consultas',
                ),
                _SidebarItem(
                  icon: Icons.settings,
                  title: 'Configurações',
                ),
              ],
            ),
          ),
          // Conteúdo principal
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.background,
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Dashboard',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      _TriageLegend(),
                    ],
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 3,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      children: [
                        _PatientCard(
                          name: 'Roberto Santos',
                          age: '68',
                          o2Level: '85%',
                          heartRate: '120',
                          status: 'Emergência',
                          onTap: () => _showPatientDetails(context, 'Roberto Santos'),
                        ),
                        _PatientCard(
                          name: 'Maria Oliveira',
                          age: '72',
                          o2Level: '91%',
                          heartRate: '105',
                          status: 'Muito Urgente',
                          onTap: () => _showPatientDetails(context, 'Maria Oliveira'),
                        ),
                        _PatientCard(
                          name: 'Carlos Silva',
                          age: '55',
                          o2Level: '94%',
                          heartRate: '88',
                          status: 'Urgente',
                          onTap: () => _showPatientDetails(context, 'Carlos Silva'),
                        ),
                        _PatientCard(
                          name: 'Ana Lima',
                          age: '42',
                          o2Level: '97%',
                          heartRate: '75',
                          status: 'Pouco Urgente',
                          onTap: () => _showPatientDetails(context, 'Ana Lima'),
                        ),
                        _PatientCard(
                          name: 'Pedro Souza',
                          age: '28',
                          o2Level: '99%',
                          heartRate: '70',
                          status: 'Não Urgente',
                          onTap: () => _showPatientDetails(context, 'Pedro Souza'),
                        ),
                        _PatientCard(
                          name: 'Lucia Costa',
                          age: '81',
                          o2Level: '89%',
                          heartRate: '95',
                          status: 'Muito Urgente',
                          onTap: () => _showPatientDetails(context, 'Lucia Costa'),
                        ),
                        _PatientCard(
                          name: 'Fernando Melo',
                          age: '59',
                          o2Level: '92%',
                          heartRate: '85',
                          status: 'Urgente',
                          onTap: () => _showPatientDetails(context, 'Fernando Melo'),
                        ),
                        _PatientCard(
                          name: 'Julia Santos',
                          age: '35',
                          o2Level: '98%',
                          heartRate: '72',
                          status: 'Pouco Urgente',
                          onTap: () => _showPatientDetails(context, 'Julia Santos'),
                        ),
                        _PatientCard(
                          name: 'Marcelo Reis',
                          age: '75',
                          o2Level: '87%',
                          heartRate: '110',
                          status: 'Emergência',
                          onTap: () => _showPatientDetails(context, 'Marcelo Reis'),
                        ),
                      ],
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

  void _showPatientDetails(BuildContext context, String patientName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detalhes do Paciente'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nome: $patientName'),
            SizedBox(height: 8),
            Text('Histórico de consultas:'),
            Text('• 12/03/2024 - Consulta de rotina'),
            Text('• 25/02/2024 - Exames laboratoriais'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Fechar'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PatientDetailsPage(patientName: patientName),
                ),
              );
            },
            child: Text('Ver mais detalhes'),
          ),
        ],
      ),
    );
  }
}

class PatientDetailsPage extends StatelessWidget {
  final String patientName;

  const PatientDetailsPage({
    super.key,
    required this.patientName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prontuário - $patientName'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PatientInfoHeader(patientName: patientName),
            SizedBox(height: 32),
            _VitalSignsCharts(),
            SizedBox(height: 32),
            _RecentActivities(),
          ],
        ),
      ),
    );
  }
}

class _PatientInfoHeader extends StatelessWidget {
  final String patientName;

  const _PatientInfoHeader({required this.patientName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Text(
                  patientName.substring(0, 1),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patientName,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'ID: 123456 • Última consulta: 12/03/2024',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          Row(
            children: [
              _InfoCard(
                title: 'Idade',
                value: '45 anos',
                icon: Icons.calendar_today,
              ),
              SizedBox(width: 16),
              _InfoCard(
                title: 'Tipo Sanguíneo',
                value: 'O+',
                icon: Icons.bloodtype,
              ),
              SizedBox(width: 16),
              _InfoCard(
                title: 'Alergias',
                value: 'Penicilina',
                icon: Icons.warning,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _InfoCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFFF8FAFB),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _VitalSignsCharts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sinais Vitais',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: _VitalSignChart(
                title: 'Frequência Cardíaca',
                subtitle: 'Últimas 24 horas',
                data: [72, 74, 73, 75, 71, 72, 73],
                normalRangeMin: 60,
                normalRangeMax: 100,
                unit: 'bpm',
                color: Color(0xFFE57373),
                icon: Icons.favorite,
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _VitalSignChart(
                title: 'Saturação O₂',
                subtitle: 'Últimas 24 horas',
                data: [98, 97, 98, 96, 97, 98, 97],
                normalRangeMin: 95,
                normalRangeMax: 100,
                unit: '%',
                color: Color(0xFF64B5F6),
                icon: Icons.air,
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _VitalSignChart(
                title: 'Temperatura Corporal',
                subtitle: 'Últimas 24 horas',
                data: [36.5, 36.8, 37.1, 36.9, 36.7, 36.6, 36.8],
                normalRangeMin: 36.0,
                normalRangeMax: 37.5,
                unit: '°C',
                color: Color(0xFFFFB74D),
                icon: Icons.thermostat,
                showDecimals: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _VitalSignChart extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<double> data;
  final double normalRangeMin;
  final double normalRangeMax;
  final String unit;
  final Color color;
  final IconData icon;
  final bool showDecimals;

  const _VitalSignChart({
    required this.title,
    required this.subtitle,
    required this.data,
    required this.normalRangeMin,
    required this.normalRangeMax,
    required this.unit,
    required this.color,
    required this.icon,
    this.showDecimals = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              _LegendItem(
                color: color,
                label: 'Atual: ${showDecimals ? data.last.toStringAsFixed(1) : data.last.toInt()} $unit',
              ),
              SizedBox(width: 16),
              _LegendItem(
                color: Colors.grey.shade300,
                label: 'Faixa normal: ${showDecimals ? normalRangeMin.toStringAsFixed(1) : normalRangeMin.toInt()} - ${showDecimals ? normalRangeMax.toStringAsFixed(1) : normalRangeMax.toInt()} $unit',
              ),
            ],
          ),
          SizedBox(height: 24),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: showDecimals ? 0.5 : 10,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.1),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: showDecimals ? 0.5 : 10,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          showDecimals ? value.toStringAsFixed(1) : value.toInt().toString(),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 4,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}h',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(data.length, (i) {
                      return FlSpot(i * 4.0, data[i]);
                    }),
                    isCurved: true,
                    color: color,
                    barWidth: 3,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Colors.white,
                          strokeWidth: 2,
                          strokeColor: color,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: color.withOpacity(0.1),
                    ),
                  ),
                ],
                minY: normalRangeMin - (showDecimals ? 0.5 : 10),
                maxY: normalRangeMax + (showDecimals ? 0.5 : 10),
                minX: 0,
                maxX: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentActivities extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Atividades Recentes',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 5,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  child: Icon(
                    index % 2 == 0 ? Icons.medical_services : Icons.science,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                title: Text(
                  index % 2 == 0 ? 'Consulta de Rotina' : 'Exame de Sangue',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${12 - index * 2}/03/2024',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                trailing: Icon(Icons.chevron_right),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;

  const _SidebarItem({
    required this.icon,
    required this.title,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? Color(0xFF2E7D32).withOpacity(0.2) : null,
        border: Border(
          left: BorderSide(
            color: isSelected ? Color(0xFF2E7D32) : Colors.transparent,
            width: 4,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _PatientCard extends StatelessWidget {
  final String name;
  final String age;
  final String o2Level;
  final String heartRate;
  final String status;
  final VoidCallback onTap;

  const _PatientCard({
    required this.name,
    required this.age,
    required this.o2Level,
    required this.heartRate,
    required this.status,
    required this.onTap,
  });

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'emergente':
        return ManchesterTriage.emergente;
      case 'muito urgente':
        return ManchesterTriage.muitoUrgente;
      case 'urgente':
        return ManchesterTriage.urgente;
      case 'pouco urgente':
        return ManchesterTriage.poucoUrgente;
      case 'não urgente':
        return ManchesterTriage.naoUrgente;
      default:
        return ManchesterTriage.poucoUrgente;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(status);
    
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Idade: $age anos',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 6),
                        Text(
                          status,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFFF8FAFB),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _VitalSign(
                      icon: Icons.favorite,
                      title: 'Freq. Cardíaca',
                      value: '$heartRate bpm',
                      color: Color(0xFFE57373),
                    ),
                    SizedBox(height: 12),
                    _VitalSign(
                      icon: Icons.air,
                      title: 'Nível O₂',
                      value: o2Level,
                      color: Color(0xFF64B5F6),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VitalSign extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _VitalSign({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TriageLegend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Classificação de Risco',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                _TriageItem(
                  color: ManchesterTriage.emergente,
                  label: 'Emergência',
                  time: '0 min',
                ),
                SizedBox(width: 16),
                _TriageItem(
                  color: ManchesterTriage.muitoUrgente,
                  label: 'Muito Urgente',
                  time: '10 min',
                ),
                SizedBox(width: 16),
                _TriageItem(
                  color: ManchesterTriage.urgente,
                  label: 'Urgente',
                  time: '60 min',
                ),
                SizedBox(width: 16),
                _TriageItem(
                  color: ManchesterTriage.poucoUrgente,
                  label: 'Pouco Urgente',
                  time: '120 min',
                ),
                SizedBox(width: 16),
                _TriageItem(
                  color: ManchesterTriage.naoUrgente,
                  label: 'Não Urgente',
                  time: '240 min',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TriageItem extends StatelessWidget {
  final Color color;
  final String label;
  final String time;

  const _TriageItem({
    required this.color,
    required this.label,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 12),
            ),
            Text(
              time,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ManchesterTriage {
  static const Color emergente = Color(0xFFE53935);      // Vermelho
  static const Color muitoUrgente = Color(0xFFFF9800);   // Laranja
  static const Color urgente = Color(0xFFFFEB3B);        // Amarelo
  static const Color poucoUrgente = Color(0xFF4CAF50);   // Verde
  static const Color naoUrgente = Color(0xFF2196F3);     // Azul
}
