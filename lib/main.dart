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

class Patient {
  final String name;
  final String age;
  final String o2Level;
  final String heartRate;
  final String status;
  final String room;
  final DateTime arrivalTime;
  bool isInTreatment;

  Patient({
    required this.name,
    required this.age,
    required this.o2Level,
    required this.heartRate,
    required this.status,
    required this.room,
    required this.arrivalTime,
    this.isInTreatment = false,
  });
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final List<Patient> _waitingPatients = [
    Patient(
      name: 'Roberto Santos',
      age: '68',
      o2Level: '85%',
      heartRate: '120',
      status: 'Emergência',
      room: 'Sala de Espera 1',
      arrivalTime: DateTime.now().subtract(Duration(minutes: 5)),
    ),
    Patient(
      name: 'Maria Silva',
      age: '45',
      o2Level: '98%',
      heartRate: '85',
      status: 'Pouco Urgente',
      room: 'Sala de Espera 2',
      arrivalTime: DateTime.now().subtract(Duration(minutes: 15)),
    ),
    Patient(
      name: 'João Oliveira',
      age: '72',
      o2Level: '92%',
      heartRate: '95',
      status: 'Muito Urgente',
      room: 'Sala de Espera 1',
      arrivalTime: DateTime.now().subtract(Duration(minutes: 8)),
    ),
    Patient(
      name: 'Ana Paula',
      age: '35',
      o2Level: '99%',
      heartRate: '78',
      status: 'Não Urgente',
      room: 'Sala de Espera 3',
      arrivalTime: DateTime.now().subtract(Duration(minutes: 25)),
    ),
  ];

  final List<Patient> _inTreatmentPatients = [];

  void _startTreatment(Patient patient) {
    setState(() {
      patient.isInTreatment = true;
      _waitingPatients.remove(patient);
      _inTreatmentPatients.add(patient);
    });
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'emergência':
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

  String _getTimeTarget(String status) {
    switch (status.toLowerCase()) {
      case 'emergência':
        return '0 min';
      case 'muito urgente':
        return '10 min';
      case 'urgente':
        return '60 min';
      case 'pouco urgente':
        return '120 min';
      case 'não urgente':
        return '240 min';
      default:
        return '120 min';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 250,
            color: Color(0xFF424242),
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
                  SizedBox(height: 20),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Lista de Triagem
                        Expanded(
                          flex: 2,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Fila de Triagem',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 16),
                                ..._buildPriorityLevels(),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        // Lista de Pacientes em Atendimento
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Em Atendimento',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Expanded(
                                  child: _inTreatmentPatients.isEmpty
                                      ? Center(
                                          child: Text(
                                            'Nenhum paciente em atendimento',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 14,
                                            ),
                                          ),
                                        )
                                      : ListView.builder(
                                          itemCount: _inTreatmentPatients.length,
                                          itemBuilder: (context, index) {
                                            final patient = _inTreatmentPatients[index];
                                            return _TreatmentCard(patient: patient);
                                          },
                                        ),
                                ),
                              ],
                            ),
                          ),
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

  List<Widget> _buildPriorityLevels() {
    final Map<String, List<Patient>> patientsByPriority = {
      'Emergência': [],
      'Muito Urgente': [],
      'Urgente': [],
      'Pouco Urgente': [],
      'Não Urgente': [],
    };

    for (var patient in _waitingPatients) {
      patientsByPriority[patient.status]?.add(patient);
    }

    return patientsByPriority.entries.map((entry) {
      return _PriorityLevel(
        label: entry.key,
        color: _getStatusColor(entry.key),
        timeTarget: _getTimeTarget(entry.key),
        patients: entry.value.map((patient) {
          return _PatientCard(
            name: patient.name,
            age: patient.age,
            o2Level: patient.o2Level,
            heartRate: patient.heartRate,
            status: patient.status,
            room: patient.room,
            onTap: () => _showPatientDetails(context, patient.name),
            onStartTreatment: () => _startTreatment(patient),
          );
        }).toList(),
      );
    }).toList();
  }

  void _showPatientDetails(BuildContext context, String patientName) {
    final patient = _waitingPatients.firstWhere((p) => p.name == patientName);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detalhes do Paciente'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nome: ${patient.name}'),
            Text('Idade: ${patient.age} anos'),
            Text('Saturação O₂: ${patient.o2Level}'),
            Text('Freq. Cardíaca: ${patient.heartRate} bpm'),
            Text('Status: ${patient.status}'),
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
                  builder: (context) => PatientDetailsPage(patientName: patient.name),
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

class _PatientCard extends StatefulWidget {
  final String name;
  final String age;
  final String o2Level;
  final String heartRate;
  final String status;
  final String room;
  final VoidCallback onTap;
  final VoidCallback onStartTreatment;

  const _PatientCard({
    required this.name,
    required this.age,
    required this.o2Level,
    required this.heartRate,
    required this.status,
    required this.room,
    required this.onTap,
    required this.onStartTreatment,
  });

  @override
  State<_PatientCard> createState() => _PatientCardState();
}

class _PatientCardState extends State<_PatientCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;
  bool isUrgent = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    isUrgent = widget.status.toLowerCase() == 'emergência' || 
               widget.status.toLowerCase() == 'muito urgente';

    if (isUrgent) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(widget.status);
    
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: isUrgent ? [
              BoxShadow(
                color: statusColor.withOpacity(0.3 * _glowAnimation.value),
                blurRadius: 12 * _glowAnimation.value,
                spreadRadius: 2 * _glowAnimation.value,
              ),
            ] : [],
          ),
          child: Container(
            decoration: BoxDecoration(
              border: isUrgent ? Border.all(
                color: statusColor.withOpacity(0.8 * _glowAnimation.value),
                width: 2.5,
              ) : null,
              borderRadius: BorderRadius.circular(12),
            ),
            child: child,
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Idade: ${widget.age} anos',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
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
                          AnimatedBuilder(
                            animation: _glowAnimation,
                            builder: (context, child) {
                              return Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: statusColor,
                                  shape: BoxShape.circle,
                                  boxShadow: isUrgent ? [
                                    BoxShadow(
                                      color: statusColor.withOpacity(0.6 * _glowAnimation.value),
                                      blurRadius: 4,
                                      spreadRadius: 1,
                                    ),
                                  ] : [],
                                ),
                              );
                            },
                          ),
                          SizedBox(width: 6),
                          Text(
                            widget.status,
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
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFFF8FAFB),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _VitalSignIndicator(
                              icon: Icons.favorite,
                              title: 'Freq. Cardíaca',
                              value: '${widget.heartRate} bpm',
                              color: Color(0xFFE57373),
                              isAlert: int.parse(widget.heartRate) > 100,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: _VitalSignIndicator(
                              icon: Icons.air,
                              title: 'Nível O₂',
                              value: widget.o2Level,
                              color: Color(0xFF64B5F6),
                              isAlert: int.parse(widget.o2Level.replaceAll('%', '')) < 90,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: widget.onStartTreatment,
                        icon: Icon(Icons.medical_services),
                        label: Text('Atender'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: statusColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    IconButton(
                      onPressed: widget.onTap,
                      icon: Icon(Icons.more_vert),
                      tooltip: 'Mais detalhes',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'emergência':
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
}

class _VitalSignIndicator extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;
  final bool isAlert;

  const _VitalSignIndicator({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
    this.isAlert = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isAlert ? color.withOpacity(0.2) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: isAlert ? Border.all(color: color) : null,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isAlert ? color : Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
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

class _PriorityLevel extends StatelessWidget {
  final String label;
  final Color color;
  final String timeTarget;
  final List<Widget> patients;

  const _PriorityLevel({
    required this.label,
    required this.color,
    required this.timeTarget,
    required this.patients,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            border: Border(
              left: BorderSide(color: color, width: 4),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.arrow_right, color: color),
              SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              SizedBox(width: 16),
              Text(
                'Tempo alvo: $timeTarget',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        if (patients.isEmpty)
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Nenhum paciente neste nível',
              style: TextStyle(
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          )
        else
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: patients,
          ),
      ],
    );
  }
}

class _PriorityScale extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Escala de Prioridade',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 8),
          Container(
            height: 24,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  ManchesterTriage.naoUrgente,      // Azul (Não Urgente)
                  ManchesterTriage.poucoUrgente,    // Verde (Pouco Urgente)
                  ManchesterTriage.urgente,         // Amarelo (Urgente)
                  ManchesterTriage.muitoUrgente,    // Laranja (Muito Urgente)
                  ManchesterTriage.emergente,       // Vermelho (Emergente)
                ],
              ),
            ),
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Menor',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              Text(
                'Maior',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PriorityLegendItem(
                color: ManchesterTriage.emergente,
                label: 'Emergência',
                time: '0 min',
              ),
              _PriorityLegendItem(
                color: ManchesterTriage.muitoUrgente,
                label: 'Muito Urgente',
                time: '10 min',
              ),
              _PriorityLegendItem(
                color: ManchesterTriage.urgente,
                label: 'Urgente',
                time: '60 min',
              ),
              _PriorityLegendItem(
                color: ManchesterTriage.poucoUrgente,
                label: 'Pouco Urgente',
                time: '120 min',
              ),
              _PriorityLegendItem(
                color: ManchesterTriage.naoUrgente,
                label: 'Não Urgente',
                time: '240 min',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PriorityLegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final String time;

  const _PriorityLegendItem({
    required this.color,
    required this.label,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8),
          Text(
            '$label ($time)',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}

class _TreatmentCard extends StatelessWidget {
  final Patient patient;

  const _TreatmentCard({required this.patient});

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'emergência':
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

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: _getStatusColor(patient.status).withOpacity(0.2),
                  child: Icon(
                    Icons.medical_services,
                    color: _getStatusColor(patient.status),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        patient.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Sala: ${patient.room}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      Text(
                        'Início: ${_formatDateTime(patient.arrivalTime)}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _VitalSignIndicator(
                      icon: Icons.favorite,
                      title: 'Freq. Cardíaca',
                      value: '${patient.heartRate} bpm',
                      color: Color(0xFFE57373),
                      isAlert: int.parse(patient.heartRate) > 100,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: _VitalSignIndicator(
                      icon: Icons.air,
                      title: 'Nível O₂',
                      value: patient.o2Level,
                      color: Color(0xFF64B5F6),
                      isAlert: int.parse(patient.o2Level.replaceAll('%', '')) < 90,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PatientDetailsPage(patientName: patient.name),
                      ),
                    );
                  },
                  icon: Icon(Icons.visibility),
                  label: Text('Ver detalhes'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
