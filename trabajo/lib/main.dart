import 'package:flutter/material.dart';

void main() {
  runApp(const MiAplicacion());
}

// MODELO DE DATOS PARA REGISTROS
class Registro {
  final String id;
  final String nombre;
  final String email;
  final String genero;
  final DateTime fecha;

  Registro({
    required this.id,
    required this.nombre,
    required this.email,
    required this.genero,
    required this.fecha,
  });
}

// GESTIÓN GLOBAL DE REGISTROS
class GestorRegistros {
  static final GestorRegistros _instancia = GestorRegistros._internal();
  factory GestorRegistros() => _instancia;
  GestorRegistros._internal();

  final List<Registro> _registros = [];

  List<Registro> get registros => List.unmodifiable(_registros);

  void agregarRegistro(Registro registro) {
    _registros.insert(0, registro); // Agregar al inicio
  }

  void eliminarRegistro(String id) {
    _registros.removeWhere((r) => r.id == id);
  }

  int get totalRegistros => _registros.length;
}

class MiAplicacion extends StatelessWidget {
  const MiAplicacion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi App Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      home: const PaginaPrincipal(),
    );
  }
}

class PaginaPrincipal extends StatefulWidget {
  const PaginaPrincipal({Key? key}) : super(key: key);

  @override
  State<PaginaPrincipal> createState() => _PaginaPrincipalState();
}

class _PaginaPrincipalState extends State<PaginaPrincipal> {
  int _indiceSeleccionado = 0;

  final List<Widget> _paginas = [
    const PaginaInicio(),
    const PaginaFormulario(),
    const PaginaRegistros(),
    const PaginaLista(),
    const PaginaPerfil(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Aplicación Flutter'),
        centerTitle: true,
        elevation: 2,
      ),
      body: _paginas[_indiceSeleccionado],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceSeleccionado,
        onTap: (index) {
          setState(() {
            _indiceSeleccionado = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'Formulario',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'Registros',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Lista',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

// PÁGINA 1: INICIO
class PaginaInicio extends StatelessWidget {
  const PaginaInicio({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gestor = GestorRegistros();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 4,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Icon(Icons.phone_android, size: 80, color: Colors.blue),
                  const SizedBox(height: 16),
                  const Text(
                    '¡Bienvenido a Flutter!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Aplicación de ejemplo para Android',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.folder, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          'Registros guardados: ${gestor.totalRegistros}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Funcionalidades:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _tarjetaFuncionalidad(
            Icons.edit,
            'Formularios',
            'Crea y valida formularios que se guardan automáticamente',
            Colors.green,
          ),
          _tarjetaFuncionalidad(
            Icons.folder,
            'Ver Registros',
            'Consulta todos los formularios que has guardado',
            Colors.blue,
          ),
          _tarjetaFuncionalidad(
            Icons.list,
            'Listas Dinámicas',
            'Gestiona listas de elementos (tareas)',
            Colors.orange,
          ),
          _tarjetaFuncionalidad(
            Icons.person,
            'Perfiles',
            'Personaliza tu información',
            Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _tarjetaFuncionalidad(
      IconData icono, String titulo, String descripcion, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icono, color: Colors.white),
        ),
        title: Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(descripcion),
      ),
    );
  }
}

// PÁGINA 2: FORMULARIO
class PaginaFormulario extends StatefulWidget {
  const PaginaFormulario({Key? key}) : super(key: key);

  @override
  State<PaginaFormulario> createState() => _PaginaFormularioState();
}

class _PaginaFormularioState extends State<PaginaFormulario> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  String _genero = 'Masculino';
  bool _aceptaTerminos = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _enviarFormulario() {
    if (_formKey.currentState!.validate()) {
      if (!_aceptaTerminos) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Debes aceptar los términos y condiciones'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Crear y guardar el registro
      final registro = Registro(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        nombre: _nombreController.text,
        email: _emailController.text,
        genero: _genero,
        fecha: DateTime.now(),
      );

      GestorRegistros().agregarRegistro(registro);

      // Limpiar formulario
      _nombreController.clear();
      _emailController.clear();
      setState(() {
        _genero = 'Masculino';
        _aceptaTerminos = false;
      });

      // Mostrar confirmación
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 30),
              SizedBox(width: 10),
              Text('¡Registro Guardado!'),
            ],
          ),
          content: Text(
            'El registro de ${registro.nombre} se ha guardado exitosamente.\n\n'
            'Puedes verlo en la pestaña "Registros".',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Formulario de Registro',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Los datos se guardarán automáticamente',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre Completo',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tu nombre';
                }
                if (value.length < 3) {
                  return 'El nombre debe tener al menos 3 caracteres';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tu email';
                }
                if (!value.contains('@')) {
                  return 'Ingresa un email válido';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            const Text('Género:', style: TextStyle(fontSize: 16)),
            RadioListTile<String>(
              title: const Text('Masculino'),
              value: 'Masculino',
              groupValue: _genero,
              onChanged: (value) {
                setState(() {
                  _genero = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Femenino'),
              value: 'Femenino',
              groupValue: _genero,
              onChanged: (value) {
                setState(() {
                  _genero = value!;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Acepto los términos y condiciones'),
              value: _aceptaTerminos,
              onChanged: (value) {
                setState(() {
                  _aceptaTerminos = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _enviarFormulario,
              icon: const Icon(Icons.save),
              label: const Text('Guardar Registro', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// PÁGINA 3: VER REGISTROS GUARDADOS
class PaginaRegistros extends StatefulWidget {
  const PaginaRegistros({Key? key}) : super(key: key);

  @override
  State<PaginaRegistros> createState() => _PaginaRegistrosState();
}

class _PaginaRegistrosState extends State<PaginaRegistros> {
  final gestor = GestorRegistros();

  String _formatearFecha(DateTime fecha) {
    return '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year} '
        '${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}';
  }

  void _verDetalles(Registro registro) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detalles del Registro'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detalleCampo('Nombre', registro.nombre, Icons.person),
            const Divider(),
            _detalleCampo('Email', registro.email, Icons.email),
            const Divider(),
            _detalleCampo('Género', registro.genero, Icons.wc),
            const Divider(),
            _detalleCampo('Fecha', _formatearFecha(registro.fecha), Icons.calendar_today),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Widget _detalleCampo(String label, String valor, IconData icono) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icono, size: 20, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  valor,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _eliminarRegistro(Registro registro) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Estás seguro de eliminar el registro de ${registro.nombre}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                gestor.eliminarRegistro(registro.id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Registro eliminado'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final registros = gestor.registros;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.blue.shade50,
          child: Row(
            children: [
              const Icon(Icons.folder_open, color: Colors.blue, size: 30),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mis Registros',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Total: ${registros.length} registro(s)',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: registros.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox, size: 80, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        'No hay registros guardados',
                        style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Ve a la pestaña "Formulario" para crear uno',
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: registros.length,
                  itemBuilder: (context, index) {
                    final registro = registros[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Text(
                            registro.nombre[0].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          registro.nombre,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(registro.email),
                            const SizedBox(height: 2),
                            Text(
                              _formatearFecha(registro.fecha),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.visibility, color: Colors.blue),
                              onPressed: () => _verDetalles(registro),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _eliminarRegistro(registro),
                            ),
                          ],
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

// PÁGINA 4: LISTA DINÁMICA (TAREAS)
class PaginaLista extends StatefulWidget {
  const PaginaLista({Key? key}) : super(key: key);

  @override
  State<PaginaLista> createState() => _PaginaListaState();
}

class _PaginaListaState extends State<PaginaLista> {
  final List<String> _tareas = [
    'Aprender Flutter',
    'Crear una app Android',
    'Publicar en Play Store',
  ];
  final _controladorTexto = TextEditingController();

  void _agregarTarea() {
    if (_controladorTexto.text.isNotEmpty) {
      setState(() {
        _tareas.add(_controladorTexto.text);
        _controladorTexto.clear();
      });
    }
  }

  void _eliminarTarea(int index) {
    setState(() {
      _tareas.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controladorTexto,
                  decoration: const InputDecoration(
                    hintText: 'Nueva tarea',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _agregarTarea,
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ),
        Expanded(
          child: _tareas.isEmpty
              ? const Center(
                  child: Text(
                    'No hay tareas. ¡Agrega una!',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: _tareas.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text('${index + 1}'),
                        ),
                        title: Text(_tareas[index]),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _eliminarTarea(index),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

// PÁGINA 5: PERFIL
class PaginaPerfil extends StatelessWidget {
  const PaginaPerfil({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 60,
            backgroundColor: Colors.blue,
            child: Icon(Icons.person, size: 80, color: Colors.white),
          ),
          const SizedBox(height: 16),
          const Text(
            'Usuario Demo',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'usuario@ejemplo.com',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 30),
          _opcionPerfil(Icons.settings, 'Configuración'),
          _opcionPerfil(Icons.notifications, 'Notificaciones'),
          _opcionPerfil(Icons.security, 'Privacidad'),
          _opcionPerfil(Icons.help, 'Ayuda'),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.logout),
            label: const Text('Cerrar Sesión'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _opcionPerfil(IconData icono, String titulo) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icono, color: Colors.blue),
        title: Text(titulo),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {},
      ),
    );
  }
}